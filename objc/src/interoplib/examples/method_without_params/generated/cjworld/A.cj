// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import objc.lang.*

public class A <: M {
    public init(obj: NativeObjCId) {
        super(obj)
    }

    public init() {
        throw ObjCUnreachableCodeException()
    }

    public func fooBar(): M1 {
        let res0 = withMethodEnv<Int32>(obj), { receiver, objCSuper => unsafe {
            CFunc<(CPointer<Unit>, NativeObjCSel) -> Int32>(
                    objCMsgSendSuper(objCSuper, registerName("goo")))(receiver, registerName("goo"))
        }}
        println("cj: get Int32 res from objc: ${res0}")
        let res1 = M1(
            withMethodEnvObj(obj), { receiver, objCSuper => unsafe {
                CFunc<(CPointer<Unit>, NativeObjCSel) -> NativeObjCId>(
                        objCMsgSendSuper(objCSuper, registerName("foo")))(receiver, registerName("foo"))
            }}
        )
        println("cj: get object from objc with result: ${res1.fooBar()}")
        res1
    }
}

@C
public func CJImpl_ObjC_cjworld_A_fooBar(registryId: RegistryId): NativeObjCId {
    getFromRegistryById<A>(registryId).fooBar().obj
}

@C
public func CJImpl_ObjC_cjworld_A_initPu(obj: NativeObjCId): RegistryId {
    putToRegistry(A(obj))
}

@C
public func CJImpl_ObjC_cjworld_A_deleteCJObject(registryId: RegistryId): Unit {
    let a = getFromRegistryById<A>(registryId)
    removeFromRegistry(registryId)
    unsafe { objCRelease(a.obj) }
}
