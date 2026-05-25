// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import objc.lang.*

func assert<T>(lhv: T, rhv: T) where T <: Equatable<T> {
    if (lhv != rhv) { throw Exception() }
}

@ObjCImpl
public class A <: M {
    public init() {
        super()

        println("cj: A.init()")
    }

    public override func baseline() { return -1.0 }

    public override func run(): Unit {
        let pUnit = pointerToUnit()
        assert(pUnit.read(), ())
        let pPrim = pointerToPrimitive()
        assert(pPrim.read(), 56)
        pPrim.write(13)
        assert(pPrim.read(), 13)
        let pPointer = pointerToPointer()
        assert(pPointer.read().read(), 3.14)
        pPointer.read().write(1.0)
        assert(pPointer.read().read(), 1.0)
        let pMirror = pointerToMirror()
        assert(pMirror.read().baseline(), -1.0)
        pMirror.write(M())
        assert(pMirror.read().baseline(), 3.16)
        let pImpl = pointerToImpl()
        assert(pImpl.read().baseline(), -1.0)
    }
}
