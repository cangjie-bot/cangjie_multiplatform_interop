package ori

public class A {
    var b :Int32 = 42;
    public init (a:(Int32)->(Int32)) {
        print("A init param fun ret: ${a(b)}\n", flush: true)
    }

    public init() {}

    public func getCjLambda():(Int32) -> (Int32) {
        return {a:Int32 => a + 2}
    }

    public func test(fun : (Int32) -> (Int32)): (Int32) -> (Int32) {
        print("lambda as param:: ${fun(10)}\n", flush:true) 
        let new = {b : Int32 => b - 5}
        new
    }

     public func goo(i: I, a:Int32): (Int32) -> (Int32) {
        let b = {b:Int32 => b + 4}
        print("CJ: A goo(), b => b + 4\n", flush:true)
        if (a == 0) {
           return i.test(b)
        }
        return i.doo(b)
    }

    public static func staticFunc(a:(Int32) -> (Int32)):(Int32) -> (Int32) {
        print("CJ: A staticFunc(), param func ret: ${a(6)}\n", flush:true)
        return {b:Int32 => b + 1}
    }
}

public interface I {
    // default method
    func doo(fun : (Int32) -> (Int32)) : (Int32) -> (Int32) {
        print("CJ: at I default method doo(): ${fun(10)}\n", flush:true)
        return {b:Int32=> b + 6 }
    }

    func test(fun: (Int32) -> (Int32)): (Int32) -> (Int32)
}