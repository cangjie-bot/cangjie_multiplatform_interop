package j;
import cj.*;

public class BChild extends B {
    @Override
    public IntWInt testLambda(IntWInt a) {
        System.out.println("Java: at java BChild, fun param ret: " + a.call(2));
        IntWInt ret = c -> c * 4;
        return ret;
    }
}
