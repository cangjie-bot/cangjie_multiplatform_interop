// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package api

public open class A {
    public open func fooVirtual(): Unit {
        println("[CJ]: A.fooVirtual()")
    }
    public open func callFooVirtual(): Unit {
        println("[CJ]: A.callFooVirtual()")
        fooVirtual()
    }
    public open func fooI32(): Int32 {
        println("[CJ]: A.fooI32()")
        Int32(32)
    }
    public open func fooA(): A {
        println("[CJ]: A.fooA() returns new A()")
        A()
    }
    public open func paramA(a: A): Unit {
        let resI32 = a.fooI32()
        println("[CJ]: A.paramA gets arg (a.fooI32 == ${resI32})")
    }
}
