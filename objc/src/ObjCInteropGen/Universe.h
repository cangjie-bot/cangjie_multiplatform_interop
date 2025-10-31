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

    // These are built-in Cangjie type names, which are keywords.  If an Objective-C
    // symbol name conflicts with one of them, the conflict will be resolved by
    // enclosing the name in the `` ticks when printing.
    Keywords,

    // In the C language, type symbols tagged with struct/union/enum can share names
    // with non-tagged symbols.
    Tagged,

    Max = Tagged,
};

inline TypeNamespace kind_to_typename(const NamedTypeSymbol::Kind kind)
{
    switch (kind) {
        case NamedTypeSymbol::Kind::Protocol:
            return TypeNamespace::Protocols;
        case NamedTypeSymbol::Kind::TargetPrimitive:
            return TypeNamespace::Keywords;
        case NamedTypeSymbol::Kind::Struct:
        case NamedTypeSymbol::Kind::Enum:
        case NamedTypeSymbol::Kind::Union:
            return TypeNamespace::Tagged;
        default:
            return TypeNamespace::Primary;
    }
}

constexpr std::uint8_t TYPE_NAMESPACE_COUNT = static_cast<std::uint8_t>(TypeNamespace::Max) + 1;

using type_order_t = std::vector<std::pair<TypeNamespace, std::string>>;

template <bool OnlyType> class UniverseIterator final {
    using iterator_category = std::forward_iterator_tag;
    using difference_type = std::ptrdiff_t;
    using value_type = std::conditional_t<OnlyType, TypeDeclarationSymbol, NamedTypeSymbol>;
    using pointer = value_type*;   // or also value_type*
    using reference = value_type&; // or also value_type&

    type_order_t::const_iterator it_;

    [[nodiscard]] reference get() const;

    void find_next();

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
        find_next();
        return *this;
    }

    // Postfix increment
    UniverseIterator operator++(int)
    {
        UniverseIterator tmp = *this;
        ++(*this);
        return tmp;
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

template <bool OnlyType> struct UniverseTypes final {
    [[nodiscard]] UniverseIterator<OnlyType> cbegin() const;

    [[nodiscard]] UniverseIterator<OnlyType> cend() const;

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

    using type_map_t = std::unordered_map<std::string, NamedTypeSymbol*>;

    TopLevel top_level_;

    type_map_t types_[TYPE_NAMESPACE_COUNT];
    type_order_t type_order_;

    type_map_t& types_map(const TypeNamespace index)
    {
        return types_[static_cast<std::uint8_t>(index)];
    }

    const type_map_t& types_map(const TypeNamespace index) const
    {
        return types_[static_cast<std::uint8_t>(index)];
    }

    friend class UniverseIterator<false>;
    friend class UniverseIterator<true>;
    friend struct UniverseTypes<false>;
    friend struct UniverseTypes<true>;

public:
    Universe()
    {
        for (auto& map : types_) {
            map.reserve(PREALLOCATED_TYPE_COUNT);
        }
        type_order_.reserve(PREALLOCATED_TYPE_COUNT);
    }

    NonTypeSymbol& register_top_level_function(std::string name, TypeLikeSymbol& return_type, uint8_t modifiers);

    void register_type(NamedTypeSymbol* symbol);

    NamedTypeSymbol* type(const NamedTypeSymbol::Kind where, const std::string& name) const
    {
        return this->type(kind_to_typename(where), name);
    }

    NamedTypeSymbol* type(const TypeNamespace where, const std::string& name) const
    {
        auto& types_map = this->types_map(where);
        const auto it = types_map.find(name);
        return it == types_map.end() ? nullptr : it->second;
    }

    NamedTypeSymbol* type(const std::string& name) const
    {
        NamedTypeSymbol* result = nullptr;
        for (std::uint8_t i = 0; i < TYPE_NAMESPACE_COUNT; ++i) {
            if (auto* current = type(static_cast<TypeNamespace>(i), name)) {
                assert(!result);
                result = current;
            }
        }
        return result;
    }

    void process_rename(NamedTypeSymbol* symbol, const std::string& old_name);

    static TopLevelIterator top_level() noexcept;

    static auto all_declarations()
    {
        return UniverseTypes<false>{};
    }

    static auto type_definitions()
    {
        return UniverseTypes<true>{};
    }
};

extern Universe universe;

template <bool OnlyType> typename UniverseIterator<OnlyType>::reference UniverseIterator<OnlyType>::get() const
{
    auto* symbol = universe.type(it_->first, it_->second);
    assert(symbol);
    if constexpr (OnlyType) {
        auto* type = dynamic_cast<TypeDeclarationSymbol*>(symbol);
        assert(type);
        return *type;
    } else {
        return *symbol;
    }
}

template <bool OnlyType> void UniverseIterator<OnlyType>::find_next()
{
    if constexpr (OnlyType) {
        while (++it_ != universe.type_order_.cend()) {
            auto* symbol = universe.type(it_->first, it_->second);
            assert(symbol);
            if (dynamic_cast<TypeDeclarationSymbol*>(symbol)) {
                return;
            }
        }
    } else {
        ++it_;
    }
}

template <bool OnlyType> UniverseIterator<OnlyType> UniverseTypes<OnlyType>::cbegin() const
{
    return UniverseIterator<OnlyType>{universe.type_order_.cbegin()};
}

template <bool OnlyType> UniverseIterator<OnlyType> UniverseTypes<OnlyType>::cend() const
{
    return UniverseIterator<OnlyType>{universe.type_order_.cend()};
}

#endif // UNIVERSE_H
