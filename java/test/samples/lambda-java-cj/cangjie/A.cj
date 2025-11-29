package cj
import interoplib.interop.*
public class A {
    public func test(fun : (Int32) -> (Int32)): (Int32) -> (Int32) {
        print("lambda as param:: ${fun(10)}\n", flush:true) 
        var new = b:Int32 => b - 5
        new
    }
}