// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#include "CangjieWriter.h"
#include "Logging.h"

#include <fstream>
#include <iostream>
#include <set>
#include <sstream>

#include "Logging.h"
#include "Mode.h"
#include "Package.h"
#include "SingleDeclarationSymbolVisitor.h"
#include "Strings.h"

static constexpr char INDENT[] = "    ";
static constexpr std::size_t INDENT_LENGTH = sizeof(INDENT) - 1;

static_assert(INDENT_LENGTH == 4);

constexpr char COMMENT[] = "// ";
constexpr auto COMMENT_LENGTH = sizeof(COMMENT) - 1;

class IndentingStringBuf final : public std::streambuf {
public:
    IndentingStringBuf() : buf_(std::ios_base::out)
    {
    }

    void indent() noexcept
    {
        indentation_ += INDENT;
    }

    void dedent() noexcept
    {
        assert(ends_with(indentation_, INDENT));
        indentation_.resize(indentation_.size() - INDENT_LENGTH);
    }

    void set_comment() noexcept
    {
        indentation_ += COMMENT;
    }

    void reset_comment() noexcept
    {
        assert(ends_with(indentation_, COMMENT));
        indentation_.resize(indentation_.size() - COMMENT_LENGTH);
    }

    std::string str() const
    {
        return buf_.str();
    }

protected:
    int_type overflow(const int_type ch) override
    {
        if (start_line_) {
            // Print `//` (with proper indentation) even for empty lines
            auto count = static_cast<std::streamsize>(indentation_.length());
            if (buf_.sputn(indentation_.data(), count) != count) {
                return traits_type::eof();
            }
        }
        start_line_ = ch == '\n';
        return buf_.sputc(traits_type::to_char_type(ch));
    }

private:
    std::stringbuf buf_;
    /**
     * Indentation spaces printed currently at the beginning of each line.
     * Includes `//` comments, if any.
     */
    std::string indentation_;
    bool start_line_ = true;
};

class IndentingStringStream : public std::ostream {
public:
    IndentingStringStream() : std::ostream(&fos_buf)
    {
    }

    std::string str() const
    {
        return fos_buf.str();
    }

    void indent() noexcept
    {
        fos_buf.indent();
    }

    void dedent() noexcept
    {
        fos_buf.dedent();
    }

    void set_comment() noexcept
    {
        fos_buf.set_comment();
    }

    void reset_comment() noexcept
    {
        fos_buf.reset_comment();
    }

private:
    IndentingStringBuf fos_buf;
};

std::string_view current_package_name;
std::set<std::string> imports;

class PackageFileScope final {
    const std::string_view package_name_;

public:
    [[nodiscard]] explicit PackageFileScope(std::string_view package_name) noexcept : package_name_(package_name)
    {
        assert(current_package_name.empty());
        assert(!package_name.empty());
        assert(imports.empty());
        current_package_name = package_name;
    }

    ~PackageFileScope()
    {
        assert(current_package_name == package_name_);
        current_package_name = {};
        imports.clear();
    }

    PackageFileScope(const PackageFileScope& other) = delete;

    PackageFileScope(PackageFileScope&& other) noexcept = delete;

    PackageFileScope& operator=(const PackageFileScope& other) = delete;

    PackageFileScope& operator=(PackageFileScope&& other) noexcept = delete;
};

std::string symbol_to_import_name(const FileLevelSymbol& symbol)
{
    assert(!current_package_name.empty());
    const auto& symbol_package_name = symbol.cangjie_package_name();
    if (!symbol_package_name.empty() && symbol_package_name != current_package_name) {
        auto import_name = symbol_package_name;
        import_name += ".";
        import_name += symbol.name();
        return import_name;
    }
    return {};
}

class ImportCollectVisitor final : public SingleDeclarationSymbolVisitor {
public:
    [[nodiscard]] explicit ImportCollectVisitor() : SingleDeclarationSymbolVisitor(false)
    {
    }

    ImportCollectVisitor(const ImportCollectVisitor& other) = delete;

    ImportCollectVisitor(ImportCollectVisitor&& other) noexcept = delete;

    ImportCollectVisitor& operator=(const ImportCollectVisitor& other) = delete;

    ImportCollectVisitor& operator=(ImportCollectVisitor&& other) noexcept = delete;

protected:
    void visit_impl(FileLevelSymbol*, FileLevelSymbol* value, SymbolProperty, bool) override
    {
        assert(value);
        if (auto import_name = symbol_to_import_name(*value); !import_name.empty()) {
            imports.emplace(std::move(import_name));
        }
    }
};

static void collect_import(TypeLikeSymbol& symbol)
{
    ImportCollectVisitor().visit(&symbol);
}

