package cj;


import static cangjie.lang.LibraryLoader.loadLibrary;

public class A {
    static {
        loadLibrary("cj");
    }

    long self;

    public A() {
        self = initCJObject();
    }

    public native long initCJObject();

    public int test(IntWInt lambda) {
        if (lambda instanceof IntWInt.Display) {
            IntWInt.Display display = (IntWInt.Display)lambda;
            return testImpl1(this.self, display.cjLambdaId);
        } else {
            IntWInt.BoxIntWInt box = IntWInt.box(lambda);
            return testImpl2(this.self, box);
        }
    }

    public native int testImpl1(long self, long aId);
    public native int testImpl2(long self, IntWInt a);

    public native void deleteCJObject(long self);

    @Override
    public void finalize() {
        deleteCJObject(this.self);
    }
}
