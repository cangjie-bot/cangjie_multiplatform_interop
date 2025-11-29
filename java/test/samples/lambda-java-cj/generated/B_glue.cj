package cj

import interoplib.interop.*
import ori.*

@C
public func Java_cj_B_testLambdai(env: CPointer<CPointer<JNINativeInterface_>>, _: CPointer<Unit>, self: Int64, a: jobject): jobject {
    return withExceptionHandling(env, { =>
        let tmp2 = Java_CFFI_getFromRegistry<B>(env, self).testLambda(getIntWIntCjLambda(a)/*different*/)
        // different with origin glue code
        return getIntWIntJavaLambda(tmp2)
    })
}

@C
public func Java_cj_B_detachCJObject(env: CPointer<CPointer<JNINativeInterface_>>, obj: CPointer<Unit>, self: Int64) {
    return withExceptionHandling<Bool>(env, { =>
        return Java_CFFI_getFromRegistry<B_fwd>(env, self).controller.detachCJObject(env, Java_CFFI_JavaEntityJobject(obj), self)
    })
}

@C
public func Java_cj_B_initCJObject(env: CPointer<CPointer<JNINativeInterface_>>, obj: CPointer<Unit>, overrideMask: Int64) {
    return withExceptionHandling<Int64>(env, { =>
        return Java_CFFI_put_to_registry_1(B_fwd(Java_CFFI_newGlobalReference(env, Java_CFFI_JavaEntityJobject(obj), true), UInt64(overrideMask)))
    })
}

class B_fwd <: B {
    public let controller: JavaObjectController<B>

    public let overrideMask: UInt64

    public init(ref: Java_CFFI_JavaEntity, mask: UInt64) {
        super()
        controller = JavaObjectController<B>(ref, "cj/B")
        overrideMask = mask

    }

    public func attachCJObject(env: CPointer<CPointer<JNINativeInterface_>>): Java_CFFI_JavaEntity {
        return controller.attachCJObject(env)
    }

    public open func testLambda(a: (Int32) -> Int32): (Int32) -> Int32 {
        return if ((overrideMask & 1) != 0) {
            let env: CPointer<CPointer<JNINativeInterface_>> = Java_CFFI_get_env()
            let localRef: Java_CFFI_JavaEntity = attachCJObject(env)
            let tmp1: Java_CFFI_JavaEntity = Java_CFFI_callVirtualMethod(env, localRef, Java_CFFI_MethodIDConstr(Java_CFFI_get_env(), Java_CFFI_ClassInit(Java_CFFI_get_env(), "cj/B"), "testLambda", Java_CFFI_parseMethodSignature("(I)I")), [getIntWIntJavaLambdaEntity(a)/*different*/], Java_CFFI_JavaCallNestInit(1))
            deleteLocalRef(env, localRef)
            return getIntWIntCjLambda(tmp1.asJObject()) // different
        } else {
            return super.testLambda(a)
        }
        
    }

}

