// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#include "Universe.h"

Universe universe;

NonTypeSymbol& TopLevel::add_function(std::string name, TypeLikeSymbol& return_type, uint8_t modifiers)
{
    return members_.emplace_back(
        NonTypeSymbol::Private(), std::move(name), NonTypeSymbol::Kind::GlobalFunction, &return_type, modifiers);
}

TopLevelIterator Universe::top_level() noexcept
{
    return universe.top_level_.get_iterator();
}

Universe::Universe()
    : primitive_types_{{"Unit", PrimitiveTypeCategory::Unit, PrimitiveSize::Zero},
          {"Bool", PrimitiveTypeCategory::Boolean, PrimitiveSize::One},
          {"Int8", PrimitiveTypeCategory::SignedInteger, PrimitiveSize::One},
          {"Int16", PrimitiveTypeCategory::SignedInteger, PrimitiveSize::Two},
          {"Int32", PrimitiveTypeCategory::SignedInteger, PrimitiveSize::Four},
          {"Int64", PrimitiveTypeCategory::SignedInteger, PrimitiveSize::Eight},
          {"UInt8", PrimitiveTypeCategory::UnsignedInteger, PrimitiveSize::One},
          {"UInt16", PrimitiveTypeCategory::UnsignedInteger, PrimitiveSize::Two},
          {"UInt32", PrimitiveTypeCategory::UnsignedInteger, PrimitiveSize::Four},
          {"UInt64", PrimitiveTypeCategory::UnsignedInteger, PrimitiveSize::Eight},
          {"Float16", PrimitiveTypeCategory::FloatingPoint, PrimitiveSize::Two},
          {"Float32", PrimitiveTypeCategory::FloatingPoint, PrimitiveSize::Four},
          {"Float64", PrimitiveTypeCategory::FloatingPoint, PrimitiveSize::Eight}},
      built_in_type_declarations_{{NamedTypeSymbol::Kind::Struct, "ObjCInt128"},
          {NamedTypeSymbol::Kind::Struct, "ObjCUInt128"}, {NamedTypeSymbol::Kind::Interface, "ObjCClass"},
          {NamedTypeSymbol::Kind::Protocol, "ObjCId"}, {NamedTypeSymbol::Kind::Interface, "SEL" /* "ObjCSelector" */}}
{
    for (auto& map : types_) {
        map.reserve(PREALLOCATED_TYPE_COUNT);
    }
    type_order_.reserve(PREALLOCATED_TYPE_COUNT);
}

NonTypeSymbol& Universe::register_top_level_function(std::string name, TypeLikeSymbol& return_type, uint8_t modifiers)
{
    return top_level_.add_function(std::move(name), return_type, modifiers);
}

[[nodiscard]] static TypeNamespace kind_to_typename(NamedTypeSymbol::Kind kind) noexcept
{
    switch (kind) {
        case NamedTypeSymbol::Kind::Protocol:
            return TypeNamespace::Protocols;
        case NamedTypeSymbol::Kind::Struct:
        case NamedTypeSymbol::Kind::Enum:
        case NamedTypeSymbol::Kind::Union:
            return TypeNamespace::Tagged;
        default:
            return TypeNamespace::Primary;
    }
}

void Universe::register_type(NamedTypeSymbol* symbol)
{
    assert(symbol);
    const auto kind = symbol->kind();
    const auto name = std::string(symbol->name());
    const auto type_namespace = kind_to_typename(kind);

    auto& types_map = this->types_map(type_namespace);
    assert(types_map.find(name) == types_map.end());

    types_map.emplace(name, symbol);
    type_order_.emplace_back(type_namespace, name);
}

