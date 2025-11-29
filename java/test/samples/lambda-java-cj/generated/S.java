package cj;


import static cangjie.lang.LibraryLoader.loadLibrary;
import cangjie.lang.internal.$$NativeConstructorMarker;

final public class S {
    static {
        loadLibrary("cj");
    }

    long self;

    public S() {
        self = initCJObject();
    }

    private S($$NativeConstructorMarker __init__) {
    }

    public native long initCJObject();

    private S (long id, $$NativeConstructorMarker __init__) {
        self = id;
    }

    public IntWInt test(IntWInt a) {
        return testi(this.self, IntWInt.box(a));
    }

    private native IntWInt testi(long self, IntWInt a);

    private native void deleteCJObject(long self);

    @Override
    public void finalize() {
        deleteCJObject(this.self);
    }
}
