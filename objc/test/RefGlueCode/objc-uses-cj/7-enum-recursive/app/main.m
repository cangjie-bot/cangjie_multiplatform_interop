// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#import <Foundation/Foundation.h>

#import "Expr.h"

int main(int argc, char** argv) {
    @autoreleasepool {
        printf("main: evaluate expr =>\n");
        printf("expected 2 evaluated: %lld\n", CJEval([Expr Num:2]));
        printf("expected 7 evaluated: %lld\n", CJEval([Expr Add:[Expr Num:2]:[Expr Num:5]]));
        printf("expected 3 evaluated: %lld\n", CJEval([Expr Sub:[Expr Num:10]:[Expr Add:[Expr Num:2]:[Expr Num:5]]]));
    }
    return 0;
}
