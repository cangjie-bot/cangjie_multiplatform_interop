// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#import "M.h"

@implementation M

- (id)init {
    if (self = [super init]) {
        NSLog(@"objc: M init()");
    }

    return self;
}

- (int64_t)goo {
    NSLog(@"objc: M goo()");
    return 42;
}

@end
