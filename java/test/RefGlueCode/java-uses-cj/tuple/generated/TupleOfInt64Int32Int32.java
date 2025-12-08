package UNNAMED;


import static cangjie.lang.LibraryLoader.loadLibrary;
import cangjie.lang.internal.$$NativeConstructorMarker;

final public class TupleOfInt64Int32Int32 {
    static {
        loadLibrary("UNNAMED");
    }

    long self;

    public TupleOfInt64Int32Int32(long item1, int item2, int item3) {
        self = initCJObjectlii(item1, item2, item3);
    }

    private TupleOfInt64Int32Int32(long item1, int item2, int item3, $$NativeConstructorMarker __init__) {
    }

    public native long initCJObjectlii(long item1, int item2, int item3);

    private TupleOfInt64Int32Int32 (long id, $$NativeConstructorMarker __init__) {
        self = id;
    }

    public long item1() {
        return item1(self);
    }
    public native long item1(long id);

    public int item2() {
        return item2(self);
    }
    public native int item2(long id);

    public int item3() {
        return item3(self);
    }
    public native int item3(long id);


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
