// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

public class Main {

    public static void main(String[] args) {
        try {
            A a = new A();
            a.goo();
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        System.out.println("");

        try {
            A b = new A();
            b.gooCJThrowGet();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }
}