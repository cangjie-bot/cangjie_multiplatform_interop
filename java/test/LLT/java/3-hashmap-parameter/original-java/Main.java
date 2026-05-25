// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

import java.lang.Integer;
import java.util.HashMap;

public class Main {

    public static void main(String[] args) {
        HashMap<Integer, String> hashMap = new HashMap<>();
        hashMap.put(5, "Value for key 5");
        hashMap.put(7, "Value for key 7");

        M a = new A(1);
        a.goo(hashMap);

        hashMap.put(5, "New value for key 5");
        hashMap.put(8, "Value for key 8");

        M b = new A(2);
        b.goo(hashMap);
    }
}