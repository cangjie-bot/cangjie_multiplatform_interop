// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// NOTE: Uses CJNative-specific API declared in LLVMGC/Signal/Cangjie.h

#import <dlfcn.h>
#import "Cangjie.h"
#import "CjAdd.h"

extern int32_t CJImpl_ObjC_cjworld_globalAddII(int32_t, int32_t);
extern int32_t CJImpl_ObjC_cjworld_CjAdd_staticAddII(int32_t, int32_t);

static void* CJWorldDLHandle = NULL;

static struct RuntimeParam defaultCJRuntimeParams = {0};

int32_t globalAddII(int32_t a, int32_t b) {
    return CJImpl_ObjC_cjworld_globalAddII(a, b);
}

@implementation CjAdd

+ (void)initialize {
    if (self == [CjAdd class]) {
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

+ (int32_t)staticAddII:(int32_t)a :(int32_t)b {
    return CJImpl_ObjC_cjworld_CjAdd_staticAddII(a, b);
}

@end
