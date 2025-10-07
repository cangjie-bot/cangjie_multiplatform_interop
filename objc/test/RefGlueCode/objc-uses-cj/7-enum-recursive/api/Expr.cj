// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package api

// =========================================================
// Enum Definition: Enum with recursive construction (Expr)
// =========================================================
public enum Expr {
    | Num(Int64)
    | Add(Expr, Expr)
    | Sub(Expr, Expr)
}

// To eval the expr. 
public func CJEval(expr: Expr): Int64 {
    match (expr) {
        case Num(n) => n
        case Add(left, right) => CJEval(left) + CJEval(right)
        case Sub(left, right) => CJEval(left) - CJEval(right)
    }
}
