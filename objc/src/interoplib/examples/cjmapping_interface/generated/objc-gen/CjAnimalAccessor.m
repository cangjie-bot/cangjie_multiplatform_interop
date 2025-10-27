// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#import <dlfcn.h>
#import <stddef.h>
#import "Cangjie.h"
#import "CjAnimalAccessor.h"

extern void CJImpl_ObjC_cjworld_CjAnimalAccessor_deleteCJObject(int64_t);
extern int64_t CJImpl_ObjC_cjworld_CjAnimalAccessor_initCJObject();
extern void CJImpl_ObjC_cjworld_CjAnimalAccessor_fooWithDefault(int64_t, void*);
extern void CJImpl_ObjC_cjworld_CjAnimalAccessor_foo(int64_t, void*);
static void* CJWorldDLHandle = NULL;
static struct RuntimeParam defaultCJRuntimeParams = {0};

// @CJMirror
@implementation CjAnimalAccessor: NSObject

+ (void)initialize {
    if (self == [CjAnimalAccessor class]) {
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
        self.$registryId = CJImpl_ObjC_cjworld_CjAnimalAccessor_initCJObject();
    }
    return self;
}

- (void)dealloc {
    CJImpl_ObjC_cjworld_CjAnimalAccessor_deleteCJObject(self.$registryId);
}

- (void)fooWithDefault:(id<Animal>) animal {
    CJImpl_ObjC_cjworld_CjAnimalAccessor_fooWithDefault(self.$registryId, (__bridge void*)animal);
}

- (void)foo:(id<Animal>) animal {
    CJImpl_ObjC_cjworld_CjAnimalAccessor_foo(self.$registryId, (__bridge void*)animal);
}

@end
