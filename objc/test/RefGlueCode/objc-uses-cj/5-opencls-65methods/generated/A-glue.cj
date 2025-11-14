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
    init(obj: NativeObjCId, overrideMask: UInt64) {
        super()
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

    public override func foo0(): Unit {
        if ((overrideMask & (1 << 0)) != 0) {
            println("[CJ]: foo0 is overridden - call ObjC implementation")
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo0"))
                }
            }
        } else {
            println("[CJ]: foo0 is NOT overridden - call foo0Impl at CJ side")
            foo0Impl()
        }
    }

    public override func foo1(): Unit {
        if ((overrideMask & (1 << 1)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo1"))
                }
            }
        } else {
            foo1Impl()
        }
    }

    public override func foo2(): Unit {
        if ((overrideMask & (1 << 2)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo2"))
                }
            }
        } else {
            foo2Impl()
        }
    }

    public override func foo3(): Unit {
        if ((overrideMask & (1 << 3)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo3"))
                }
            }
        } else {
            foo3Impl()
        }
    }

    public override func foo4(): Unit {
        if ((overrideMask & (1 << 4)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo4"))
                }
            }
        } else {
            foo4Impl()
        }
    }

    public override func foo5(): Unit {
        if ((overrideMask & (1 << 5)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo5"))
                }
            }
        } else {
            foo5Impl()
        }
    }

    public override func foo6(): Unit {
        if ((overrideMask & (1 << 6)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo6"))
                }
            }
        } else {
            foo6Impl()
        }
    }

    public override func foo7(): Unit {
        if ((overrideMask & (1 << 7)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo7"))
                }
            }
        } else {
            foo7Impl()
        }
    }

    public override func foo8(): Unit {
        if ((overrideMask & (1 << 8)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo8"))
                }
            }
        } else {
            foo8Impl()
        }
    }

    public override func foo9(): Unit {
        if ((overrideMask & (1 << 9)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo9"))
                }
            }
        } else {
            foo9Impl()
        }
    }

    public override func foo10(): Unit {
        if ((overrideMask & (1 << 10)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo10"))
                }
            }
        } else {
            foo10Impl()
        }
    }

    public override func foo11(): Unit {
        if ((overrideMask & (1 << 11)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo11"))
                }
            }
        } else {
            foo11Impl()
        }
    }

    public override func foo12(): Unit {
        if ((overrideMask & (1 << 12)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo12"))
                }
            }
        } else {
            foo12Impl()
        }
    }

    public override func foo13(): Unit {
        if ((overrideMask & (1 << 13)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo13"))
                }
            }
        } else {
            foo13Impl()
        }
    }

    public override func foo14(): Unit {
        if ((overrideMask & (1 << 14)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo14"))
                }
            }
        } else {
            foo14Impl()
        }
    }

    public override func foo15(): Unit {
        if ((overrideMask & (1 << 15)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo15"))
                }
            }
        } else {
            foo15Impl()
        }
    }

    public override func foo16(): Unit {
        if ((overrideMask & (1 << 16)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo16"))
                }
            }
        } else {
            foo16Impl()
        }
    }

    public override func foo17(): Unit {
        if ((overrideMask & (1 << 17)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo17"))
                }
            }
        } else {
            foo17Impl()
        }
    }

    public override func foo18(): Unit {
        if ((overrideMask & (1 << 18)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo18"))
                }
            }
        } else {
            foo18Impl()
        }
    }

    public override func foo19(): Unit {
        if ((overrideMask & (1 << 19)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo19"))
                }
            }
        } else {
            foo19Impl()
        }
    }

    public override func foo20(): Unit {
        if ((overrideMask & (1 << 20)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo20"))
                }
            }
        } else {
            foo20Impl()
        }
    }

    public override func foo21(): Unit {
        if ((overrideMask & (1 << 21)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo21"))
                }
            }
        } else {
            foo21Impl()
        }
    }

    public override func foo22(): Unit {
        if ((overrideMask & (1 << 22)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo22"))
                }
            }
        } else {
            foo22Impl()
        }
    }

    public override func foo23(): Unit {
        if ((overrideMask & (1 << 23)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo23"))
                }
            }
        } else {
            foo23Impl()
        }
    }

    public override func foo24(): Unit {
        if ((overrideMask & (1 << 24)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo24"))
                }
            }
        } else {
            foo24Impl()
        }
    }

    public override func foo25(): Unit {
        if ((overrideMask & (1 << 25)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo25"))
                }
            }
        } else {
            foo25Impl()
        }
    }

    public override func foo26(): Unit {
        if ((overrideMask & (1 << 26)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo26"))
                }
            }
        } else {
            foo26Impl()
        }
    }

    public override func foo27(): Unit {
        if ((overrideMask & (1 << 27)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo27"))
                }
            }
        } else {
            foo27Impl()
        }
    }

    public override func foo28(): Unit {
        if ((overrideMask & (1 << 28)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo28"))
                }
            }
        } else {
            foo28Impl()
        }
    }

    public override func foo29(): Unit {
        if ((overrideMask & (1 << 29)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo29"))
                }
            }
        } else {
            foo29Impl()
        }
    }

    public override func foo30(): Unit {
        if ((overrideMask & (1 << 30)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo30"))
                }
            }
        } else {
            foo30Impl()
        }
    }

    public override func foo31(): Unit {
        if ((overrideMask & (1 << 31)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo31"))
                }
            }
        } else {
            foo31Impl()
        }
    }

    public override func foo32(): Unit {
        if ((overrideMask & (1 << 32)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo32"))
                }
            }
        } else {
            foo32Impl()
        }
    }

    public override func foo33(): Unit {
        if ((overrideMask & (1 << 33)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo33"))
                }
            }
        } else {
            foo33Impl()
        }
    }

    public override func foo34(): Unit {
        if ((overrideMask & (1 << 34)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo34"))
                }
            }
        } else {
            foo34Impl()
        }
    }

    public override func foo35(): Unit {
        if ((overrideMask & (1 << 35)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo35"))
                }
            }
        } else {
            foo35Impl()
        }
    }

    public override func foo36(): Unit {
        if ((overrideMask & (1 << 36)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo36"))
                }
            }
        } else {
            foo36Impl()
        }
    }

    public override func foo37(): Unit {
        if ((overrideMask & (1 << 37)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo37"))
                }
            }
        } else {
            foo37Impl()
        }
    }

    public override func foo38(): Unit {
        if ((overrideMask & (1 << 38)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo38"))
                }
            }
        } else {
            foo38Impl()
        }
    }

    public override func foo39(): Unit {
        if ((overrideMask & (1 << 39)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo39"))
                }
            }
        } else {
            foo39Impl()
        }
    }

    public override func foo40(): Unit {
        if ((overrideMask & (1 << 40)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo40"))
                }
            }
        } else {
            foo40Impl()
        }
    }

    public override func foo41(): Unit {
        if ((overrideMask & (1 << 41)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo41"))
                }
            }
        } else {
            foo41Impl()
        }
    }

    public override func foo42(): Unit {
        if ((overrideMask & (1 << 42)) != 0) {
            println("[CJ]: foo42 is overridden - call ObjC implementation")
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo42"))
                }
            }
        } else {
            println("[CJ]: foo42 is NOT overridden - call foo42Impl at CJ side")
            foo42Impl()
        }
    }

    public override func foo43(): Unit {
        if ((overrideMask & (1 << 43)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo43"))
                }
            }
        } else {
            foo43Impl()
        }
    }

    public override func foo44(): Unit {
        if ((overrideMask & (1 << 44)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo44"))
                }
            }
        } else {
            foo44Impl()
        }
    }

    public override func foo45(): Unit {
        if ((overrideMask & (1 << 45)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo45"))
                }
            }
        } else {
            foo45Impl()
        }
    }

    public override func foo46(): Unit {
        if ((overrideMask & (1 << 46)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo46"))
                }
            }
        } else {
            foo46Impl()
        }
    }

    public override func foo47(): Unit {
        if ((overrideMask & (1 << 47)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo47"))
                }
            }
        } else {
            foo47Impl()
        }
    }

    public override func foo48(): Unit {
        if ((overrideMask & (1 << 48)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo48"))
                }
            }
        } else {
            foo48Impl()
        }
    }

    public override func foo49(): Unit {
        if ((overrideMask & (1 << 49)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo49"))
                }
            }
        } else {
            foo49Impl()
        }
    }

    public override func foo50(): Unit {
        if ((overrideMask & (1 << 50)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo50"))
                }
            }
        } else {
            foo50Impl()
        }
    }

    public override func foo51(): Unit {
        if ((overrideMask & (1 << 51)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo51"))
                }
            }
        } else {
            foo51Impl()
        }
    }

    public override func foo52(): Unit {
        if ((overrideMask & (1 << 52)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo52"))
                }
            }
        } else {
            foo52Impl()
        }
    }

    public override func foo53(): Unit {
        if ((overrideMask & (1 << 53)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo53"))
                }
            }
        } else {
            foo53Impl()
        }
    }

    public override func foo54(): Unit {
        if ((overrideMask & (1 << 54)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo54"))
                }
            }
        } else {
            foo54Impl()
        }
    }

    public override func foo55(): Unit {
        if ((overrideMask & (1 << 55)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo55"))
                }
            }
        } else {
            foo55Impl()
        }
    }

    public override func foo56(): Unit {
        if ((overrideMask & (1 << 56)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo56"))
                }
            }
        } else {
            foo56Impl()
        }
    }

    public override func foo57(): Unit {
        if ((overrideMask & (1 << 57)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo57"))
                }
            }
        } else {
            foo57Impl()
        }
    }

    public override func foo58(): Unit {
        if ((overrideMask & (1 << 58)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo58"))
                }
            }
        } else {
            foo58Impl()
        }
    }

    public override func foo59(): Unit {
        if ((overrideMask & (1 << 59)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo59"))
                }
            }
        } else {
            foo59Impl()
        }
    }

    public override func foo60(): Unit {
        if ((overrideMask & (1 << 60)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo60"))
                }
            }
        } else {
            foo60Impl()
        }
    }

    public override func foo61(): Unit {
        if ((overrideMask & (1 << 61)) != 0) {
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo61"))
                }
            }
        } else {
            foo61Impl()
        }
    }

    public override func foo62(): Unit {
        if ((overrideMask & (1 << 62)) != 0) {
            println("[CJ]: foo62 is overridden - call ObjC implementation")
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo62"))
                }
            }
        } else {
            println("[CJ]: foo62 is NOT overridden - call foo62Impl at CJ side")
            foo62Impl()
        }
    }

    public override func foo63(): Unit {
        if ((overrideMask & (1 << 63)) != 0) {
            println("[CJ]: foo63 is overridden - call ObjC implementation")
            withAutoreleasePool<Unit> { =>
                unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo63"))
                }
            }
        } else {
            println("[CJ]: foo63 is NOT overridden - call foo63Impl at CJ side")
            foo63Impl()
        }
    }

    // no mask for virtual method number 65 and greater - always treat it as overridden
    public override func foo64(): Unit {
        println("[CJ]: foo64 may be overridden - call ObjC implementation")
        withAutoreleasePool<Unit> { =>
            unsafe {
                CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo64"))
            }
        }
    }

    // no mask for virtual method number 65 and greater - always treat it as overridden
    public override func foo65(): Unit {
        println("[CJ]: foo65 may be overridden - call ObjC implementation")
        withAutoreleasePool<Unit> { =>
            unsafe {
                CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(objcObjAutoreleased(), registerName("foo65"))
            }
        }
    }

    func foo0Impl(): Unit { println("[CJ]: foo0Impl called"); super.foo0() }
    func foo1Impl(): Unit { super.foo1() }
    func foo2Impl(): Unit { super.foo2() }
    func foo3Impl(): Unit { super.foo3() }
    func foo4Impl(): Unit { super.foo4() }
    func foo5Impl(): Unit { super.foo5() }
    func foo6Impl(): Unit { super.foo6() }
    func foo7Impl(): Unit { super.foo7() }
    func foo8Impl(): Unit { super.foo8() }
    func foo9Impl(): Unit { super.foo9() }
    func foo10Impl(): Unit { super.foo10() }
    func foo11Impl(): Unit { super.foo11() }
    func foo12Impl(): Unit { super.foo12() }
    func foo13Impl(): Unit { super.foo13() }
    func foo14Impl(): Unit { super.foo14() }
    func foo15Impl(): Unit { super.foo15() }
    func foo16Impl(): Unit { super.foo16() }
    func foo17Impl(): Unit { super.foo17() }
    func foo18Impl(): Unit { super.foo18() }
    func foo19Impl(): Unit { super.foo19() }
    func foo20Impl(): Unit { super.foo20() }
    func foo21Impl(): Unit { super.foo21() }
    func foo22Impl(): Unit { super.foo22() }
    func foo23Impl(): Unit { super.foo23() }
    func foo24Impl(): Unit { super.foo24() }
    func foo25Impl(): Unit { super.foo25() }
    func foo26Impl(): Unit { super.foo26() }
    func foo27Impl(): Unit { super.foo27() }
    func foo28Impl(): Unit { super.foo28() }
    func foo29Impl(): Unit { super.foo29() }
    func foo30Impl(): Unit { super.foo30() }
    func foo31Impl(): Unit { super.foo31() }
    func foo32Impl(): Unit { super.foo32() }
    func foo33Impl(): Unit { super.foo33() }
    func foo34Impl(): Unit { super.foo34() }
    func foo35Impl(): Unit { super.foo35() }
    func foo36Impl(): Unit { super.foo36() }
    func foo37Impl(): Unit { super.foo37() }
    func foo38Impl(): Unit { super.foo38() }
    func foo39Impl(): Unit { super.foo39() }
    func foo40Impl(): Unit { super.foo40() }
    func foo41Impl(): Unit { super.foo41() }
    func foo42Impl(): Unit { println("[CJ]: foo42Impl called"); super.foo42() }
    func foo43Impl(): Unit { super.foo43() }
    func foo44Impl(): Unit { super.foo44() }
    func foo45Impl(): Unit { super.foo45() }
    func foo46Impl(): Unit { super.foo46() }
    func foo47Impl(): Unit { super.foo47() }
    func foo48Impl(): Unit { super.foo48() }
    func foo49Impl(): Unit { super.foo49() }
    func foo50Impl(): Unit { super.foo50() }
    func foo51Impl(): Unit { super.foo51() }
    func foo52Impl(): Unit { super.foo52() }
    func foo53Impl(): Unit { super.foo53() }
    func foo54Impl(): Unit { super.foo54() }
    func foo55Impl(): Unit { super.foo55() }
    func foo56Impl(): Unit { super.foo56() }
    func foo57Impl(): Unit { super.foo57() }
    func foo58Impl(): Unit { super.foo58() }
    func foo59Impl(): Unit { super.foo59() }
    func foo60Impl(): Unit { super.foo60() }
    func foo61Impl(): Unit { super.foo61() }
    func foo62Impl(): Unit { println("[CJ]: foo62Impl called"); super.foo62() }
    func foo63Impl(): Unit { println("[CJ]: foo63Impl called"); super.foo63() }
    func foo64Impl(): Unit { println("[CJ]: foo64Impl called"); super.foo64() }
    func foo65Impl(): Unit { println("[CJ]: foo65Impl called"); super.foo65() }
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
public func CJImpl_ObjC_cjworld_A_foo0(registryId: RegistryId): Unit {
    getFromRegistryById<A>(registryId).foo0()
}

