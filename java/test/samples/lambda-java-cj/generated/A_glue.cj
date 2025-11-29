package cj

import interoplib.interop.*
import ori.*

class I_fwd <: I {
    public let javaref: Java_CFFI_JavaEntity

    public init(ref: Java_CFFI_JavaEntity) {
        Java_CFFI_ensure_not_null(ref)
        javaref = Java_CFFI_newGlobalReference(Java_CFFI_get_env(), ref, false)

    }

    public func test(fun: (Int32) -> (Int32)): (Int32) -> (Int32) {
        let funObj = getIntWIntJavaLambdaEntity(fun) // different
        let env = Java_CFFI_get_env();
        let methodId = Java_CFFI_MethodIDConstr(env, Java_CFFI_ClassInit(Java_CFFI_get_env(), "cj/I"), "test", Java_CFFI_parseMethodSignature("(Lcj/IntWInt;)Lcj/IntWInt;"/*diferent*/)) // diferent
        let tmp1: Java_CFFI_JavaEntity = Java_CFFI_callVirtualMethod(env, this.javaref, methodId, [funObj/*diferent*/], Java_CFFI_JavaCallNestInit(1))
        // diferent
        let jobj = Java_CFFI_unwrapJavaEntityAsValue<jobject>(tmp1)
        getIntWIntCjLambda(jobj)
    }

    public func doo(fun: (Int32) -> (Int32)): (Int32) -> (Int32) {
        let funObj = getIntWIntJavaLambdaEntity(fun) // different
        let env = Java_CFFI_get_env();
        let methodId = Java_CFFI_MethodIDConstr(env, Java_CFFI_ClassInit(Java_CFFI_get_env(), "cj/I"), "doo", Java_CFFI_parseMethodSignature("(Lcj/IntWInt;)Lcj/IntWInt;"/*diferent*/)) // diferent
        let tmp1: Java_CFFI_JavaEntity = Java_CFFI_callVirtualMethod(env, this.javaref, methodId, [funObj/*diferent*/], Java_CFFI_JavaCallNestInit(1))
        // diferent
        let jobj = Java_CFFI_unwrapJavaEntityAsValue<jobject>(tmp1)
        getIntWIntCjLambda(jobj)
    }

    public func doo_default_impl(fun: (Int32) -> (Int32)):  (Int32) -> (Int32) {
        print("CJ: at I default method doo(): ${fun(10)}\n", flush:true)
        return {b:Int32=> b + 6 }
    }

}

@C
public func Java_cj_A_getCjLambda(env: CPointer<CPointer<JNINativeInterface_>>, _: CPointer<Unit>, self: Int64): jobject{
    return withExceptionHandling(env, { =>
        let tmp1 = Java_CFFI_getFromRegistry<A>(env, self).getCjLambda()
        return getIntWIntJavaLambda(tmp1) // different
    })
}

@C
public func Java_cj_A_testImpl(env: CPointer<CPointer<JNINativeInterface_>>, _: CPointer<Unit>, self: Int64, a: jobject): jobject {
    return withExceptionHandling(env, { =>
        let tmp2 = Java_CFFI_getFromRegistry<A>(env, self).test(getIntWIntCjLambda(a)/*different*/)
        // different with origin glue code
        return getIntWIntJavaLambda(tmp2)
    })
}

@C
public func Java_cj_A_deleteCJObject(env: CPointer<CPointer<JNINativeInterface_>>, obj: jobject, self: Int64) {
    return withExceptionHandling<Unit>(env, { =>
        return Java_CFFI_removeFromRegistry(self)
    })
}

@C
public func Java_cj_A_initCJObject(env: CPointer<CPointer<JNINativeInterface_>>, obj: jobject) {
    return withExceptionHandling<Int64>(env, { =>
        return Java_CFFI_put_to_registry_1(A())
    })
}

@C
public func Java_cj_A_gooCN2cj1IE(env: CPointer<CPointer<JNINativeInterface_>>, _: CPointer<Unit>, self: Int64, i: jobject, a: Int32) : jobject {
    return withExceptionHandling(env, { =>
        let tmp2: (Int32)->(Int32) = Java_CFFI_getFromRegistry<A>(env, self).goo(I_fwd(Java_CFFI_JavaEntityJobject(i)), a)
        // different with origin glue code
        return getIntWIntJavaLambda(tmp2)
    })
}

@C
public func Java_cj_A_staticFunci(env: CPointer<CPointer<JNINativeInterface_>>, _: jobject, a: jobject) : jobject {
    return withExceptionHandling(env, { =>
        let tmp3 = A.staticFunc(getIntWIntCjLambda(a)/*different*/)
        // different with origin glue code
        return getIntWIntJavaLambda(tmp3)
    })
}

@C
public func Java_cj_I_1fwd_doo_1default_1impli(env: CPointer<CPointer<JNINativeInterface_>>, _: CPointer<Unit>, selfobj: jobject, fun: jobject) : jobject{
    return withExceptionHandling(env, { =>
        let cjLambda = getIntWIntCjLambda(fun) // different
        let tmp4 = I_fwd(Java_CFFI_JavaEntityJobject(selfobj)).doo_default_impl(cjLambda /*different*/)
        // different with origin glue code
        return getIntWIntJavaLambda(tmp4)
    })
}

@C
public func Java_cj_A_initCJObjecti(env: CPointer<CPointer<JNINativeInterface_>>, obj: CPointer<Unit>, a: jobject) {
    return withExceptionHandling<Int64>(env, { =>
        return Java_CFFI_put_to_registry_1(A(getIntWIntCjLambda(a)/*different*/))
    })
}

