package UNNAMED

import interoplib.interop.*
import java.lang.*

public class C <: Object {
    public func foo(b: B): Unit {
        b.hoo(b.koo())
        return ()
    }

    public init() {
        super()
    }
}

@C
public func Java_UNNAMED_C_fooCN7UNNAMED1BE(env: CPointer<CPointer<JNINativeInterface_>>, _: CPointer<Unit>,
    self: Int64, b: CPointer<Unit>) {
    return withExceptionHandling<Unit>(
        env, {
            =>  let tmp3: Unit = Java_CFFI_getFromRegistry<C>(env, self).foo(B_fwd(Java_CFFI_JavaEntityJobject(b)))
                return tmp3
        }
    )
}

@C
public func Java_UNNAMED_C_deleteCJObject(env: CPointer<CPointer<JNINativeInterface_>>, obj: CPointer<Unit>, self: Int64) {
    return withExceptionHandling<Unit>(env, {
        => return Java_CFFI_removeFromRegistry(self)
    })
}

@C
public func Java_UNNAMED_C_initCJObject(env: CPointer<CPointer<JNINativeInterface_>>, obj: CPointer<Unit>) {
    return withExceptionHandling<Int64>(env, {
        => return Java_CFFI_put_to_registry_1(C())
    })
}
