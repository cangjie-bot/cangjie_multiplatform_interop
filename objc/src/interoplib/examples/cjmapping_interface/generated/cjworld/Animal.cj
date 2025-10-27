// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import interoplib.objc.*

public interface Animal {
    func Say(): Unit {
        println("[CJ]: Animal.Say()")
    }
 
    func Eat(): Unit {
        println("[CJ]: Animal.Eat() ENTER")
        Say()
        println("[CJ]: Animal.Eat() EXIT")
    }

    func Weight(): Int32
}

// to make accessible the default implementation of Animal interface
abstract class AnimalImpl <: Animal {}

class Animal_fwd <: AnimalImpl {
    let obj: NativeObjCId

    init(obj: NativeObjCId) {
        this.obj = unsafe { ObjCRuntime.retain(obj) }
        // enable this print to ensure Animal_fwd is created: println("[CJ]: Animal_fwd created")
    }

    ~init() {
        unsafe { ObjCRuntime.release(obj) }
    }

    public func Say(): Unit {
        unsafe {
            CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(ObjCRuntime.msgSend)(obj, registerName("Say"))
        }
    }
 
    public func Eat(): Unit {
        unsafe {
            CFunc<(NativeObjCId, NativeObjCSel) -> Unit>(ObjCRuntime.msgSend)(obj, registerName("Eat"))
        }
    }

    public func Weight(): Int32 {
        unsafe {
            CFunc<(NativeObjCId, NativeObjCSel) -> Int32>(ObjCRuntime.msgSend)(obj, registerName("Weight"))
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