// Currently in the NORMAL mode, Objective-C compatible types are primitives,
// @C structures, ObjCPointer/ObjCFunc, and classes/interfaces.  But not
// CPointer, CFunc, or VArray.
static bool is_objc_compatible(const TypeLikeSymbol& type)
{
    assert(normal_mode());
    if (dynamic_cast<const TypeParameterSymbol*>(&type)) {
        // Type parameters are printed as ObjCId, which is Objective-C compatible
        return true;
    }
    const auto* ptr = dynamic_cast<const PointerTypeSymbol*>(&type);
    if (ptr) {
        return is_objc_compatible(ptr->pointee());
    }
    const auto* func = dynamic_cast<const FuncTypeSymbol*>(&type);
    if (func) {
        const auto& parameters = *func->parameters();
        auto n = parameters.item_count();
        for (size_t i = 0; i < n; ++i) {
            if (!is_objc_compatible(*parameters.item(i))) {
                return false;
            }
        }
        auto* return_type = func->return_type();
        return !return_type || is_objc_compatible(*return_type);
    }
    const auto* named = dynamic_cast<const NamedTypeSymbol*>(&type);
    if (!named) {
        return false;
    }
    switch (named->kind()) {
        case NamedTypeSymbol::Kind::Struct:
        case NamedTypeSymbol::Kind::Union:
            return type.is_ctype();
        case NamedTypeSymbol::Kind::Interface: {
            const auto& name = type.name();
            return name != "SEL" && name != "Class" && name != "Protocol";
        }
        case NamedTypeSymbol::Kind::TargetPrimitive:
        case NamedTypeSymbol::Kind::Protocol:
        case NamedTypeSymbol::Kind::Enum:
            return true;
        case NamedTypeSymbol::Kind::TypeDef:
            return is_objc_compatible(type.canonical_type());
        default:
            return false;
    }
}

static bool write_type_alias(IndentingStringStream& output, TypeAliasSymbol& alias)
{
    auto* target = alias.target();
    assert(target);
    if (alias.name() == target->name()) {
        // typedef struct S S;
        // In the Cangjie output, the target symbol is used directly instead of this typedef, do not print it.
        return false;
    }

    auto supported = !normal_mode() || alias.is_ctype() || is_objc_compatible(alias);
    if (supported) {
        collect_import(*target);
    } else {
        output.set_comment();
    }
    output << "public type " << emit_cangjie(alias) << " = " << emit_cangjie(*target) << '\n';
    if (!supported) {
        output.reset_comment();
    }
    return true;
}

class DefaultValuePrinter {
public:
    explicit DefaultValuePrinter(const NonTypeSymbol& symbol, SymbolPrinter type_printer) noexcept
        : symbol_(symbol), type_printer_(type_printer)
    {
    }

    friend std::ostream& operator<<(std::ostream& stream, const DefaultValuePrinter& op);

private:
    const NonTypeSymbol& symbol_;
    const SymbolPrinter type_printer_;
};

static DefaultValuePrinter default_value(
    const NonTypeSymbol& symbol, const TypeLikeSymbol& type, SymbolPrintFormat format)
{
    return DefaultValuePrinter(symbol, SymbolPrinter(type, format));
}

static bool is_integer_type(std::string_view type_name)
{
    return type_name == "Int32" || type_name == "UInt32" || type_name == "Int64" || type_name == "UInt64" ||
        type_name == "Int16" || type_name == "UInt16" || type_name == "Int8" || type_name == "UInt8";
}

static void print_tricky_default_value(std::ostream& stream, std::string_view type_name, bool is_nullable)
{
    if (is_nullable) {
        stream << "None";
    } else {
        // The dirty trick is applied for printing default values of:
        // - Interface types -- instances of the interface type cannot be created.
        // - @ObjCMirror classes -- they do not have a primary constructor.
        stream << "Option<" << type_name << ">.None.getOrThrow()";
    }
}

