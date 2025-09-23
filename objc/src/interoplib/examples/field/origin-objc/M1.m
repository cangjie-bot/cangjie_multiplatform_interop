// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#import "M1.h"

@implementation M1

- (id)initWithAnswer:(double)answer {
    if (self = [super init]) {
        NSLog(@"objc: M1 initWithAnswer(%lf)", answer);
        self->answer = answer;
    }

    return self;
}

@end
