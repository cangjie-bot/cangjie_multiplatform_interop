// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#import <Foundation/Foundation.h>

//@CJMirror
@protocol Animal
@required
- (void)Say;
- (void)Eat;
- (int32_t)Weight;
@end

// the default implementation of Animal interface
//@CJMirror
@interface AnimalImpl : NSObject <Animal>
- (void)Say;
- (void)Eat;
@end
