package cangjie.interop.util;

import java.util.Set;

public class NotNullAnnotations {
    public static final Set<String> NOT_NULL_ANNOTATIONS = Set.of(
            "android.support.annotation.NonNull",
            "androidx.annotation.NonNull",
            "androidx.annotation.RecentlyNonNull",
            "com.android.annotations.NonNull",
            "edu.umd.cs.findbugs.annotations.NonNull",
            "jakarta.annotation.Nonnull",
            "javax.annotation.Nonnull",
            "lombok.NonNull",
            "org.checkerframework.checker.nullness.compatqual.NonNullDecl",
            "org.checkerframework.checker.nullness.compatqual.NonNullType",
            "org.checkerframework.checker.nullness.qual.NonNull",
            "org.eclipse.jdt.annotation.NonNull",
            "org.jetbrains.annotations.NotNull",
            "org.jspecify.annotations.NonNull"
    );
}