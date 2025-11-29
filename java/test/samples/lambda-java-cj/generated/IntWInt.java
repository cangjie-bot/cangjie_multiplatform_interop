package cj;

import static cangjie.lang.LibraryLoader.loadLibrary;

@FunctionalInterface
public interface IntWInt {
    public int call(int a);

    public static BoxIntWInt box(IntWInt lambda) {
        return new BoxIntWInt(lambda);
    }

    static class Display extends BoxIntWInt {

        public Display() {
            cjLambdaId = initDisplayObject();
        }

        public static native long initDisplayObject();
    }

    class BoxIntWInt implements IntWInt {
        static {
            loadLibrary("cj");
        }
        long cjLambdaId = 0;
        IntWInt javaLambda;

        BoxIntWInt() {}
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
            deleteIntWIntCJObject(cjLambdaId);
        }

        public static native int intWIntImpl(long cjLambdaId, int a);

        public static native void deleteIntWIntCJObject(long cjLambdaId);
    }
}
