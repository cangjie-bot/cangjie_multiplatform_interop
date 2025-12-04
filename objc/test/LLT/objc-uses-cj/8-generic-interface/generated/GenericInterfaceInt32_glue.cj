package cjworld

//import genericInterface.*
import interoplib.objc.*

class GenericInterfaceInt32Fwd <: GenericInterface<Int32> {
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

    public func printValue(t : Int32) : Unit {
        unsafe {
            return CFunc<(NativeObjCId, CPointer<Unit>) -> Unit>(objCMsgSend())(this.getObj(), registerName("printValueInt32"))
        }
    }

    public func setValue(t : Int32) : Unit {
        unsafe {
            return CFunc<(NativeObjCId, CPointer<Unit>) -> Unit>(objCMsgSend())(this.getObj(), registerName("setValueInt32"))
        }
    }

    public func getValue() : Int32 {
        unsafe {
            return return CFunc<(NativeObjCId, CPointer<Unit>) -> Int32>(objCMsgSend())(this.getObj(), registerName("getValueInt32"))
        }
    }
}
