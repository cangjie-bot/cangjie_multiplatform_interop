package cj
import interoplib.interop.*

// new
public func getIntWIntCjLambda(a: jobject) : (Int32) -> Int32 {
    let javaref = Java_CFFI_JavaEntityJobject(a)
    let cjLambda = { b:Int32 => 
        let env = Java_CFFI_get_env()
        let methodId = Java_CFFI_MethodIDConstr(env, Java_CFFI_ClassInit(env, "cj/IntWInt"), "call", Java_CFFI_parseMethodSignature("(I)I"));
        let result = Java_CFFI_callVirtualMethod(env, javaref, methodId, [Java_CFFI_JavaEntity(b)], Java_CFFI_JavaCallNestInit(1))
        Java_CFFI_unwrapJavaEntityAsValue<Int32>(result)
    }
    cjLambda
}

// new
public func getIntWIntJavaLambda(fun : (Int32) -> (Int32)) : jobject {
    let obj = getIntWIntJavaLambdaEntity(fun)
    obj.asJObject()
}

public func getIntWIntJavaLambdaEntity(fun : (Int32) -> (Int32)) : Java_CFFI_JavaEntity {
    let cjId = Java_CFFI_put_to_registry_1(fun)
    let env = Java_CFFI_get_env()
    let clazz = Java_CFFI_ClassInit(env, "cj/IntWInt$BoxIntWInt")
    let methodId = Java_CFFI_MethodIDConstr(env, clazz, "<init>", Java_CFFI_parseMethodSignature("(J)V"));
    let obj = Java_CFFI_newJavaObject(env, clazz, methodId, [Java_CFFI_JavaEntity(cjId)], Java_CFFI_JavaCallNest(1))
    obj
}