/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
 *
 * This code is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License version 2 only, as
 * published by the Free Software Foundation. Huawei designates this
 * particular file as subject to the "Classpath" exception as provided
 * by Huawei in the LICENSE file that accompanied this code.
 *
 * This code is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
 * version 2 for more details (a copy is included in the LICENSE file that
 * accompanied this code).
 *
 * You should have received a copy of the GNU General Public License version
 * 2 along with this work; if not, write to the Free Software Foundation,
 * Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
 *
 */

package cangjie.interop.driver;

import static cangjie.interop.Utils.addBackticksIfNeeded;
import static cangjie.interop.Utils.addUnderscoresIfNeeded;
import static cangjie.interop.Utils.getFlatNameWithoutPackage;
import static vendor.com.sun.tools.javac.code.Flags.EFFECTIVELY_FINAL;
import static vendor.com.sun.tools.javac.code.Flags.FINAL;
import static vendor.com.sun.tools.javac.code.Kinds.Kind.TYP;
import static vendor.com.sun.tools.javac.code.Kinds.KindSelector.VAL_MTH;
import static vendor.com.sun.tools.javac.code.TypeTag.TYPEVAR;

import cangjie.interop.cangjie.QualifiedName;
import cangjie.interop.cangjie.tree.CJTree;
import cangjie.interop.cangjie.tree.Scanner;
import vendor.com.sun.tools.javac.code.Symbol;
import vendor.com.sun.tools.javac.code.Symtab;
import vendor.com.sun.tools.javac.code.Type;
import vendor.com.sun.tools.javac.code.Types;
import vendor.com.sun.tools.javac.tree.JCTree;
import vendor.com.sun.tools.javac.tree.TreeInfo;
import vendor.com.sun.tools.javac.util.Convert;
import vendor.com.sun.tools.javac.util.Name;
import vendor.com.sun.tools.javac.util.Names;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashSet;
import java.util.Map;
import java.util.Optional;
import java.util.Set;

public final class VisitorUtils {
    private static Symtab symtab;
    private static Names names;
    private static final Set<Symbol.ClassSymbol> symbolsToMangle = new HashSet<>();
    private static Map<String, String> importsMap = new HashMap<>();

    private VisitorUtils() {}

    public static Set<Symbol.ClassSymbol> getSymbolsToMangle() {
        return symbolsToMangle;
    }

    public static void addSymbolsToMangle(Symbol.ClassSymbol sym) {
        symbolsToMangle.add(sym);
    }

    public static void setSymtab(Symtab symtab) {
        VisitorUtils.symtab = symtab;
    }

    public static void setNames(Names names) {
        VisitorUtils.names = names;
    }

    public static void setImportsMap(Map<String, String> importsMap) {
        VisitorUtils.importsMap = importsMap;
    }

    static boolean isVarFinal(JCTree tree) {
        return isVarFinal(TreeInfo.symbolFor(tree));
    }

    static boolean isVarFinal(Symbol symbol) {
        if (symbol instanceof Symbol.VarSymbol var) {
            // TODO: option to disable treating effectively final variables as final?
            return (var.flags() & (FINAL | EFFECTIVELY_FINAL)) != 0;
        }
        return false;
    }

    public static CJTree.Expression defaultValueForType(Type type) {
        return switch (type.getKind()) {
            case BOOLEAN -> CJTree.Expression.Literal.bool(false);
            case BYTE, SHORT, INT, LONG, CHAR -> new CJTree.Expression.Literal.Numeric(0, "0");
            case FLOAT, DOUBLE -> new CJTree.Expression.Literal.Numeric(0.0, "0.0");
            default -> defaultValueForType();
        };
    }

    public static CJTree.Expression.Name.SimpleName.IdentifierName defaultValueForType() {
        return new CJTree.Expression.Name.SimpleName.IdentifierName("None");
    }

    public static CJTree.Expression.Name.SimpleName.IdentifierName defaultValueForToString() {
        return new CJTree.Expression.Name.SimpleName.IdentifierName("JString()");
    }

