// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#import <Foundation/Foundation.h>
#import "A.h"
#import "AA.h"

extern void CJImpl_ObjC_cjworld_cjGC();

void TestFooI32() {
 // @autoreleasepool { // uncomment to try with ARCOFF=true
    printf("\nObjC: TestFooI32 STARTED\n");

    A* aa = [[AA alloc] init];
    printf("ObjC: TestFooI32 got AA instance RC2: %ld\n", CFGetRetainCount((__bridge CFTypeRef)aa));

    printf("\nObjC: TestFooI32 execute aa.fooI32:\n");
    printf("ObjC: TestFooI32 got aa.fooI32 result (expected 42):%d\n", [aa fooI32]);

    A* pureA = [aa fooA];
    printf("ObjC: TestFooI32 got aa.fooA (pureA) instance RC1: %ld\n", CFGetRetainCount((__bridge CFTypeRef)pureA));

    printf("\nObjC: TestFooI32 execute pureA.fooI32:\n");
    printf("ObjC: TestFooI32 got pureA.fooI32 result (expected 32):%d\n", [pureA fooI32]);

    printf("\nObjC: TestFooI32 is finished, after return - the autoreleasepool (by ARC) is closed so 1 TransitionII is expected for aa, and simple deallocation for pureA:\n");
// [aa autorelease]; // uncomment to try with ARCOFF=true
// [pureA autorelease]; // uncomment to try with ARCOFF=true
// }
}

void TestCallVirtual() {
 // @autoreleasepool { // uncomment to try with ARCOFF=true
    printf("\nObjC: TestCallVirtual STARTED\n");

    A* aa = [[AA alloc] init];
    printf("ObjC: TestCallVirtual got AA instance RC2: %ld\n", CFGetRetainCount((__bridge CFTypeRef)aa));

    printf("\nObjC: TestCallVirtual execute aa.fooVirtual:\n");
    [aa fooVirtual];

    printf("\nObjC: TestCallVirtual execute aa.callFooVirtual:\n");
    [aa callFooVirtual];

    printf("\nObjC: TestCallVirtual execute pureA = aa.fooA:\n");
    A* pureA = [aa fooA];
    printf("ObjC: TestCallVirtual got aa.fooA (pureA) instance RC1: %ld\n", CFGetRetainCount((__bridge CFTypeRef)pureA));

    printf("\nObjC: TestCallVirtual execute pureA.fooVirtual (must not call super.fooVirtual):\n");
    [pureA fooVirtual];

    printf("\nObjC: TestCallVirtual execute pureA.callFooVirtual (must not call super.fooVirtual):\n");
    [pureA callFooVirtual];

    printf("\nObjC: TestCallVirtual execute pureA.paramA(aa):\n");
    [pureA paramA:aa];

    printf("\nObjC: TestCallVirtual is finished, after return - the autoreleasepool (by ARC) is closed so 1 TransitionII is expected for aa, and simple deallocation for pureA:\n");
// [aa autorelease]; // uncomment to try with ARCOFF=true
// [pureA autorelease]; // uncomment to try with ARCOFF=true
// }
}

int main(int argc, char** argv) {

    TestFooI32();

    printf("\nObjC: after TestFooI32 call cjGC, 1 TransitionIV is expected:\n");
    CJImpl_ObjC_cjworld_cjGC();
    printf("ObjC: cjGC COMPLETED\n");

    TestCallVirtual();

    printf("\nObjC: after TestCallVirtual call cjGC, 1 TransitionIV is expected:\n");
    CJImpl_ObjC_cjworld_cjGC();
    printf("ObjC: cjGC COMPLETED\n");

    return 0;
}
