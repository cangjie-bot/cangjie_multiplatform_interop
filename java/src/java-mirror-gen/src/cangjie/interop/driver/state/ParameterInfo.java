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

package cangjie.interop.driver.state;

import static cangjie.interop.Utils.syntheticParameterName;

import cangjie.interop.Utils;
import vendor.com.sun.tools.javac.code.Symbol;
import vendor.com.sun.tools.javac.tree.JCTree;

import java.util.ArrayList;
import java.util.List;

public final class ParameterInfo {

    private final String name;
    private final boolean isNameSynthetic;

    private ParameterInfo(String name, boolean isNameSynthetic) {
        this.name = name;
        this.isNameSynthetic = isNameSynthetic;
    }

    public static List<ParameterInfo> makeParameters(List<?> parameters) {
        final var size = parameters.size();
        final var sizeLength = Utils.stringLength(size);
        final var result = new ArrayList<ParameterInfo>(size);
        for (int i = 0; i < size; i++) {
            final var param = parameters.get(i);
            final String name;
            final boolean isNameSynthetic;
            if (param instanceof JCTree.JCVariableDecl decl) {
                name = Utils.addBackticksIfNeeded(decl.name);
                isNameSynthetic = false;
            } else if (param instanceof JCTree.JCIdent ident) {
                name = Utils.addBackticksIfNeeded(ident.name);
                isNameSynthetic = false;
            } else if (param instanceof Symbol.VarSymbol sym) {
                name = Utils.addBackticksIfNeeded(sym.name);
                isNameSynthetic = false;
            } else {
                name = syntheticParameterName(i, sizeLength);
                isNameSynthetic = true;
            }
            final var symbol = new ParameterInfo(name, isNameSynthetic);
            result.add(symbol);
        }
        return result;
    }

    public String name() {
        return name;
    }

    public boolean isNameSynthetic() {
        return isNameSynthetic;
    }
}
