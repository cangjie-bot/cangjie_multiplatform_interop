// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package api

// =============================================
// Enum Definition: Basic Enum (TimeUnit)
// =============================================
public enum TimeUnit {
    | Year(Int64)
    | Month(Int64)
    | Year
    | Month

    // The public method to Calculate how many months.
    public func CalcMonth(): Int64 {
        let count = match (this) {
            case Year(n)    => n * 12
            case Year       => 12
            case Month(n)   => n
            case Month      => 1
        }
        println("[CJ]: CalcMonth about to return ${count}")
        count
    }

    // The static method to return ten years.
    public static func TenYear(): TimeUnit {
        Year(10)
    }
}

// To print how many months in a time unit.
public func CJPrintMonthCount(e: TimeUnit): Unit {
    println("[CJ]: CJPrintMonthCount x has ${e.CalcMonth()}")
}
