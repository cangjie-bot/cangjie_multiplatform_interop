package cj;


import static cangjie.lang.LibraryLoader.loadLibrary;

public interface I {
    public IntWInt test(IntWInt fun);

    public default IntWInt doo(IntWInt fun) {
        return I_fwd.doo_default_impli(this, fun);
    }
}
final class I_fwd {
    private I_fwd() {}
    static {
        loadLibrary("cj");
    }

    public static native IntWInt doo_default_impli(I selfobj, IntWInt fun);
}
