// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#pragma once
#ifndef CONFIG_H
#define CONFIG_H

#if defined OBJCINTEROPGEN_NO_WARNINGS && defined __GNUC__
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wconversion"
#endif
#include "toml.hpp"
#if defined OBJCINTEROPGEN_NO_WARNINGS && defined __GNUC__
#pragma GCC diagnostic pop
#endif
#include <string_view>

extern toml::table config;

void parse_toml_config_file(std::string_view path);

#endif // CONFIG_H
