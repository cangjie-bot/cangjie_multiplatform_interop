// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#pragma once
#ifndef CONFIG_H
#define CONFIG_H

#include "toml.hpp"
#include <string_view>

extern toml::table config;

void parse_toml_config_file(std::string_view path);

#endif // CONFIG_H
