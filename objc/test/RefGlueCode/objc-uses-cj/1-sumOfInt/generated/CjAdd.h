// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#import <Foundation/Foundation.h>

int32_t globalAddII(int32_t a, int32_t b);

@interface CjAdd : NSObject

+ (int32_t)staticAddII:(int32_t)a :(int32_t)b;

@end
