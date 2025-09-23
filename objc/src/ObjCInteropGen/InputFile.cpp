// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#include "InputFile.h"

Inputs inputs;

bool InputFile::SymbolComparator::operator()(
    const FileLevelSymbol* symbol1, const FileLevelSymbol* symbol2) const noexcept
{
    return *symbol1 < *symbol2;
}

void InputFile::add_symbol(FileLevelSymbol* symbol)
{
    assert(symbol);
    assert(symbol->is_file_level());
    symbols_.insert(symbol);
}

InputFile::InputFile(InputDirectory* directory, std::filesystem::path path)
    : directory_(directory), path_(std::move(path))
{
    assert(directory);
    directory->files_.push_back(this);
}

InputFile* Inputs::operator[](const std::filesystem::path& path)
{
    assert(path.has_parent_path());
    const auto parent = path.parent_path();
    InputDirectory* found_directory = nullptr;
    for (auto* directory : directories_) {
        if (parent == directory->path()) {
            found_directory = directory;
            break;
        }
    }
    if (!found_directory) {
        found_directory = new InputDirectory(parent);
        directories_.push_back(found_directory);
    }
    for (auto* file : *found_directory) {
        if (file->path() == path) {
            return file;
        }
    }
    return new InputFile(found_directory, path);
}
