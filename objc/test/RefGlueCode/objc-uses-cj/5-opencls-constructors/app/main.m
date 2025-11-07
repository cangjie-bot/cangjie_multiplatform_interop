// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#import <Foundation/Foundation.h>
#import "A.h"
#import "AA.h"

extern void CJImpl_ObjC_cjworld_cjGC();

void TestFooI64() {
 // @autoreleasepool { // uncomment to try with ARCOFF=true
    printf("\nObjC: TestFooI64 STARTED");

    A* aL = [[A alloc] init :2];
    printf("\nObjC: TestFooI64 got A(2) instance RC2: %ld\n", CFGetRetainCount((__bridge CFTypeRef)aL));
    printf("\nObjC: TestFooI64 execute aL.fooI64:\n");
    printf("ObjC: TestFooI64 got aL.fooI64 result (expected 4):%lld\n", [aL fooI64]);

    A* aLL = [[A alloc] init :3 :4];
    printf("\nObjC: TestFooI64 got A(3, 4) instance RC2: %ld\n", CFGetRetainCount((__bridge CFTypeRef)aLL));
    printf("\nObjC: TestFooI64 execute aLL.fooI64:\n");
    printf("ObjC: TestFooI64 got aLL.fooI64 result (expected 7):%lld\n", [aLL fooI64]);

    A* aaL = [[AA alloc] init :2];
    printf("\nObjC: TestFooI64 got AA(2) instance RC2: %ld\n", CFGetRetainCount((__bridge CFTypeRef)aaL));
    printf("\nObjC: TestFooI64 execute aaL.fooI64:\n");
    printf("ObjC: TestFooI64 got aaL.fooI64 result (expected 42):%lld\n", [aaL fooI64]);

    A* aaLL = [[AA alloc] init :3 :4];
    printf("\nObjC: TestFooI64 got AA(3, 4) instance RC2: %ld\n", CFGetRetainCount((__bridge CFTypeRef)aaLL));
    printf("\nObjC: TestFooI64 execute aaLL.fooI64:\n");
    printf("ObjC: TestFooI64 got aaLL.fooI64 result (expected 42):%lld\n", [aaLL fooI64]);

    printf("\nObjC: TestFooI64 is finished, after return - the autoreleasepool (by ARC) is closed so 4 TransitionII are expected for aL, aLL, aaL and aaLL:\n");
// [aa autorelease]; // uncomment to try with ARCOFF=true
// [pureA autorelease]; // uncomment to try with ARCOFF=true
// }
}

int main(int argc, char** argv) {

    TestFooI64();

    printf("\nObjC: after TestFooI64 call cjGC, 4 TransitionIV are expected:\n");
    CJImpl_ObjC_cjworld_cjGC();
    printf("ObjC: cjGC COMPLETED\n");

    return 0;
}