@C
public func CJImpl_ObjC_cjworld_A_foo1(registryId: RegistryId): Unit {
    getFromRegistryById<A>(registryId).foo1()
}

@C
public func CJImpl_ObjC_cjworld_A_foo2(registryId: RegistryId): Unit {
    getFromRegistryById<A>(registryId).foo2()
}

@C
public func CJImpl_ObjC_cjworld_A_foo3(registryId: RegistryId): Unit {
    getFromRegistryById<A>(registryId).foo3()
}

@C
public func CJImpl_ObjC_cjworld_A_foo4(registryId: RegistryId): Unit {
    getFromRegistryById<A>(registryId).foo4()
}

@C
public func CJImpl_ObjC_cjworld_A_foo5(registryId: RegistryId): Unit {
    getFromRegistryById<A>(registryId).foo5()
}

@C
public func CJImpl_ObjC_cjworld_A_foo6(registryId: RegistryId): Unit {
    getFromRegistryById<A>(registryId).foo6()
}

@C
public func CJImpl_ObjC_cjworld_A_foo7(registryId: RegistryId): Unit {
    getFromRegistryById<A>(registryId).foo7()
}

@C
public func CJImpl_ObjC_cjworld_A_foo8(registryId: RegistryId): Unit {
    getFromRegistryById<A>(registryId).foo8()
}

