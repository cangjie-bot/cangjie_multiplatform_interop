// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// NOTE: Uses CJNative-specific API declared in LLVMGC/Signal/Cangjie.h

#import "Cangjie.h"
#import <dlfcn.h>
#import "Expr.h"

extern void CJImpl_ObjC_api_Expr_deleteCJObject(int64_t);

extern int64_t CJImpl_ObjC_api_Expr_NumInitCJObject(int64_t);
extern int64_t CJImpl_ObjC_api_Expr_AddInitCJObject(int64_t, int64_t);
extern int64_t CJImpl_ObjC_api_Expr_SubInitCJObject(int64_t, int64_t);

extern int64_t CJImpl_ObjC_api_CJEval(int64_t);

static void* CJWorldDLHandle = NULL;

static struct RuntimeParam defaultCJRuntimeParams = {0};

// @CJMirror
@implementation Expr

+ (void)initialize {
    if (self == [Expr class]) {
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

- (id)initWithRegistryId:(int64_t)registryId {
    if (self = [super init]) {
        self.$registryId = registryId;
    }
    return self;
}

- (void)dealloc {
    CJImpl_ObjC_api_Expr_deleteCJObject(self.$registryId);
}

+ (Expr*)Num:(int64_t)p1 {
    int64_t regId = CJImpl_ObjC_api_Expr_NumInitCJObject(p1);
    return [[Expr alloc] initWithRegistryId:regId];
}

+ (Expr*)Add:(Expr*)_e1 :(Expr*)_e2 {
    int64_t regId = CJImpl_ObjC_api_Expr_AddInitCJObject(_e1.$registryId, _e2.$registryId);
    return [[Expr alloc] initWithRegistryId:regId];
}

+ (Expr*)Sub:(Expr*)_e1 :(Expr*)_e2 {
    int64_t regId = CJImpl_ObjC_api_Expr_SubInitCJObject(_e1.$registryId, _e2.$registryId);
    return [[Expr alloc] initWithRegistryId:regId];
}

@end

int64_t CJEval(Expr* a) {
    return CJImpl_ObjC_api_CJEval(a.$registryId);
}
