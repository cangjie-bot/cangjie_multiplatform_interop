package objc.lang

public struct ObjCFunc<F> {
    @Frozen
    public ObjCFunc(let ptr: CPointer<CFunc<() -> Unit>>) {}
    public prop call: F {
        get() { throw Exception() }
    }

    public unsafe func unsafeGetFunctionPointer(): CPointer<CFunc<() -> Unit>> {
        return ptr;
    }
}
