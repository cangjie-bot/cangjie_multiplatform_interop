// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import objc.lang.*

open class M {
    public let obj: NativeObjCId

    public init(obj: NativeObjCId) {
        this.obj = obj
    }

    public init() {
        this(withAutoreleasePoolObj({
            => unsafe {
                CFunc<(NativeObjCId, NativeObjCSel) -> NativeObjCId>(objCMsgSend())(alloc("M"), registerName("init"))
            }
        }))
    }
}
