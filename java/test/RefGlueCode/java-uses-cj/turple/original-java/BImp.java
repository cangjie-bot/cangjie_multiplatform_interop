package UNNAMED;

public class BImp implements B {
    public void hoo(TurpleOfInt64Int32Int32 a) {
        System.out.println(a.item1());
        System.out.println(a.item2());
        System.out.println(a.item3());
    }

    public TurpleOfInt64Int32Int32 koo() {
        TurpleOfInt64Int32Int32 a = new TurpleOfInt64Int32Int32(666, 555, 444);
        return a;
    }
}
