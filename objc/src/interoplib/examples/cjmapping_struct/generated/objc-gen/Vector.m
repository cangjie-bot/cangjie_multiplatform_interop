// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// NOTE: Uses CJNative-specific API declared in LLVMGC/Signal/Cangjie.h

#import "Vector.h"
#import "Cangjie.h"
#import <dlfcn.h>

extern int64_t CJImpl_ObjC_cjworld_Vector_initCJObject(int32_t, int32_t);

extern int32_t CJImpl_ObjC_cjworld_Vector_XField_get(int64_t);

extern int32_t CJImpl_ObjC_cjworld_Vector_YField_get(int64_t);

extern void CJImpl_ObjC_cjworld_Vector_deleteCJObject(int64_t);

extern int64_t CJImpl_ObjC_cjworld_Vector_dot(int64_t, int64_t);

extern int64_t CJImpl_ObjC_cjworld_Vector_add(int64_t, int64_t);

extern void CJImpl_ObjC_cjworld_Vector_processPrimitive(int32_t, double, bool);

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

- (id)initWithRegistryId:(int64_t)registryId {
    if (self = [super init]) {
        self.$registryId = registryId;
    }
    return self;
}

- (int32_t)getXField {
    return CJImpl_ObjC_cjworld_Vector_XField_get(self.$registryId);
}

- (int32_t)getYField {
   return CJImpl_ObjC_cjworld_Vector_YField_get(self.$registryId);
}

- (void)dealloc {
    [self deleteCJObject:self.$registryId];
}

- (int64_t)dot:(Vector*)v {
    return CJImpl_ObjC_cjworld_Vector_dot(self.$registryId, v.$registryId);
}

- (Vector*)add:(Vector*)v {
    return [[Vector alloc] initWithRegistryId: CJImpl_ObjC_cjworld_Vector_add(self.$registryId, v.$registryId)];
}

+ (void)processPrimitive:(int32_t)intArg :(double)doubleArg :(bool)boolArg {
    CJImpl_ObjC_cjworld_Vector_processPrimitive(intArg, doubleArg, boolArg);
}

- (void)deleteCJObject:(int64_t)registryId {
    CJImpl_ObjC_cjworld_Vector_deleteCJObject(registryId);
}

@end
