package UNNAMED;

public class Main {

    public static void main(String[] args) {
        A aImp = new A();
        TurpleOfInt64Int32Int32 turple1 = aImp.goo(987, 654, 321);
        TurpleOfInt64Int32Int32 turple2 = new TurpleOfInt64Int32Int32(123, 456, 789);
        aImp.foo(turple2);
        System.out.println(turple1.item1());
        System.out.println(turple1.item2());
        System.out.println(turple1.item3());
        C cImp = new C();
        BImp bImp = new BImp();
        cImp.foo(bImp);
    }
}