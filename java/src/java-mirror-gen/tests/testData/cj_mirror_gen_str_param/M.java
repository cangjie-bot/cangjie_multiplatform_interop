// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

import java.lang.String;

public class M {
    public int f;

    public M(int f) {
        this.f = f;
    }

    public void goo(String arg) {
        System.out.println(arg);
    }

    public void gooMultipleArgs(String arg1, int arg2) {
        System.out.println(arg1);
        System.out.println(arg2);
    }
}