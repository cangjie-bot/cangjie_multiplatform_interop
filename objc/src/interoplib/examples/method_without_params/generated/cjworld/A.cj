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
    }

    public init() {
        throw ObjCUnreachableCodeException()
    }

    public func fooBar(): M1 {
        M1(
            withAutoreleasePoolObj(
                {
                    => unsafe {
                        let res0 = CFunc<(NativeObjCId, NativeObjCSel) -> Int32>(ObjCRuntime.msgSend)(obj,
                            registerName("super$goo"))
                        println("cj: get Int32 res from objc: ${res0}")

                        let res1 = M1(
                            CFunc<(NativeObjCId, NativeObjCSel) -> NativeObjCId>(ObjCRuntime.msgSend)(obj,
                                registerName("super$foo")))
                        println("cj: get object from objc with result: ${res1.fooBar()}")

                        res1.obj
                    }
                }))
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
    unsafe { ObjCRuntime.release(a.obj) }
}
