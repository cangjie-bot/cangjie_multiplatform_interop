// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#import "M.h"

double PI = 3.14;
double* pPI = &PI;

M* global;

int64_t primGlobal = 56;

@implementation M

- (void*) pointerToUnit {
    return (__bridge void*)self;
}
- (int64_t*) pointerToPrimitive {
    return &primGlobal;
}
- (double**) pointerToPointer {
    return &pPI;
}
- (M*__strong*) pointerToMirror {
    global = self;
    return &global;
}
- (M*__strong*) pointerToImpl {
    global = self;
    return &global;
}
- (double) baseline {
    return 3.16;
}
- (void) run {
    printf("M::run\n");
}

@end
