// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#import "Animal.h"
#import "Cat.h"
#import "Dog.h"
#import "CjAnimalAccessor.h"
#import <Foundation/Foundation.h>

void animalSay(id<Animal> animal) {
    printf("ObjC: main animalSay:\n");
    [animal Say];
}

void animalEat(id<Animal> animal) {
    printf("ObjC: main animalEat:\n");
    [animal Eat];
}

int32_t animalWeight(id<Animal> animal) {
    return [animal Weight];
}

int main(int argc, char** argv) {
    @autoreleasepool {
        CjAnimalAccessor* accessor = [[CjAnimalAccessor alloc] init];
        printf("\n");
        id<Animal> cat = [[Cat alloc] init];
        animalSay(cat);
        printf("\n");
        animalEat(cat);
        printf("\n");
        [accessor fooWithDefault:cat];
        [accessor foo:cat];

        printf("\n");
        id<Animal> impl = [[AnimalImpl alloc] init];
        animalSay(impl);
        printf("\n");
        animalEat(impl);
        printf("\n");
        [accessor fooWithDefault:impl];
        printf("ObjC: AnimalImpl is a pure CJMirror of CJ Animal interface so it must not be passed to accessor.foo for calling Weight (that has no default implementation)\n");

        printf("\n");
        id<Animal> dog = [[Dog alloc] init];
        animalSay(dog);
        printf("\n");
        animalEat(dog);
        printf("\n");
        [accessor fooWithDefault:dog];
        [accessor foo:dog];

        printf("\n");
        printf("main: Cat weight = %d\n", animalWeight(cat));
        printf("main: Dog weight = %d\n", animalWeight(dog));
    }
    return 0;
}
