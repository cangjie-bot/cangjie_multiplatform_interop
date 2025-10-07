// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import api.*
import interoplib.objc.*

@C
public func CJImpl_ObjC_api_Expr_NumInitCJObject(p1: Int64): RegistryId {
    let exprNum = Expr.Num(p1)
    putToRegistry(exprNum)
}

@C
public func CJImpl_ObjC_api_Expr_AddInitCJObject(registryIdL: RegistryId, registryIdR: RegistryId): RegistryId {
    let exprL = getFromRegistryById<Expr>(registryIdL)
    let exprR = getFromRegistryById<Expr>(registryIdR)
    let exprAdd = Expr.Add(exprL, exprR)
    putToRegistry(exprAdd)
}

@C
public func CJImpl_ObjC_api_Expr_SubInitCJObject(registryIdL: RegistryId, registryIdR: RegistryId): RegistryId {
    let exprL = getFromRegistryById<Expr>(registryIdL)
    let exprR = getFromRegistryById<Expr>(registryIdR)
    let exprSub = Expr.Sub(exprL, exprR)
    putToRegistry(exprSub)
}

@C
public func CJImpl_ObjC_api_Expr_deleteCJObject(registryId: RegistryId): Unit {
    removeFromRegistry(registryId)
}

@C
public func CJImpl_ObjC_api_CJEval(registryId: RegistryId): Unit {
    CJEval(getFromRegistryById<Expr>(registryId))
}
