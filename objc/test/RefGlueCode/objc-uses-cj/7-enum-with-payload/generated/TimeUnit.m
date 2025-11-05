// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// NOTE: Uses CJNative-specific API declared in LLVMGC/Signal/Cangjie.h

#import "Cangjie.h"
#import <dlfcn.h>
#import "TimeUnit.h"

extern void CJImpl_ObjC_api_TimeUnit_deleteCJObject(int64_t);

extern int64_t CJImpl_ObjC_api_TimeUnit_MonthInitCJObject();
extern int64_t CJImpl_ObjC_api_TimeUnit_YearInitCJObject();

extern int64_t CJImpl_ObjC_api_TimeUnit_MonthP1InitCJObject(int64_t);
extern int64_t CJImpl_ObjC_api_TimeUnit_YearP1InitCJObject(int64_t);

extern int64_t CJImpl_ObjC_api_TimeUnit_TenYear();

extern int64_t CJImpl_ObjC_api_TimeUnit_CalcMonth(int64_t);

extern void CJImpl_ObjC_api_CJPrintMonthCount(int64_t);

static void* CJWorldDLHandle = NULL;

static struct RuntimeParam defaultCJRuntimeParams = {0};

static TimeUnit* LET_Month = NULL;
static TimeUnit* LET_Year = NULL;

// @CJMirror
@implementation TimeUnit

+ (void)initialize {
    if (self == [TimeUnit class]) {
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

        LET_Month = [[TimeUnit alloc] initWithRegistryId:CJImpl_ObjC_api_TimeUnit_MonthInitCJObject()];
        LET_Year = [[TimeUnit alloc] initWithRegistryId:CJImpl_ObjC_api_TimeUnit_YearInitCJObject()];
    }
}

- (id)initWithRegistryId:(int64_t)registryId {
    if (self = [super init]) {
        self.$registryId = registryId;
    }
    return self;
}

- (void)dealloc {
    CJImpl_ObjC_api_TimeUnit_deleteCJObject(self.$registryId);
}

+ (TimeUnit*)Month {
    return LET_Month;
}

+ (TimeUnit*)Year {
    return LET_Year;
}

+ (TimeUnit*)Month:(int64_t)p1 {
    int64_t regId = CJImpl_ObjC_api_TimeUnit_MonthP1InitCJObject(p1);
    return [[TimeUnit alloc] initWithRegistryId:regId];
}

+ (TimeUnit*)Year:(int64_t)p1 {
    int64_t regId = CJImpl_ObjC_api_TimeUnit_YearP1InitCJObject(p1);
    return [[TimeUnit alloc] initWithRegistryId:regId];
}

+ (TimeUnit*)TenYear {
    int64_t regId = CJImpl_ObjC_api_TimeUnit_TenYear();
    return [[TimeUnit alloc] initWithRegistryId:regId];
}

- (int64_t)CalcMonth {
    return CJImpl_ObjC_api_TimeUnit_CalcMonth(self.$registryId);
}

@end

void CJPrintMonthCount(TimeUnit* a) {
    CJImpl_ObjC_api_CJPrintMonthCount(a.$registryId);
}
