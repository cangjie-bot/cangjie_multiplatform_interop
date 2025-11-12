// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import api.*
import std.runtime.* // not a reference glue-code, just a debug utility
import std.sync.Mutex
import objc.lang.*

// not a reference glue-code, just a debug utility
func cjGC(): Unit {
    gc(heavy: true)
    sleep(5*Duration.millisecond)
    gc(heavy: true)
    sleep(5*Duration.millisecond)
}

// not a reference glue-code, just a debug utility
@C
public func CJImpl_ObjC_cjworld_cjGC(): Unit {
    cjGC();
}

// When pure CJ object (A instance) needs to be passed to ObjC side the pure object itself is put into registry
// and the CJMirror is created using initWithRegistryId constructor.
// RC++ is not performed for ObjC object and resulted twins pair does not follow the DistributedGC workflow.
func objcObjForPureCJ(cjA: A): NativeObjCId {
    let id = putToRegistry(cjA)
    unsafe {
        CFunc<(NativeObjCId, NativeObjCSel, RegistryId) -> NativeObjCId>(objCMsgSend())(alloc("A"), registerName("initWithRegistryId:"), id)
    }
}

class A_fwdDestructor {
    var obj: NativeObjCId

    init(obj: NativeObjCId) {
        this.obj = obj
    }

    ~init() {
        println("[CJ]: A_fwd.~init happened (TransitionIV)")
        unsafe { objCRelease(obj) } // TransitionIV
    }
}

open class A_fwd <: A {
    let mtx = Mutex()
    var fwd: A_fwdDestructor
    var cjFinalizable = false

    // The order of bits in the mask from 0 to 4: fooVirtual, callFooVirtual, fooI32, fooA, paramA.
    // It must be the same in A.m where the mask value is calculated.
    let overrideMask: UInt64

    // When twin-objects creation starts at ObjC side, the forwarder has ObjC obj available before the constructor call.
    init(obj: NativeObjCId, overrideMask: UInt64) {
        super()
        fwd = A_fwdDestructor(obj)
        this.overrideMask = overrideMask
    }

    // Returns objcObj of retainable object pointer type that holds RC++ by extra retain, any call-site should care about it.
    func objcObj(): NativeObjCId {
        synchronized(mtx) {
            let ocObj = fwd.obj
            if (cjFinalizable) { // backOnTrack also known as TransitionIII
                cjFinalizable = false
                let id = putToRegistry(this)
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel, RegistryId) -> NativeObjCId>(objCMsgSend())(ocObj, registerName("reinitWithRegistryId:"), id)
                }
            } else {
                unsafe { objCRetain(ocObj) }
            }
        }
    }

    // To be used by forwarder for virtual calls of methods overridden at ObjC side.
    func objcObjAutoreleased(): NativeObjCId {
        unsafe { objCAutorelease(objcObj()) }
    }

    public override func fooVirtual(): Unit {
        if ((overrideMask & (1 << 0)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objCAutorelease(objcObj()), registerName("fooVirtual"))
                }
            }
        } else {
            fooVirtualImpl()
        }
    }
    public override func callFooVirtual(): Unit {
        if ((overrideMask & (1 << 1)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objCAutorelease(objcObj()), registerName("callFooVirtual"))
                }
            }
        } else {
            callFooVirtualImpl()
        }
    }
    public override func fooI32(): Int32 {
        if ((overrideMask & (1 << 2)) != 0) {
            withAutoreleasePool<Int32> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Int32>(objCMsgSend())(objCAutorelease(objcObj()), registerName("fooI32"))
                }
            }
        } else {
            fooI32Impl()
        }
    }
    public override func fooA(): A {
        if ((overrideMask & (1 << 3)) != 0) {
            let objcA = withAutoreleasePool<NativeObjCId> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> NativeObjCId>(objCMsgSend())(objCAutorelease(objcObj()), registerName("fooA"))
                }
            }
            getFromRegistryByNativeHandle<A>(objcA)
        } else {
            fooAImpl()
        }
    }
    public override func paramA(cjA: A): Unit {
        if ((overrideMask & (1 << 4)) != 0) {
            withAutoreleasePool<Unit> { =>
                let objcA = match(cjA as A_fwd) {
                    case Some(a_fwd) => objCAutorelease(a_fwd.objcObj())
                    case None => objCAutorelease(objcObjForPureCJ(cjA))
                }
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel, NativeObjCId) -> Unit>(objCMsgSend())(objCAutorelease(objcObj()), registerName("paramA:"), objcA)
                }
            }
        } else {
            paramAImpl(cjA)
        }
    }

    protected open func fooVirtualImpl(): Unit {
        super.fooVirtual()
    }

    protected open func callFooVirtualImpl(): Unit {
        super.callFooVirtual()
    }

    protected open func fooI32Impl(): Int32 {
        super.fooI32()
    }

    protected open func fooAImpl(): A {
        super.fooA()
    }

    protected open func paramAImpl(a: A): Unit {
        super.paramA(a)
    }
}

@C
public func CJImpl_ObjC_cjworld_A_init(obj: NativeObjCId, overrideMask: UInt64): RegistryId {
    let id = putToRegistry(A_fwd(obj, overrideMask))
    println("[CJ]: A.init(${id}, ${overrideMask})")
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
public func CJImpl_ObjC_cjworld_A_fooVirtual(registryId: RegistryId): Unit {
    getFromRegistryById<A>(registryId).fooVirtual()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_fooVirtual(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).fooVirtualImpl()
}

@C
public func CJImpl_ObjC_cjworld_A_callFooVirtual(registryId: RegistryId): Unit {
    getFromRegistryById<A>(registryId).callFooVirtual()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_callFooVirtual(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).callFooVirtualImpl()
}

@C
public func CJImpl_ObjC_cjworld_A_fooI32(registryId: RegistryId): Int32 {
    getFromRegistryById<A>(registryId).fooI32()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_fooI32(registryId: RegistryId): Int32 {
    getFromRegistryById<A_fwd>(registryId).fooI32Impl()
}

@C
public func CJImpl_ObjC_cjworld_A_fooA(registryId: RegistryId): NativeObjCId {
    let cjA = getFromRegistryById<A>(registryId).fooA()
    match(cjA as A_fwd) {
        case Some(a_fwd) => a_fwd.objcObj() // to transit the ownership: at ObjC side (in A.h) A.fooA is marked with __attribute((ns_returns_retained)
        case None => objcObjForPureCJ(cjA)
    }
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_fooA(registryId: RegistryId): NativeObjCId {
    let cjA = getFromRegistryById<A_fwd>(registryId).fooAImpl()
    match(cjA as A_fwd) {
        case Some(a_fwd) => a_fwd.objcObj() // to transit the ownership: at ObjC side (in A.h) A.fooA is marked with __attribute((ns_returns_retained)
        case None => objcObjForPureCJ(cjA)
    }
}

@C
public func CJImpl_ObjC_cjworld_A_paramA(registryId: RegistryId, aRegistryId: RegistryId): Unit {
    let cjA = getFromRegistryById<A>(aRegistryId) // it's OK if cjA is actually of A_fwd type
    getFromRegistryById<A>(registryId).paramA(cjA)
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_paramA(registryId: RegistryId, aRegistryId: RegistryId): Unit {
    let cjA = getFromRegistryById<A>(aRegistryId) // it's OK if cjA is actually of A_fwd type
    getFromRegistryById<A_fwd>(registryId).paramAImpl(cjA)
}
