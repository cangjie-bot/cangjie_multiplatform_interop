package cj;

import cangjie.interop.java.ClassAnalyser;
import cangjie.interop.java.MethodDef;
import static cangjie.lang.LibraryLoader.loadLibrary;
import cangjie.lang.internal.$$NativeConstructorMarker;

public class B {
    static {
        loadLibrary("ori");
    }

    private class Guard {
        @Override
        public void finalize() {
            B.this.detachCJObject();
        }
    }
    static final ClassAnalyser<B> classAnalyser =
        new ClassAnalyser<B>(B.class, new MethodDef [] {
            new MethodDef("testLambda",IntWInt.class /*different*/)
        });
    static final Object cjLock = new Object();
    private Guard guard = new Guard();
    final long overrideMask;
    long self;

    public B() {
        overrideMask = classAnalyser.getOverrideMask(getClass());
        self = initCJObject(overrideMask);
    }

    private B($$NativeConstructorMarker __init__) {
        overrideMask = 0;
    }

    public native long initCJObject(long overrideMask);

    private B (long id, $$NativeConstructorMarker __init__) {
        self = id;
        overrideMask = 0;
    }

    public IntWInt testLambda(IntWInt a) {
        return testLambdai(this.self, IntWInt.box(a));
        
    }

    public native IntWInt testLambdai(long self, IntWInt a);

    private void attachCJObject(long self) {
        guard = new Guard();
        this.self = self;
    }
    private void detachCJObject() {
        guard = null;
        synchronized (cjLock) {
            if (detachCJObject(self)) {
                self = -1;
            } else {
                guard = new Guard();
            }
            cjLock.notifyAll();
        }
    }
    private native boolean detachCJObject(long self);
}
