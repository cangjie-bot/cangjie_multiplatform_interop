// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#import "M.h"

@implementation M

@synthesize foo;
@synthesize bar;

- (id)init {
    if (self = [super init]) {
        NSLog(@"objc: M init()");

        self.foo = 100500;
        self.bar = [[M1 alloc] initWithAnswer: 100500.100500];
    }

    return self;
}

@end
