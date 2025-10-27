// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

public class CjAnimalAccessor {
    public func fooWithDefault(a: Animal): Unit {
        println("[CJ]: CjAnimalAccessor.fooWithDefault()")
        a.Say()
    }
 
    public func foo(a: Animal): Unit {
        println("[CJ]: CjAnimalAccessor.foo got Weight == ${a.Weight()}")
    }
}
