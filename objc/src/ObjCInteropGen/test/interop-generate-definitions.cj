// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package objc.foundation

public struct Class /*ObjCClass*/ {
}

public open interface ObjCId {
}

public open class SEL /*ObjCSelector*/ {
}

public open class Protocol {
}

public open class ObjCPointer<T> {
    public ObjCPointer(let ptr: CPointer<Unit>) {}
}

public open class ObjCFunc<T> {
}

public struct ObjCBlock<T> {
}
