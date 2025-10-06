// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#import <Foundation/Foundation.h>
#import "Animal.h"

// Inherits AnimalImpl so it can access default implementations (Cangjie code) via super)
@interface Dog : AnimalImpl
- (void)Say;
- (void)Eat;
- (int32_t)Weight;
@end
