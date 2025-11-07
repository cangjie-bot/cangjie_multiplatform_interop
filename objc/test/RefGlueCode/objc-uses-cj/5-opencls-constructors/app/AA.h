// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#import <Foundation/Foundation.h>
#import <stddef.h>
#import "A.h"

@interface AA : A

- (id)init :(int64_t)x;
- (id)init :(int64_t)x :(int64_t)y;

- (int64_t)fooI64;
@end
