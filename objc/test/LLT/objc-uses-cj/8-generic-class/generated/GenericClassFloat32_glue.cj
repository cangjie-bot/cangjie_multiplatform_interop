package cjworld

import genericClass.*
import interoplib.objc.*

@C
public func CJImpl_ObjC_cjworld_GenericClassFloat32_initCJObjectG_1(v: Float32) : RegistryId {
    putToRegistry(GenericClass<Float32>(v))
}

@C
public func CJImpl_ObjC_cjworld_GenericClassFloat32_setValueG_1(registryId: RegistryId, t: Float32) {
    getFromRegistryById<GenericClass<Float32>>(registryId).setValue(t)
}

@C
public func CJImpl_ObjC_cjworld_GenericClassFloat32_getValue(registryId: RegistryId) : Float32 {
    getFromRegistryById<GenericClass<Float32>>(registryId).getValue()
}

@C
public func CJImpl_ObjC_cjworld_GenericClassFloat32_deleteCJObject(registryId: RegistryId): Unit {
    removeFromRegistry(registryId)
}
