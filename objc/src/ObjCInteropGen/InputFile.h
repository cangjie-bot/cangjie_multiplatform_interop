// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#pragma once
#ifndef INPUTFILE_H
#define INPUTFILE_H

#include <filesystem>
#include <set>
#include <vector>

#ifdef OBJCINTEROPGEN_NO_WARNINGS
#// [[nodiscard]] is ignored in C++17 when being applied to constructors.  Older
#// GCC issues warnings on that.
#if __has_cpp_attribute(nodiscard) > 201603L
#define OBJCINTEROPGEN_NODISCARD_CONSTRUCTOR [[nodiscard]]
#else
#define OBJCINTEROPGEN_NODISCARD_CONSTRUCTOR
#endif
#endif

class FileLevelSymbol;
class InputDirectory;

struct LineCol {
    unsigned line_;
    unsigned col_;

    friend bool operator<(const LineCol& loc1, const LineCol& loc2) noexcept
    {
        return loc1.line_ < loc2.line_ || (loc1.line_ == loc2.line_ && loc1.col_ < loc2.col_);
    }
};

struct Location : LineCol {
    std::filesystem::path file_;

    [[nodiscard]] auto is_null() const noexcept
    {
        return file_.empty();
    }
};

static Location null_location = Location{{0, 0}, {}};

class InputFile final {
    struct SymbolComparator {
        bool operator()(const FileLevelSymbol* symbol1, const FileLevelSymbol* symbol2) const noexcept;
    };

    InputDirectory* directory_;
    std::filesystem::path path_;

    std::set<LineCol> cursors_up_to_this_translation_;
    std::set<LineCol> cursors_in_this_translation_;

    std::multiset<FileLevelSymbol*, SymbolComparator> symbols_;

    friend class FileLevelSymbol;

    void add_symbol(FileLevelSymbol* symbol);

public:
    [[nodiscard]] InputFile(InputDirectory* directory, std::filesystem::path path);

    [[nodiscard]] InputDirectory* directory() const
    {
        return directory_;
    }

    [[nodiscard]] std::filesystem::path path() const
    {
        return path_;
    }

    [[nodiscard]] auto cbegin() const
    {
        return symbols_.cbegin();
    }

    [[nodiscard]] auto cend() const
    {
        return symbols_.cend();
    }

    [[nodiscard]] auto begin() const
    {
        return cbegin();
    }

    [[nodiscard]] auto end() const
    {
        return cend();
    }

    void next_translation();

    [[nodiscard]] bool add_cursor(const LineCol& location);
};

class InputDirectory final {
    std::filesystem::path path_;
    std::vector<InputFile*> files_;

    friend class InputFile;

public:
    [[nodiscard]] explicit InputDirectory(std::filesystem::path path) : path_(std::move(path))
    {
    }

    [[nodiscard]] std::filesystem::path path() const
    {
        return path_;
    }

    [[nodiscard]] auto cbegin() const
    {
        return files_.cbegin();
    }

    [[nodiscard]] auto cend() const
    {
        return files_.cend();
    }

    [[nodiscard]] auto begin() const
    {
        return cbegin();
    }

    [[nodiscard]] auto end() const
    {
        return cend();
    }
};

class Inputs final {
    std::vector<InputDirectory*> directories_;

    std::set<std::string> builtin_cursors_up_to_this_translation_;
    std::set<std::string> builtin_cursors_in_this_translation_;

public:
    Inputs() = default;

    InputFile& operator[](const std::filesystem::path& path);

    auto cbegin() const
    {
        return directories_.cbegin();
    }

    auto cend() const
    {
        return directories_.cend();
    }

    auto begin() const
    {
        return cbegin();
    }

    auto end() const
    {
        return cend();
    }

    void next_translation();

    [[nodiscard]] bool add_cursor(const Location& location, const std::string& name);
};

extern Inputs inputs;

#endif // INPUTFILE_H
