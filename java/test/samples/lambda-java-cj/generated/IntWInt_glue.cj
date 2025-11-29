package cj

import interoplib.interop.*

var display = {a:Int32 => a + 2}

@C
public func Java_cj_IntWInt_00024Display_initDisplayObject(env: JNIEnv_ptr, _: jclass): Int64 {
    withExceptionHandling(env) {
        Java_CFFI_put_to_registry_1(display)
    }
}

@C
public func Java_cj_IntWInt_00024BoxIntWInt_intWIntImpl(env: JNIEnv_ptr, _: jclass, self: jlong, arg: Int32): Int32 {
    withExceptionHandling(env) {
        let v = Java_CFFI_getFromRegistry<(Int32) -> Int32>(env, self)
        let r = v(arg)
        r
    }
}

@C
public func Java_cj_IntWInt_00024BoxIntWInt_deleteIntWIntCJObject(env: JNIEnv_ptr, _: jclass, self:jlong): Unit {
    withExceptionHandling(env) {
        Java_CFFI_deleteCJObjectOneWay<(Int32) -> Int32>(env, self)
    }
}