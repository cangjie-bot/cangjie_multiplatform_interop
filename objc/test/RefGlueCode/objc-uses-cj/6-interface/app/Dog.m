// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#import "Dog.h"

@implementation Dog

- (void)Say {
    printf("ObjC: Dog.Say(); now call super.Say()\n");
    [super Say];
}

- (void)Eat {
    printf("ObjC: Dog.Eat(); now call super.Eat()\n");
    [super Eat];
}

- (int32_t)Weight {
    printf("ObjC: Dog.Weight()\n");
    return 10;
}

@end
