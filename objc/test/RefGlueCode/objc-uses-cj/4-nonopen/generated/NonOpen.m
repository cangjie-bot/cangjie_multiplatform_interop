// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#import "NonOpen.h"

// Interoplib objc common code (libinterop.objclib.dylib)
extern bool initCJRuntime(const char*);

extern void CJImpl_ObjC_cjworld_NonOpen_deleteCJObject(int64_t);
extern int64_t CJImpl_ObjC_cjworld_NonOpen_initCJObject();
extern void CJImpl_ObjC_cjworld_NonOpen_Foo(int64_t);

// @CJMirror
@implementation NonOpen

+ (void)initialize {
    if (self == [NonOpen class]) {
        if (!initCJRuntime("libcjworld.dylib")) {
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