std::ostream& operator<<(std::ostream& stream, const DefaultValuePrinter& op)
{
    const auto& type = op.type_printer_.symbol();
    if (dynamic_cast<const TypeParameterSymbol*>(&type)) {
        print_tricky_default_value(stream, "ObjCId", op.symbol_.is_nullable());
        return stream;
    }
    const auto* ptr = dynamic_cast<const PointerTypeSymbol*>(&type);
    if (ptr) {
        return stream << op.type_printer_
                      << (!ptr->is_ctype() || op.type_printer_.format() == SymbolPrintFormat::EmitCangjieStrict
                                 ? "(CPointer<Unit>())"
                                 : "()");
    }
    const auto* func = dynamic_cast<const FuncTypeSymbol*>(&type);
    if (func) {
        return stream << op.type_printer_
                      << (!func->is_ctype() || op.type_printer_.format() == SymbolPrintFormat::EmitCangjieStrict
                                 ? "(CPointer<CFunc<() -> Unit>>())"
                                 : "(CPointer<Unit>())");
    }
    if (dynamic_cast<const BlockTypeSymbol*>(&type)) {
        return stream << op.type_printer_ << "(CPointer<NativeBlockABI>())";
    }
    const auto* named_type = dynamic_cast<const NamedTypeSymbol*>(&type);
    if (named_type) {
        switch (named_type->kind()) {
            case NamedTypeSymbol::Kind::TargetPrimitive: {
                auto name = named_type->name();
                if (name == "Bool") {
                    return stream << "false";
                }

                if (is_integer_type(name)) {
                    return stream << '0';
                }

                if (name == "Float32" || name == "Float64") {
                    return stream << "0.0";
                }

                if (named_type->is_unit()) {
                    return stream << "()";
                }
                break;
            }
            case NamedTypeSymbol::Kind::TypeDef: {
                // Some time later it should be simplified to be just
                assert(dynamic_cast<const TypeAliasSymbol*>(named_type));
                const auto* alias = static_cast<const TypeAliasSymbol*>(named_type);
                const auto* named_target = dynamic_cast<const NamedTypeSymbol*>(alias->root_target());
                if (named_target && named_target->is(NamedTypeSymbol::Kind::TargetPrimitive) &&
                    is_integer_type(named_target->name())) {
                    return stream << "unsafe{zeroValue<" << named_type->name() << ">()}";
                }
                const auto& target = alias->canonical_type();
                return stream << default_value(op.symbol_, target, op.type_printer_.format());
            }
            case NamedTypeSymbol::Kind::Enum:
                return stream << '0';
            case NamedTypeSymbol::Kind::Interface:
            case NamedTypeSymbol::Kind::Protocol:
                print_tricky_default_value(stream, named_type->name(), op.symbol_.is_nullable());
                return stream;
            default:
                break;
        }
    } else {
        const auto* varray = dynamic_cast<const VArraySymbol*>(&type);
        if (varray) {
            stream << '[';
            if (varray->size_) {
                auto value = default_value(op.symbol_, *varray->element_type_, op.type_printer_.format());
                stream << value;
                for (size_t i = 1; i < varray->size_; ++i) {
                    stream << ", " << value;
                }
            }
            return stream << ']';
        }
    }
    return stream << emit_cangjie(type) << "()";
}

static void print_enum_constant_value(std::ostream& output, const NonTypeSymbol& symbol)
{
    assert(symbol.kind() == NonTypeSymbol::Kind::EnumConstant);
    auto value = symbol.enum_constant_value();
    const auto* named_type = dynamic_cast<const NamedTypeSymbol*>(symbol.return_type());
    if (named_type) {
        named_type = dynamic_cast<const NamedTypeSymbol*>(&named_type->canonical_type());
        if (named_type && named_type->kind() == NamedTypeSymbol::Kind::TargetPrimitive) {
            auto type_name = named_type->name();
            // Avoid the "number exceeds the value range of type" Cangjie compiler error by
            // printing the value in a type-specific way.
            if (type_name == "Int8") {
                output << static_cast<int>(static_cast<int8_t>(value));
                return;
            }
            if (type_name == "Int16") {
                output << static_cast<int16_t>(value);
                return;
            }
            if (type_name == "Int32") {
                output << static_cast<int32_t>(value);
                return;
            }
            if (type_name == "Int64") {
                output << static_cast<int64_t>(value);
                return;
            }
            if (type_name == "UInt8") {
                output << static_cast<uint32_t>(static_cast<uint8_t>(value));
                return;
            }
            if (type_name == "UInt16") {
                output << static_cast<uint16_t>(value);
                return;
            }
            if (type_name == "UInt32") {
                output << static_cast<uint32_t>(value);
                return;
            }
            // "UInt64" is handled properly by fallback case.
        }
    }
    output << value;
}

static bool is_objc_compatible_parameters(NonTypeSymbol& method) noexcept
{
    for (const auto& parameter : method.parameters()) {
        if (!is_objc_compatible(*parameter.type())) {
            return false;
        }
    }
    return true;
}

template <class Symbol>
void write_type(std::ostream& output, const Symbol& symbol, TypeLikeSymbol& type, SymbolPrintFormat format)
{
    output << ": ";
    if (symbol.is_nullable()) {
        output << '?';
    }
    if (mode != Mode::EXPERIMENTAL && format == SymbolPrintFormat::EmitCangjieStrict) {
        auto* alias = dynamic_cast<TypeAliasSymbol*>(&type);
        if (alias) {
            const auto& canonical_type = alias->canonical_type();
            if (canonical_type.is_ctype() && canonical_type.contains_pointer_or_func()) {
                output << SymbolPrinter(canonical_type, format) << " /*" << emit_cangjie(type) << "*/";
                return;
            }
        }
    }
    output << SymbolPrinter(type, format);
}

static void write_method_parameters(std::ostream& output, const NonTypeSymbol& method, SymbolPrintFormat format)
{
    output << '(';
    auto parameter_count = method.parameter_count();
    for (std::size_t j = 0; j < parameter_count; ++j) {
        if (j != 0) {
            output << ", ";
        }

        auto& parameter_symbol = method.parameter(j);
        auto* parameter_type = parameter_symbol.type();
        assert(parameter_type);
        output << escape_keyword(parameter_symbol.name());
        write_type(output, parameter_symbol, *parameter_type, format);
        collect_import(*parameter_type);
    }
    output << ')';
}

