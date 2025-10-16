// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#import <Foundation/Foundation.h>
#import "Vector.h"

int main(int argc, char** argv) {
    @autoreleasepool {
        Vector* v = [[Vector alloc] init:1 :2];
        printf("ObjC: main v is (%d, %d)\n", [v getX], [v getY]);
        Vector* w = [[Vector alloc] init:3 :4];
        printf("ObjC: main w is (%d, %d)\n", [w getX], [w getY]);
        int dotRes = [v dot: w];
        printf("ObjC: main got [v dot: w] = %d\n", dotRes);
    }
    return 0;
}
