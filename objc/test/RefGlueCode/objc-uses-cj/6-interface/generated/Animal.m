// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#import "Animal.h"

// Interoplib objc common code (libinterop.objclib.dylib)
extern bool initCJRuntime(const char*);

extern void CJImpl_ObjC_cjworld_AnimalImpl_SayImpl(void*);
extern void CJImpl_ObjC_cjworld_AnimalImpl_EatImpl(void*);
extern void CJImpl_ObjC_cjworld_AnimalImpl_staticTest(void*);

// the default implementation of Animal interface
//@CJMirror
@implementation AnimalImpl

+ (void)initialize {
    if (self == [AnimalImpl class]) {
        if (!initCJRuntime("libcjworld.dylib")) {
            exit(1);
        }
    }
}

- (void)Say {
    CJImpl_ObjC_cjworld_AnimalImpl_SayImpl((void*)[self retain]);
}

- (void)Eat {
    CJImpl_ObjC_cjworld_AnimalImpl_EatImpl((void*)[self retain]);
}

+ (void)staticTest:(id<Animal>) animal {
    CJImpl_ObjC_cjworld_AnimalImpl_staticTest((void*)[animal retain]);
}

@end
