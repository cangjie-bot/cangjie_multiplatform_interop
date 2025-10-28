// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#include "Symbol.h"

#include <algorithm>

#include "InputFile.h"
#include "Mappings.h"
#include "Mode.h"
#include "Package.h"
#include "Universe.h"

std::ostream& operator<<(std::ostream& stream, const KeywordEscaper& op)
{
    // Do not include keywords common for Cangjie and C/Objective-C
    static constexpr const char* cangjieKeywords[] = {
        "as", "Bool",
        //"break",
        //"case",
        "catch", "class",
        //"const",
        //"continue",
        //"do",
        //"else",
        //"enum",
        "extend", "false", "finally", "Float16", "Float32", "Float64",
        //"for",
        "foreign", "from", "func", "handle",
        //"if",
        "import", "in", "init", "inout", "Int16", "Int32", "Int64", "Int8", "interface", "IntNative", "is", "let",
        "macro", "main", "match", "mut", "Nothing", "operator", "package", "perform", "prop", "quote", "resume",
        //"return",
        "Rune", "spawn",
        //"static",
        //"struct",
        "super", "synchronized", "This", "this", "throw", "true", "try", "type", "UInt16", "UInt32", "UInt64", "UInt8",
        "UIntNative", "Unit", "unsafe", "var", "where",
        //"while",
    };
    auto e = std::cend(cangjieKeywords);
    if (std::find(std::cbegin(cangjieKeywords), e, op.name) != e) {
        stream << '`' << op.name << '`';
    } else {
        stream << op.name;
    }
    return stream;
}

Symbol::Symbol(std::string name) : name_(std::move(name))
{
}

void Symbol::print(std::ostream& stream, [[maybe_unused]] SymbolPrintFormat format) const
{
    stream << escape_keyword(name_);
}

std::ostream& operator<<(std::ostream& stream, const SymbolPrinter& symbolPrinter)
{
    if (symbolPrinter.symbol) {
        symbolPrinter.symbol->print(stream, symbolPrinter.format);
    } else {
        stream << "<null>";
    }
    return stream;
}

void SymbolVisitor::recurse(FileLevelSymbol* value)
{
    value->visit_impl(*this);
}

void NamedTypeSymbol::rename(const std::string_view new_name)
{
    const auto old_name = name();
    TypeLikeSymbol::rename(new_name);
    universe.process_rename(this, old_name);
}

template <class UnaryPred>
bool NamedTypeSymbol::is_recursively(UnaryPred cond) const noexcept(noexcept(cond(std::declval<NamedTypeSymbol>())))
{
    if (cond(*this)) {
        return true;
    }
    if (const auto* alias = dynamic_cast<const TypeAliasSymbol*>(this)) {
        if (const auto* target = dynamic_cast<const NamedTypeSymbol*>(alias->target())) {
            return target->is_recursively(cond);
        }
    }
    return false;
}

bool NamedTypeSymbol::is_objc_reference() const noexcept
{
    return is_recursively([](const auto& symbol) {
        switch (symbol.kind_) {
            case Kind::Interface:
            case Kind::Protocol:
                return true;
            default:
                return false;
        }
    });
}

