// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import objc.lang.*

open class M <: M1 {
    public init(obj: NativeObjCId) {
        super(obj)
    }

    public init() {
        this(withAutoreleasePoolObj { => unsafe {
                CFunc<(NativeObjCId, NativeObjCSel) -> NativeObjCId>(objCMsgSend())(alloc("M"),
                    registerName("init"))
            }})
    }

    public override func goo(): Int64 {
        withAutoreleasePool<Int64> {
            => unsafe {
                CFunc<(NativeObjCId, NativeObjCSel) -> Int64>(objCMsgSend())(obj, registerName("goo"))
            }
        }
    }
}
