package UNNAMED

import interoplib.interop.*
import java.lang.*

@C
public func Java_UNNAMED_TurpleOfInt64Int32Int32_deleteCJObject(env: CPointer<CPointer<JNINativeInterface_>>,
    obj: CPointer<Unit>, self: Int64) {
    return withExceptionHandling<Unit>(env, {
        => return Java_CFFI_removeFromRegistry(self)
    })
}

@C
public func Java_UNNAMED_TurpleOfInt64Int32Int32_initCJObjectlii(env: CPointer<CPointer<JNINativeInterface_>>,
    obj: CPointer<Unit>, item1: Int64, item2: Int32, item3: Int32) {
    return withExceptionHandling<Int64>(env, {
        => return Java_CFFI_put_to_registry_1((item1, item2, item3))
    })
}

@C
public func Java_UNNAMED_TurpleOfInt64Int32Int32_item1(env: CPointer<CPointer<JNINativeInterface_>>,
    obj: CPointer<Unit>, self: Int64) {
    return withExceptionHandling<Int64>(env, {
        => return Java_CFFI_getFromRegistry<(Int64, Int32, Int32)>(env, self)[0]
    })
}

@C
public func Java_UNNAMED_TurpleOfInt64Int32Int32_item2(env: CPointer<CPointer<JNINativeInterface_>>,
    obj: CPointer<Unit>, self: Int64) {
    return withExceptionHandling<Int32>(env, {
        => return Java_CFFI_getFromRegistry<(Int64, Int32, Int32)>(env, self)[1]
    })
}

@C
public func Java_UNNAMED_TurpleOfInt64Int32Int32_item3(env: CPointer<CPointer<JNINativeInterface_>>,
    obj: CPointer<Unit>, self: Int64) {
    return withExceptionHandling<Int32>(env, {
        => return Java_CFFI_getFromRegistry<(Int64, Int32, Int32)>(env, self)[2]
    })
}
