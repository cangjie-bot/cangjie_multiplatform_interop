// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import objc.lang.*

public class M1 {
    public let obj: NativeObjCId

    public prop answer: Float64 {
        get() {
            unsafe {
                CFunc<(NativeObjCId, NativeObjCSel) -> Float64>(objCMsgSend())(obj, registerName("answer"))
            }
        }
    }

    public init(obj: NativeObjCId) {
        this.obj = obj
    }

    public init(answer: Float64) {
        this(withAutoreleasePoolObj { => unsafe {
                CFunc<(NativeObjCId, NativeObjCSel, Float64) -> NativeObjCId>(objCMsgSend())(alloc("M1"),
                    registerName("initWithAnswer:"), answer)
            }})
    }

    /**
     * Finalizer MUST be generated for every mirror.
     */
    ~init() {
        unsafe {
            objCRelease(obj)
        }
    }
}
