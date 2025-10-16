// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// NOTE: Uses CJNative-specific API declared in LLVMGC/Signal/Cangjie.h

#import <dlfcn.h>
#import "Cangjie.h"
#import "Vector.h"

extern int64_t CJImpl_ObjC_cjworld_Vector_initCJObject(int32_t, int32_t);

extern void CJImpl_ObjC_cjworld_Vector_deleteCJObject(int64_t);

extern int32_t CJImpl_ObjC_cjworld_Vector_X_get(int64_t);

extern int32_t CJImpl_ObjC_cjworld_Vector_Y_get(int64_t);

extern int64_t CJImpl_ObjC_cjworld_Vector_dot(int64_t, int64_t);

static void* CJWorldDLHandle = NULL;

static struct RuntimeParam defaultCJRuntimeParams = {0};


@implementation Vector

+ (void)initialize {
    if (self == [Vector class]) {
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

- (id)init:(int32_t)x :(int32_t)y {
    if (self = [super init]) {
        self.$registryId = CJImpl_ObjC_cjworld_Vector_initCJObject(x, y);
    }
    return self;
}

- (void)dealloc {
    CJImpl_ObjC_cjworld_Vector_deleteCJObject(self.$registryId);
}

- (int32_t)getX {
    return CJImpl_ObjC_cjworld_Vector_X_get(self.$registryId);
}

- (int32_t)getY {
   return CJImpl_ObjC_cjworld_Vector_Y_get(self.$registryId);
}

- (int64_t)dot:(Vector*)v {
    return CJImpl_ObjC_cjworld_Vector_dot(self.$registryId, v.$registryId);
}

@end
