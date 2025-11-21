// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import api.*
import objc.lang.*

// When pure CJ object (A instance) needs to be passed to ObjC side the pure object itself is put into registry
// and the CJMirror is created using initWithRegistryId constructor.
// RC++ is not performed for ObjC object and resulted twins pair does not follow the DistributedGC workflow.
func objcObjForPureCJ(cjA: A): NativeObjCId {
    let id = putToRegistry(cjA)
    unsafe {
        CFunc<(NativeObjCId, NativeObjCSel, RegistryId) -> NativeObjCId>(objCMsgSend())(alloc("A"), registerName("initWithRegistryId:"), id)
    }
}

class A_fwd <: A {
    let mtx = ForwarderMutex()
    var obj: NativeObjCId
    var cjFinalizable = false

    let overrideMask: UInt64

    // When twin-objects creation starts at ObjC side, the forwarder has ObjC obj available before the constructor call.
    init(obj: NativeObjCId, overrideMask: UInt64, x: Int64) {
        super(x)
        this.obj = obj
        this.overrideMask = overrideMask
    }

    // When twin-objects creation starts at ObjC side, the forwarder has ObjC obj available before the constructor call.
    init(obj: NativeObjCId, overrideMask: UInt64, x: Int64, y: Int64) {
        super(x, y)
        this.obj = obj
        this.overrideMask = overrideMask
    }

    ~init() {
        println("[CJ]: A_fwd.~init happened (TransitionIV)")
        unsafe { objCRelease(obj) } // TransitionIV
    }

    // Returns objcObj of retainable object pointer type that holds RC++ by extra retain, any call-site should care about it.
    func objcObj(): NativeObjCId {
        synchronized(mtx) {
            if (cjFinalizable) { // backOnTrack also known as TransitionIII
                cjFinalizable = false
                let id = putToRegistry(this)
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel, RegistryId) -> NativeObjCId>(objCMsgSend())(obj, registerName("reinitWithRegistryId:"), id)
                }
            } else {
                unsafe { objCRetain(obj) }
            }
        }
    }

    // To be used by forwarder for virtual calls of methods overridden at ObjC side.
    func objcObjAutoreleased(): NativeObjCId {
        unsafe { objCAutorelease(objcObj()) }
    }

    public override func fooI64(): Int64 {
        if ((overrideMask & (1 << 0)) != 0) {
            withAutoreleasePool<Int64> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Int64>(objCMsgSend())(objcObjAutoreleased(), registerName("fooI64"))
                }
            }
        } else {
            fooI64Impl()
        }
    }

    func fooI64Impl(): Int64 {
        super.fooI64()
    }
}

@C
public func CJImpl_ObjC_cjworld_A_initl(obj: NativeObjCId, overrideMask: UInt64, x: Int64): RegistryId {
    let id = putToRegistry(A_fwd(obj, overrideMask, x))
    println("[CJ]: A.init(${id}, ${overrideMask}, ${x})")
    id
}

@C
public func CJImpl_ObjC_cjworld_A_initll(obj: NativeObjCId, overrideMask: UInt64, x: Int64, y: Int64): RegistryId {
    let id = putToRegistry(A_fwd(obj, overrideMask, x, y))
    println("[CJ]: A.init(${id}, ${overrideMask}, ${x}, ${y})")
    id
}

@C
public func CJImpl_ObjC_cjworld_A_lockCJObjectFwd(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).mtx.lock()
}

@C
public func CJImpl_ObjC_cjworld_A_unlockCJObjectFwd(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).mtx.unlock()
}

@C
public func CJImpl_ObjC_cjworld_A_deleteCJObjectFwd(registryId: RegistryId): Unit {
    //println("[CJ]: A.deleteCJObjectFwd(${registryId})")
    let fwd = getFromRegistryById<A_fwd>(registryId)
    fwd.cjFinalizable = true
    removeFromRegistry(registryId)
    fwd.mtx.unlock()
}

@C
public func CJImpl_ObjC_cjworld_A_deleteCJObject(registryId: RegistryId): Unit {
    //println("[CJ]: A.deleteCJObject(${registryId})")
    removeFromRegistry(registryId)
}

@C
public func CJImpl_ObjC_cjworld_A_fooI64(registryId: RegistryId): Int64 {
    getFromRegistryById<A>(registryId).fooI64()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_fooI64(registryId: RegistryId): Int64 {
    getFromRegistryById<A_fwd>(registryId).fooI64Impl()
}
