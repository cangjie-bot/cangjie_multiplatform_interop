# Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
# This source file is part of the Cangjie project, licensed under Apache-2.0
# with Runtime Library Exception.
#
# See https://cangjie-lang.cn/pages/LICENSE for license information.

// NOTE: Uses CJNative-specific API declared in LLVMGC/Signal/Cangjie.h

#import "Cangjie.h"
#import <dlfcn.h>
#import <stddef.h>
#import "NonOpen.h"

extern void CJImpl_ObjC_cjworld_NonOpen_deleteCJObject(int64_t);
extern int64_t CJImpl_ObjC_cjworld_NonOpen_initCJObject();
extern void CJImpl_ObjC_cjworld_NonOpen_Foo(int64_t);

static void* CJWorldDLHandle = NULL;

static struct RuntimeParam defaultCJRuntimeParams = {0};

// @CJMirror
@implementation NonOpen

+ (void)initialize {
    if (self == [NonOpen class]) {
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
        self.$registryId = CJImpl_ObjC_cjworld_NonOpen_initCJObject();
    }
    return self;
}

- (void)dealloc {
    CJImpl_ObjC_cjworld_NonOpen_deleteCJObject(self.$registryId);
}

- (void)Foo {
    CJImpl_ObjC_cjworld_NonOpen_Foo(self.$registryId);
}

@end
