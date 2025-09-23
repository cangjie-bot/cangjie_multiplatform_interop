// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package com;

interface I1 {
    public static long staticMethod() {
        return 0;
    }

    public I1 foo();

    public long foo(I1 i);
}

public class JavaClass implements I1 {
    public JavaClass() {
        System.out.println("in JavaClass Init");
    }

    public I1 foo() {
        System.out.println("in JavaClass foo()");
        return this;
    }

    public long foo(I1 i) {
        System.out.println("in JavaClass foo(I1 i)");
        return 0;
    }
}