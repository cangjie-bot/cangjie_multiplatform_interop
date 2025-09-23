// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#import "A.h"

@implementation A

- (id)init {
    if (self = [super init]) {
        NSLog(@"objc: A.init()");

        M* m = [[M alloc] init];
    }

    return self;
}

- (BOOL)boo {
    NSLog(@"objc: A.boo: M.init()");
    M* m = [[M alloc] init];
    NSLog(@"objc: A.boo: M1.init()");
    M1* m1 = [[M1 alloc] init];

    return [m goo] < [m1 goo];
}

@end
