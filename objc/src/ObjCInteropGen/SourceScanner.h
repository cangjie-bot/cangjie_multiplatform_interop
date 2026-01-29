// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#pragma once
#ifndef SOURCESCANNER_H
#define SOURCESCANNER_H

#include <string>
#include <vector>

#include "ClangSession.h"

namespace objcgen {

void parse_sources(
    const std::vector<std::string>& files, const std::vector<std::string>& arguments, const ClangSession& session);

} // namespace objcgen

#endif // SOURCESCANNER_H
