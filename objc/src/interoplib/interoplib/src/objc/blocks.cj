package interoplib.objc

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