static void write_foreign_name(std::ostream& output, std::string_view attribute, std::string_view value)
{
    // FE supports foreign name attributes in @ObjCMirror classes only.  In the
    // GENERATE_DEFINITIONS mode, where @ObjCMirror is not used, the foreign name
    // attributes are commented out.
    auto hide_foreign_name = generate_definitions_mode();
    if (hide_foreign_name) {
        output << "/* ";
    }
    output << attribute << "[\"" << value << "\"]";
    if (hide_foreign_name) {
        output << " */";
    }
    output << ' ';
}

static void write_foreign_name(std::ostream& output, const NonTypeSymbol& method)
{
    // The foreign name attributes could not appear on overridden declaration
    if (method.is_override()) {
        return;
    }

    constexpr std::string_view attribute = "@ForeignName";
    const auto& selector_attribute = method.selector_attribute();
    if (!selector_attribute.empty()) {
        write_foreign_name(output, attribute, selector_attribute);
    } else if (method.is_constructor() && method.name() != "init") {
        write_foreign_name(output, attribute, method.name());
    }
}

static bool same_types(const TypeLikeSymbol* type1, const TypeLikeSymbol* type2)
{
    const auto* alias = dynamic_cast<const TypeAliasSymbol*>(type1);
    if (alias) {
        type1 = &alias->canonical_type();
    }
    alias = dynamic_cast<const TypeAliasSymbol*>(type2);
    if (alias) {
        type2 = &alias->canonical_type();
    }

    const auto* constructed1 = dynamic_cast<const ConstructedTypeSymbol*>(type1);
    if (constructed1) {
        const auto* constructed2 = dynamic_cast<const ConstructedTypeSymbol*>(type2);
        return constructed2 && same_types(constructed1->original(), constructed2->original());
    }

    const auto* pointer1 = dynamic_cast<const PointerTypeSymbol*>(type1);
    if (pointer1) {
        auto* pointer2 = dynamic_cast<const PointerTypeSymbol*>(type2);
        return pointer2 && same_types(&pointer1->pointee(), &pointer2->pointee());
    }

    const auto* func1 = dynamic_cast<const FuncLikeTypeSymbol*>(type1);
    if (func1) {
        auto* func2 = dynamic_cast<const FuncTypeSymbol*>(type2);
        if (!func2 || !same_types(func1->return_type(), func2->return_type())) {
            return false;
        }
        const auto& parameters1 = *func1->parameters();
        auto n1 = parameters1.item_count();
        const auto& parameters2 = *func2->parameters();
        auto n2 = parameters2.item_count();
        if (n1 != n2) {
            return false;
        }
        for (size_t i = 0; i < n1; ++i) {
            if (!same_types(parameters1.item(i), parameters2.item(i))) {
                return false;
            }
        }
        return true;
    }

    const auto* varray1 = dynamic_cast<const VArraySymbol*>(type1);
    if (varray1) {
        const auto* varray2 = dynamic_cast<const VArraySymbol*>(type2);
        return varray2 && varray1->size() == varray2->size() &&
            same_types(&varray1->element_type(), &varray2->element_type());
    }

    return type1 == type2;
}

static bool is_overloading_constructor(TypeDeclarationSymbol& type, const NonTypeSymbol& constructor)
{
    assert(constructor.is_constructor());
    auto parameter_count = constructor.parameter_count();
    for (const auto& member : type.members()) {
        if (&member == &constructor || !member.is_constructor() || member.parameter_count() != parameter_count) {
            continue;
        }
        auto overloading = true;
        for (size_t i = 0; i < parameter_count; ++i) {
            if (!same_types(member.parameter(i).type(), constructor.parameter(i).type())) {
                overloading = false;
                break;
            }
        }
        if (overloading) {
            return true;
        }
    }
    return false;
}

enum Optionality { required, optional, non_overridden };

// If the method does not override any method in the base protocols, return
// `non_override`.
// Otherwise, if the method overrides any of the @required methods in base
// protocols methods, return `required`.
// Otherwise, return `optional`.
static Optionality implementation_optionality(TypeDeclarationSymbol& decl, const NonTypeSymbol& method)
{
    assert(method.is_member_method());
    const auto& selector = method.selector();
    bool is_static = method.is_static();
    bool is_optional = false;
    for (auto& base_decl : decl.bases()) {
        auto* base_type_decl = dynamic_cast<TypeDeclarationSymbol*>(&base_decl);
        if (base_type_decl && base_type_decl->kind() == NamedTypeSymbol::Kind::Protocol) {
            for (const auto& member : base_type_decl->members()) {
                if (member.is_member_method() && member.is_static() == is_static && member.selector() == selector) {
                    if (!member.is_optional()) {
                        return required;
                    }
                    is_optional = true;
                }
            }
            switch (implementation_optionality(*base_type_decl, method)) {
                case required:
                    return required;
                case optional:
                    is_optional = true;
                    break;
                default:
                    // non_overridden
                    break;
            }
        }
    }
    return is_optional ? optional : non_overridden;
}

