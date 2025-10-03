// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// NOTE: Uses CJNative-specific API declared in LLVMGC/Signal/Cangjie.h

#import <dlfcn.h>
#import "Cangjie.h"
#import "CjConcat.h"

extern NSString* CJImpl_ObjC_cjworld_globalConcat(void*, void*);
extern NSString* CJImpl_ObjC_cjworld_CjConcat_staticConcat(void*, void*);

static void* CJWorldDLHandle = NULL;

static struct RuntimeParam defaultCJRuntimeParams = {0};

NSString* globalConcat(NSString* a, NSString* b) {
    @autoreleasepool {
        return CJImpl_ObjC_cjworld_globalConcat((__bridge void*)a, (__bridge void*)b);
    }
}

@implementation CjConcat

+ (void)initialize {
    if (self == [CjConcat class]) {
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

+ (NSString*)staticConcat:(NSString*)a :(NSString*)b {
    @autoreleasepool {
        return CJImpl_ObjC_cjworld_CjConcat_staticConcat((__bridge void*)a, (__bridge void*)b);
    }
}

@end
