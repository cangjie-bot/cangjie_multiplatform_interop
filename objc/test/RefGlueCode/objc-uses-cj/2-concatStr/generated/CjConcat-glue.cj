// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import api.*
import objc.lang.*

@C
public func CJImpl_ObjC_cjworld_globalConcat(a: NativeObjCId, b: NativeObjCId): NativeObjCId {
    let cstrA = unsafe { CFunc<(NativeObjCId, NativeObjCSel) -> CString>(objCMsgSend())(a, registerName("UTF8String")) }
    let cstrB = unsafe { CFunc<(NativeObjCId, NativeObjCSel) -> CString>(objCMsgSend())(b, registerName("UTF8String")) }
    let str = globalConcat(cstrA.toString(), cstrB.toString())

    // this String (cj) => NSString (objc) converter better be moved to interoplib
    unsafe {
        let cstr = LibC.mallocCString(str)
        try {
            CFunc<(NativeObjCId, NativeObjCSel, CString) -> NativeObjCId>(objCMsgSend())(getClass("NSString"), registerName("stringWithUTF8String:"), cstr)
        } finally {
            LibC.free(cstr)
        }
    }
}

@C
public func CJImpl_ObjC_cjworld_CjConcat_staticConcat(a: NativeObjCId, b: NativeObjCId): NativeObjCId {
    let cstrA = unsafe { CFunc<(NativeObjCId, NativeObjCSel) -> CString>(objCMsgSend())(a, registerName("UTF8String")) }
    let cstrB = unsafe { CFunc<(NativeObjCId, NativeObjCSel) -> CString>(objCMsgSend())(b, registerName("UTF8String")) }
    let str = CjConcat.staticConcat(cstrA.toString(), cstrB.toString())

    // this String (cj) => NSString (objc) converter better be moved to interoplib
    unsafe {
        let cstr = LibC.mallocCString(str)
        try {
            CFunc<(NativeObjCId, NativeObjCSel, CString) -> NativeObjCId>(objCMsgSend())(getClass("NSString"), registerName("stringWithUTF8String:"), cstr)
        } finally {
            LibC.free(cstr)
        }
    }
}
