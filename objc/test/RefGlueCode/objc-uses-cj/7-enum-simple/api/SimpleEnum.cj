// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package api

// =============================================
// Enum Definition: Simple Enum (no payloads)
// =============================================
public enum SimpleEnum {
    | One
    | Two
    | Three
}

public func CJPrint(simple: SimpleEnum): Unit {
    match (simple) {
        case One => println("[CJ]: One")
        case Two => println("[CJ]: Two")
        case Three => println("[CJ]: Three")
    }
}
