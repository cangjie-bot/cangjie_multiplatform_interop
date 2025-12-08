package UNNAMED

import interoplib.interop.*
import java.lang.*

public class A <: Object {
    public func foo(a: (Int64, Int32, Int32)): Unit {
        println(a[0]);
        println(a[1]);
        println(a[2]);
        return ()
    }

    public func goo(a: Int64, b: Int32, c: Int32): (Int64, Int32, Int32) {
        return (a, b, c)
    }

    public init() {
        super()
    }
}

@C
public func Java_UNNAMED_A_fooRN7UNNAMED23TurpleOfInt64Int32Int32E(env: CPointer<CPointer<JNINativeInterface_>>,
    _: CPointer<Unit>, self: Int64, a: Int64) {
    return withExceptionHandling<Unit>(
        env,
        {
            =>
                let tmp1: Unit = Java_CFFI_getFromRegistry<A>(env, self).foo(
                    Java_CFFI_getFromRegistry<(Int64, Int32, Int32)>(env, a))
                return tmp1
        }
    )
}

@C
public func Java_UNNAMED_A_goolii(env: CPointer<CPointer<JNINativeInterface_>>, _: CPointer<Unit>, self: Int64,
    a: Int64, b: Int32, c: Int32) {
    return withExceptionHandling<CPointer<Unit>>(
        env,
        {
            =>
                let tmp2: (Int64, Int32, Int32) = Java_CFFI_getFromRegistry<A>(env, self).goo(a, b, c)
                return Java_CFFI_newJavaProxyObjectForCJMapping(env, tmp2, "UNNAMED/TurpleOfInt64Int32Int32", true)
        }
    )
}

@C
public func Java_UNNAMED_A_deleteCJObject(env: CPointer<CPointer<JNINativeInterface_>>, obj: CPointer<Unit>, self: Int64) {
    return withExceptionHandling<Unit>(env, {
        => return Java_CFFI_removeFromRegistry(self)
    })
}

@C
public func Java_UNNAMED_A_initCJObject(env: CPointer<CPointer<JNINativeInterface_>>, obj: CPointer<Unit>) {
    return withExceptionHandling<Int64>(env, {
        => return Java_CFFI_put_to_registry_1(A())
    })
}
