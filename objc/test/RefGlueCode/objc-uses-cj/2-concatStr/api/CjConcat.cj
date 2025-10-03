// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package api

public func globalConcat(a: String, b: String): String {
    println("[CJ]: globalConcat(\"${a}\", \"${b}\")")
    a + b
}

public class CjConcat {
    public static func staticConcat(a: String, b: String): String {
        println("[CJ]: staticConcat(\"${a}\", \"${b}\")")
        a + b
    }
}
