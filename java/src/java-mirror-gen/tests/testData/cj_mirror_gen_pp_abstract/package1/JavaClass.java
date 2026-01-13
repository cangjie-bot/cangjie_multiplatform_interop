// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
package package1;

abstract class C1 {
    public abstract C1 newoo(C1 c1);

    protected abstract C2 newoo(C2 c2);
}

public class JavaClass extends C1 {
    public JavaClass() {
        System.out.println("JavaClass constructor");
    }

    public C1 newoo(C1 c1) {
        return new JavaClass();
    }

    protected C2 newoo(C2 c2) {
        return null;
    }
}