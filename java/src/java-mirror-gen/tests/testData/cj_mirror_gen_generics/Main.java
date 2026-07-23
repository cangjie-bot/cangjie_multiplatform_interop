// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.


public class Main {
    public Box<Integer, Integer> box1;
    public BoxOfNumbers<Integer> box2;
    public BoxOfNumbersWithSupers<Integer> box3;
    public BoxOfNumbersWithGenericSupers<Integer> box4;
    public OuterBoxWithInnerBox<Integer> box5;
    public OuterBoxWithInnerBox<Double>.InnerBox<Integer> box6;
}
