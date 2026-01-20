// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

enum ee {
    EE01, EE02, EE03, EE04, EE05, EE06, EE07
}

public enum TestEnum03 {
    ee01;

    public enum EE {
        EE01, EE02, EE03, EE04, EE05
    }

    public static class TestEnum {
    }

    String str;
    static TestEnum ce;

    public static void foo() {
        ee ee01 = ee.EE01;
        EE ee02 = EE.EE02;
        System.out.println(ee01);
        System.out.println(ee02);

        // call values()
        ee[] arr = ee.values();

        // call ordinal()
        for (ee ele : arr) {
            // view index
            System.out.println(ele + " at index " + ele.ordinal());
        }
        // call valueOf()
        System.out.println(EE.valueOf("EE01"));
    }
}
