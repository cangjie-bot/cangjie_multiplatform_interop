// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#import "A.h"

@implementation A

@synthesize a;
@synthesize b;
@synthesize c;

- (id)init {
    if (self = [super init]) {
        NSLog(@"objc: A.init()");
        self.foo = -123;
        self.bar = [[M1 alloc] initWithAnswer: 2.71];
        self.b = [[M1 alloc] initWithAnswer: 321.321];
    }

    return self;
}

@end
