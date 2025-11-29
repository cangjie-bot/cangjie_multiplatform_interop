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

    public A(IntWInt a) {
        self = initCJObjecti(IntWInt.box(a));
    }

    private native long initCJObject();

    private native long initCJObjecti(IntWInt a);

    public IntWInt test(IntWInt lambda) {
        return testImpl(this.self, IntWInt.box(lambda));
    }

    public IntWInt getCjLambda() {
        return getCjLambda(this.self);
    }

    public IntWInt goo(I i, int a) {
        return gooCN2cj1IE(this.self, i, a);
    }

    public static IntWInt staticFunc(IntWInt a) {
        return staticFunci(IntWInt.box(a));
    }

    private static native IntWInt staticFunci(IntWInt a);

    private native IntWInt getCjLambda(long self);

    private native IntWInt gooCN2cj1IE(long self, I i, int a);

    private native IntWInt testImpl(long self, IntWInt a);

    private native void deleteCJObject(long self);

    @Override
    public void finalize() {
        deleteCJObject(this.self);
    }
}
