// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#import "AA.h"

@implementation AA

- (id)init :(int64_t)x {
    if (self = [super init:x]) {
        printf("ObjC: AA.init(%lld)\n", x);
    }
    return self;
}

- (id)init :(int64_t)x :(int64_t)y {
    if (self = [super init:x:y]) {
        printf("ObjC: AA.init(%lld, %lld)\n", x, y);
    }
    return self;
}

- (int64_t)fooI64 {
    return 42;
}

@end
