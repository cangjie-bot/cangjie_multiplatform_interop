// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package com.xxx;

public class CalledA {
    public int a = 0;

    public void setHandler(int in) {
        System.out.println("cjdemo-CalledA.java setHandler");
        this.a = in;
    }

    public int getHandler() {
        System.out.println("cjdemo-CalledA.java getHandler");
        System.out.println("cjdemo-CalledA.java " + String.valueOf(a));
        return a;
    }
}