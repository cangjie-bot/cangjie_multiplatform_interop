// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import api.*
import interoplib.objc.*

@C
public func CJImpl_ObjC_cjworld_Vector_dot(registryId: RegistryId, anotherRegistryId: RegistryId): Int64 {
    getFromRegistryById<Vector>(registryId).dot(
        getFromRegistryById<Vector>(anotherRegistryId)
    )
}

@C
public func CJImpl_ObjC_cjworld_Vector_initCJObject(x: Int32, y:Int32): RegistryId {
    putToRegistry(Vector(x, y))
}

@C
public func CJImpl_ObjC_cjworld_Vector_X_get(registryId: RegistryId): Int32 {
    getFromRegistryById<Vector>(registryId).x
}

@C
public func CJImpl_ObjC_cjworld_Vector_Y_get(registryId: RegistryId): Int32 {
    getFromRegistryById<Vector>(registryId).y
}

@C
public func CJImpl_ObjC_cjworld_Vector_deleteCJObject(registryId: RegistryId): Unit {
    removeFromRegistry(registryId)
}
