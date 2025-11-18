// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#import <Foundation/Foundation.h>
#import "A.h"
#import "AA.h"

extern void Interoptest_cjworld_GC(); // provided by _common/interoptest.cj

void TestFoo() {
#if !__has_feature(objc_arc)
@autoreleasepool {
#endif
    printf("\nObjC: TestFoo STARTED\n");

    A* aa = [[AA alloc] init];

    printf("\nObjC: TestFoo execute aa.foo0:\n");
    [aa foo0];

    printf("\nObjC: TestFoo execute aa.foo42:\n");
    [aa foo42];

    printf("\nObjC: TestFoo execute aa.foo62 (not overridden):\n");
    [aa foo62];

    printf("\nObjC: TestFoo execute aa.foo63:\n");
    [aa foo63];

    printf("\nObjC: TestFoo execute aa.foo64:\n");
    [aa foo64];

    printf("\nObjC: TestFoo execute aa.foo65:\n");
    [aa foo65];

    printf("\nObjC: TestFoo execute aa.foo1 to test aa from CJ side:\n");
    [aa foo1];

    printf("\nObjC: TestFoo is finished, after return - the autoreleasepool (by ARC) is closed so 1 TransitionII ia expected for aa:\n");
#if !__has_feature(objc_arc)
    [aa autorelease];
}
#endif
}

int main(int argc, char** argv) {

    TestFoo();

    printf("\nObjC: after TestFoo call cjGC, 1 TransitionIV is expected:\n");
    Interoptest_cjworld_GC();
    printf("ObjC: cjGC COMPLETED\n");

    return 0;
}