@C
public func CJImpl_ObjC_cjworld_A_foo9(registryId: RegistryId): Unit {
    getFromRegistryById<A>(registryId).foo9()
}

@C
public func CJImpl_ObjC_cjworld_A_foo20(registryId: RegistryId): Unit {
    getFromRegistryById<A>(registryId).foo20()
}

@C
public func CJImpl_ObjC_cjworld_A_foo21(registryId: RegistryId): Unit {
    getFromRegistryById<A>(registryId).foo21()
}

@C
public func CJImpl_ObjC_cjworld_A_foo22(registryId: RegistryId): Unit {
    getFromRegistryById<A>(registryId).foo22()
}

@C
public func CJImpl_ObjC_cjworld_A_foo23(registryId: RegistryId): Unit {
    getFromRegistryById<A>(registryId).foo23()
}

@C
public func CJImpl_ObjC_cjworld_A_foo24(registryId: RegistryId): Unit {
    getFromRegistryById<A>(registryId).foo24()
}

@C
public func CJImpl_ObjC_cjworld_A_foo25(registryId: RegistryId): Unit {
    getFromRegistryById<A>(registryId).foo25()
}

@C
public func CJImpl_ObjC_cjworld_A_foo26(registryId: RegistryId): Unit {
    getFromRegistryById<A>(registryId).foo26()
}

