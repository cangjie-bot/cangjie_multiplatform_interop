package cangjie.interop.java;

public final class MethodDef {
    final String name;
    final Class<?> [] parameters;

    public MethodDef(String name, Class<?>... parameters) {
        this.name = name;
        this.parameters = parameters;
    }
}
