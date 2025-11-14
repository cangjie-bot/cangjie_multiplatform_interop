// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package interoptest

import std.runtime.*

func triggerGC(): Unit {
    gc(heavy: true)
    sleep(5*Duration.millisecond)
    gc(heavy: true)
    sleep(5*Duration.millisecond)
}

@C
public func Interoptest_cjworld_GC(): Unit {
    triggerGC();
}
