package interoplib.objc

foreign func _NSConcreteStackBlock(): Unit

// block descriptor, use all defaults for 'our' blocks
@C
public struct NativeBlockDescriptorABI {
    NativeBlockDescriptorABI(
        let reserved!: UInt64 = 0, // should be zero
        let size!: UInt64, // equals to the size of block (= sizeOf<NativeBlockABI> or = sizeOf<CangjieBlockABI>),
        let copy!: CFunc<(CPointer<NativeBlockABI>, CPointer<NativeBlockABI>) -> Unit> = cangjieBlockCopy,
        let dispose!: CFunc<(CPointer<NativeBlockABI>) -> Unit> = cangjieBlockDispose
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

    public init(invoke: CPointer<CFunc<(CPointer<NativeBlockABI>) -> Unit>>) {
        this(
            isa: CPointer<Unit>(_NSConcreteStackBlock),
            flags: 1 << 25,
            reserved: 0,
            invoke: invoke,
            descriptor: unsafe { pDefaultDescriptor() }
        )
    }
}

// blocks created from Cangjie need additional fields
@C
public struct CangjieBlockABI {
    public CangjieBlockABI(
        let blockABI!: NativeBlockABI,
        let registryId!: RegistryId
    ) {}
}

// we don't really have to use malloc, we can get a pointer to global directly
var defaultDescriptor = NativeBlockDescriptorABI(
    size: UInt64(sizeOf<CangjieBlockABI>())
)

@C
unsafe func pDefaultDescriptor__(ptr: CPointer<NativeBlockDescriptorABI>) {
    return ptr
}

@C
unsafe func pDefaultDescriptor() { pDefaultDescriptor__(inout defaultDescriptor) }

@C
func cangjieBlockCopy(src: CPointer<NativeBlockABI>, _: CPointer<NativeBlockABI>): Unit {
    unsafe {
        var realSrc = CPointer<CangjieBlockABI>(src).read()
        getFromRegistryById<LambdaWrapper>(realSrc.registryId).counter++
    }
}
@C
func cangjieBlockDispose(ptr: CPointer<NativeBlockABI>): Unit {
    unsafe {
        var realSrc = CPointer<CangjieBlockABI>(ptr).read()
        let wrapper = getFromRegistryById<LambdaWrapper>(realSrc.registryId)
        wrapper.counter--
        if (wrapper.counter == 0) {
            removeFromRegistry(realSrc.registryId)
        }
    }
}

public class LambdaWrapper {
    LambdaWrapper(
        let lambda: Any, var counter!: Int64 = 0
    ) {}
}
