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

    public IntWInt test(IntWInt lambda) {
        if (lambda instanceof IntWInt.BoxIntWInt ) {
            IntWInt.BoxIntWInt boxLambda = (IntWInt.BoxIntWInt)lambda;
            if (boxLambda.cjLambdaId != 0) {
                return testImpl1(this.self, boxLambda.cjLambdaId);
            } else {
                return testImpl2(this.self, boxLambda);
            }
        } else {
            IntWInt.BoxIntWInt box = IntWInt.box(lambda);
            return testImpl2(this.self, box);
        }
    }

    public native IntWInt testImpl1(long self, long aId);
    public native IntWInt testImpl2(long self, IntWInt a);

    public native void deleteCJObject(long self);

    @Override
    public void finalize() {
        deleteCJObject(this.self);
    }
}