void NamedTypeSymbol::print(std::ostream& stream, SymbolPrintFormat format) const
{
    auto name = this->name();
    switch (kind_) {
        case Kind::Enum:
            if (format.emit_cangjie()) {
                // TODO: print real underlying type instead of hardcoded Int32
                stream << "Int32 /*" << name << "*/";
            } else {
                stream << name;
            }
            break;
        case Kind::TargetPrimitive:
            stream << name;
            if (name == "CPointer") {
                assert(parameter_count() == 1);
                const auto* parameter = this->parameter(0);
                assert(parameter);
                stream << '<';
                parameter->print(stream, format);
                stream << '>';
            } else if (name == "CFunc") {
                assert(parameter_count() == 1);
                const auto* parameter = this->parameter(0);
                assert(parameter);
                stream << '<' << (format.emit_cangjie() ? emit_cangjie(parameter) : raw(parameter)) << '>';
            }
            break;
        default:
            if (kind_ == Kind::Struct && name == "ObjCPointer") {
                stream << name;
                assert(parameter_count() == 1);
                const auto* parameter = this->parameter(0);
                assert(parameter);
                stream << '<';
                parameter->print(stream, format);
                stream << '>';
            } else if (kind_ == Kind::Struct && (name == "ObjCFunc" || name == "ObjCBlock")) {
                stream << name;
                assert(parameter_count() == 1);
                const auto* parameter = this->parameter(0);
                assert(parameter);
                stream << '<' << (format.emit_cangjie() ? emit_cangjie(parameter) : raw(parameter)) << '>';
            } else {
                if (kind_ == Kind::TypeDef) {
                    assert(dynamic_cast<const TypeAliasSymbol*>(this));
                    const auto* target = static_cast<const TypeAliasSymbol*>(this)->target();
                    if (target && name == target->name()) {
                        // typedef struct S S;
                        target->print(stream, format);
                        return;
                    }
                }
                stream << escape_keyword(name);
                if (const auto count = parameter_count(); count != 0) {
                    auto no_type_arguments = format.emit_cangjie();
                    if (no_type_arguments) {
                        stream << "/*";
                    }
                    stream << "<";
                    for (std::size_t i = 0; i < count; ++i) {
                        if (i != 0) {
                            stream << ", ";
                        }

                        const auto* parameter = this->parameter(i);
                        assert(parameter);
                        stream << raw(parameter);
                    }
                    stream << '>';
                    if (no_type_arguments) {
                        stream << "*/";
                    }
                }
            }
    }
}

TypeLikeSymbol* NamedTypeSymbol::map()
{
    if (auto* mapping = this->mapping())
        return mapping->map(this);

    if (const auto parameter_count = this->parameter_count(); parameter_count) {
        std::vector<TypeLikeSymbol*> arguments;
        arguments.reserve(parameter_count);
        auto changed = false;

        for (std::size_t i = 0; i < parameter_count; ++i) {
            auto* old_parameter = this->parameter(i);
            auto* new_parameter = old_parameter->map();
            arguments.push_back(new_parameter);
            changed = changed || new_parameter != old_parameter;
        }

        if (changed) {
            return construct(arguments);
        }
    }

    return this;
}

NamedTypeSymbol* NamedTypeSymbol::construct(const std::vector<TypeLikeSymbol*>& arguments) const
{
    const auto parameter_count = this->parameter_count();
    assert(parameter_count == arguments.size());

    if (parameter_count) {
        auto changed = false;

        for (std::size_t i = 0; i < parameter_count; ++i) {
            const auto* old_parameter = this->parameter(i);
            const auto* new_parameter = arguments.at(i);
            changed = changed || new_parameter != old_parameter;
        }

        if (changed) {
            auto* original = this->original();
            assert(original);
            auto* original_type = dynamic_cast<TypeDeclarationSymbol*>(original);
            assert(original_type);
            auto* result = new ConstructedTypeSymbol(original_type);
            const auto& cangjie_package_name = original_type->cangjie_package_name();
            if (!cangjie_package_name.empty()) {
                result->set_cangjie_package_name(cangjie_package_name);
            }
            for (auto* argument : arguments) {
                result->add_parameter(argument);
            }
            return result;
        }
    }

    return const_cast<NamedTypeSymbol*>(this);
}

static bool is_ctype_by_default(NamedTypeSymbol::Kind kind, std::string_view name)
{
    switch (kind) {
        case NamedTypeSymbol::Kind::SourcePrimitive:
        case NamedTypeSymbol::Kind::TargetPrimitive:
        case NamedTypeSymbol::Kind::Enum:

        // Empty structures are CType.  If afterwards a non-CType member is added,
        // `is_ctype_` will be set to `false`.
        case NamedTypeSymbol::Kind::Struct:
        case NamedTypeSymbol::Kind::Union:
            return name != "ObjCPointer" && name != "ObjCFunc" && name != "ObjCBlock";
        default:
            return false;
    }
}

