// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

import java.lang.String;

public class Main {

    public static void main(String[] args) {
        M a = new A(1);
        a.goo("From Java object a");

        M b = new A(2);
        b.goo("From Java object b");

        a.gooMultipleArgs("From Java object a", 8);
    }
}