    public static CJTree.Expression.Name name(Type type) {
        CJTree.Expression.Name result;
        if (type.isPrimitiveOrVoid()) {
            final var ident =
                    switch (type.getKind()) {
                        case BOOLEAN -> "Bool";
                        case BYTE -> "Int8";
                        case SHORT -> "Int16";
                        case INT -> "Int32";
                        case LONG -> "Int64";
                        case CHAR -> "UInt16";
                        case FLOAT -> "Float32";
                        case DOUBLE -> "Float64";
                        case VOID -> "Unit";
                        default -> null;
                    };
            if (ident == null) {
                throw new RuntimeException("Unsupported type");
            }
            return new CJTree.Expression.Name.SimpleName.IdentifierName(ident);
        }

        if (type instanceof Type.ArrayType arrayType) {
            var elemType = arrayType.getComponentType();
            final var translatedElemType = name(elemType);
            final var ident = new CJTree.Expression.Name.SimpleName.GenericName("JArray");
            ident.arguments.add(translatedElemType);
            result = new CJTree.Expression.Name.SimpleName.OptionName(ident);

            if (translatedElemType.importNames() instanceof QualifiedName qualifiedName) {
                result.addImport(qualifiedName);
            }
            final Optional<QualifiedName> clazz = QualifiedName.parse("java.lang.JArray");
            clazz.ifPresent(result::addImport);
            return result;
        }

        if (type.tsym instanceof Symbol.ClassSymbol typeSymbol) {
            String identifier;
            String qualifiedName;
            if (type.tsym == symtab.objectType.tsym) {
                identifier = "JObject";
                qualifiedName = "java.lang." + identifier;
            } else if (type.tsym == symtab.stringType.tsym) {
                identifier = "JString";
                qualifiedName = "java.lang." + identifier;
            } else {
                identifier = symbolsToMangle.contains(typeSymbol)
                        ? mangleClassName(typeSymbol)
                        : addBackticksIfNeeded(getFlatNameWithoutPackage(typeSymbol));
                qualifiedName = addBackticksIfNeeded(typeSymbol.flatName());

                final var nameFromMap = importsMap.get(typeSymbol.flatName().toString());
                if (nameFromMap != null) {
                    identifier = addUnderscoresIfNeeded(Convert.shortName(names.fromString(nameFromMap)));
                    qualifiedName = nameFromMap;
                }
            }

            CJTree.Expression.Name.SimpleName ident;

            ident = new CJTree.Expression.Name.SimpleName.IdentifierName(identifier);
            final Optional<QualifiedName> optClazz = QualifiedName.parse(qualifiedName);
            if (optClazz.isPresent()) {
                final QualifiedName clazz = optClazz.get();
                if (clazz.fullPackageName() != null) {
                    ident.addImport(clazz);
                }
            }

            return new CJTree.Expression.Name.SimpleName.OptionName(ident);
        }

        return null;
    }

    public static void collectImports(CJTree.CompilationUnit unit, QualifiedName packageName) {
        final var currentImportedNames = new LinkedHashSet<QualifiedName>();

        new Scanner() {
            @Override
            protected void scan(CJTree tree) {
                if (tree instanceof CJTree.Expression expression) {
                    final var importName = expression.importNames();
                    if (importName instanceof Collection<?> collection) {
                        for (final var o : collection) {
                            registerImport(o);
                        }
                    } else if (importName != null) {
                        registerImport(importName);
                    }
                }
                super.scan(tree);
            }

            private void registerImport(Object importName) {
                if (importName instanceof QualifiedName name) {
                    registerImport(name);
                }
            }

            private void registerImport(QualifiedName name) {
                currentImportedNames.add(name);
            }
        }.scan(unit);

        final var filtered = new ArrayList<QualifiedName>();
        for (final var name : currentImportedNames) {
            if (!name.requiresImport() || name.isFromPackage(packageName)) {
                continue;
            }
            filtered.add(name);
        }
        filtered.sort(Comparator.comparing(QualifiedName::toString));
        unit.imports.addAll(filtered);
    }

    public static Symbol.TypeSymbol erasureType(Type type, Types types) {
        var result = type;
        while (result instanceof Type.ArrayType arrayType) {
            result = arrayType.elemtype;
        }
        return types.erasure(result).tsym;
    }

    public static CJTree.Expression createJavaMirrorAnnotation() {
        return new CJTree.Expression.Name.SimpleName.IdentifierName("JavaMirror");
    }

    public static String mangleClassName(Symbol.ClassSymbol typeSymbol) {
        return addUnderscoresIfNeeded(typeSymbol.flatName()).replace('.', '_');
    }

    public static CJTree.Declaration.Annotation foreignNameAnnotationGen(Name originalName) {
        final var foreignNameAnnotation =
                new CJTree.Expression.Name.SimpleName.IdentifierName("ForeignName");
        final var annotation = new CJTree.Declaration.Annotation(foreignNameAnnotation);
        final var argument = new CJTree.Expression.Literal.String(originalName.toString());
        annotation.argumentList.add(argument);
        return annotation;
    }

    public static CJTree.Declaration.Annotation defaultMethodAnnotationGen() {
        final var defaultMethodAnnotation = new CJTree.Expression.Name.SimpleName.IdentifierName("JavaHasDefault");
        return new CJTree.Declaration.Annotation(defaultMethodAnnotation);
    }

    public static Name formTypeName(Symbol.TypeSymbol type) {
        Symbol symbol = type;
        Name result = null;
        char sep = 0;
        do {
            result = prependTypeNameComponent(symbol, sep, result);

            final var owner = symbol.owner;
            if (owner == null || owner.kind.matches(VAL_MTH) || (owner.kind == TYP && owner.type.hasTag(TYPEVAR))) {
                return result;
            }

            sep = owner.kind == TYP ? '$' : '.';
            symbol = owner;
        } while (true);
    }

    private static Name prependTypeNameComponent(Symbol symbol, char sep, Name suffix) {
        var name = symbol.name;
        if (name.lastIndexOf((byte) '$') != -1) {
            name = name.table.fromString(name.toString().replace("$", "\\$"));
        }

        if (name != null && name != name.table.names.empty) {
            return suffix != null ? name.append(sep, suffix) : name;
        }

        return suffix;
    }
}
