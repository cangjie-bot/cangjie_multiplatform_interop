// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package mirrors;

import java.lang.Integer;
import java.util.HashMap;
import java.util.Map;

public class M {
    public M() {
        System.out.println("From Java constructor");
    }

    public M(int arg) {
        System.out.println("From Java constructor with argument " + arg);
    }

    public void goo(HashMap<Integer, String> map) {
        System.out.println("Hello from Java M goo(HashMap)");
        for (Map.Entry<Integer, String> entry : map.entrySet()) {
            System.out.println(entry.getKey());
            System.out.println(entry.getValue());
        }
    }
}