TypeDeclarationSymbol::TypeDeclarationSymbol(const Kind kind, std::string name)
    : NamedTypeSymbol(kind, std::move(name)), is_ctype_(is_ctype_by_default(kind, this->name()))
{
}

TypeParameterSymbol* TypeDeclarationSymbol::parameter(const std::size_t index) const
{
    return parameters_.at(index).get();
}

void TypeDeclarationSymbol::member_remove(size_t index)
{
    auto it = members_.begin();
    std::advance(it, index);
    switch (kind()) {
        case Kind::Struct:
        case Kind::Union:
            assert(it->kind() == NonTypeSymbol::Kind::Field);
            {
                auto removing_ctype = it->return_type()->is_ctype();
                members_.erase(it);
                if (!removing_ctype) {
                    is_ctype_ = all_of_members([](const auto& member) { return member.return_type()->is_ctype(); });
                }
            }
            break;
        default:
            members_.erase(it);
            break;
    }
}

template <class Pred>
bool TypeDeclarationSymbol::all_of_members(Pred cond) const noexcept(noexcept(cond(std::declval<NonTypeSymbol>())))
{
    return std::all_of(members_.cbegin(), members_.cend(), [cond](const auto& member) { return cond(member); });
}

void TypeDeclarationSymbol::add_parameter(std::string name)
{
    for ([[maybe_unused]] const auto& parameter : parameters_) {
        assert(parameter->name() != name);
    }

    parameters_.push_back(std::make_unique<TypeParameterSymbol>(TypeParameterSymbol::Private(), std::move(name)));
}

NonTypeSymbol& TypeDeclarationSymbol::add_member_method(
    std::string name, TypeLikeSymbol* return_type, uint8_t modifiers)
{
    // No clash detection, otherwise might assert on method overloads

    assert(kind() == Kind::Interface || kind() == Kind::Protocol);
    return members_.emplace_back(
        NonTypeSymbol::Private(), std::move(name), NonTypeSymbol::Kind::MemberMethod, return_type, modifiers);
}

NonTypeSymbol& TypeDeclarationSymbol::add_constructor(std::string name, TypeLikeSymbol* return_type)
{
    assert(kind() == Kind::Interface || kind() == Kind::Protocol);
    return members_.emplace_back(
        NonTypeSymbol::Private(), std::move(name), NonTypeSymbol::Kind::Constructor, return_type);
}

NonTypeSymbol& TypeDeclarationSymbol::add_field(std::string name, TypeLikeSymbol* type, bool is_nullable)
{
    assert(kind() == Kind::Struct || kind() == Kind::Union);
    assert(all_of_members([&name](const auto& member) { return !member.is_field() || member.name() != name; }));

    auto& member = members_.emplace_back(NonTypeSymbol::Private(), std::move(name), NonTypeSymbol::Kind::Field, type,
        is_nullable ? ModifierNullable : 0);
    if (is_ctype_ && !member.return_type()->is_ctype()) {
        is_ctype_ = false;
    }
    return member;
}

NonTypeSymbol& TypeDeclarationSymbol::add_instance_variable(std::string name, TypeLikeSymbol* type, uint8_t modifiers)
{
    assert(kind() == Kind::Interface);
    assert(all_of_members([&name](const auto& member) { return member.name() != name; }));

    auto& ivar = members_.emplace_back(
        NonTypeSymbol::Private(), std::move(name), NonTypeSymbol::Kind::InstanceVariable, type, modifiers);
    if (is_ctype_ && !ivar.return_type()->is_ctype()) {
        is_ctype_ = false;
    }
    return ivar;
}

NonTypeSymbol& TypeDeclarationSymbol::add_enum_constant(std::string name, TypeLikeSymbol* type)
{
    assert(kind() == Kind::Enum);
    assert(all_of_members([&name](const auto& member) { return !member.is_enum_constant() || member.name() != name; }));

    return members_.emplace_back(NonTypeSymbol::Private(), std::move(name), NonTypeSymbol::Kind::EnumConstant, type);
}

