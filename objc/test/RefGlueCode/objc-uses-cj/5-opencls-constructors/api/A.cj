// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package api

public open class A {
    let x: Int64
    let y: Int64

    public init(x: Int64) {
        this.x = x
        this.y = x
    }

    public init(x: Int64, y: Int64) {
        this.x = x
        this.y = y
    }

    // Overridden at ObjC side in AA
    public open func fooI64(): Int64 {
        println("[CJ]: A.fooI64()")
        x + y
    }
}
