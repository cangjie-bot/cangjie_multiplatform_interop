package cjworld

import interoplib.objc.*

@C
public func CJImpl_ObjC_cjworld_GenericEnumInt32_RedInitCJObject(v: Int32): RegistryId {
    putToRegistry(GenericEnum<Int32>.Red(v))
}

@C
public func CJImpl_ObjC_cjworld_GenericEnumInt32_GreenInitCJObject(v: Int32): RegistryId {
    putToRegistry(GenericEnum<Int32>.Green(v))
}

@C
public func CJImpl_ObjC_cjworld_GenericEnumInt32_BlueInitCJObject(v: Int32): RegistryId {
    putToRegistry(GenericEnum<Int32>.Blue(v))
}

@C
public func CJImpl_ObjC_cjworld_GenericEnumInt32_printValue(registryId: RegistryId): Unit {
    getFromRegistryById<GenericEnum<Int32>>(registryId).printValue()
}

@C
public func CJImpl_ObjC_cjworld_GenericEnumInt32_value_get(registryId: RegistryId): Unit {
    getFromRegistryById<GenericEnum<Int32>>(registryId).value
}

@C
public func CJImpl_ObjC_cjworld_GenericEnumInt32_deleteCJObject(registryId: RegistryId): Unit {
    removeFromRegistry(registryId)
}
