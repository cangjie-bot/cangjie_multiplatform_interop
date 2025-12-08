package UNNAMED;


import static cangjie.lang.LibraryLoader.loadLibrary;
import cangjie.lang.internal.$$NativeConstructorMarker;

public class C {
    static {
        loadLibrary("UNNAMED");
    }

    long self;

    public C() {
        self = initCJObject();
    }

    private C($$NativeConstructorMarker __init__) {
    }

    public native long initCJObject();

    private C (long id, $$NativeConstructorMarker __init__) {
        self = id;
    }

    public void foo(B b) {
        fooCN7UNNAMED1BE(this.self, b);
    }

    public native void fooCN7UNNAMED1BE(long self, B b);

    @Override
    public boolean equals(Object obj) {
        throw new UnsupportedOperationException("equals is not supported for java proxy object.");
    }

    @Override
    public int hashCode() {
        throw new UnsupportedOperationException("hashCode is not supported for java proxy object.");
    }

    @Override
    public String toString() {
        throw new UnsupportedOperationException("toString is not supported for java proxy object.");
    }

    public native void deleteCJObject(long self);

    @Override
    public void finalize() {
        deleteCJObject(this.self);
    }
}
