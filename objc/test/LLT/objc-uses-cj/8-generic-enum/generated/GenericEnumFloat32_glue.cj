package cjworld

import interoplib.objc.*

@C
public func CJImpl_ObjC_cjworld_GenericEnumFloat32_RedInitCJObject(v: Float32): RegistryId {
    putToRegistry(GenericEnum<Float32>.Red(v))
}

@C
public func CJImpl_ObjC_cjworld_GenericEnumFloat32_GreenInitCJObject(v: Float32): RegistryId {
    putToRegistry(GenericEnum<Float32>.Green(v))
}

@C
public func CJImpl_ObjC_cjworld_GenericEnumFloat32_BlueInitCJObject(v: Float32): RegistryId {
    putToRegistry(GenericEnum<Float32>.Blue(v))
}

@C
public func CJImpl_ObjC_cjworld_GenericEnumFloat32_printValue(registryId: RegistryId): Unit {
    getFromRegistryById<GenericEnum<Float32>>(registryId).printValue()
}

@C
public func CJImpl_ObjC_cjworld_GenericEnumFloat32_value_get(registryId: RegistryId): Unit {
    getFromRegistryById<GenericEnum<Float32>>(registryId).value
}

@C
public func CJImpl_ObjC_cjworld_GenericEnumFloat32_deleteCJObject(registryId: RegistryId): Unit {
    removeFromRegistry(registryId)
}
