// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import interoplib.objc.*

public open class M {
    public let obj: NativeObjCId

    public mut prop foo: Int64 {
        get() {
            unsafe {
                CFunc<(NativeObjCId, NativeObjCSel) -> Int64>(ObjCRuntime.msgSend)(obj, registerName("foo"))
            }
        }
        set(value) {
            unsafe {
                CFunc<(NativeObjCId, NativeObjCSel, Int64) -> Unit>(ObjCRuntime.msgSend)(obj, registerName("setFoo:"),
                    value)
            }
        }
    }

    public mut prop bar: M1 {
        get() {
            M1(
                withAutoreleasePoolObj {
                    => unsafe {
                        CFunc<(NativeObjCId, NativeObjCSel) -> NativeObjCId>(ObjCRuntime.msgSend)(obj,
                            registerName("bar"))
                    }
                })
        }
        set(value) {
            withAutoreleasePool<Unit> {
                => unsafe {
                    CFunc<(NativeObjCId, NativeObjCSel, NativeObjCId) -> Unit>(ObjCRuntime.msgSend)(obj,
                        registerName("setBar:"), value.obj)
                }
            }
        }
    }

    public init(obj: NativeObjCId) {
        this.obj = obj
    }

    public init() {
        this(
            unsafe {
                CFunc<(NativeObjCId, NativeObjCSel) -> NativeObjCId>(ObjCRuntime.msgSend)(alloc("M"),
                    registerName("init"))
            })
    }
}
