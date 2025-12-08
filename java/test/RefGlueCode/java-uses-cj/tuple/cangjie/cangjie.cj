package UNNAMED

import interoplib.interop.*
import java.lang.*

public class A {
	public func foo(a: (Int64, Int32, Int32)) : Unit {
		println(a[0]);
		println(a[1]);
		println(a[2]);
	}

	public func goo(a: Int64, b: Int32, c: Int32) : (Int64, Int32, Int32) {
		return (a, b, c);
	}
}

public interface B {
    func hoo(a: (Int64, Int32, Int32)): Unit
	func koo(): (Int64, Int32, Int32)
}

public class C {
    public func foo(b: B) {
        b.hoo(b.koo())
    }
}