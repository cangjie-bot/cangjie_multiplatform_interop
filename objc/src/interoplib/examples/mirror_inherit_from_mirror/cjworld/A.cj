// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import interoplib.objc.*

@ObjCImpl
public class A <: M {
    public init() {
        super()

        println("cj: A.init()")
        let m = M()
    }

    @ForeignName["boo"]
    public func boo(): Bool {
        println("cj: A.boo: M.init()")
        let m = M()
        println("cj: A.boo: M1.init()")
        let m1 = M1()

        m.goo() > m1.goo()
    }
}
