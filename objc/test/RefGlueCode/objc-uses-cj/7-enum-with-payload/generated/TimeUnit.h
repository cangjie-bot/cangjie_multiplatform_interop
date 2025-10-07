// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#import <Foundation/Foundation.h>

// @CJMirror
@interface TimeUnit : NSObject

@property (readwrite) int64_t $registryId;

+ (TimeUnit*)Month;
+ (TimeUnit*)Year;
+ (TimeUnit*)Month:(int64_t)p1;
+ (TimeUnit*)Year:(int64_t)p1;
+ (TimeUnit*)TenYear;
- (int64_t)CalcMonth;

@end

void CJPrintMonthCount(TimeUnit* a);