static NonTypeSymbol* get_overridden_method(TypeDeclarationSymbol& decl, const NonTypeSymbol& prop)
{
    const auto& selector = prop.getter();
    auto is_static = prop.is_static();
    for (auto& base_decl : decl.bases()) {
        auto* base_type_decl = dynamic_cast<TypeDeclarationSymbol*>(&base_decl);
        if (base_type_decl) {
            for (auto& member : base_type_decl->members()) {
                if (member.is_member_method() && member.is_static() == is_static && member.selector() == selector) {
                    return &member;
                }
            }
            auto* overridden_method = get_overridden_method(*base_type_decl, prop);
            if (overridden_method) {
                return overridden_method;
            }
        }
    }
    return nullptr;
}

static NonTypeSymbol* get_property(TypeDeclarationSymbol& decl, const NonTypeSymbol& getter_or_setter)
{
    const auto& selector = getter_or_setter.selector();
    auto is_static = getter_or_setter.is_static();
    for (auto& member : decl.members()) {
        if (member.is_property() && member.is_static() == is_static &&
            (member.getter() == selector || member.setter() == selector)) {
            return &member;
        }
    }
    return nullptr;
}

static NonTypeSymbol* get_method_by_selector(TypeDeclarationSymbol& decl, const std::string& selector, bool is_static)
{
    for (auto& member : decl.members()) {
        if (member.is_member_method() && member.is_static() == is_static && member.selector() == selector) {
            return &member;
        }
    }
    return nullptr;
}

static NonTypeSymbol* get_overridden_property(TypeDeclarationSymbol& decl, const std::string& getter, bool is_static)
{
    for (auto& base_decl : decl.bases()) {
        auto* base_type_decl = dynamic_cast<TypeDeclarationSymbol*>(&base_decl);
        if (base_type_decl) {
            for (auto& member : base_type_decl->members()) {
                if (member.is_property() && member.is_static() == is_static && member.getter() == getter) {
                    return &member;
                }
            }
            auto* overridden_prop = get_overridden_property(*base_type_decl, getter, is_static);
            if (overridden_prop) {
                return overridden_prop;
            }
        }
    }
    return nullptr;
}

static void print_optional(std::ostream& output, TypeDeclarationSymbol& decl, const NonTypeSymbol& member)
{
    bool is_optional;
    bool enabled;
    if (decl.kind() == NamedTypeSymbol::Kind::Protocol) {
        is_optional = member.is_optional();
        enabled = mode == Mode::EXPERIMENTAL;
    } else {
        assert(decl.kind() == NamedTypeSymbol::Kind::Interface);
        if (!member.is_member_method()) {
            return;
        }
        is_optional = implementation_optionality(decl, member) == optional;
        enabled = !generate_definitions_mode();
    }
    if (is_optional) {
        if (!enabled) {
            output << "// ";
        }
        output << "@ObjCOptional\n";
    }
}

static bool is_standard_setter_name(std::string_view prop_name, std::string_view setter_name)
{
    assert(!prop_name.empty());
    constexpr char standard_setter_prefix[] = "set";
    constexpr auto standard_setter_prefix_size = std::size(standard_setter_prefix) - 1;
    return setter_name.size() > standard_setter_prefix_size + 1 && setter_name.back() == ':' &&
        starts_with(setter_name, standard_setter_prefix) &&
        setter_name[standard_setter_prefix_size] == static_cast<char>(toupper(prop_name.front())) &&
        setter_name.substr(standard_setter_prefix_size + 1, prop_name.size() - 1) == prop_name.substr(1);
}

static void print_getter_setter_names(std::ostream& output, const NonTypeSymbol& prop)
{
    assert(prop.kind() == NonTypeSymbol::Kind::Property);
    const auto& name = prop.name();
    const auto& getter_name = prop.getter();
    bool standard_getter = getter_name == name;
    if (prop.is_readonly()) {
        if (!standard_getter) {
            write_foreign_name(output, "@ForeignGetterName", getter_name);
        }
    } else {
        const auto& setter_name = prop.setter();
        if (is_standard_setter_name(name, setter_name)) {
            if (!standard_getter) {
                write_foreign_name(output, "@ForeignGetterName", getter_name);
            }
        } else if (standard_getter) {
            write_foreign_name(output, "@ForeignSetterName", setter_name);
        } else if (is_standard_setter_name(getter_name, setter_name)) {
            write_foreign_name(output, "@ForeignName", getter_name);
        } else {
            write_foreign_name(output, "@ForeignGetterName", getter_name);
            write_foreign_name(output, "@ForeignSetterName", setter_name);
        }
    }
}

enum class FuncKind { TopLevelFunc, InterfaceMethod, ClassMethod };

