// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#import <Foundation/Foundation.h>

NSString* globalConcat(NSString* a, NSString* b);

@interface CjConcat : NSObject

+ (NSString*)staticConcat:(NSString*)a :(NSString*)b;

@end
