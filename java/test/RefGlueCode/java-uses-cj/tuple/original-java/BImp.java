package UNNAMED;

public class BImp implements B {
    public void hoo(TupleOfInt64Int32Int32 a) {
        System.out.println(a.item1());
        System.out.println(a.item2());
        System.out.println(a.item3());
    }

    public TupleOfInt64Int32Int32 koo() {
        TupleOfInt64Int32Int32 a = new TupleOfInt64Int32Int32(666, 555, 444);
        return a;
    }
}
