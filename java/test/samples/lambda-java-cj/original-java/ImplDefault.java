package j;
import cj.*;
public class ImplDefault implements I{
    @Override
    public IntWInt doo(IntWInt fun) {
        System.out.println("Java: ImplDefault test(): " + fun.call(11));
        IntWInt ret = b->b -11;
        return ret;
    }

    @Override
    public IntWInt test(IntWInt fun) {
        System.out.println("Java: IImpl test(): " + fun.call(10));
        IntWInt ret = b->b -10;
        return ret;
    }
}
