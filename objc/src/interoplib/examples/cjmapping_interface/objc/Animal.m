// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#import "Animal.h"

// This is a reference pure-objc implementation to be used only in origin-objc mode of examples-oc2cj.sh

// the default implementation of Animal interface
@implementation AnimalImpl

- (id)init {
    if (self = [super init]) {
        printf("ObjC: AnimalImpl init()\n");
    }

    return self;
}

- (void)Say {
    printf("ObjC: AnimalImpl.Say()\n");
}

- (void)Eat {
    printf("ObjC: AnimalImpl.Eat() ENTER\n");
    [self Say];
    printf("ObjC: AnimalImpl.Eat() EXIT\n");
}

@end
