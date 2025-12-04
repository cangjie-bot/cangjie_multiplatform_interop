package cjworld

enum GenericEnum<T> where T <: ToString {
    | Red(T) | Green(T) | Blue(T)

    public func printValue() : Unit {
        let s = match (this) {
            case Red(n) => "red(${n})"
            case Green(n) => "green(${n})"
            case Blue(n) => "blue(${n})"
        }
        print("cangjie: ${s}\n", flush: true)
    }

    prop value: T {
        get() {
            match (this) {
                case Red(n) => n
                case Green(n) => n
                case Blue(n) => n
            }
        }
    }
}