NonTypeSymbol& TypeDeclarationSymbol::add_property(
    std::string name, std::string getter, std::string setter, uint8_t modifiers)
{
    assert(kind() == Kind::Interface || kind() == Kind::Protocol);

    return members_.emplace_back(
        NonTypeSymbol::Private(), std::move(name), std::move(getter), std::move(setter), modifiers);
}

void TypeDeclarationSymbol::add_base(TypeLikeSymbol* base)
{
    bases_.push_back(base);
}

const std::string& FileLevelSymbol::cangjie_package_name() const
{
    if (!cangjie_package_name_.empty()) {
        assert(!output_file_);
        return cangjie_package_name_;
    }
    if (!output_file_) {
        return cangjie_package_name_;
    }
    auto* package = output_file_->package();
    assert(package);
    return package->cangjie_name();
}

Package* FileLevelSymbol::package() const
{
    const auto* file = package_file();
    return file ? file->package() : nullptr;
}

void FileLevelSymbol::set_definition_location(const Location& location)
{
    assert(!input_file_);
    input_file_ = &inputs[location.file_];
    location_ = location;
    input_file_->add_symbol(this);
}

void FileLevelSymbol::set_package_file(PackageFile* package_file)
{
    assert(cangjie_package_name_.empty());
    assert(!output_file_);
    assert(package_file);
    assert(this->is_file_level());
    output_file_ = package_file;
}

void FileLevelSymbol::set_cangjie_package_name(std::string cangjie_package_name) noexcept
{
    assert(cangjie_package_name_.empty());
    assert(!output_file_);
    assert(!cangjie_package_name.empty());
    cangjie_package_name_ = std::move(cangjie_package_name);
}

void FileLevelSymbol::add_reference(FileLevelSymbol* symbol)
{
    // symbol references this

    assert(symbol);
    assert(symbol != this);
    assert(symbol->is_file_level());
    assert(is_file_level());
    add_reference_to_self(symbol);
}

TypeParameterSymbol::TypeParameterSymbol(Private, std::string name) : TypeLikeSymbol(std::move(name))
{
}

void TypeParameterSymbol::print(std::ostream& stream, SymbolPrintFormat format) const
{
    if (format.emit_cangjie()) {
        stream << "ObjCId /*" << name() << "*/";
    } else {
        stream << name();
    }
}

void NarrowedTypeParameterSymbol::print(std::ostream& stream, SymbolPrintFormat format) const
{
    if (format.emit_cangjie()) {
        stream << protocol_name_ << " /*" << name() << '<' << protocol_name_ << ">*/";
    } else {
        stream << name() << '<' << protocol_name_ << '>';
    }
}

void VArraySymbol::print(std::ostream& stream, SymbolPrintFormat format) const
{
    stream << name() << '<';
    element_type_->print(stream, format);
    stream << ", $" << size_ << '>';
}

[[nodiscard]] VArraySymbol* VArraySymbol::map()
{
    auto* new_element_type = element_type_->map();
    return new_element_type == element_type_ ? this : new VArraySymbol(*new_element_type, size_);
}

void TypeDeclarationSymbol::visit_impl(SymbolVisitor& visitor)
{
    // TODO: is infinite recursion possible? With CRTP for example.
    if (const auto count = this->parameter_count(); count) {
        for (std::size_t i = 0; i < count; ++i) {
            visitor.visit(this, this->parameter(i), SymbolProperty::TypeArgument);
        }
    }
    if (const auto count = this->base_count(); count) {
        for (std::size_t i = 0; i < count; ++i) {
            visitor.visit(this, this->base(i), SymbolProperty::Base);
        }
    }
    if (const auto count = this->member_count(); count) {
        for (std::size_t i = 0; i < count; ++i) {
            visitor.visit(this, &this->member(i), SymbolProperty::Member);
        }
    }
}

TupleTypeSymbol::TupleTypeSymbol() : TypeLikeSymbol(""), is_ctype_(true)
{
}

TupleTypeSymbol::TupleTypeSymbol(std::vector<TypeLikeSymbol*> items)
    : TypeLikeSymbol(""),
      items_(std::move(items)),
      is_ctype_(std::all_of(items_.cbegin(), items_.cend(), [](auto item) { return item->is_ctype(); }))
{
}

