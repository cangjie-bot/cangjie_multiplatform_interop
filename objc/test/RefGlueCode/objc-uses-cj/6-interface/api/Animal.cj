// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package api

public interface Animal {
    func Say(): Unit {
        println("[CJ] Animal.Say()")
    }
 
    func Eat(): Unit {
        println("[CJ]: Animal.Eat() ENTER")
        Say()
        println("[CJ]: Animal.Eat() EXIT")
    }

    func Weight(): Int32

    static func staticTest(a: Animal): Unit {
        println("[CJ]: Animal.staticTest Say:")
        a.Say()
        println("[CJ]: Animal.staticTest Eat:")
        a.Eat()
        println("[CJ]: Animal.staticTest Weight:")
        a.Weight()
    }
}
