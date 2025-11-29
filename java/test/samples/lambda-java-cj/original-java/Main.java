package j;

import cj.*;
import j.*;
public class Main {
    public static void main(String[] args) {
        A cjA = new A();
        IntWInt display = cjA.getCjLambda();
        System.out.println("Java: cangjie lambda:" + display.call(10));
        System.out.print("Java: cangjie ");
        IntWInt reDis = cjA.test(display);
        System.out.println("lambda return param: " + reDis.call(10));

        IntWInt javaL = a -> a*3;
        System.out.print("Java: java ");
        IntWInt reJava = cjA.test(javaL);
        System.out.println("lambda return param: " + reJava.call(20));

        IImpl imp = new IImpl();
        IntWInt i = b -> b + 3;
        IntWInt w = imp.test(i); // 13
        System.out.println("Java: IImpl with java lambda return func ret:" + w.call(12)); // 2
        IntWInt w2 = imp.test(display); // 12
        System.out.println("Java: IImpl with cj lambda return func ret:" + w.call(12)); // 2
        IntWInt c = cjA.goo(imp, 0);
        System.out.println("Java: Cj class A param IImpl return func ret:" + c.call(13)); // 3
        IntWInt c2 = cjA.goo(imp, 1);
        System.out.println("Java: Cj class A param IImpl default method doo return func ret:" + c2.call(13)); // 14 19

        ImplDefault imde = new ImplDefault();
        IntWInt c4 = cjA.goo(imde, 1);
        System.out.println("Java: Cj class A param IImpl java override default method doo return func ret:" + c4.call(13)); // 15 2

        A cja = new A(display); // IntWInt ctor. 44
        System.out.println("Java: call cj A static method, param cj lambda, ret func ret: " + A.staticFunc(display).call(10)); // 8 11
        System.out.println("Java: call cj A static method, param java lambda, ret func ret: " + A.staticFunc(javaL).call(10)); // 18 11

        B b = new B();
        System.out.println("Java: call open cj B, param cj lambda, ret func ret: " + b.testLambda(display).call(10)); // 12 12
        System.out.println("Java: call open cj B, param java lambda, ret func ret: " + b.testLambda(javaL).call(10)); // 30 12

        B b1 = new BChild();
        System.out.println("Java: call java BChild, param cj lambda, ret func ret: " + b1.testLambda(display).call(10)); // 4 40
        System.out.println("Java: call java BChild, param java lambda, ret func ret: " + b1.testLambda(javaL).call(10)); // 6 40
    }
}
