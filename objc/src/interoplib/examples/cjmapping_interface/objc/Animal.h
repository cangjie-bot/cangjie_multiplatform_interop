// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#import <Foundation/Foundation.h>

// This is a reference pure-objc implementation to be used only in origin-objc mode of examples-oc2cj.sh

@protocol Animal
@required
- (void)Say;
- (void)Eat;
- (int32_t)Weight;
@end

// the default implementation of Animal interface
@interface AnimalImpl : NSObject <Animal>
@end
