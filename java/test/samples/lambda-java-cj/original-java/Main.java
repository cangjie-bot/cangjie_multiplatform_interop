import cj.*;
public class Main {
    public static void main(String[] args) {
        IntWInt display = new IntWInt.Display();
        System.out.println("cangjie lambda:" + display.call(10));
        A cjA = new A();
        System.out.print("cangjie ");
        IntWInt reDis = cjA.test(display);
        System.out.println("lambda return param: " + reDis.call(10));

        IntWInt javaL = a -> a*3;
        System.out.print("java ");
        IntWInt reJava = cjA.test(javaL);
        System.out.println("lambda return param: " + reJava.call(20));
    }
}
