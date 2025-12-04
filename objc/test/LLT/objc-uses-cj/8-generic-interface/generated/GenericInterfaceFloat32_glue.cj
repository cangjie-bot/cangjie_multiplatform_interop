package cjworld

//import genericInterface.*
import interoplib.objc.*

class GenericInterfaceFloat32Fwd <: GenericInterface<Float32> {
    public let obj: NativeObjCId

    init(obj: NativeObjCId) {
        this.obj = obj
    }

    ~init() {
        return objCRelease(this.obj)
    }

    public func getObj(): NativeObjCId {
        return this.obj
    }

    private var hasInited: Bool = false

    public func printValue(t : Float32) : Unit {
        unsafe {
            return CFunc<(NativeObjCId, CPointer<Unit>) -> Unit>(objCMsgSend())(this.getObj(), registerName("printValueFloat32"))
        }
    }

    public func setValue(t : Float32) : Unit {
        unsafe {
            return CFunc<(NativeObjCId, CPointer<Unit>) -> Unit>(objCMsgSend())(this.getObj(), registerName("setValueFloat32"))
        }
    }

    public func getValue() : Float32 {
        unsafe {
            return return CFunc<(NativeObjCId, CPointer<Unit>) -> Float32>(objCMsgSend())(this.getObj(), registerName("getValueFloat32"))
        }
    }
}