TypeLikeSymbol* TupleTypeSymbol::item(const std::size_t index) const
{
    return items_.at(index);
}

void TupleTypeSymbol::print(std::ostream& stream, SymbolPrintFormat format) const
{
    stream << '(';
    for (std::size_t i = 0; i < items_.size(); ++i) {
        if (i != 0) {
            stream << ", ";
        }
        items_[i]->print(stream, format);
    }
    stream << ')';
}

TypeLikeSymbol* TupleTypeSymbol::map()
{
    std::vector<TypeLikeSymbol*> new_items;
    auto changed = false;
    const std::size_t count = item_count();
    for (std::size_t i = 0; i < count; i++) {
        auto* item = this->item(i);
        auto* new_item = item->map();
        new_items.push_back(new_item);
        changed = changed || item != new_item;
    }
    return changed ? new TupleTypeSymbol(new_items) : this;
}

void TupleTypeSymbol::visit_impl(SymbolVisitor& visitor)
{
    if (const auto count = this->item_count(); count) {
        for (std::size_t i = 0; i < count; ++i) {
            visitor.visit(this, this->item(i), SymbolProperty::TupleItem);
        }
    }
}

FuncTypeSymbol::FuncTypeSymbol() : TypeLikeSymbol("")
{
}

FuncTypeSymbol::FuncTypeSymbol(TupleTypeSymbol* parameters, TypeLikeSymbol* return_type)
    : TypeLikeSymbol(""), parameters_(parameters), return_type_(return_type)
{
}

void FuncTypeSymbol::print(std::ostream& stream, SymbolPrintFormat format) const
{
    parameters_->print(stream, format);
    stream << " -> ";
    return_type_->print(stream, format);
}

TypeLikeSymbol* FuncTypeSymbol::map()
{
    auto* parameters = this->parameters();
    auto* return_type = this->return_type();
    auto* new_parameters = parameters->map();
    auto* new_return_type = return_type->map();
    const auto changed = parameters != new_parameters || return_type != new_return_type;
    return changed ? new FuncTypeSymbol(dynamic_cast<TupleTypeSymbol*>(new_parameters), new_return_type) : this;
}

void FuncTypeSymbol::visit_impl(SymbolVisitor& visitor)
{
    visitor.visit(this, this->parameters(), SymbolProperty::FunctionParametersTuple);
    visitor.visit(this, this->return_type(), SymbolProperty::FunctionReturnType);
}

ConstructedTypeSymbol::ConstructedTypeSymbol(TypeDeclarationSymbol* original)
    : NamedTypeSymbol(original->kind(), std::string(original->name())), original_(original)
{
    assert(original->original() == original);
}

TypeLikeSymbol* ConstructedTypeSymbol::parameter(const std::size_t index) const
{
    return parameters_.at(index);
}

void ConstructedTypeSymbol::visit_impl(SymbolVisitor& visitor)
{
    if (const auto count = this->parameter_count(); count) {
        for (std::size_t i = 0; i < count; ++i) {
            visitor.visit(this, this->parameter(i), SymbolProperty::TypeArgument);
        }
    }
}

TypeAliasSymbol::TypeAliasSymbol(std::string name) : NamedTypeSymbol(Kind::TypeDef, std::move(name))
{
}

void TypeAliasSymbol::visit_impl(SymbolVisitor& visitor)
{
    visitor.visit(this, this->target(), SymbolProperty::AliasTarget);
}

TypeLikeSymbol* TypeAliasSymbol::root_target() const
{
    const TypeAliasSymbol* target = dynamic_cast<const TypeAliasSymbol*>(target_);
    return target ? target->root_target() : target_;
}

TypeLikeSymbol& TypeAliasSymbol::canonical_type()
{
    auto* target = this->target();
    assert(target);
    return target->canonical_type();
}

void NonTypeSymbol::visit_impl(SymbolVisitor& visitor)
{
    if (const auto count = this->parameter_count(); count) {
        for (std::size_t i = 0; i < count; ++i) {
            visitor.visit(this, this->parameter(i).type(), SymbolProperty::ParameterType);
        }
    }

    visitor.visit(this, this->return_type(), SymbolProperty::ReturnType);
}

