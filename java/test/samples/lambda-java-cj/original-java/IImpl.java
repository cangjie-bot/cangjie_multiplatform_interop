package j;
import cj.*;
public class IImpl implements I{
    @Override
    public IntWInt test(IntWInt fun) {
        System.out.println("Java: IImpl test(): " + fun.call(10));
        IntWInt ret = b->b -10;
        return ret;
    }
}
