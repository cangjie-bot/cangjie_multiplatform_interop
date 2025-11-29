package cj;

import static cangjie.lang.LibraryLoader.loadLibrary;

@FunctionalInterface
public interface IntWInt {
    public int call(int a);

    public static IntWInt box(IntWInt lambda) {
        if (lambda instanceof IntWInt.BoxIntWInt ) {
            return lambda;
        } else {
            return new BoxIntWInt(lambda);
        }  
    }
    class BoxIntWInt implements IntWInt {
        static {
            loadLibrary("cj");
        }
        long cjLambdaId = 0;
        IntWInt javaLambda;

        private BoxIntWInt(IntWInt javaL) {
            javaLambda = javaL;
        }

        private BoxIntWInt(long cjId) {
            cjLambdaId = cjId;
        }

        @Override
        public int call(int a) {
            return this.javaLambda != null ? javaLambda.call(a) : intWIntImpl(cjLambdaId, a);
        }

        public void finalize() {
            if (cjLambdaId != 0) {
                deleteIntWIntCJObject(cjLambdaId);
            }
        }

        public static native int intWIntImpl(long cjLambdaId, int a);

        public static native void deleteIntWIntCJObject(long cjLambdaId);
    }
}
