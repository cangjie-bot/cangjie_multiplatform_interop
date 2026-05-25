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
    }

    return self;
}

- (M1*)fooBar {
    int32_t res0 = [super goo];
    NSLog(@"objc: get int32_t res from objc: %d", res0);

    M1* res1 = [super foo];
    NSLog(@"objc: get object from objc with result: %s", [res1 fooBar] ? "YES" : "NO");

    return res1;
}

@end
