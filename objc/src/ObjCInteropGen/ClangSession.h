// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#pragma once
#ifndef CLANGSESSION_H
#define CLANGSESSION_H

#include <memory>

namespace objcgen {

class ClangSessionImpl;

class ClangSession final {
    std::unique_ptr<ClangSessionImpl> impl_;

public:
    [[nodiscard]] explicit ClangSession();

    ~ClangSession();

    [[nodiscard]] ClangSessionImpl& impl() const;
};

} // namespace objcgen

#endif // CLANGSESSION_H