static void write_function(IndentingStringStream& output, FuncKind kind, TypeDeclarationSymbol* decl,
    NonTypeSymbol& function, SymbolPrintFormat format)
{
    auto* return_type = function.return_type();
    assert(return_type);
    auto supported = !normal_mode() || (is_objc_compatible(*return_type) && is_objc_compatible_parameters(function));
    if (!supported) {
        output.set_comment();
    }
    bool is_ctype = false;
    if (kind == FuncKind::TopLevelFunc) {
        is_ctype = function.is_ctype();
        if (is_ctype) {
            output << "foreign ";
        } else if (!generate_definitions_mode()) {
            output << "@ObjCMirror\n";
            format = SymbolPrintFormat::EmitCangjieStrict;
        }
    } else {
        print_optional(output, *decl, function);
    }
    write_foreign_name(output, function);
    if (kind == FuncKind::ClassMethod || (kind == FuncKind::TopLevelFunc && !is_ctype)) {
        output << "public ";
    }
    if (function.is_static()) {
        // In Objective-C, the overridden static method can have different parameter
        // types (co/contra-variant pointers).  In Cangjie, the types must strictly
        // match.  Consider printing "redef" at least when it is allowed in Cangjie.
        if constexpr ((false)) {
            if (function.is_override()) {
                output << "redef ";
            }
        }
        output << "static ";
    } else {
        if (kind == FuncKind::ClassMethod) {
            output << "open ";
        }
        // In Objective-C, the overridden method can have different parameter types
        // (co/contra-variant pointers).  In Cangjie, the types must strictly coincide.
        // Consider printing "override" at least when it is allowed in Cangjie.
        if constexpr ((false)) {
            if (function.is_override()) {
                output << "override ";
            }
        }
    }
    output << "func " << escape_keyword(function.name());
    write_method_parameters(output, function, format);
    write_type(output, function, *return_type, format);
    if (generate_definitions_mode() && !is_ctype) {
        if (return_type->is_unit()) {
            output << " { }";
        } else {
            output << " { " << default_value(function, *return_type, format) << " }";
        }
    }
    if (supported) {
        collect_import(*return_type);
    } else {
        output.reset_comment();
    }
    output << '\n';
}

enum class DeclKind { Enum, CStruct, ObjCStruct, Interface, Class };

// Whether a property or field with the specified type and name is currently
// supported by FE in declarations of the specified kind.  If not, then in the
// NORMAL mode it will be commented out. In the EXPERIMENTAL and
// GENERATE_DEFINITIONS modes, any property/field is supported.
static bool is_field_type_supported(DeclKind decl_kind, TypeLikeSymbol& type, const std::string& name)
{
    if (!normal_mode()) {
        return true;
    }
    switch (decl_kind) {
        case DeclKind::CStruct:
            assert(type.is_ctype());
            return true;
        case DeclKind::ObjCStruct:
            return true;
        default:
            assert(decl_kind == DeclKind::Class || decl_kind == DeclKind::Interface);

            // Current FE fails to process a field or property of an @ObjCMirror class if
            // the field and its type have the same name (no such problem in non-@ObjCMirror
            // declarations).  As a workaround, comment out such fields.
            return name != type.name() && is_objc_compatible(type);
    }
}

static void print_objcmirror_attribute(std::ostream& output, bool supported)
{
    auto hide_objcmirror_attribute = !supported;
    if (hide_objcmirror_attribute) {
        output << "/* ";
    }
    output << "@ObjCMirror";
    if (hide_objcmirror_attribute) {
        output << " */";
    }
    output << '\n';
}

