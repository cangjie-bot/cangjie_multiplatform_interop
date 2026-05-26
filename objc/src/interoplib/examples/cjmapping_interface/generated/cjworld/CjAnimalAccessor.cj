// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import objc.lang.*

public class CjAnimalAccessor {
    public func fooWithDefault(a: Animal): Unit {
        println("[CJ]: CjAnimalAccessor.fooWithDefault()")
        a.Say()
    }
 
    public func foo(a: Animal): Unit {
        println("[CJ]: CjAnimalAccessor.foo got Weight == ${a.Weight()}")
    }
}

@C
public func CJImpl_ObjC_cjworld_CjAnimalAccessor_initCJObject(): RegistryId {
    putToRegistry(CjAnimalAccessor())
}

@C
public func CJImpl_ObjC_cjworld_CjAnimalAccessor_fooWithDefault(registryId: RegistryId, obj: NativeObjCId): Unit {
    let accessor = getFromRegistryById<CjAnimalAccessor>(registryId)
    accessor.fooWithDefault(Animal_fwd(obj))
}

@C
public func CJImpl_ObjC_cjworld_CjAnimalAccessor_foo(registryId: RegistryId, obj: NativeObjCId): Unit {
    let accessor = getFromRegistryById<CjAnimalAccessor>(registryId)
    accessor.foo(Animal_fwd(obj))
}

@C
public func CJImpl_ObjC_cjworld_CjAnimalAccessor_deleteCJObject(registryId: RegistryId): Unit {
    removeFromRegistry(registryId)
}
