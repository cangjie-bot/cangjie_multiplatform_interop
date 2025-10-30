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

NonTypeSymbol& Universe::register_top_level_function(std::string name, TypeLikeSymbol& return_type, uint8_t modifiers)
{
    return top_level_.add_function(std::move(name), return_type, modifiers);
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
