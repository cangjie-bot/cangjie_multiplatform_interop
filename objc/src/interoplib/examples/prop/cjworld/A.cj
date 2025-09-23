// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import interoplib.objc.*

@ObjCImpl
public class A <: M {
    private var _b: M1

    public mut prop a: Int64 {
        get() {
            foo
        }
        set(value) {
            foo = value
        }
    }

    public mut prop b: M1 {
        get() {
            _b
        }
        set(value) {
            _b = value
        }
    }

    public prop c: Bool {
        get() {
            true
        }
    }

    private prop d: Float64 {
        get() {
            3.14159
        }
    }

    public init() {
        super()

        println("cj: A.init()")

        _b = M1(123.123)
        foo = 42
        bar = M1(d)
    }
}
