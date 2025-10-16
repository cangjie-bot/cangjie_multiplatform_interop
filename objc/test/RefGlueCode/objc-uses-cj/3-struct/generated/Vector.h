// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#import <Foundation/Foundation.h>

__attribute__((objc_subclassing_restricted))
@interface Vector : NSObject

@property (readwrite) int64_t $registryId;
@property (readonly, getter=getX) int32_t x;
@property (readonly, getter=getY) int32_t y;
- (id)init:(int32_t)x :(int32_t)y;
- (void)dealloc;
- (int32_t)getX;
- (int32_t)getY;
- (int64_t)dot:(Vector*)v;

@end
