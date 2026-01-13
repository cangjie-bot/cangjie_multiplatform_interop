// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

import package1.*;

public class Main extends A {
    void goo() {
        fooProtected();
    }

    public static void main(String[] args) {
        A a = new A();
        a.fooPublic();

        a.fPublic = 1;
        return;
    }
}