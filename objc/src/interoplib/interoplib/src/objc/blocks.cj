package interoplib.objc

import std.sync.*

foreign func _NSConcreteStackBlock(): Unit

// block descriptor, use all defaults for 'our' blocks
@C
public struct NativeBlockDescriptorABI {
    NativeBlockDescriptorABI(
        let reserved!: UInt64 = 0, // should be zero
        let size!: UInt64, // equals to the size of block (= sizeOf<NativeBlockABI> or = sizeOf<CangjieBlockABI>),
        let copy!: CFunc<(CPointer<NativeBlockABI>, CPointer<NativeBlockABI>) -> Unit>,
        let dispose!: CFunc<(CPointer<NativeBlockABI>) -> Unit>
    ) {}
}

// block structure, see block ABI
// default values are defaults that we provide when constructing block from Cangjie
@C
public struct NativeBlockABI {
    public NativeBlockABI(
        public let isa!: CPointer<Unit>,
        public let flags!: Int32, // see ABI description
        public let reserved!: Int32, // must be zero
        public let invoke!: CPointer<CFunc<(CPointer<NativeBlockABI>) -> Unit>>, // the actual function pointer to implementation
        public let descriptor!: CPointer<NativeBlockDescriptorABI>
    ) {}
}

@C
public struct CangjieBlockABI {
    public CangjieBlockABI(
        let base!: NativeBlockABI,
        let registryId!: RegistryId
    ) {}
}

public class ObjCLambdaWrapper {
    ObjCLambdaWrapper(
        let lambda: Any,
        let counter!: AtomicInt64 = AtomicInt64(1)
    ) {}
}

@C
func cangjieBlockCopy(src: CPointer<NativeBlockABI>, dst: CPointer<NativeBlockABI>) {
}

@C
func cangjieBlockDispose(src: CPointer<NativeBlockABI>) {
}

private var cangjieBlockDescriptor = NativeBlockDescriptorABI(
    reserved: 0,
    size: unsafe { UInt64(sizeOf<CangjieBlockABI>()) },
    copy: cangjieBlockCopy,
    dispose: cangjieBlockDispose
)

@C
private func pCangjieBlockDescriptor(ptr: CPointer<NativeBlockDescriptorABI>): CPointer<NativeBlockDescriptorABI> {
    return ptr
}

public func objcStoreLambdaAsBlock(ref: Any, body: CPointer<CFunc<(CPointer<NativeBlockABI>) -> Unit>>): CPointer<NativeBlockABI> {
    unsafe {
        let regid = putToRegistry(ObjCLambdaWrapper(ref))
        let resultStack = CangjieBlockABI(
            base: NativeBlockABI(
                isa: CPointer<Unit>(_NSConcreteStackBlock),
                flags: 1 << 27,
                reserved: 0,
                invoke: body,
                descriptor: pCangjieBlockDescriptor(inout cangjieBlockDescriptor)
            ),
            registryId: regid
        )
        let resultHeap = LibC.malloc<CangjieBlockABI>()
        resultHeap.write(resultStack)
        return CPointer<NativeBlockABI>(resultHeap)
    }
}

public func objcGetLambdaFromBlock<F>(block: CPointer<NativeBlockABI>): F {
    unsafe {
        let cangjieBlock = CPointer<CangjieBlockABI>(block).read()
        let wrapper = getFromRegistryById<ObjCLambdaWrapper>(cangjieBlock.registryId)
        return (wrapper.lambda as F) ?? throw IllegalStateException("Illegal type")
    }
}
