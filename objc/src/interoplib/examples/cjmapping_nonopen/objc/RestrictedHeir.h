# Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
# This source file is part of the Cangjie project, licensed under Apache-2.0
# with Runtime Library Exception.
#
# See https://cangjie-lang.cn/pages/LICENSE for license information.

#import <Foundation/Foundation.h>
#import "NonOpen.h"

// restricted: it should not override methods of NonOpen, but can call them
@interface RestrictedHeir: NonOpen

- (void)CallParentFoo;

@end
