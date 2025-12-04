package genericClass

public class GenericClass<T> where T <: ToString {

    private var value: T

    public GenericClass(v: T) {
        this.value = v
    }

    public func getValue() : T {
        println(this.value)
        return this.value
    }

    public func setValue(t: T) {
        value = t
    }
}
