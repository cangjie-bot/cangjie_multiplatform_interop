// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#import <Foundation/Foundation.h>

// @CJMirror
@interface Expr : NSObject

@property (readwrite) int64_t $registryId;

+ (Expr*)Num:(int64_t)p1;
+ (Expr*)Add:(Expr*)_e1 :(Expr*)_e2;
+ (Expr*)Sub:(Expr*)_e1 :(Expr*)_e2;

@end

int64_t CJEval(Expr* a);
