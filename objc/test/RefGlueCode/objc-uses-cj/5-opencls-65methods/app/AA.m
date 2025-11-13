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

- (void)foo0 {
    printf("ObjC: AA.foo0()\n");
}

- (void)foo42 {
    printf("ObjC: AA.foo42()\n");
}

- (void)foo63 {
    printf("ObjC: AA.foo63()\n");
}

- (void)foo64 {
    printf("ObjC: AA.foo64()\n");
}

@end
