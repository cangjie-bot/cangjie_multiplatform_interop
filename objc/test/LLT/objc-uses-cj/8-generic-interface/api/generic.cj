//package genericInterface
package cjworld

interface GenericInterface<T> {

    public func printValue<T>(t: T) : Unit where T <: ToString {
        print("cangjie: ${t}\n", flush: true)
    }

    public func getValue() : T

    public func setValue(t: T) : Unit
}
