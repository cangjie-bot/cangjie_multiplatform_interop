// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#import "SimpleEnum.h"

// Interoplib objc common code (libinterop.objclib.dylib)
extern bool initCJRuntime(const char*);

extern int64_t CJImpl_ObjC_api_SimpleEnum_OneInitCJObject();
extern int64_t CJImpl_ObjC_api_SimpleEnum_TwoInitCJObject();
extern int64_t CJImpl_ObjC_api_SimpleEnum_ThreeInitCJObject();

extern void CJImpl_ObjC_api_CJPrint(int64_t);

static SimpleEnum* LET_One = NULL;
static SimpleEnum* LET_Two = NULL;
static SimpleEnum* LET_Three = NULL;

// @CJMirror
@implementation SimpleEnum

+ (void)initialize {
    if (self == [SimpleEnum class]) {
        if (!initCJRuntime("libcjworld.dylib")) {
            exit(1);
        }

        LET_One = [[SimpleEnum alloc] initWithRegistryId:CJImpl_ObjC_api_SimpleEnum_OneInitCJObject()];
        LET_Two = [[SimpleEnum alloc] initWithRegistryId:CJImpl_ObjC_api_SimpleEnum_TwoInitCJObject()];
        LET_Three = [[SimpleEnum alloc] initWithRegistryId:CJImpl_ObjC_api_SimpleEnum_ThreeInitCJObject()];
    }
}

- (id)initWithRegistryId:(int64_t)registryId {
    if (self = [super init]) {
        self.$registryId = registryId;
    }
    return self;
}

+ (SimpleEnum*)One {
    return LET_One;
}

+ (SimpleEnum*)Two {
    return LET_Two;
}

+ (SimpleEnum*)Three {
    return LET_Three;
}

@end

void CJPrint(SimpleEnum* a) {
    CJImpl_ObjC_api_CJPrint(a.$registryId);
}
