package UNNAMED

import interoplib.interop.*
import java.lang.*

public interface B {
    func hoo(a: (Int64, Int32, Int32)): Unit

    func koo(): (Int64, Int32, Int32)
}

class B_fwd <: B {
    public let javaref: Java_CFFI_JavaEntity

    public init(ref: Java_CFFI_JavaEntity) {
        Java_CFFI_ensure_not_null(ref)
        javaref = Java_CFFI_newGlobalReference(Java_CFFI_get_env(), ref, false)
    }

    public func koo(): (Int64, Int32, Int32) {
        let tmp1: Java_CFFI_JavaEntity = Java_CFFI_callVirtualMethod(Java_CFFI_get_env(), this.javaref,
            Java_CFFI_MethodIDConstr(Java_CFFI_get_env(), Java_CFFI_ClassInit(Java_CFFI_get_env(), "UNNAMED/B"), "koo",
                Java_CFFI_parseMethodSignature("()LUNNAMED/TurpleOfInt64Int32Int32;")), [], Java_CFFI_JavaCallNestInit(0))
        return Java_CFFI_getFromRegistry<(Int64, Int32, Int32)>(Java_CFFI_get_env(),
            Java_CFFI_unwrapJavaEntityAsValue<Int64>(
                Java_CFFI_getField(Java_CFFI_get_env(), tmp1,
                    Java_CFFI_FieldIDConstr(Java_CFFI_get_env(),
                        Java_CFFI_ClassInit(Java_CFFI_get_env(), "UNNAMED/TurpleOfInt64Int32Int32"), "self",
                        Java_CFFI_parseComponentSignature("J")))))
    }

    public func hoo(a: (Int64, Int32, Int32)): Unit {
        let tmp2: Java_CFFI_JavaEntity = Java_CFFI_callVirtualMethod(Java_CFFI_get_env(), this.javaref,
            Java_CFFI_MethodIDConstr(Java_CFFI_get_env(), Java_CFFI_ClassInit(Java_CFFI_get_env(), "UNNAMED/B"), "hoo",
                Java_CFFI_parseMethodSignature("(LUNNAMED/TurpleOfInt64Int32Int32;)V")),
            [Java_CFFI_JavaEntity(JOBJECT,
                Java_CFFI_newJavaProxyObjectForCJMapping(Java_CFFI_get_env(), a, "UNNAMED/TurpleOfInt64Int32Int32", true))],
            Java_CFFI_JavaCallNestInit(1))
        return Java_CFFI_unwrapJavaEntityAsValue<Unit>(tmp2)
    }
}