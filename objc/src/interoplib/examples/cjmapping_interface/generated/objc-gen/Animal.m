// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#import <dlfcn.h>
#import "Cangjie.h"
#import "Animal.h"

extern void CJImpl_ObjC_cjworld_AnimalImpl_SayImpl(void*);
extern void CJImpl_ObjC_cjworld_AnimalImpl_EatImpl(void*);

static void* CJWorldDLHandle = NULL;
static struct RuntimeParam defaultCJRuntimeParams = {0};

// the default implementation of Animal interface
//@CJMirror
@implementation AnimalImpl

+ (void)initialize {
    if (self == [AnimalImpl class]) {
        defaultCJRuntimeParams.logParam.logLevel = RTLOG_ERROR;
        if (InitCJRuntime(&defaultCJRuntimeParams) != E_OK) {
            NSLog(@"ERROR: Failed to initialize Cangjie runtime");
            exit(1);
        }

        if (LoadCJLibraryWithInit("libcjworld.dylib")) {
            NSLog(@"ERROR: Failed to init cjworld library");
            exit(1);
        }

        if ((CJWorldDLHandle = dlopen("libcjworld.dylib", RTLD_LAZY)) == NULL) {
            NSLog(@"ERROR: Failed to open cjworld library");
            NSLog(@"%s", dlerror());
            exit(1);
        }
    }
}

- (id)init {
    if (self = [super init]) {
        printf("ObjC: AnimalImpl init()\n");
    }

    return self;
}

- (void)Say {
    CJImpl_ObjC_cjworld_AnimalImpl_SayImpl((__bridge void*)self);
}

- (void)Eat {
    CJImpl_ObjC_cjworld_AnimalImpl_EatImpl((__bridge void*)self);
}

@end