@C
public func CJImpl_ObjC_cjworld_A_foo27(registryId: RegistryId): Unit {
    getFromRegistryById<A>(registryId).foo27()
}

@C
public func CJImpl_ObjC_cjworld_A_foo28(registryId: RegistryId): Unit {
    getFromRegistryById<A>(registryId).foo28()
}

@C
public func CJImpl_ObjC_cjworld_A_foo29(registryId: RegistryId): Unit {
    getFromRegistryById<A>(registryId).foo29()
}

@C
public func CJImpl_ObjC_cjworld_A_foo30(registryId: RegistryId): Unit {
    getFromRegistryById<A>(registryId).foo30()
}

@C
public func CJImpl_ObjC_cjworld_A_foo31(registryId: RegistryId): Unit {
    getFromRegistryById<A>(registryId).foo31()
}

@C
public func CJImpl_ObjC_cjworld_A_foo32(registryId: RegistryId): Unit {
    getFromRegistryById<A>(registryId).foo32()
}

@C
public func CJImpl_ObjC_cjworld_A_foo33(registryId: RegistryId): Unit {
    getFromRegistryById<A>(registryId).foo33()
}

@C
public func CJImpl_ObjC_cjworld_A_foo34(registryId: RegistryId): Unit {
    getFromRegistryById<A>(registryId).foo34()
}

