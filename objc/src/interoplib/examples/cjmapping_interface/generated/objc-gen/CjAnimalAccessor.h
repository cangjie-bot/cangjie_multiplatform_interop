// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#import <Foundation/Foundation.h>

#import "Animal.h"

// @CJMirror
@interface CjAnimalAccessor : NSObject
@property (readwrite) int64_t $registryId;
- (void)fooWithDefault:(id<Animal>) animal;
- (void)foo:(id<Animal>) animal;
@end
