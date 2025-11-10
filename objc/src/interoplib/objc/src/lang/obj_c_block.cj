package objc.lang

public class ObjCBlock<F> {
    @Frozen
    public ObjCBlock(let ptr: CPointer<NativeBlockABI>) {
    }
    @Frozen
    public init(f: F) {
        throw Exception("Function constructor is implemented by the compiler")
    }
    public prop call: F {
        get() { throw Exception("'call' is implemented by compiler") }
    }
    public unsafe func unsafeGetNativeABIPointer(): CPointer<Unit> {
        return CPointer<Unit>(ptr);
    }
    public unsafe func unsafeGetFunctionPointer(): CPointer<CFunc<(CPointer<Unit>) -> Unit>> {
        return CPointer<CFunc<(CPointer<Unit>) -> Unit>>(ptr.read().invoke);
    }
    ~init() {
        unsafe {
            objCRelease(NativeObjCId(this.ptr))
        }
    }
}