@C
public func CJImpl_ObjC_cjworld_A_foo35(registryId: RegistryId): Unit {
    getFromRegistryById<A>(registryId).foo35()
}

@C
public func CJImpl_ObjC_cjworld_A_foo36(registryId: RegistryId): Unit {
    getFromRegistryById<A>(registryId).foo36()
}

@C
public func CJImpl_ObjC_cjworld_A_foo37(registryId: RegistryId): Unit {
    getFromRegistryById<A>(registryId).foo37()
}

@C
public func CJImpl_ObjC_cjworld_A_foo38(registryId: RegistryId): Unit {
    getFromRegistryById<A>(registryId).foo38()
}

@C
public func CJImpl_ObjC_cjworld_A_foo39(registryId: RegistryId): Unit {
    getFromRegistryById<A>(registryId).foo39()
}

@C
public func CJImpl_ObjC_cjworld_A_foo40(registryId: RegistryId): Unit {
    getFromRegistryById<A>(registryId).foo40()
}

@C
public func CJImpl_ObjC_cjworld_A_foo41(registryId: RegistryId): Unit {
    getFromRegistryById<A>(registryId).foo41()
}

@C
public func CJImpl_ObjC_cjworld_A_foo42(registryId: RegistryId): Unit {
    getFromRegistryById<A>(registryId).foo42()
}

