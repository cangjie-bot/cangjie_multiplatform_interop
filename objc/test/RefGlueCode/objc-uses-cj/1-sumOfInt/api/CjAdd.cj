// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package api

public func globalAddII(a: Int32, b: Int32): Int32 {
    println("[CJ]: globalAddII(${a}, ${b})")
    a + b
}

public class CjAdd {
    public static func staticAddII(a: Int32, b: Int32): Int32 {
        println("[CJ]: staticAddII(${a}, ${b})")
        a + b
    }
}
