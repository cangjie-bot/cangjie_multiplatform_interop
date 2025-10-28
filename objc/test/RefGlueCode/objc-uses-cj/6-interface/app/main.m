// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#import <Foundation/Foundation.h>
#import "Animal.h"
#import "Cat.h"
#import "Dog.h"

int main(int argc, char** argv) {
    @autoreleasepool {
        printf("\n");
        id<Animal> cat = [[Cat alloc] init];
        printf("ObjC: main cat.Say:\n");
        [cat Say];
        printf("\n");
        printf("ObjC: main cat.Eat:\n");
        [cat Eat];
        printf("\n");
        int32_t catWeight = [cat Weight];
        printf("main: cat.Weight = %d\n", catWeight);
        printf("\n");

        [AnimalImpl staticTest:cat];

        printf("\n");
        id<Animal> impl = [[AnimalImpl alloc] init];
        printf("ObjC: main impl.Say:\n");
        [impl Say];
        printf("\n");
        printf("ObjC: main impl.Eat:\n");
        [impl Eat];
        printf("\n");

        // AnimalImpl is a pure CJMirror of CJ Animal interface so it must not be passed to staticTest because Weight method has no default implementation.
        // Do not call AnimalImpl staticTest with 'impl' argument.

        id<Animal> dog = [[Dog alloc] init];
        printf("ObjC: main dog.Say:\n");
        [dog Say];
        printf("\n");
        printf("ObjC: main dog.Eat:\n");
        [dog Eat];
        printf("\n");
        int32_t dogWeight = [dog Weight];
        printf("main: dog.Weight = %d\n", dogWeight);
        printf("\n");

        [AnimalImpl staticTest:dog];
    }
    return 0;
}
