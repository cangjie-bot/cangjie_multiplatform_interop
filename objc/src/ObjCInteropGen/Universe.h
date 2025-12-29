// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#pragma once
#ifndef UNIVERSE_H
#define UNIVERSE_H

#include <deque>
#include <unordered_map>

#include "Symbol.h"

enum class TypeNamespace : std::uint8_t {
    Primary,

    // In Objective-C, protocols and interfaces can have same names.  In the output
    // Cangjie code we will resolve the conflicts by adding the `Protocol` suffix to
    // protocol names when printing.
    Protocols,

    // In the C language, type symbols tagged with struct/union/enum can share names
    // with non-tagged symbols.
    Tagged,

    Max = Tagged,
};

constexpr std::uint8_t TYPE_NAMESPACE_COUNT = static_cast<std::uint8_t>(TypeNamespace::Max) + 1;

using type_order_t = std::vector<std::pair<TypeNamespace, std::string>>;

template <class TypeSymbol> type_order_t::const_iterator find_first(type_order_t::const_iterator it);

template <class TypeSymbol> class UniverseIterator final {
    using iterator_category = std::forward_iterator_tag;
    using difference_type = std::ptrdiff_t;
    using value_type = TypeSymbol;
    using pointer = value_type*;   // or also value_type*
    using reference = value_type&; // or also value_type&

    type_order_t::const_iterator it_;

    [[nodiscard]] reference get() const;

public:
    explicit UniverseIterator(type_order_t::const_iterator it) : it_(std::move(it))
    {
    }

    reference operator*() const
    {
        return get();
    }
    pointer operator->()
    {
        return &get();
    }

    // Prefix increment
    UniverseIterator& operator++()
    {
        it_ = find_first<TypeSymbol>(++it_);
        return *this;
    }

    friend bool operator==(const UniverseIterator& lhs, const UniverseIterator& rhs)
    {
        return lhs.it_ == rhs.it_;
    }

    friend bool operator!=(const UniverseIterator& lhs, const UniverseIterator& rhs)
    {
        return !(lhs == rhs);
    }
};

template <class TypeSymbol> struct UniverseTypes final {
    [[nodiscard]] UniverseIterator<TypeSymbol> cbegin() const;

    [[nodiscard]] UniverseIterator<TypeSymbol> cend() const;

    [[nodiscard]] auto begin() const
    {
        return cbegin();
    }

    [[nodiscard]] auto end() const
    {
        return cend();
    }
};

class TopLevelIterator final {
public:
    explicit TopLevelIterator(std::deque<NonTypeSymbol>& members) noexcept : members_(members)
    {
    }

    [[nodiscard]] auto begin() const noexcept
    {
        return members_.begin();
    }

    [[nodiscard]] auto end() const noexcept
    {
        return members_.end();
    }

private:
    std::deque<NonTypeSymbol>& members_;
};

class TopLevel final {
public:
    auto get_iterator() noexcept
    {
        return TopLevelIterator(members_);
    }

    NonTypeSymbol& add_function(std::string name, TypeLikeSymbol& return_type, uint8_t modifiers);

private:
    std::deque<NonTypeSymbol> members_;
};

class Universe final {
    static constexpr int PREALLOCATED_TYPE_COUNT = 8192;

    enum class PrimitiveTypeIndex {
        Unit,
        Bool,
        Int8,
        Int16,
        Int32,
        Int64,
        UInt8,
        UInt16,
        UInt32,
        UInt64,
        Float16,
        Float32,
        Float64
    };
    static constexpr int NumberOfPrimitiveTypes = static_cast<int>(PrimitiveTypeIndex::Float64) + 1;

    enum class BuiltInTypeDeclarationIndex { Int128, UInt128, Class, Id, Sel };
    static constexpr int NumberOfBuiltInTypeDeclarations = static_cast<int>(BuiltInTypeDeclarationIndex::Sel) + 1;

    using type_map_t = std::unordered_map<std::string, NamedTypeSymbol*>;

    TopLevel top_level_;

    type_map_t types_[TYPE_NAMESPACE_COUNT];
    type_order_t type_order_;

    PrimitiveTypeSymbol primitive_types_[NumberOfPrimitiveTypes];
    TypeDeclarationSymbol built_in_type_declarations_[NumberOfBuiltInTypeDeclarations];

