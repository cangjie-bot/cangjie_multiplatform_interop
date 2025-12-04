package cjworld

import genericClass.*
import interoplib.objc.*

@C
public func CJImpl_ObjC_cjworld_GenericClassInt32_initCJObjectG_1(v: Int32) : RegistryId {
    putToRegistry(GenericClass<Int32>(v))
}

@C
public func CJImpl_ObjC_cjworld_GenericClassInt32_setValueG_1(registryId: RegistryId, t: Int32) {
    getFromRegistryById<GenericClass<Int32>>(registryId).setValue(t)
}

@C
public func CJImpl_ObjC_cjworld_GenericClassInt32_getValue(registryId: RegistryId) : Int32 {
    getFromRegistryById<GenericClass<Int32>>(registryId).getValue()
}

@C
public func CJImpl_ObjC_cjworld_GenericClassInt32_deleteCJObject(registryId: RegistryId): Unit {
    removeFromRegistry(registryId)
}