void write_type_declaration(IndentingStringStream& output, TypeDeclarationSymbol* type)
{
    DeclKind decl_kind;
    SymbolPrintFormat format;

    // Mark all classes and interfaces as @ObjCMirror.  Mark structures as @C when
    // they are empty or contain CType fields only, and as @ObjCMirror otherwise.
    // Currently FE does not support @ObjCMirror structures, so print them as
    // ordinary Cangjie structures.
    //
    // In the EXPERIMENTAL mode, print them as @ObjCMirror structures.
    //
    // In the GENERATE_DEFINITIONS mode, comment out @ObjCMirror from both
    // classes/interfaces and structures.
    switch (type->kind()) {
        case NamedTypeSymbol::Kind::Protocol:
            decl_kind = DeclKind::Interface;
            format = SymbolPrintFormat::EmitCangjieStrict;
            print_objcmirror_attribute(output, !generate_definitions_mode());
            break;
        case NamedTypeSymbol::Kind::Enum:
            decl_kind = DeclKind::Enum;

            // Can be EmitCangjieStrict, does not matter here
            format = SymbolPrintFormat::EmitCangjie;

            break;
        case NamedTypeSymbol::Kind::Struct:
        case NamedTypeSymbol::Kind::Union:
            if (type->is_ctype()) {
                decl_kind = DeclKind::CStruct;
                format = SymbolPrintFormat::EmitCangjie;
                output << "@C\n";
            } else {
                decl_kind = DeclKind::ObjCStruct;
                format = SymbolPrintFormat::EmitCangjie;
                print_objcmirror_attribute(output, mode == Mode::EXPERIMENTAL);
            }
            break;
        default:
            assert(type->kind() == NamedTypeSymbol::Kind::Interface);
            decl_kind = DeclKind::Class;
            format = SymbolPrintFormat::EmitCangjieStrict;
            print_objcmirror_attribute(output, !generate_definitions_mode());
            break;
    }
    output << "public ";
    switch (decl_kind) {
        case DeclKind::Interface:
            output << "interface";
            break;
        case DeclKind::CStruct:
        case DeclKind::ObjCStruct:
            output << "struct";
            break;
        case DeclKind::Enum:
            output << "abstract sealed class";
            break;
        default:
            assert(decl_kind == DeclKind::Class);
            output << "open class";
            break;
    }
    output << " " << escape_keyword(type->name());
    if (const auto parameter_count = type->parameter_count()) {
        output << "/*<";
        for (std::size_t i = 0; i < parameter_count; ++i) {
            if (i != 0) {
                output << ", ";
            }

            auto* parameter = type->parameter(i);
            assert(parameter);
            output << parameter->name();
        }
        output << ">*/";
    }
    const auto base_count = type->base_count();
    if (base_count) {
        output << " <: ";
        auto* base = type->base(0);
        assert(base);
        output << emit_cangjie(*base);
        collect_import(*base);
        for (std::size_t i = 1; i < base_count; ++i) {
            output << " & ";
            auto* base = type->base(i);
            assert(base);
            output << emit_cangjie(*base);
            collect_import(*base);
        }
    }
    output << " {\n";
    output.indent();
    auto any_constructor_exists = false;
    auto default_constructor_exists = false;
    for (auto&& member : type->members()) {
        if (member.is_property()) {
            auto is_static = member.is_static();
            const auto& getter_name = member.getter();
            auto* getter = get_method_by_selector(*type, getter_name, is_static);
            assert(getter);
            if (!get_overridden_method(*type, member) && !get_overridden_property(*type, getter_name, is_static)) {
                auto* return_type = getter->return_type();
                assert(return_type);
                assert(!return_type->is_unit());
                const auto& name = member.name();
                auto supported = is_field_type_supported(decl_kind, *return_type, name);
                if (!supported) {
                    output.set_comment();
                }
                print_optional(output, *type, member);
                print_getter_setter_names(output, member);
                if (decl_kind != DeclKind::Interface) {
                    output << "public ";
                }
                if (is_static) {
                    output << "static ";
                } else if (decl_kind != DeclKind::Interface) {
                    output << "open ";
                }
                if (!member.is_readonly()) {
                    output << "mut ";
                }
                output << "prop " << escape_keyword(name);
                write_type(output, *getter, *return_type, format);
                if (generate_definitions_mode()) {
                    output << " {\n";
                    output.indent();
                    output << "get() { " << default_value(*getter, *return_type, format) << " }\n";
                    if (!member.is_readonly()) {
                        output << "set(v) { }\n";
                    }
                    output.dedent();
                    output << '}';
                }
                if (supported) {
                    collect_import(*return_type);
                } else {
                    output.reset_comment();
                }
                output << '\n';
            }
        } else if (member.is_constructor()) {
            auto supported =
                decl_kind != DeclKind::Interface && (!normal_mode() || is_objc_compatible_parameters(member));
            if (supported) {
                any_constructor_exists = true;
                if (!default_constructor_exists) {
                    default_constructor_exists = member.parameter_count() == 0;
                }
            } else {
                output.set_comment();
            }
            if (is_overloading_constructor(*type, member)) {
                if (!generate_definitions_mode()) {
                    output << "@ObjCInit ";
                }
                write_foreign_name(output, member);
                if (decl_kind != DeclKind::Interface) {
                    output << "public ";
                }
                output << "static func " << escape_keyword(member.name());
                write_method_parameters(output, member, format);

                // FE requires the return type to be strictly the declaring class
                auto* return_type = normal_mode() ? type : member.return_type();
                assert(return_type);

                write_type(output, member, *return_type, format);
                if (generate_definitions_mode() && decl_kind != DeclKind::Interface) {
                    output << " { " << default_value(member, *return_type, format) << " }";
                }
                if (supported) {
                    collect_import(*return_type);
                }
            } else {
                write_foreign_name(output, member);
                if (decl_kind != DeclKind::Interface) {
                    output << "public ";
                }
                output << "init";
                write_method_parameters(output, member, format);
                if (generate_definitions_mode() && decl_kind != DeclKind::Interface) {
                    output << " { }";
                }
            }
            if (!supported) {
                output.reset_comment();
            }
            output << '\n';
        } else if (member.is_member_method()) {
            if (!get_property(*type, member) &&
                !get_overridden_property(*type, member.selector(), member.is_static())) {
                write_function(output,
                    decl_kind == DeclKind::Interface ? FuncKind::InterfaceMethod : FuncKind::ClassMethod, type, member,
                    format);
            }
        } else if (member.is_instance_variable()) {
            assert(member.is_instance());
            auto* return_type = member.return_type();
            assert(return_type);
            assert(!return_type->is_unit());
            assert(member.is_public() || member.is_protected());
            const auto& name = member.name();
            auto supported = is_field_type_supported(decl_kind, *return_type, name);
            if (!supported) {
                output.set_comment();
            }
            output << (member.is_public() ? "public" : "protected") << " var " << escape_keyword(name);
            write_type(output, member, *return_type, format);
            if (generate_definitions_mode()) {
                output << " = " << default_value(member, *return_type, format);
            }
            if (supported) {
                collect_import(*return_type);
            } else {
                output.reset_comment();
            }
            output << '\n';
        } else if (member.is_field()) {
            assert(member.is_instance());
            auto* return_type = member.return_type();
            assert(return_type);
            assert(!return_type->is_unit());
            const auto& name = member.name();
            auto supported = is_field_type_supported(decl_kind, *return_type, name);
            if (!supported) {
                output.set_comment();
            }
            output << "public var " << escape_keyword(name);
            write_type(output, member, *return_type, format);
            if (mode != Mode::EXPERIMENTAL) {
                output << " = " << default_value(member, *return_type, format);
            }
            if (supported) {
                collect_import(*return_type);
            } else {
                output.reset_comment();
            }
            output << '\n';
        } else if (member.is_enum_constant()) {
            assert(decl_kind == DeclKind::Enum);
            auto* return_type = member.return_type();
            assert(return_type);
            assert(!return_type->is_unit());
            output << "public static const " << escape_keyword(member.name());
            write_type(output, member, *return_type, format);
            output << " = ";
            collect_import(*return_type);
            print_enum_constant_value(output, member);
            output << '\n';
        } else {
            assert(false);
        }
    }

    // In the `GENERATE_DEFINITIONS` mode, add a fake default constructor if needed.
    // Otherwise, the following error can happen:
    // error: there is no non-parameter constructor in super class, please invoke
    // super call explicitly
    if (generate_definitions_mode() && any_constructor_exists && !default_constructor_exists) {
        output << "public init() { }";
    }

    output.dedent();
    output << "}" << std::endl;
}

