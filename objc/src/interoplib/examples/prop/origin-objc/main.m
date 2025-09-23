// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#import "A.h"
#import <Foundation/Foundation.h>


int main(int argc, char** argv) {
    @autoreleasepool {
        A* a = [[A alloc] init];

        NSLog(@"objc: value of foo: %lld", a.foo);
        NSLog(@"objc: value of bar.answer: %lf", a.bar.answer);
        NSLog(@"objc: value of a: %lld", a.a);
        NSLog(@"objc: value of b.answer: %lf", a.b.answer);
        NSLog(@"objc: value of c: %s", a.c ? "YES" : "NO");
    }
    return 0;
}
