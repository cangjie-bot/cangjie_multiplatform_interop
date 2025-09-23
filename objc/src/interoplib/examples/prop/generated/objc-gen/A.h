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
@property(readwrite, getter=getA, setter=setA:) int64_t a;
@property(readwrite, getter=getB, setter=setB:) M1* b;
@property(readonly, getter=getC) BOOL c;

- (id)init;
- (int64_t)getA;
- (void)setA:(int64_t)value;
- (M1*)getB;
- (void)setB:(M1*)value;
- (BOOL)getC;
- (void)deleteCJObject:(int64_t)registryId;
- (void)dealloc;

@end