    type_map_t& types_map(const TypeNamespace index)
    {
        return types_[static_cast<std::uint8_t>(index)];
    }

    const type_map_t& types_map(const TypeNamespace index) const
    {
        return types_[static_cast<std::uint8_t>(index)];
    }

    template <class TypeSymbol> friend class UniverseIterator;
    template <class TypeSymbol> friend struct UniverseTypes;
    template <class TypeSymbol> friend type_order_t::const_iterator find_first(type_order_t::const_iterator it);

public:
    Universe();

    NonTypeSymbol& register_top_level_function(std::string name, TypeLikeSymbol& return_type, uint8_t modifiers);

    void register_type(NamedTypeSymbol* symbol);

    [[nodiscard]] NamedTypeSymbol& primitive_type(PrimitiveTypeCategory category, size_t size) noexcept;

    [[nodiscard]] TypeDeclarationSymbol& id() noexcept
    {
        return built_in_type_declarations_[static_cast<int>(BuiltInTypeDeclarationIndex::Id)];
    }

    [[nodiscard]] TypeDeclarationSymbol& clazz() noexcept
    {
        return built_in_type_declarations_[static_cast<int>(BuiltInTypeDeclarationIndex::Class)];
    }

    [[nodiscard]] TypeDeclarationSymbol& sel() noexcept
    {
        return built_in_type_declarations_[static_cast<int>(BuiltInTypeDeclarationIndex::Sel)];
    }

    // Find the registered type symbol by its name and kind.  Return nullptr if no
    // such type has been registered.
    [[nodiscard]] NamedTypeSymbol* type(NamedTypeSymbol::Kind where, const std::string& name) const noexcept;

    // Find the registered type symbol by its name and namespace.  Return nullptr if
    // no such type has been registered.
    [[nodiscard]] NamedTypeSymbol* type(TypeNamespace where, const std::string& name) const;

    // Find a registered type symbol by its name.  Return nullptr if no such type
    // has been registered.
    [[nodiscard]] NamedTypeSymbol* type(const std::string& name) const;

    // Find a type by its name.  First, find among primitive and built-in
    // ObjCInteropGen types.  Then in the Primary - Protocol - Tagged namespaces (in
    // that particular order).  Return nullptr if no such type can be found.
    [[nodiscard]] NamedTypeSymbol* any_type(const std::string& name);

    void process_rename(NamedTypeSymbol* symbol, const std::string& old_name);

    static TopLevelIterator top_level() noexcept;

    static auto all_declarations()
    {
        return UniverseTypes<NamedTypeSymbol>{};
    }

    static auto type_definitions()
    {
        return UniverseTypes<TypeDeclarationSymbol>{};
    }
};

extern Universe universe;

template <class TypeSymbol> typename UniverseIterator<TypeSymbol>::reference UniverseIterator<TypeSymbol>::get() const
{
    auto* symbol = universe.type(it_->first, it_->second);
    assert(symbol);
    if constexpr (std::is_same_v<TypeSymbol, NamedTypeSymbol>) {
        return *symbol;
    } else {
        assert(dynamic_cast<TypeSymbol*>(symbol));
        return static_cast<TypeSymbol&>(*symbol);
    }
}

template <class TypeSymbol> type_order_t::const_iterator find_first(type_order_t::const_iterator it)
{
    if constexpr (!std::is_same_v<TypeSymbol, NamedTypeSymbol>) {
        for (auto e = universe.type_order_.cend(); it != e; ++it) {
            auto* symbol = universe.type(it->first, it->second);
            assert(symbol);
            if (dynamic_cast<TypeSymbol*>(symbol)) {
                break;
            }
        }
    }
    return it;
}

template <class TypeSymbol> UniverseIterator<TypeSymbol> UniverseTypes<TypeSymbol>::cbegin() const
{
    return UniverseIterator<TypeSymbol>{find_first<TypeSymbol>(universe.type_order_.cbegin())};
}

template <class TypeSymbol> UniverseIterator<TypeSymbol> UniverseTypes<TypeSymbol>::cend() const
{
    return UniverseIterator<TypeSymbol>{universe.type_order_.cend()};
}

#endif // UNIVERSE_H
