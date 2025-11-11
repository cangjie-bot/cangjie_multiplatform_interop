// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import api.*
import objc.lang.*

// to make accessible the default implementation of Animal interface
abstract class AnimalImpl <: Animal {}

class Animal_fwd <: AnimalImpl {
    let obj: NativeObjCId

    init(obj: NativeObjCId) {
        this.obj = obj
    }

    ~init() {
        unsafe { objCRelease(obj) }
    }

    public func Say(): Unit {
        unsafe {
            CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(obj, registerName("Say"))
        }
    }
 
    public func Eat(): Unit {
        unsafe {
            CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(objCMsgSend())(obj, registerName("Eat"))
        }
    }

    public func Weight(): Int32 {
        unsafe {
            CFunc<(NativeObjCId, NativeObjCSel) -> Int32>(objCMsgSend())(obj, registerName("Weight"))
        }
    }

    func SayImpl(): Unit {
        super.Say()
    }

    func EatImpl(): Unit {
        super.Eat()
    }
}

@C
public func CJImpl_ObjC_cjworld_AnimalImpl_SayImpl(obj: NativeObjCId): Unit {
    Animal_fwd(obj).SayImpl()
}

@C
public func CJImpl_ObjC_cjworld_AnimalImpl_EatImpl(obj: NativeObjCId): Unit {
    Animal_fwd(obj).EatImpl()
}

@C
public func CJImpl_ObjC_cjworld_AnimalImpl_staticTest(obj: NativeObjCId): Unit {
    AnimalImpl.staticTest(Animal_fwd(obj))
}
