// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#import <dlfcn.h>
#import "Cangjie.h"
#import "A.h"

// ObjC runtime functions used to calculate override-mask
typedef struct objc_method* Method;
extern IMP method_getImplementation(Method m);
extern Method class_getInstanceMethod(Class cls, SEL name);
extern id objc_getClass(const char * name);

// CJ glue-code functions to create/lock/unlock and remove from registry the A_fwd twin object
extern int64_t CJImpl_ObjC_cjworld_A_initl(void*, uint64_t, int64_t);
extern int64_t CJImpl_ObjC_cjworld_A_initll(void*, uint64_t, int64_t, int64_t);
extern void CJImpl_ObjC_cjworld_A_lockCJObjectFwd(int64_t);
extern void CJImpl_ObjC_cjworld_A_unlockCJObjectFwd(int64_t);
extern void CJImpl_ObjC_cjworld_A_deleteCJObjectFwd(int64_t);

// CJ glue-code function to remove from registry the pure Cangjie A twin object
extern void CJImpl_ObjC_cjworld_A_deleteCJObject(int64_t);

// CJ glue-code functions to be called for pure Cangjie A twin object ($initedFromObjC == false)
extern int64_t CJImpl_ObjC_cjworld_A_fooI64(int64_t);

// CJ glue-code functions to be called for Cangjie forwarder A_fwd object ($initedFromObjC == true)
extern int64_t CJImpl_ObjC_cjworld_A_fwd_fooI64(int64_t);

static void* CJWorldDLHandle = NULL;
static struct RuntimeParam defaultCJRuntimeParams = {0};

//@CJMirror
@implementation A : NSObject

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

static uint64_t calcMask(Class baseCls, Class selfCls, SEL* methods, int len) {
    int max = len;
    if (max > 64) {
        max = 64;
    }

    uint64_t mask = 0;
    for (int i = 0; i < max; i++) {
        SEL m = methods[i];
        bool override = method_getImplementation(class_getInstanceMethod(baseCls, m)) != method_getImplementation(class_getInstanceMethod(selfCls, m));
        if (override) {
            mask |= (UINT64_C(1) << i);
        }
    }

    return mask;
}

// For initedFromCJ-twin - @CJMirror of pure Cangjie A object, without additional RC++.
- (id)initWithRegistryId:(int64_t)registryId {
    if (self = [super init]) {
        self.$registryId = registryId;
        self.$initedFromObjC = false;
        printf("ObjC: A.initWithRegistryId(%lld) self RC1: %ld\n", registryId, CFGetRetainCount((__bridge CFTypeRef)self));
    }
    return self;
}

// For initedFromObjC-twin objects - 'A' instance created by initiative of from ObjC side also known as TransitionI.
// Additional RC++ is done by extra retain to follow the Distributed-GC protocol.
- (id)init :(int64_t)x {
    if (self = [super init]) {
        Class baseCls = objc_getClass("A");
        Class selfCls = [self class];
        int len = 1;
        SEL methods[] = {@selector(fooI64)};
        uint64_t overrideMask = calcMask(baseCls, selfCls, methods, len);

        self.$registryId = CJImpl_ObjC_cjworld_A_initl((__bridge void*)self, overrideMask, x);
        self.$initedFromObjC = true;
        [self retain]; // extra RC++
    }
    return self;
}

// For initedFromObjC-twin objects - 'A' instance created by initiative of from ObjC side also known as TransitionI.
// Additional RC++ is done by extra retain to follow the Distributed-GC protocol.
- (id)init :(int64_t)x :(int64_t)y {
    if (self = [super init]) {
        Class baseCls = objc_getClass("A");
        Class selfCls = [self class];
        int len = 1;
        SEL methods[] = {@selector(fooI64)};
        uint64_t overrideMask = calcMask(baseCls, selfCls, methods, len);

        self.$registryId = CJImpl_ObjC_cjworld_A_initll((__bridge void*)self, overrideMask, x, y);
        self.$initedFromObjC = true;
        [self retain]; // extra RC++
    }
    return self;
}

// for backOnTrack also known as TransitionIII
- (id)reinitWithRegistryId:(int64_t)registryId {
    assert(self.$registryId == -1); // not a part of reference glue-code, do not generate it
    assert(self.$initedFromObjC == true); // not a part of reference glue-code, do not generate it
    self.$registryId = registryId;
    [self retain]; // do RC++ by extra retain for Distributed-GC protocol
    printf("ObjC: A.reinitWithRegistryId -1 => %lld self after +1 RC2: %ld (with RC++ by extra retain)\n", registryId, CFGetRetainCount((__bridge CFTypeRef)self));
    return self;
}

// For TransitionII of DistributedGC workflow if the instance is initedFromObjC-twin
- (oneway void) release {
    [super release];
    // DistributedGC workflow is performed only for instances created (initialized) from ObjC side.
    if (self.$initedFromObjC && 1 == CFGetRetainCount((__bridge CFTypeRef)self)) {
        int64_t idToDelete = self.$registryId;
        CJImpl_ObjC_cjworld_A_lockCJObjectFwd(idToDelete);
        if (1 == CFGetRetainCount((__bridge CFTypeRef)self)) { // ensure RC == 1 after the lock is obtained
            // TransitionII
            printf("ObjC: Transition II for %lld (now resetted to -1)\n", idToDelete);
            self.$registryId = -1;
            CJImpl_ObjC_cjworld_A_deleteCJObjectFwd(idToDelete); // the obtained lock is released inside
        } else {
            CJImpl_ObjC_cjworld_A_unlockCJObjectFwd(idToDelete); // CJObject is still in use, just release the obtained lock
        }
    }
}

// The dealloc must be generated for glue-code (NSObject parent does not have it).
// Actually, [super dealloc] should be called only if the main app and all libraries are compiled without ARC.
// But for now there is at least libcangjie-runtime.dylib built with ARC, so even if CALL_SUPER_DEALLOC macro is set, dealloc should not call [super dealloc].
// Reference glue-code should have dealloc method without [super dealloc].
 - (void)dealloc {
    if (!self.$initedFromObjC) {
        printf("ObjC: objc-twin of pure CJ A object is deallocated for id %lld\n", self.$registryId);
        // The instance does not participate in DistributedGC workflow: just remove the cjObj from the registry, lock is not required.
        CJImpl_ObjC_cjworld_A_deleteCJObject(self.$registryId);
    }
#ifdef CALL_SUPER_DEALLOC
//    [super dealloc];
#endif
}

- (int64_t)fooI64 {
    if (self.$initedFromObjC) {
        return CJImpl_ObjC_cjworld_A_fwd_fooI64(self.$registryId);
    } else {
        return CJImpl_ObjC_cjworld_A_fooI64(self.$registryId);
    }
}

@end
