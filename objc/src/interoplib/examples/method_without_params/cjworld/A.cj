// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import objc.lang.*

@ObjCImpl
public class A <: M {
    public init() {
        super()
    }

    @ForeignName["fooBar"]
    public func fooBar(): M1 {
        let res0 = super.goo()
        println("cj: get Int32 res from objc: ${res0}")

        let res1 = super.foo()
        println("cj: get object from objc with result: ${res1.fooBar()}")

        res1
    }
}
