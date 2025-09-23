// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#import <Foundation/Foundation.h>
#import <stddef.h>
#import "M.h"

@interface A : M

@property (readwrite) int64_t $registryId;
@property (readwrite, getter=getCjField, setter=setCjField:) int64_t cjField;
- (id)init;
- (int64_t)getCjField;
- (void)setCjField:(int64_t)value;
- (void)deleteCJObject:(int64_t)registryId;
- (void)dealloc;

@end
