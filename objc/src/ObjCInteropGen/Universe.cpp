// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#include "Universe.h"

#include <algorithm>

namespace objcgen {

Universe& Universe::get()
{
    static Universe universe;
    return universe;
}

NonTypeSymbol& TopLevel::add_function(
    std::string name, Type return_type, std::vector<ParameterSymbol> parameters, Modifiers modifiers)
{
    assert(member_set_.empty() && "Calling TopLevel::add_function after TopLevel::make_unique");
    return members_.emplace_back(
        std::move(name), NonTypeSymbol::Kind::GlobalFunction, std::move(return_type), std::move(parameters), modifiers);
}

struct SymbolPointerComparator final {
    using is_transparent = void;

    bool operator()(const NonTypeSymbol* symbol1, const NonTypeSymbol* symbol2) const noexcept
    {
        return symbol1->name() < symbol2->name();
    }

    bool operator()(std::string_view name, const NonTypeSymbol* symbol) const noexcept
    {
        return name < symbol->name();
    }

    bool operator()(const NonTypeSymbol* symbol, std::string_view name) const noexcept
    {
        return symbol->name() < name;
    }
};

template <class Set, class It> static void rename_set_element(Set& set, It it)
{
    auto new_name = (*it)->name() + '_';
    auto node = set.extract(it);
    assert(node);
    auto e = set.end();
    while (set.find(new_name) != e) {
        new_name += '_';
    }
    node.value()->rename(std::move(new_name));
    set.insert(std::move(node));
}

void TopLevel::make_unique()
{
    if (members_.empty() || !member_set_.empty()) {
        return;
    }
    std::multiset<NonTypeSymbol*, SymbolPointerComparator> multiset;
    for (auto& func : members_) {
        multiset.insert(&func);
    }
    auto e = multiset.cend();
    auto it = multiset.cbegin();
    for (auto next_it = std::next(it); next_it != e; next_it = std::next(it)) {
        const auto& func = **it;
        const auto& next_func = **next_it;
        if (next_func.name() == func.name()) {
            if (func.is_overloadable()) {
                rename_set_element(multiset, it);
                it = next_it;
            } else {
                assert(next_func.is_overloadable());
                rename_set_element(multiset, next_it);
            }
        } else {
            it = next_it;
        }
    }
    member_set_.merge(multiset);
    assert(multiset.empty());
}

const NonTypeSymbol* TopLevel::find_function(std::string_view name) const noexcept
{
    assert(
        (members_.empty() || !member_set_.empty()) && "Calling TopLevel::find_function without TopLevel::make_unique");
    auto it = member_set_.find(name);
    return it == member_set_.end() ? nullptr : *it;
}

Universe::Universe()
    : unit_("Unit", PrimitiveTypeCategory::Unit, PrimitiveSize::Zero),
      bool_("Bool", PrimitiveTypeCategory::Boolean, PrimitiveSize::One),
      int8_("Int8", PrimitiveTypeCategory::SignedInteger, PrimitiveSize::One),
      int16_("Int16", PrimitiveTypeCategory::SignedInteger, PrimitiveSize::Two),
      int32_("Int32", PrimitiveTypeCategory::SignedInteger, PrimitiveSize::Four),
      int64_("Int64", PrimitiveTypeCategory::SignedInteger, PrimitiveSize::Eight),
      uint8_("UInt8", PrimitiveTypeCategory::UnsignedInteger, PrimitiveSize::One),
      uint16_("UInt16", PrimitiveTypeCategory::UnsignedInteger, PrimitiveSize::Two),
      uint32_("UInt32", PrimitiveTypeCategory::UnsignedInteger, PrimitiveSize::Four),
      uint64_("UInt64", PrimitiveTypeCategory::UnsignedInteger, PrimitiveSize::Eight),
      float16_("Float16", PrimitiveTypeCategory::FloatingPoint, PrimitiveSize::Two),
      float32_("Float32", PrimitiveTypeCategory::FloatingPoint, PrimitiveSize::Four),
      float64_("Float64", PrimitiveTypeCategory::FloatingPoint, PrimitiveSize::Eight),
      class_(NamedTypeSymbol::Kind::Interface, "ObjCClass"),
      id_(NamedTypeSymbol::Kind::Protocol, "ObjCId"),
      sel_(NamedTypeSymbol::Kind::Interface, "SEL" /* "ObjCSelector" */),

