package ori

import interoplib.interop.*

public open class B {
    public open func testLambda(a:(Int32) -> Int32):(Int32) -> Int32 {
        print("CJ: at cj B testLambda(), param fun ret: ${a(10)}\n")
        return {b : Int32 => b + 2 }
    }
}
