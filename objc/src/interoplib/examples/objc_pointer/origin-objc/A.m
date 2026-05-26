// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#import "A.h"

#define assert(a, b) (((a) == (b))? (void)1 : exit(-15))

@implementation A

- (id)init {
    if (self = [super init]) {}

    return self;
}

- (double) baseline {
    return -1.0;
}

- (void) run {
    void* pUnit = [self pointerToUnit];
    //assert(*pUnit, ());
    int64_t pPrim = [self pointerToPrimitive];
    assert(*pPrim, 56);
    *pPrim = 13;
    assert(*(pPrim), 13);
    double** pPointer = pointerToPointer();
    assert(**(pPointer), 3.14);
    **(pPointer) = 1.0;
    assert(**(pPointer), 1.0);
    M** pMirror = pointerToMirror();
    assert([*pMirror baseline], -1.0);
    *pMirror = [[M alloc] init];
    assert([*pMirror baseline], 3.16);
    A** pImpl = pointerToImpl();
    assert([*pImpl baseline], -1.0);
}

@end
