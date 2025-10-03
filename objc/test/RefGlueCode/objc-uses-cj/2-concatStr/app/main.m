// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#import <Foundation/Foundation.h>
#import "CjConcat.h"

int main(int argc, char** argv) {
    @autoreleasepool {
        NSString* staticSum = [CjConcat staticConcat :@"str1" :@"str2"];
        printf("ObjC: main [CjAdd staticConcat] returned: %s\n", [staticSum UTF8String]);

        NSString* globalSum = globalConcat(@"str3", @"str4");
        printf("ObjC: main globalConcat returned: %s\n", [globalSum UTF8String]);
    }
    return 0;
}
