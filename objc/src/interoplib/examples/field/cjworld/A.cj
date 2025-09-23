// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import interoplib.objc.*

@ObjCImpl
public class A <: M {
    public var cjField: Int64

    public init() {
        super()

        println("cj: A.init()")
        cjField = 123
        foo = 42
        bar = M1(3.14)
    }
}
