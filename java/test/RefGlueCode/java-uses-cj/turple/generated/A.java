package UNNAMED;


import static cangjie.lang.LibraryLoader.loadLibrary;
import cangjie.lang.internal.$$NativeConstructorMarker;

public class A {
    static {
        loadLibrary("UNNAMED");
    }

    long self;

    public A() {
        self = initCJObject();
    }

    private A($$NativeConstructorMarker __init__) {
    }

    public native long initCJObject();

    private A (long id, $$NativeConstructorMarker __init__) {
        self = id;
    }

    public void foo(TurpleOfInt64Int32Int32 a) {
        fooRN7UNNAMED23TurpleOfInt64Int32Int32E(this.self, a.self);
    }

    public native void fooRN7UNNAMED23TurpleOfInt64Int32Int32E(long self, long aId);

    public TurpleOfInt64Int32Int32 goo(long a, int b, int c) {
        return goolii(this.self, a, b, c);
    }

    public native TurpleOfInt64Int32Int32 goolii(long self, long a, int b, int c);

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