@C
public func CJImpl_ObjC_cjworld_A_foo43(registryId: RegistryId): Unit {
    getFromRegistryById<A>(registryId).foo43()
}

@C
public func CJImpl_ObjC_cjworld_A_foo44(registryId: RegistryId): Unit {
    getFromRegistryById<A>(registryId).foo44()
}

@C
public func CJImpl_ObjC_cjworld_A_foo45(registryId: RegistryId): Unit {
    getFromRegistryById<A>(registryId).foo45()
}

@C
public func CJImpl_ObjC_cjworld_A_foo46(registryId: RegistryId): Unit {
    getFromRegistryById<A>(registryId).foo46()
}

@C
public func CJImpl_ObjC_cjworld_A_foo47(registryId: RegistryId): Unit {
    getFromRegistryById<A>(registryId).foo47()
}

@C
public func CJImpl_ObjC_cjworld_A_foo48(registryId: RegistryId): Unit {
    getFromRegistryById<A>(registryId).foo48()
}

@C
public func CJImpl_ObjC_cjworld_A_foo49(registryId: RegistryId): Unit {
    getFromRegistryById<A>(registryId).foo49()
}

@C
public func CJImpl_ObjC_cjworld_A_foo50(registryId: RegistryId): Unit {
    getFromRegistryById<A>(registryId).foo50()
}

@C
public func CJImpl_ObjC_cjworld_A_foo51(registryId: RegistryId): Unit {
    getFromRegistryById<A>(registryId).foo51()
}

@C
public func CJImpl_ObjC_cjworld_A_foo52(registryId: RegistryId): Unit {
    getFromRegistryById<A>(registryId).foo52()
}

@C
public func CJImpl_ObjC_cjworld_A_foo53(registryId: RegistryId): Unit {
    getFromRegistryById<A>(registryId).foo53()
}

@C
public func CJImpl_ObjC_cjworld_A_foo54(registryId: RegistryId): Unit {
    getFromRegistryById<A>(registryId).foo54()
}

@C
public func CJImpl_ObjC_cjworld_A_foo55(registryId: RegistryId): Unit {
    getFromRegistryById<A>(registryId).foo55()
}

