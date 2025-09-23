// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#include "Mappings.h"

#include "Universe.h"

std::vector<TypeMapping*> mappings;

TypeLikeSymbol* find(const std::string& name)
{
    // Find the target type symbol by its name.  If both a Cangjie primitive type
    // and a type declared in Objective-C is found, the primitive type is preferred.
    auto* result = universe.type(NamedTypeSymbol::Kind::TargetPrimitive, name);
    if (!result) {
        result = universe.type(name);
        assert(result);
    }
    return result;
}

TypeLikeSymbol* NonGenericMapping::map([[maybe_unused]] NamedTypeSymbol* type)
{
    assert(can_map(type));
    return find(to_);
}

struct PrimitiveMapping final : TypeMapping {
public:
    explicit PrimitiveMapping() = default;

    bool can_map(NamedTypeSymbol* type) override
    {
        if (type->is(NamedTypeSymbol::Kind::SourcePrimitive)) {
            if (auto* type_decl = dynamic_cast<TypeDeclarationSymbol*>(type)) {
                if (auto info = type_decl->primitive_information()) {
                    return info->category() != PrimitiveTypeCategory::Unknown;
                }
            }
        }
        return false;
    }

    TypeLikeSymbol* map(NamedTypeSymbol* type) override
    {
        constexpr unsigned sizeOfInt8 = 1;
        constexpr unsigned sizeOfInt16 = 2;
        constexpr unsigned sizeOfInt32 = 4;
        constexpr unsigned sizeOfInt64 = 8;
        assert(can_map(type));
        if (auto* type_decl = dynamic_cast<TypeDeclarationSymbol*>(type)) {
            if (auto info = type_decl->primitive_information()) {
                const auto size = info->size();
                switch (info->category()) {
                    case PrimitiveTypeCategory::Unknown:
                        assert(false);
                        return type;
                    case PrimitiveTypeCategory::Boolean:
                        return find("Bool");
                    case PrimitiveTypeCategory::SignedInteger:
                        switch (size) {
                            case sizeOfInt8:
                                return find("Int8");
                            case sizeOfInt16:
                                return find("Int16");
                            case sizeOfInt32:
                                return find("Int32");
                            case sizeOfInt64:
                                return find("Int64");
                            default:
                                assert(false);
                                return type;
                        }
                    case PrimitiveTypeCategory::UnsignedInteger:
                        switch (size) {
                            case sizeOfInt8:
                                return find("UInt8");
                            case sizeOfInt16:
                                return find("UInt16");
                            case sizeOfInt32:
                                return find("UInt32");
                            case sizeOfInt64:
                                return find("UInt64");
                            default:
                                assert(false);
                                return type;
                        }
                    case PrimitiveTypeCategory::FloatingPoint:
                        switch (size) {
                            case sizeOfInt16:
                                return find("Float16");
                            case sizeOfInt32:
                                return find("Float32");
                            case sizeOfInt64:
                                return find("Float64");
                            default:
                                // TODO: do something?
                                return type;
                        }
                }
            }
        }
        assert(false);
        return type;
    }
};

void initialize_mappings()
{
    add_non_generic_mapping("Bool").add_from("BOOL");
    add_non_generic_mapping("Unit").add_from("void");
    mappings.push_back(new PrimitiveMapping());
    read_toml_mappings();
}

NonGenericMapping& add_non_generic_mapping(const std::string_view to)
{
    auto* mapping = new NonGenericMapping(to);
    mappings.push_back(mapping);
    return *mapping;
}
