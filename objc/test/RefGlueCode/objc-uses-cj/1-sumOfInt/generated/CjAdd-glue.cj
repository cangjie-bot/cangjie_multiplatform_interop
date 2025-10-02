// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import api.*
import objc.lang.*

@C
public func CJImpl_ObjC_cjworld_globalAddII(a: Int32, b:Int32): Int32 {
    globalAddII(a, b)
}

@C
public func CJImpl_ObjC_cjworld_CjAdd_staticAddII(a: Int32, b:Int32): Int32 {
    CjAdd.staticAddII(a, b)
}
