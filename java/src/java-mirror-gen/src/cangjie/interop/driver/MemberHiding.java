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

import static vendor.com.sun.tools.javac.code.Kinds.Kind.MTH;

import vendor.com.sun.tools.javac.code.Symbol;
import vendor.com.sun.tools.javac.code.Types;
import vendor.com.sun.tools.javac.util.Context;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashSet;
import java.util.List;

public final class MemberHiding {
    private final Types types;
    private final OverrideChains overrideChains;

    private MemberHiding(Context context) {
        context.put(MemberHiding.class, this);
        types = Types.instance(context);
        overrideChains = OverrideChains.instance(context);
    }

    public static MemberHiding instance(Context context) {
        final var instance = context.get(MemberHiding.class);
        return instance == null ? new MemberHiding(context) : instance;
    }

    private List<Symbol> findHiddenMembers(Symbol child, Symbol.TypeSymbol ownerType) {
        final var childType = types.erasure(child.type);

        List<Symbol> result = null;
        for (final var symbol : ownerType.members().getSymbolsByName(child.name)) {
            if (symbol.isConstructor()) {
                continue;
            }

            if (child.kind == MTH && symbol.kind == MTH) {
                if (overrideChains.overridesWithFilter(child, symbol)) {
                    continue;
                }
                if (!types.hasSameArgs(childType, types.erasure(symbol.type))) {
                    continue;
                }
            }

            if (result == null) {
                result = new ArrayList<>();
            }

            result.add(symbol);
        }

        return result != null ? result : List.of();
    }

    public Collection<Symbol> collectHiddenSymbols(Symbol child) {
        final var result = new HashSet<Symbol>();

        final var startClass = child.enclClass();
        for (final var type : types.closure(startClass.type)) {
            final var tsym = type.tsym;
            if (tsym == startClass) {
                continue;
            }

            result.addAll(findHiddenMembers(child, tsym));
        }

        return result;
    }
}
