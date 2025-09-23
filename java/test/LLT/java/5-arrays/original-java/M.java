// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

public class M {

    protected int[] array;
    protected boolean shouldLog;

    M(int[] array) {
        this.array = array;
        this.shouldLog = false;
    }

    protected static String collectArray(int[] array) {
        StringBuilder buffer = new StringBuilder();
        buffer.append("[");

        for (int i = 0; i < array.length; i++) {
            buffer.append(array[i]);
            if (i != array.length - 1) {
                buffer.append(", ");
            }
        }
        buffer.append("]");
        
        return buffer.toString();
    }

    protected void transferElement(int[] dst, int dstIndex, int[] src, int srcIndex) {
        dst[dstIndex] = src[srcIndex];
    }

    protected static boolean isInOrder(int a, int b) {
        return a <= b;
    }

    protected static boolean isSorted(int[] array) {
        for (int i = 0; i < array.length - 1; i++) {
            if (!isInOrder(array[i], array[i + 1])) {
                return false;
            }
        }

        return true;
    }

    public void goo() {
        StringBuilder buffer = new StringBuilder();
        buffer.append("Hello from Java M goo(). This object contains array "); 
        if (shouldLog) {
            buffer.append(collectArray(array));
        } else {
            buffer.append("{ LOGGING DISABLED }");
        }

        System.out.println(buffer.toString());
    }
}
