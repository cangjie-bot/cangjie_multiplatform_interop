// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#import <Foundation/Foundation.h>

#import "SimpleEnum.h"

int main(int argc, char** argv) {
    @autoreleasepool {
        printf("main: print SimpleEnum values =>\n");
        CJPrint([SimpleEnum One]);
        CJPrint([SimpleEnum Two]);
        CJPrint([SimpleEnum Three]);
    }
    return 0;
}
