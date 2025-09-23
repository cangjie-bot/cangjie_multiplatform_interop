// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

public class TestClass05 extends Animal {
    public TestClass05() {
    }

    public TestClass05 eat() {
        return this;
    }

    public void eat(int time) {
        System.out.println(time);
    }
}