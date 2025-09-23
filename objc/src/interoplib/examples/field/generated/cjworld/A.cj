// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import interoplib.objc.*

public class A <: M {
    public var cjField: Int64

    public init() {
        throw ObjCUnreachableCodeException()
    }

    public init(obj: NativeObjCId) {
        super(obj)

        println("cj: A.init()")
        cjField = 123
        foo = 42
        bar = M1(3.14)
    }
}

@C
public func CJImpl_ObjC_cjworld_A_initPu(obj: NativeObjCId): RegistryId {
    putToRegistry(A(obj))
}

@C
public func CJImpl_ObjC_cjworld_A_deleteCJObject(registryId: RegistryId): Unit {
    let a = getFromRegistryById<A>(registryId)
    removeFromRegistry(registryId)
    unsafe { ObjCRuntime.release(a.obj) }
}

@C
public func CJImpl_ObjC_cjworld_A_cjField_get(registryId: RegistryId): Int64 {
    getFromRegistryById<A>(registryId).cjField
}

@C
public func CJImpl_ObjC_cjworld_A_cjField_set(registryId: RegistryId, value: Int64): Unit {
    getFromRegistryById<A>(registryId).cjField = value
}