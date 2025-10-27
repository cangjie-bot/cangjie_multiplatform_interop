// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#import <dlfcn.h>
#import "CjAnimalAccessor.h"

// This is a reference pure-objc implementation to be used only in origin-objc mode of examples-oc2cj.sh

@implementation CjAnimalAccessor

- (void)fooWithDefault:(id<Animal>) animal {
    printf("ObjC: CjAnimalAccessor.fooWithDefault()\n");
    [animal Say];
}

- (void)foo:(id<Animal>) animal {
    int32_t w = [animal Weight];
    printf("ObjC: CjAnimalAccessor.foo got Weight == %d\n", w);
}

@end
