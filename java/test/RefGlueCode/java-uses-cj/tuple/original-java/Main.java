package UNNAMED;

public class Main {

    public static void main(String[] args) {
        A aImp = new A();
        TupleOfInt64Int32Int32 tuple1 = aImp.goo(987, 654, 321);
        TupleOfInt64Int32Int32 tuple2 = new TupleOfInt64Int32Int32(123, 456, 789);
        aImp.foo(tuple2);
        System.out.println(tuple1.item1());
        System.out.println(tuple1.item2());
        System.out.println(tuple1.item3());
        C cImp = new C();
        BImp bImp = new BImp();
        cImp.foo(bImp);
    }
}