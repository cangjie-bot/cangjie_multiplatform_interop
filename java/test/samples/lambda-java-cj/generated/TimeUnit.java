package cj;


import static cangjie.lang.LibraryLoader.loadLibrary;
import cangjie.lang.internal.$$NativeConstructorMarker;

public class TimeUnit {
    static {
        loadLibrary("cj");
    }

    long self;

    private TimeUnit (long id) {
        self = id;
    }

    public static TimeUnit Year(int p1) {
        return new TimeUnit(YearinitCJObjecti(p1));
    }

    private static native long YearinitCJObjecti(int p1);

    public IntWInt NumCalcMonth(IntWInt a) {
        return NumCalcMonthi(this.self, IntWInt.box(a));
    }

    private native IntWInt NumCalcMonthi(long self, IntWInt a);

    private native void deleteCJObject(long self);

    @Override
    public void finalize() {
        deleteCJObject(this.self);
    }
}
