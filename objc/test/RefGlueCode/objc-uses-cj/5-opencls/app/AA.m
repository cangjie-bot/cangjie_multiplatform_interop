// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#import "AA.h"

@implementation AA

- (id)init {
    if (self = [super init]) {
        printf("ObjC: AA.init()\n");
    }
    return self;
}

- (void)fooVirtual {
    printf("ObjC: AA.fooVirtual() self RC: %ld, now call super.fooVirtual:\n", CFGetRetainCount((__bridge CFTypeRef)self));
    [super fooVirtual];
}

- (int32_t)fooI32 {
    printf("ObjC: AA.fooI32() self RC: %ld\n", CFGetRetainCount((__bridge CFTypeRef)self));
    return 42;
}

- (void)paramA:(A*)a {
    printf("ObjC: AA.paramA(), now call super.paramA():\n");
    [super paramA:a];
}

@end