      // `pointer_` and `func_` do not have fixed names.  They can be "CPointer/CFunc"
      // or "ObjCPointer/ObjCFunc", depending on the parameter types.
      pointer_({}),
      func_({}),

      block_("ObjCBlock"),
      varray_("VArray")
{
    for (auto& map : types_) {
        map.reserve(PREALLOCATED_TYPE_COUNT);
    }
    type_order_.reserve(PREALLOCATED_TYPE_COUNT);
    register_type(unit_);
    register_type(bool_);
    register_type(int8_);
    register_type(int16_);
    register_type(int32_);
    register_type(int64_);
    register_type(uint8_);
    register_type(uint16_);
    register_type(uint32_);
    register_type(uint64_);
    register_type(float16_);
    register_type(float32_);
    register_type(float64_);
    register_type(class_);
    register_type(id_);
    register_type(sel_);

    // These types are ObjC built-ins.  They are not subjects for closure-depth
    // filtering, their reference levels must be initially zero.
    class_.set_zero_reference_level();
    id_.set_zero_reference_level();
    sel_.set_zero_reference_level();
}

NonTypeSymbol& Universe::register_top_level_function(
    std::string name, Type return_type, std::vector<ParameterSymbol> parameters, Modifiers modifiers)
{
    return top_level_.add_function(std::move(name), std::move(return_type), std::move(parameters), modifiers);
}

[[nodiscard]] static TypeNamespace kind_to_typename(NamedTypeSymbol::Kind kind) noexcept
{
    switch (kind) {
        case NamedTypeSymbol::Kind::Protocol:
            return TypeNamespace::Protocols;
        case NamedTypeSymbol::Kind::Primitive:
            return TypeNamespace::Keywords;
        case NamedTypeSymbol::Kind::Struct:
        case NamedTypeSymbol::Kind::Enum:
        case NamedTypeSymbol::Kind::Union:
            return TypeNamespace::Tagged;
        default:
            return TypeNamespace::Primary;
    }
}

void Universe::register_type(NamedTypeSymbol& symbol)
{
    std::string_view name = symbol.name();
    auto type_namespace = kind_to_typename(symbol.kind());

    auto& types_map = this->types_map(type_namespace);
    assert(types_map.find(name) == types_map.end());

    types_map.try_emplace(name, &symbol);
    type_order_.emplace_back(TypeOrderElement{type_namespace, name});
}

NamedTypeSymbol* Universe::type(NamedTypeSymbol::Kind where, std::string_view name) const noexcept
{
    assert(where != NamedTypeSymbol::Kind::Primitive);
    return this->type(kind_to_typename(where), name);
}

NamedTypeSymbol* Universe::type(TypeNamespace where, std::string_view name) const
{
    auto& types_map = this->types_map(where);
    const auto it = types_map.find(name);
    return it == types_map.end() ? nullptr : it->second;
}

NamedTypeSymbol* Universe::type(std::string_view name) const
{
    for (std::uint8_t i = 0; i < TYPE_NAMESPACE_COUNT; ++i) {
        if (auto* result = type(static_cast<TypeNamespace>(i), name)) {
            return result;
        }
    }
    return nullptr;
}

void Universe::rename_type(NamedTypeSymbol& symbol, std::string new_name)
{
    assert(!new_name.empty());
    std::string_view old_name = symbol.name();
    assert(!old_name.empty());
    assert(new_name != old_name);
    const auto type_namespace = kind_to_typename(symbol.kind());
    auto& types_map = this->types_map(type_namespace);

    auto type_order_it = std::find(type_order_.begin(), type_order_.end(), TypeOrderElement{type_namespace, old_name});
    assert(type_order_it != type_order_.end());
    auto node = types_map.extract(old_name);
    assert(node);
    assert(node.key() == old_name);
    assert(node.mapped() == &symbol);
    symbol.rename(std::move(new_name));
    std::string_view new_name_view = symbol.name();
    node.key() = new_name_view;
    types_map.insert(std::move(node));
    type_order_it->name = new_name_view;
}

void Universe::make_global_symbols_unique()
{
    top_level_.make_unique();
}

const NonTypeSymbol* Universe::global_non_type_symbol(std::string_view name) const noexcept
{
    return top_level_.find_function(name);
}

} // namespace objcgen
