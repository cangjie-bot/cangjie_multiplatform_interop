# Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
# This source file is part of the Cangjie project, licensed under Apache-2.0
# with Runtime Library Exception.
#
# See https://cangjie-lang.cn/pages/LICENSE for license information.

#import <Foundation/Foundation.h>
#import <stddef.h>
#import "Vector.h"

__attribute__((objc_subclassing_restricted))
@interface Vector : NSObject

@property (readonly) int32_t x;
@property (readonly) int32_t y;
- (id)init:(int32_t)x :(int32_t)y;
- (int64_t)dot:(Vector*)v;
- (Vector*)add:(Vector*)v;
+ (void)processPrimitive:(int32_t)intArg :(double)doubleArg :(bool)boolArg;

@end
