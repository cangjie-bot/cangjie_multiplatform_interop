// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#pragma once
#ifndef LOGGING_H
#define LOGGING_H

#include <iostream>
#include <regex>
#include <string_view>

namespace objcgen {

enum class LogLevel { WARNING = 0, INFO = 1, DIAGNOSTIC = 2, DEBUG = 3, TRACE = 4 };

extern LogLevel verbosity;

std::string_view describe_regex_error(std::regex_constants::error_type type);

template <class T, class... Args> [[noreturn]] void fatal(T&& what, Args&&... args);

class FatalException : public std::exception {
private:
    // Use the `fatal` function for throwing this exception
    FatalException() = default;

    template <class T, class... Args> friend void fatal(T&& what, Args&&... args);
};

template <class T, class... Args> [[noreturn]] void fatal(T&& what, Args&&... args)
{
    ((std::cerr << std::forward<T>(what)) << ... << std::forward<Args>(args)) << std::endl;
    throw FatalException();
}

} // namespace objcgen

#endif // LOGGING_H
