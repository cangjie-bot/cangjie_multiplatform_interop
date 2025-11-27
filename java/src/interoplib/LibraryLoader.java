// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cangjie.lang;

public final class LibraryLoader {
    private LibraryLoader() {
    }

    public static void loadLibrary(String libName) {
        System.loadLibrary(libName);

        String systemLibName = System.mapLibraryName(libName);
        nativeLoadCJLibrary(systemLibName);
    }

    public static native void nativeLoadCJLibrary(String libName);
}