static NamedTypeSymbol* construct_symbol(NamedTypeSymbol::Kind kind, const std::string& name, TypeLikeSymbol* parameter)
{
    return universe.type(kind, name)->construct({parameter});
}

NamedTypeSymbol* cpointer(TypeLikeSymbol* symbol)
{
    return construct_symbol(NamedTypeSymbol::Kind::TargetPrimitive, "CPointer", symbol);
}

NamedTypeSymbol* objc_pointer(TypeLikeSymbol* symbol)
{
    return construct_symbol(NamedTypeSymbol::Kind::Struct, "ObjCPointer", symbol);
}

NamedTypeSymbol* cfunc(FuncTypeSymbol* symbol)
{
    return construct_symbol(NamedTypeSymbol::Kind::TargetPrimitive, "CFunc", symbol);
}

NamedTypeSymbol* objc_func(FuncTypeSymbol* symbol)
{
    return construct_symbol(NamedTypeSymbol::Kind::Struct, "ObjCFunc", symbol);
}

NamedTypeSymbol& pointer(TypeLikeSymbol& pointee)
{
    // C pointer to anything other than function is converted `CPointer` or
    // `ObjCPointer`.  Pointer-to-function is converted to `CFunc` or `ObjCFunc`.
    auto* named_pointee = dynamic_cast<NamedTypeSymbol*>(&pointee);
    if (dynamic_cast<const ConstructedTypeSymbol*>(&pointee)) {
        auto name = pointee.name();
        if (name == "ObjCFunc" || name == "CFunc") {
            assert(named_pointee);
            return *named_pointee;
        }
    }
    return *(named_pointee && named_pointee->is_ctype() ? cpointer(&pointee) : objc_pointer(&pointee));
}

static TypeDeclarationSymbol& add_cangjie_primitive(const std::string& name)
{
    auto* symbol = new TypeDeclarationSymbol(NamedTypeSymbol::Kind::TargetPrimitive, name);
    universe.register_type(symbol);
    return *symbol;
}

static TypeDeclarationSymbol& add_cangjie_type_declaration(NamedTypeSymbol::Kind kind, std::string&& name)
{
    assert(!universe.type(name));
    auto* symbol = new TypeDeclarationSymbol(kind, std::move(name));
    universe.register_type(symbol);
    return *symbol;
}

static TypeDeclarationSymbol& add_cangjie_struct(std::string&& name)
{
    return add_cangjie_type_declaration(NamedTypeSymbol::Kind::Struct, std::move(name));
}

static void add_cangjie_interface(std::string&& name)
{
    add_cangjie_type_declaration(NamedTypeSymbol::Kind::Protocol, std::move(name));
}

static void add_cangjie_class(std::string&& name)
{
    add_cangjie_type_declaration(NamedTypeSymbol::Kind::Interface, std::move(name));
}

void add_builtin_types()
{
    add_cangjie_primitive("Unit");
    add_cangjie_primitive("Bool");
    add_cangjie_primitive("Int8");
    add_cangjie_primitive("Int16");
    add_cangjie_primitive("Int32");
    add_cangjie_primitive("Int64");
    add_cangjie_primitive("UInt8");
    add_cangjie_primitive("UInt16");
    add_cangjie_primitive("UInt32");
    add_cangjie_primitive("UInt64");
    add_cangjie_primitive("Float16");
    add_cangjie_primitive("Float32");
    add_cangjie_primitive("Float64");
    add_cangjie_primitive("CString");
    add_cangjie_primitive("CPointer").add_parameter("T");
    add_cangjie_primitive("CFunc").add_parameter("T");
    add_cangjie_struct("ObjCPointer").add_parameter("T");
    add_cangjie_struct("ObjCFunc").add_parameter("T");
    add_cangjie_struct("ObjCBlock").add_parameter("T");
    add_cangjie_class("Class" /* "ObjCClass" */);
    add_cangjie_interface("ObjCId");
    add_cangjie_class("SEL" /* "ObjCSelector" */);
}
