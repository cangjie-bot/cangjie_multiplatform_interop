package cj

import interoplib.interop.*

public class A <: Object {
    public func test(fun : (Int32) -> (Int32)): (Int32) -> (Int32) {
        print("lambda as param:: ${fun(10)}\n", flush:true) 
        let new = {b : Int32 => b - 5}
        new
    }

    public init() {
        super()

    }

}

public func getIntWIntCjLambda(a: CPointer<Unit>) : (Int32) -> Int32 {
    let javaref = Java_CFFI_JavaEntityJobject(a)
    let cjLambda = { b:Int32 => 
        let env = Java_CFFI_get_env()
        let methodId = Java_CFFI_MethodIDConstr(env, Java_CFFI_ClassInit(env, "cj/IntWInt$BoxIntWInt"), "call", Java_CFFI_parseMethodSignature("(I)I"));
        let result = Java_CFFI_callVirtualMethod(env, javaref, methodId, [Java_CFFI_JavaEntity(b)], Java_CFFI_JavaCallNestInit(1))
        Java_CFFI_unwrapJavaEntityAsValue<Int32>(result)
    }
    cjLambda
}

public func getIntWIntJavaLambda(fun : (Int32) -> (Int32)) : Java_CFFI_JavaEntity {
    let cjId = Java_CFFI_put_to_registry_1(fun)
    let env = Java_CFFI_get_env()
    let clazz = Java_CFFI_ClassInit(env, "cj/IntWInt$BoxIntWInt")
    let methodId = Java_CFFI_MethodIDConstr(env, Java_CFFI_ClassInit(env, "cj/IntWInt$BoxIntWInt"), "<init>", Java_CFFI_parseMethodSignature("(J)V"));
    let obj = Java_CFFI_newJavaObject(env, clazz, methodId, [Java_CFFI_JavaEntity(cjId)], Java_CFFI_JavaCallNest(1))
    obj
}

@C
public func Java_cj_A_testImpl2(env: CPointer<CPointer<JNINativeInterface_>>, _: CPointer<Unit>, self: Int64, a: CPointer<Unit>): jobject {
    return withExceptionHandling(env, { =>
        let tmp2 = Java_CFFI_getFromRegistry<A>(env, self).test(getIntWIntCjLambda(a))
        let obj = getIntWIntJavaLambda(tmp2)
        obj.asJObject()
    })
}

@C
public func Java_cj_A_testImpl1(env: CPointer<CPointer<JNINativeInterface_>>, _: CPointer<Unit>, self: Int64, a: Int64): jobject {
    return withExceptionHandling(env, { =>
        let b = Java_CFFI_getFromRegistry<(Int32)->(Int32)>(env, a)
        println("2 testImpl1")
        println(b(10))
        let tmp2 = Java_CFFI_getFromRegistry<A>(env, self).test(b)
        let obj = getIntWIntJavaLambda(tmp2)
        obj.asJObject()
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

