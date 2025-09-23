// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#pragma once
#ifndef INPUTFILE_H
#define INPUTFILE_H

#include "Symbol.h"
#include <filesystem>
#include <set>
#include <vector>

class InputDirectory;

class InputFile final {
    struct SymbolComparator {
        bool operator()(const FileLevelSymbol* symbol1, const FileLevelSymbol* symbol2) const noexcept;
    };

    InputDirectory* directory_;
    std::filesystem::path path_;
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

public:
    Inputs() = default;

    InputFile* operator[](const std::filesystem::path& path);

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
};

extern Inputs inputs;

#endif // INPUTFILE_H
