package cj

import interoplib.interop.*

public class A <: Object {
    public func test(fun : (Int) -> (Int)): Unit {
        fun.test(10)
    }

    public init() {
        super()

    }

}

public func getIntWIntCjLambda(a: CPointer<Unit>) : (Int) -> Int {
    let javaref = Java_CFFI_JavaEntityJobject(a)
    let cjLambda : (Int) -> (Int) = b:Int32 => {  
        let env = Java_CFFI_get_env()
        let methodId = Java_CFFI_MethodIDConstr(env, Java_CFFI_ClassInit(Java_CFFI_get_env(), "cj/IntWInt$BoxIntWInt"), "call", Java_CFFI_parseMethodSignature("()V"));
        let result = Java_CFFI_callVirtualMethod(env, javaref, methodId, [Java_CFFI_JavaEntity(b)], Java_CFFI_JavaCallNestInit(0))
        return Java_CFFI_unwrapJavaEntityAsValue<Int32>(result)
        }
    cjLambda
}

@C
public func Java_cj_A_testImpl2(env: CPointer<CPointer<JNINativeInterface_>>, _: CPointer<Unit>, self: Int64, a: CPointer<Unit>) {
    return withExceptionHandling<Unit>(env, { =>
        let tmp2: Unit = Java_CFFI_getFromRegistry<A>(env, self).test(getIntWIntCjLambda(a))
        return tmp2
    })
}

@C
public func Java_cj_A_testImpl1(env: CPointer<CPointer<JNINativeInterface_>>, _: CPointer<Unit>, self: Int64, a: Int64) {
    return withExceptionHandling<Unit>(env, { =>
        let b = Java_CFFI_getFromRegistry<(Int)->(Int)>(env, a)
        let tmp2: Unit = Java_CFFI_getFromRegistry<A>(env, self).test(b)
        return tmp2
    })
}

@C
public func Java_cj_A_deleteCJObject(env: CPointer<CPointer<JNINativeInterface_>>, obj: CPointer<Unit>, self: Int64) {
    return withExceptionHandling<Unit>(env, { =>
        return Java_CFFI_removeFromRegistry(self)
    })
}

@C
public func Java_cj_A_initCJObject(env: CPointer<CPointer<JNINativeInterface_>>, obj: CPointer<Unit>) {
    return withExceptionHandling<Int64>(env, { =>
        return Java_CFFI_put_to_registry_1(A())
    })
}

