package cj
import interoplib.interop.*
public class A {
    public func test(fun : (Int) -> (Int)): Unit {
        fun.test(10)
    }
}