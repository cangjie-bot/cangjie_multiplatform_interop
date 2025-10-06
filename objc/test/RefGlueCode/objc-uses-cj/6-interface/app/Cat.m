// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#import "Cat.h"

@implementation Cat

- (void)Say {
    printf("ObjC: Cat.Say()\n");
}

- (void)Eat {
    printf("ObjC: Cat.Eat()\n");
}

- (int32_t)Weight {
    printf("ObjC: Cat.Weight()\n");
    return 5;
}

@end