void write_cangjie()
{
    std::uint64_t generated_files = 0;
    for (auto&& package : packages) {
        for (auto&& package_file : package) {
            assert(package_file.package() == &package);

            PackageFileScope scope(package_file.package()->cangjie_name());

            auto file_path = package_file.output_path();
            create_directories(file_path.parent_path());
            IndentingStringStream output;

            for (auto* symbol : package_file) {
                if (auto* alias = dynamic_cast<TypeAliasSymbol*>(symbol)) {
                    if (!write_type_alias(output, *alias)) {
                        continue;
                    }
                } else if (auto* type = dynamic_cast<TypeDeclarationSymbol*>(symbol)) {
                    write_type_declaration(output, type);
                } else {
                    assert(dynamic_cast<NonTypeSymbol*>(symbol));
                    auto& top_level = static_cast<NonTypeSymbol&>(*symbol);
                    assert(top_level.kind() == NonTypeSymbol::Kind::GlobalFunction);
                    write_function(output, FuncKind::TopLevelFunc, nullptr, top_level, SymbolPrintFormat::EmitCangjie);
                }
                output << std::endl;
            }

            std::ofstream file_output(file_path);
            file_output << "// Generated by ObjCInteropGen" << std::endl;
            file_output << std::endl;
            file_output << "package " << package.cangjie_name() << std::endl;
            file_output << std::endl;
            for (auto&& import : imports) {
                file_output << "import " << import << std::endl;
            }
            if (!generate_definitions_mode()) {
                file_output << "import interoplib.objc.*\n"
                               "import objc.lang.*\n\n";
            }
            file_output << output.str();

            generated_files++;
        }
    }

    if (generated_files == 0) {
        std::cerr << "No output files are generated" << std::endl;
    } else {
        std::cout << "Generated " << generated_files << " files for " << packages.size() << " packages" << std::endl;
    }

    if (verbosity >= LogLevel::INFO) {
        for (const auto* input_directory : inputs) {
            for (const auto* input_file : *input_directory) {
                for (const auto* symbol : *input_file) {
                    assert(symbol);
                    if (auto* package_file = symbol->package_file()) {
                        auto* edge_from = package_file->package();
                        assert(edge_from);
                        for (const auto* reference : symbol->references_symbols()) {
                            if (auto* edge_to = reference->package()) {
                                if (edge_from != edge_to) {
                                    edge_from->add_dependency_edge(edge_to);
                                }
                            }
                        }
                    }
                }
            }
        }
        for (auto&& package : packages) {
            auto& depends_on = package.depends_on();
            std::cout << "Package `" << package.cangjie_name() << "` depends on " << depends_on.size();
            if (depends_on.size() == 1) {
                auto* dependency = *depends_on.begin();
                std::cout << " package: `" << dependency->cangjie_name() << "`" << std::endl;
            } else if (depends_on.size() > 1) {
                std::cout << " packages:" << std::endl;
                for (auto* dependency : depends_on) {
                    std::cout << "* " << dependency->cangjie_name() << std::endl;
                }
            } else {
                std::cout << " packages" << std::endl;
            }
        }
    }
}
