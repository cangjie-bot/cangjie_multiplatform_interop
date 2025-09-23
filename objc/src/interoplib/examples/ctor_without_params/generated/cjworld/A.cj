// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import interoplib.objc.*

public class A <: M {
    public init(obj: NativeObjCId) {
        super(obj)

        println("cj: A.init()")
        let m = M()
    }

    public init() {
        throw ObjCUnreachableCodeException()
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