@C
public func CJImpl_ObjC_cjworld_A_foo56(registryId: RegistryId): Unit {
    getFromRegistryById<A>(registryId).foo56()
}

@C
public func CJImpl_ObjC_cjworld_A_foo57(registryId: RegistryId): Unit {
    getFromRegistryById<A>(registryId).foo57()
}

@C
public func CJImpl_ObjC_cjworld_A_foo58(registryId: RegistryId): Unit {
    getFromRegistryById<A>(registryId).foo58()
}

@C
public func CJImpl_ObjC_cjworld_A_foo59(registryId: RegistryId): Unit {
    getFromRegistryById<A>(registryId).foo59()
}

@C
public func CJImpl_ObjC_cjworld_A_foo60(registryId: RegistryId): Unit {
    getFromRegistryById<A>(registryId).foo60()
}

@C
public func CJImpl_ObjC_cjworld_A_foo61(registryId: RegistryId): Unit {
    getFromRegistryById<A>(registryId).foo61()
}

@C
public func CJImpl_ObjC_cjworld_A_foo62(registryId: RegistryId): Unit {
    getFromRegistryById<A>(registryId).foo62()
}

@C
public func CJImpl_ObjC_cjworld_A_foo63(registryId: RegistryId): Unit {
    getFromRegistryById<A>(registryId).foo63()
}

@C
public func CJImpl_ObjC_cjworld_A_foo64(registryId: RegistryId): Unit {
    getFromRegistryById<A>(registryId).foo64()
}

@C
public func CJImpl_ObjC_cjworld_A_foo65(registryId: RegistryId): Unit {
    getFromRegistryById<A>(registryId).foo65()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_foo0(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).foo0Impl()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_foo1(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).foo1Impl()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_foo2(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).foo2Impl()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_foo3(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).foo3Impl()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_foo4(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).foo4Impl()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_foo5(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).foo5Impl()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_foo6(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).foo6Impl()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_foo7(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).foo7Impl()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_foo8(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).foo8Impl()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_foo9(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).foo9Impl()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_foo20(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).foo20Impl()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_foo21(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).foo21Impl()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_foo22(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).foo22Impl()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_foo23(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).foo23Impl()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_foo24(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).foo24Impl()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_foo25(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).foo25Impl()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_foo26(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).foo26Impl()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_foo27(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).foo27Impl()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_foo28(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).foo28Impl()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_foo29(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).foo29Impl()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_foo30(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).foo30Impl()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_foo31(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).foo31Impl()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_foo32(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).foo32Impl()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_foo33(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).foo33Impl()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_foo34(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).foo34Impl()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_foo35(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).foo35Impl()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_foo36(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).foo36Impl()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_foo37(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).foo37Impl()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_foo38(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).foo38Impl()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_foo39(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).foo39Impl()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_foo40(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).foo40Impl()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_foo41(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).foo41Impl()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_foo42(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).foo42Impl()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_foo43(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).foo43Impl()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_foo44(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).foo44Impl()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_foo45(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).foo45Impl()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_foo46(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).foo46Impl()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_foo47(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).foo47Impl()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_foo48(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).foo48Impl()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_foo49(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).foo49Impl()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_foo50(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).foo50Impl()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_foo51(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).foo51Impl()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_foo52(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).foo52Impl()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_foo53(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).foo53Impl()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_foo54(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).foo54Impl()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_foo55(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).foo55Impl()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_foo56(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).foo56Impl()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_foo57(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).foo57Impl()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_foo58(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).foo58Impl()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_foo59(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).foo59Impl()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_foo60(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).foo60Impl()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_foo61(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).foo61Impl()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_foo62(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).foo62Impl()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_foo63(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).foo63Impl()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_foo64(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).foo64Impl()
}

@C
public func CJImpl_ObjC_cjworld_A_fwd_foo65(registryId: RegistryId): Unit {
    getFromRegistryById<A_fwd>(registryId).foo65Impl()
}
