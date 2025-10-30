package objc.lang

public class ObjCBlock<F> {
    let ownedPtr: Bool
    @Frozen
    public ObjCBlock(let ptr: CPointer<NativeBlockABI>) {
        this.ownedPtr = true
    }
    public prop call: F {
        get() { throw Exception() }
    }
    public unsafe func unsafeGetNativeABIPointer(): CPointer<NativeBlockABI> {
        return ptr;
    }
    public unsafe func unsafeGetFunctionPointer(): CPointer<CFunc<(CPointer<NativeBlockABI>) -> Unit>> {
        return ptr.read().invoke;
    }
    ~init() {
        unsafe {
            if (ownedPtr) {
                LibC.free(this.ptr)
            }
        }
    }
}
