// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#import <Foundation/Foundation.h>
#import "NonOpen.h"
#import "RestrictedHeir.h"

int main(int argc, char** argv) {
    @autoreleasepool {
        printf("ObjC: main creates instance and calls [nonOpen Foo] implemented in Cangjie:\n");
        NonOpen* nonOpen = [[NonOpen alloc] init];
        [nonOpen Foo];

        printf("\nObjC: main calls [restrictedHeir CallParentFoo] that should call super.Foo implemented in Cangjie:\n");
        RestrictedHeir* heir = [[RestrictedHeir alloc] init];
        [heir CallParentFoo];
    }
    return 0;
}
