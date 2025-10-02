# Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
# This source file is part of the Cangjie project, licensed under Apache-2.0
# with Runtime Library Exception.
#
# See https://cangjie-lang.cn/pages/LICENSE for license information.

#import "Vector.h"
#import <Foundation/Foundation.h>

int main(int argc, char** argv) {
    @autoreleasepool {
        [Vector processPrimitive: 1: 2.33: false];
        Vector* v = [[Vector alloc] init:1 :2];
        Vector* w = [[Vector alloc] init:3 :4];
        int dotRes = [v dot: w];
        Vector* addRes = [v add: w];
        printf("Get data member in add result = (%d, %d)\n", addRes.x, addRes.y);
        dotRes = [addRes dot: w];
    }
    return 0;
}