NamedTypeSymbol& Universe::primitive_type(PrimitiveTypeCategory category, size_t size) noexcept
{
    switch (category) {
        case PrimitiveTypeCategory::Boolean:
            return primitive_types_[static_cast<int>(PrimitiveTypeIndex::Bool)];
        case PrimitiveTypeCategory::SignedInteger:
            switch (size) {
                case 1:
                    return primitive_types_[static_cast<int>(PrimitiveTypeIndex::Int8)];
                case 2:
                    return primitive_types_[static_cast<int>(PrimitiveTypeIndex::Int16)];
                case 4:
                    return primitive_types_[static_cast<int>(PrimitiveTypeIndex::Int32)];
                case 8:
                    return primitive_types_[static_cast<int>(PrimitiveTypeIndex::Int64)];
                default:
                    assert(size == 16);
                    return built_in_type_declarations_[static_cast<int>(BuiltInTypeDeclarationIndex::Int128)];
            }
        case PrimitiveTypeCategory::UnsignedInteger:
            switch (size) {
                case 1:
                    return primitive_types_[static_cast<int>(PrimitiveTypeIndex::UInt8)];
                case 2:
                    return primitive_types_[static_cast<int>(PrimitiveTypeIndex::UInt16)];
                case 4:
                    return primitive_types_[static_cast<int>(PrimitiveTypeIndex::UInt32)];
                case 8:
                    return primitive_types_[static_cast<int>(PrimitiveTypeIndex::UInt64)];
                default:
                    assert(size == 16);
                    return built_in_type_declarations_[static_cast<int>(BuiltInTypeDeclarationIndex::UInt128)];
            }
        case PrimitiveTypeCategory::FloatingPoint:
            switch (size) {
                case 2:
                    return primitive_types_[static_cast<int>(PrimitiveTypeIndex::Float16)];
                case 4:
                    return primitive_types_[static_cast<int>(PrimitiveTypeIndex::Float32)];
                case 8:
                    return primitive_types_[static_cast<int>(PrimitiveTypeIndex::Float64)];
                default:
                    assert(size == 16);
                    return built_in_type_declarations_[static_cast<int>(BuiltInTypeDeclarationIndex::Int128)];
            }
        default:
            assert(category == PrimitiveTypeCategory::Unit);
            return primitive_types_[static_cast<int>(PrimitiveTypeIndex::Unit)];
    }
}

NamedTypeSymbol* Universe::type(NamedTypeSymbol::Kind where, const std::string& name) const noexcept
{
    assert(where != NamedTypeSymbol::Kind::Primitive);
    return this->type(kind_to_typename(where), name);
}

NamedTypeSymbol* Universe::type(TypeNamespace where, const std::string& name) const
{
    auto& types_map = this->types_map(where);
    const auto it = types_map.find(name);
    return it == types_map.end() ? nullptr : it->second;
}

NamedTypeSymbol* Universe::type(const std::string& name) const
{
    for (std::uint8_t i = 0; i < TYPE_NAMESPACE_COUNT; ++i) {
        if (auto* result = type(static_cast<TypeNamespace>(i), name)) {
            return result;
        }
    }
    return nullptr;
}

NamedTypeSymbol* Universe::any_type(const std::string& name)
{
    for (int i = 0; i < NumberOfPrimitiveTypes; ++i) {
        if (primitive_types_[i].name() == name) {
            return &primitive_types_[i];
        };
    }
    for (int i = 0; i < NumberOfBuiltInTypeDeclarations; ++i) {
        if (built_in_type_declarations_[i].name() == name) {
            return &built_in_type_declarations_[i];
        };
    }
    return type(name);
}

void Universe::process_rename(NamedTypeSymbol* symbol, const std::string& old_name)
{
    assert(symbol);

    const auto kind = symbol->kind();
    const auto new_name = std::string(symbol->name());
    const auto type_namespace = kind_to_typename(kind);
    assert(!new_name.empty());
    assert(!old_name.empty());
    assert(new_name != old_name);

    auto& types_map = this->types_map(type_namespace);
    auto it = types_map.find(old_name);
    assert(it != types_map.end());
    assert(it->first == old_name);
    assert(it->second == symbol);
    types_map.erase(it);

    assert(types_map.find(new_name) == types_map.end());
    types_map.emplace(new_name, symbol);

    [[maybe_unused]] auto changed = false;

    for (auto& [fst, snd] : type_order_) {
        if (fst == type_namespace && snd == old_name) {
            assert(!changed);
            snd = new_name;
            changed = true;
        }
    }

    assert(changed);
}
