// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import objc.lang.*

public class A <: M {
    private var _b: M1

    public mut prop a: Int64 {
        get() {
            foo
        }
        set(value) {
            foo = value
        }
    }

    public mut prop b: M1 {
        get() {
            _b
        }
        set(value) {
            _b = value
        }
    }

    public prop c: Bool {
        get() {
            true
        }
    }

    private prop d: Float64 {
        get() {
            3.14159
        }
    }

    public init() {
        throw ObjCUnreachableCodeException()
    }

    public init(obj: NativeObjCId) {
        super(obj)

        println("cj: A.init()")

        _b = M1(123.123)
        foo = 42
        bar = M1(d)
    }
}

@C
public func CJImpl_ObjC_cjworld_A_initPu(obj: NativeObjCId): RegistryId {
    putToRegistry(A(obj))
}

@C
public func CJImpl_ObjC_cjworld_A_getA(registryId: RegistryId): Int64 {
    getFromRegistryById<A>(registryId).a
}

@C
public func CJImpl_ObjC_cjworld_A_setA(registryId: RegistryId, value: Int64): Unit {
    getFromRegistryById<A>(registryId).a = value
}

@C
public func CJImpl_ObjC_cjworld_A_getB(registryId: RegistryId): NativeObjCId {
    getFromRegistryById<A>(registryId).b.obj
}

@C
public func CJImpl_ObjC_cjworld_A_setB(registryId: RegistryId, value: NativeObjCId): Unit {
    getFromRegistryById<A>(registryId).b = M1(value)
}

@C
public func CJImpl_ObjC_cjworld_A_getC(registryId: RegistryId): Bool {
    getFromRegistryById<A>(registryId).c
}

@C
public func CJImpl_ObjC_cjworld_A_deleteCJObject(registryId: RegistryId): Unit {
    let a = getFromRegistryById<A>(registryId)
    removeFromRegistry(registryId)
    unsafe { objCRelease(a.obj) }
}
