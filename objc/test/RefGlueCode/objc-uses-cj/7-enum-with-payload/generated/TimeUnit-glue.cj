// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import api.*
import interoplib.objc.*

@C
public func CJImpl_ObjC_api_TimeUnit_MonthInitCJObject(): RegistryId {
    let tu = TimeUnit.Month
    putToRegistry(tu)
}

@C
public func CJImpl_ObjC_api_TimeUnit_YearInitCJObject(): RegistryId {
    let tu = TimeUnit.Year
    putToRegistry(tu)
}

@C
public func CJImpl_ObjC_api_TimeUnit_MonthP1InitCJObject(p1: Int64): RegistryId {
    let tu = TimeUnit.Month(p1)
    putToRegistry(tu)
}

@C
public func CJImpl_ObjC_api_TimeUnit_YearP1InitCJObject(p1: Int64): RegistryId {
    let tu = TimeUnit.Year(p1)
    putToRegistry(tu)
}

@C
public func CJImpl_ObjC_api_TimeUnit_TenYear(): RegistryId {
    let tu = TimeUnit.TenYear()
    putToRegistry(tu)
}

@C
public func CJImpl_ObjC_api_TimeUnit_CalcMonth(registryId: RegistryId): Int64 {
    let tu = getFromRegistryById<TimeUnit>(registryId)
    tu.CalcMonth()
}

@C
public func CJImpl_ObjC_api_TimeUnit_deleteCJObject(registryId: RegistryId): Unit {
    removeFromRegistry(registryId)
}

@C
public func CJImpl_ObjC_api_CJPrintMonthCount(registryId: RegistryId): Unit {
    let tu = getFromRegistryById<TimeUnit>(registryId)
    CJPrintMonthCount(tu)
}
