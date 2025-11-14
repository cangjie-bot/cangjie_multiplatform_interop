// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package api

public open class A {
    // Overridden at ObjC side in AA
    public open func foo0(): Unit {
        println("[CJ]: A.foo0()")
    }
    public open func foo1(): Unit {
        println("[CJ]: A.foo1() must not be overridden at ObjC as it is used as a test func at CJ side")
        println("[CJ]: try foo0:"); foo0()
        println("[CJ]: try foo42:"); foo42()
        println("[CJ]: try foo62:"); foo62()
        println("[CJ]: try foo63:"); foo63()
        println("[CJ]: try foo64 (overridden at ObjC):"); foo64()
        println("[CJ]: try foo65 (NOT overridden at ObjC):"); foo65()
    }
    public open func foo2(): Unit {
        println("[CJ]: A.foo2()")
    }
    public open func foo3(): Unit {
        println("[CJ]: A.foo3()")
    }
    public open func foo4(): Unit {
        println("[CJ]: A.foo4()")
    }
    public open func foo5(): Unit {
        println("[CJ]: A.foo5()")
    }
    public open func foo6(): Unit {
        println("[CJ]: A.foo6()")
    }
    public open func foo7(): Unit {
        println("[CJ]: A.foo7()")
    }
    public open func foo8(): Unit {
        println("[CJ]: A.foo8()")
    }
    public open func foo9(): Unit {
        println("[CJ]: A.foo9()")
    }
    public open func foo10(): Unit {
        println("[CJ]: A.foo10()")
    }
    public open func foo11(): Unit {
        println("[CJ]: A.foo11()")
    }
    public open func foo12(): Unit {
        println("[CJ]: A.foo12()")
    }
    public open func foo13(): Unit {
        println("[CJ]: A.foo13()")
    }
    public open func foo14(): Unit {
        println("[CJ]: A.foo14()")
    }
    public open func foo15(): Unit {
        println("[CJ]: A.foo15()")
    }
    public open func foo16(): Unit {
        println("[CJ]: A.foo16()")
    }
    public open func foo17(): Unit {
        println("[CJ]: A.foo17()")
    }
    public open func foo18(): Unit {
        println("[CJ]: A.foo18()")
    }
    public open func foo19(): Unit {
        println("[CJ]: A.foo19()")
    }
    public open func foo20(): Unit {
        println("[CJ]: A.foo20()")
    }
    public open func foo21(): Unit {
        println("[CJ]: A.foo21()")
    }
    public open func foo22(): Unit {
        println("[CJ]: A.foo22()")
    }
    public open func foo23(): Unit {
        println("[CJ]: A.foo23()")
    }
    public open func foo24(): Unit {
        println("[CJ]: A.foo24()")
    }
    public open func foo25(): Unit {
        println("[CJ]: A.foo25()")
    }
    public open func foo26(): Unit {
        println("[CJ]: A.foo26()")
    }
    public open func foo27(): Unit {
        println("[CJ]: A.foo27()")
    }
    public open func foo28(): Unit {
        println("[CJ]: A.foo28()")
    }
    public open func foo29(): Unit {
        println("[CJ]: A.foo29()")
    }
    public open func foo30(): Unit {
        println("[CJ]: A.foo30()")
    }
    public open func foo31(): Unit {
        println("[CJ]: A.foo31()")
    }
    public open func foo32(): Unit {
        println("[CJ]: A.foo32()")
    }
    public open func foo33(): Unit {
        println("[CJ]: A.foo33()")
    }
    public open func foo34(): Unit {
        println("[CJ]: A.foo34()")
    }
    public open func foo35(): Unit {
        println("[CJ]: A.foo35()")
    }
    public open func foo36(): Unit {
        println("[CJ]: A.foo36()")
    }
    public open func foo37(): Unit {
        println("[CJ]: A.foo37()")
    }
    public open func foo38(): Unit {
        println("[CJ]: A.foo38()")
    }
    public open func foo39(): Unit {
        println("[CJ]: A.foo39()")
    }
    public open func foo40(): Unit {
        println("[CJ]: A.foo40()")
    }
    public open func foo41(): Unit {
        println("[CJ]: A.foo41()")
    }
    // Overridden at ObjC side in AA
    public open func foo42(): Unit {
        println("[CJ]: A.foo42()")
    }
    public open func foo43(): Unit {
        println("[CJ]: A.foo43()")
    }
    public open func foo44(): Unit {
        println("[CJ]: A.foo44()")
    }
    public open func foo45(): Unit {
        println("[CJ]: A.foo45()")
    }
    public open func foo46(): Unit {
        println("[CJ]: A.foo46()")
    }
    public open func foo47(): Unit {
        println("[CJ]: A.foo47()")
    }
    public open func foo48(): Unit {
        println("[CJ]: A.foo48()")
    }
    public open func foo49(): Unit {
        println("[CJ]: A.foo49()")
    }
    public open func foo50(): Unit {
        println("[CJ]: A.foo50()")
    }
    public open func foo51(): Unit {
        println("[CJ]: A.foo51()")
    }
    public open func foo52(): Unit {
        println("[CJ]: A.foo52()")
    }
    public open func foo53(): Unit {
        println("[CJ]: A.foo53()")
    }
    public open func foo54(): Unit {
        println("[CJ]: A.foo54()")
    }
    public open func foo55(): Unit {
        println("[CJ]: A.foo55()")
    }
    public open func foo56(): Unit {
        println("[CJ]: A.foo56()")
    }
    public open func foo57(): Unit {
        println("[CJ]: A.foo57()")
    }
    public open func foo58(): Unit {
        println("[CJ]: A.foo58()")
    }
    public open func foo59(): Unit {
        println("[CJ]: A.foo59()")
    }
    public open func foo60(): Unit {
        println("[CJ]: A.foo60()")
    }
    public open func foo61(): Unit {
        println("[CJ]: A.foo61()")
    }
    public open func foo62(): Unit {
        println("[CJ]: A.foo62()")
    }
    // Overridden at ObjC side in AA
    public open func foo63(): Unit {
        println("[CJ]: A.foo63()")
    }
    // Overridden at ObjC side in AA
    public open func foo64(): Unit {
        println("[CJ]: A.foo64()")
    }
    public open func foo65(): Unit {
        println("[CJ]: A.foo65()")
    }
}
