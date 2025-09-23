// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import interoplib.objc.*

@ObjCMirror
public class M1 {
    @ForeignName["init"]
    public init()

    @ForeignName["fooBar"]
    public func fooBar(): Bool
}