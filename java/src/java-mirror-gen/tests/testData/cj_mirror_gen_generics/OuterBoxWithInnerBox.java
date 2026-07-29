// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.


public class OuterBoxWithInnerBox<T> {
    public OuterBoxWithInnerBox(OuterBoxWithInnerBox<T> other) {}

    public class InnerBox<U> extends OuterBoxWithInnerBox<U> {
        public InnerBox(OuterBoxWithInnerBox<U> other) {
            super(other);
        }
    }
}
