// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#pragma once
#ifndef CLANGSESSION_H
#define CLANGSESSION_H

#include <memory>

#ifdef OBJCINTEROPGEN_NO_WARNINGS
#// [[nodiscard]] is ignored in C++17 when being applied to constructors.  Older
#// GCC issues warnings on that.
#if __has_cpp_attribute(nodiscard) > 201603L
#define OBJCINTEROPGEN_NODISCARD_CONSTRUCTOR [[nodiscard]]
#else
#define OBJCINTEROPGEN_NODISCARD_CONSTRUCTOR
#endif
#endif

class ClangSessionImpl;

class ClangSession final {
    std::unique_ptr<ClangSessionImpl> impl_;

public:
#ifdef OBJCINTEROPGEN_NO_WARNINGS
    OBJCINTEROPGEN_NODISCARD_CONSTRUCTOR explicit ClangSession();
#else
    [[nodiscard]] explicit ClangSession();
#endif

    ~ClangSession();

    [[nodiscard]] ClangSessionImpl& impl() const;
};

#endif // CLANGSESSION_H
