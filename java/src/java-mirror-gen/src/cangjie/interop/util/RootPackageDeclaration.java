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

package cangjie.interop.util;

import java.util.Arrays;

public final class RootPackageDeclaration {
    private final boolean isWildcard;
    private final String[] parts;
    private final String[] partsNoWildcard;

    public RootPackageDeclaration(String line) {
        parts = line.split("\\.");
        isWildcard = parts[parts.length - 1].equals("*");
        partsNoWildcard = isWildcard ? Arrays.copyOf(parts, parts.length - 1) : parts;
    }

    @Override
    public int hashCode() {
        return Arrays.hashCode(parts);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (o == null || getClass() != o.getClass()) {
            return false;
        }
        RootPackageDeclaration that = (RootPackageDeclaration) o;
        return Arrays.equals(parts, that.parts);
    }

    public boolean matches(String[] classNameParts) {
        return Arrays.equals(classNameParts, 0, !isWildcard ? (classNameParts.length - 1) : partsNoWildcard.length,
                partsNoWildcard, 0, partsNoWildcard.length);
    }
}
