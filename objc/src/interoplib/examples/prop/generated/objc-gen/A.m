// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#import <dlfcn.h>
#import "Cangjie.h"
#import "A.h"

extern int64_t CJImpl_ObjC_cjworld_A_initPu(void*);
extern int64_t CJImpl_ObjC_cjworld_A_getA(int64_t);
extern void CJImpl_ObjC_cjworld_A_setA(int64_t, int64_t);
extern void* CJImpl_ObjC_cjworld_A_getB(int64_t);
extern void CJImpl_ObjC_cjworld_A_setB(int64_t, void*);
extern BOOL CJImpl_ObjC_cjworld_A_getC(int64_t);
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
        self.$registryId = [self initCJObject];
    }
    return self;
}

- (void)dealloc {
    [self deleteCJObject:self.$registryId];
}

- (int64_t)initCJObject {
    return CJImpl_ObjC_cjworld_A_initPu((__bridge void*)self);
}

- (int64_t)getA {
    return CJImpl_ObjC_cjworld_A_getA(self.$registryId);
}

- (void)setA:(int64_t)value {
    CJImpl_ObjC_cjworld_A_setA(self.$registryId, value);
}

- (M1*)getB {
    return (__bridge M1*)CJImpl_ObjC_cjworld_A_getB(self.$registryId);
}

- (void)setB:(M1*)value {
    CJImpl_ObjC_cjworld_A_setB(self.$registryId, (__bridge void*)value);
}

- (BOOL)getC {
    return CJImpl_ObjC_cjworld_A_getC(self.$registryId);
}

- (void)deleteCJObject:(int64_t)registryId {
    CJImpl_ObjC_cjworld_A_deleteCJObject(registryId);
}

@end
