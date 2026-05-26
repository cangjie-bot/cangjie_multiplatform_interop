// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#import <dlfcn.h>
#import "Cangjie.h"
#import "A.h"

extern void* CJImpl_ObjC_cjworld_A_fooBar(int64_t);
extern int64_t CJImpl_ObjC_cjworld_A_initPu(void*);
extern void CJImpl_ObjC_cjworld_A_deleteCJObject(int64_t);
static void* CJWorldDLHandle = NULL;
static struct RuntimeParam defaultCJRuntimeParams = {0};

@implementation A

+ (void)initialize {
    if (self == [A class]) {
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
            NSLog(@"ERROR: Failed to open cjworld library ");
            NSLog(@"%s", dlerror());
            exit(1);
        }
    }
}

- (id)init {
    if (self = [super init]) {
        self.$registryId = CJImpl_ObjC_cjworld_A_initPu((__bridge void*)self);
    }
    return self;
}

- (M1*)fooBar {
    return (__bridge M1*)CJImpl_ObjC_cjworld_A_fooBar(self.$registryId);
}

- (M1*)super$foo {
    return [super foo];
}

- (int32_t)super$goo {
    return [super goo];
}

- (void)dealloc {
    [self deleteCJObject:self.$registryId];
}

- (void)deleteCJObject:(int64_t)registryId {
    CJImpl_ObjC_cjworld_A_deleteCJObject(registryId);
}

@end
