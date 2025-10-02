# Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
# This source file is part of the Cangjie project, licensed under Apache-2.0
# with Runtime Library Exception.
#
# See https://cangjie-lang.cn/pages/LICENSE for license information.

#import "Vector.h"
#import <dlfcn.h>

@implementation Vector

- (id)init:(int32_t)x :(int32_t)y {
    if (self = [super init]) {
        _x = x;
        _y = y;
    }
    return self;
}

- (int64_t)dot: (Vector*)v {
    int64_t res = self.x * v.x + self.y * v.y;
    printf("Hello from dot (%d, %d) . (%d, %d) = %lld\n", self.x, self.y, v.x, v.y, res);
    return res;
}

- (Vector*)add: (Vector*)v {
    Vector* res = [[Vector alloc] init:(self.x + v.x) :(self.y + v.y)];
    printf("Hello from add (%d, %d) + (%d, %d) new Vector =  (%d, %d)\n", self.x, self.y, v.x, v.y, res.x, res.y);
    return res;
}

+ (void)processPrimitive:(int32_t)intArg :(double)doubleArg :(bool)boolArg {
    printf("Hello from static processPrimitive: %d, %g + %s\n", intArg * 2, doubleArg + 1.0, !boolArg ? "true" : "false");
}

@end
