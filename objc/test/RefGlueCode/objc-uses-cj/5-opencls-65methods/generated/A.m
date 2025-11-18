// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#import "A.h"

// Interoplib objc common code (libinterop.objclib.dylib)
extern bool initCJRuntime(const char*);

// ObjC runtime functions used to calculate override-mask
typedef struct objc_method* Method;
extern IMP method_getImplementation(Method m);
extern Method class_getInstanceMethod(Class cls, SEL name);
extern id objc_getClass(const char * name);

// CJ glue-code functions to create/lock/unlock and remove from registry the A_fwd twin object
extern int64_t CJImpl_ObjC_cjworld_A_init(void*, uint64_t);
extern void CJImpl_ObjC_cjworld_A_lockCJObjectFwd(int64_t);
extern void CJImpl_ObjC_cjworld_A_unlockCJObjectFwd(int64_t);
extern void CJImpl_ObjC_cjworld_A_deleteCJObjectFwd(int64_t);

// CJ glue-code function to remove from registry the pure Cangjie A twin object
extern void CJImpl_ObjC_cjworld_A_deleteCJObject(int64_t);

// CJ glue-code functions to be called for pure Cangjie A twin object ($initedFromObjC == false)
extern void CJImpl_ObjC_cjworld_A_foo0(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo1(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo2(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo3(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo4(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo5(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo6(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo7(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo8(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo9(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo10(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo11(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo12(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo13(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo14(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo15(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo16(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo17(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo18(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo19(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo20(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo21(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo22(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo23(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo24(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo25(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo26(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo27(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo28(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo29(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo30(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo31(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo32(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo33(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo34(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo35(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo36(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo37(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo38(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo39(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo40(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo41(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo42(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo43(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo44(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo45(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo46(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo47(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo48(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo49(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo50(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo51(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo52(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo53(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo54(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo55(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo56(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo57(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo58(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo59(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo60(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo61(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo62(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo63(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo64(int64_t);
extern void CJImpl_ObjC_cjworld_A_foo65(int64_t);

// CJ glue-code functions to be called for Cangjie forwarder A_fwd object ($initedFromObjC == true)
extern void CJImpl_ObjC_cjworld_A_fwd_foo0(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo1(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo2(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo3(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo4(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo5(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo6(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo7(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo8(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo9(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo10(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo11(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo12(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo13(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo14(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo15(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo16(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo17(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo18(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo19(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo20(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo21(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo22(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo23(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo24(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo25(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo26(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo27(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo28(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo29(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo30(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo31(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo32(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo33(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo34(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo35(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo36(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo37(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo38(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo39(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo40(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo41(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo42(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo43(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo44(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo45(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo46(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo47(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo48(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo49(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo50(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo51(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo52(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo53(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo54(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo55(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo56(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo57(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo58(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo59(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo60(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo61(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo62(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo63(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo64(int64_t);
extern void CJImpl_ObjC_cjworld_A_fwd_foo65(int64_t);

//@CJMirror
@implementation A : NSObject

+ (void)initialize {
    if (self == [A class]) {
        if (!initCJRuntime("libcjworld.dylib")) {
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
        printf("ObjC: A.initWithRegistryId(%lld) self RC1: %ld\n", (long long) registryId, CFGetRetainCount((__bridge CFTypeRef)self));
    }
    return self;
}

// For initedFromObjC-twin objects - 'A' instance created by initiative of from ObjC side also known as TransitionI.
// Additional RC++ is done by extra retain to follow the Distributed-GC protocol.
- (id)init {
    if (self = [super init]) {
        Class baseCls = objc_getClass("A");
        Class selfCls = [self class];
        int len = 64;
        SEL methods[] = {
            @selector(foo0),
            @selector(foo1),
            @selector(foo2),
            @selector(foo3),
            @selector(foo4),
            @selector(foo5),
            @selector(foo6),
            @selector(foo7),
            @selector(foo8),
            @selector(foo9),
            @selector(foo10),
            @selector(foo11),
            @selector(foo12),
            @selector(foo13),
            @selector(foo14),
            @selector(foo15),
            @selector(foo16),
            @selector(foo17),
            @selector(foo18),
            @selector(foo19),
            @selector(foo20),
            @selector(foo21),
            @selector(foo22),
            @selector(foo23),
            @selector(foo24),
            @selector(foo25),
            @selector(foo26),
            @selector(foo27),
            @selector(foo28),
            @selector(foo29),
            @selector(foo30),
            @selector(foo31),
            @selector(foo32),
            @selector(foo33),
            @selector(foo34),
            @selector(foo35),
            @selector(foo36),
            @selector(foo37),
            @selector(foo38),
            @selector(foo39),
            @selector(foo40),
            @selector(foo41),
            @selector(foo42),
            @selector(foo43),
            @selector(foo44),
            @selector(foo45),
            @selector(foo46),
            @selector(foo47),
            @selector(foo48),
            @selector(foo49),
            @selector(foo50),
            @selector(foo51),
            @selector(foo52),
            @selector(foo53),
            @selector(foo54),
            @selector(foo55),
            @selector(foo56),
            @selector(foo57),
            @selector(foo58),
            @selector(foo59),
            @selector(foo60),
            @selector(foo61),
            @selector(foo62),
            @selector(foo63)
            // @selector(foo64) // there is no sense to list more than 64 methods in the list
        };
        uint64_t overrideMask = calcMask(baseCls, selfCls, methods, len);

        self.$registryId = CJImpl_ObjC_cjworld_A_init((__bridge void*)self, overrideMask);
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
    printf("ObjC: A.reinitWithRegistryId -1 => %lld self after +1 RC2: %ld (with RC++ by extra retain)\n", (long long) registryId, CFGetRetainCount((__bridge CFTypeRef)self));
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
            printf("ObjC: Transition II for %lld (now resetted to -1)\n", (long long) idToDelete);
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
        printf("ObjC: objc-twin of pure CJ A object is deallocated for id %lld\n", (long long) self.$registryId);
        // The instance does not participate in DistributedGC workflow: just remove the cjObj from the registry, lock is not required.
        CJImpl_ObjC_cjworld_A_deleteCJObject(self.$registryId);
    }
#ifdef CALL_SUPER_DEALLOC
//    [super dealloc];
#endif
}

- (void)foo0 { if (self.$initedFromObjC) { printf("ObjC: A.foo0() about to call CJImpl_ObjC_cjworld_A_fwd_foo0\n"); CJImpl_ObjC_cjworld_A_fwd_foo0(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo0(self.$registryId); } }
- (void)foo1 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo1(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo1(self.$registryId); } }
- (void)foo2 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo2(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo2(self.$registryId); } }
- (void)foo3 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo3(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo3(self.$registryId); } }
- (void)foo4 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo4(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo4(self.$registryId); } }
- (void)foo5 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo5(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo5(self.$registryId); } }
- (void)foo6 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo6(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo6(self.$registryId); } }
- (void)foo7 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo7(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo7(self.$registryId); } }
- (void)foo8 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo8(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo8(self.$registryId); } }
- (void)foo9 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo9(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo9(self.$registryId); } }
- (void)foo10 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo10(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo10(self.$registryId); } }
- (void)foo11 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo11(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo11(self.$registryId); } }
- (void)foo12 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo12(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo12(self.$registryId); } }
- (void)foo13 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo13(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo13(self.$registryId); } }
- (void)foo14 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo14(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo14(self.$registryId); } }
- (void)foo15 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo15(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo15(self.$registryId); } }
- (void)foo16 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo16(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo16(self.$registryId); } }
- (void)foo17 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo17(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo17(self.$registryId); } }
- (void)foo18 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo18(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo18(self.$registryId); } }
- (void)foo19 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo19(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo19(self.$registryId); } }
- (void)foo20 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo20(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo20(self.$registryId); } }
- (void)foo21 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo21(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo21(self.$registryId); } }
- (void)foo22 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo22(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo22(self.$registryId); } }
- (void)foo23 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo23(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo23(self.$registryId); } }
- (void)foo24 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo24(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo24(self.$registryId); } }
- (void)foo25 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo25(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo25(self.$registryId); } }
- (void)foo26 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo26(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo26(self.$registryId); } }
- (void)foo27 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo27(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo27(self.$registryId); } }
- (void)foo28 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo28(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo28(self.$registryId); } }
- (void)foo29 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo29(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo29(self.$registryId); } }
- (void)foo30 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo30(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo30(self.$registryId); } }
- (void)foo31 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo31(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo31(self.$registryId); } }
- (void)foo32 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo32(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo32(self.$registryId); } }
- (void)foo33 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo33(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo33(self.$registryId); } }
- (void)foo34 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo34(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo34(self.$registryId); } }
- (void)foo35 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo35(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo35(self.$registryId); } }
- (void)foo36 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo36(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo36(self.$registryId); } }
- (void)foo37 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo37(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo37(self.$registryId); } }
- (void)foo38 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo38(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo38(self.$registryId); } }
- (void)foo39 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo39(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo39(self.$registryId); } }
- (void)foo40 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo40(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo40(self.$registryId); } }
- (void)foo41 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo41(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo41(self.$registryId); } }
- (void)foo42 { if (self.$initedFromObjC) { printf("ObjC: A.foo42() about to call CJImpl_ObjC_cjworld_A_fwd_foo42\n"); CJImpl_ObjC_cjworld_A_fwd_foo42(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo42(self.$registryId); } }
- (void)foo43 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo43(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo43(self.$registryId); } }
- (void)foo44 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo44(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo44(self.$registryId); } }
- (void)foo45 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo45(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo45(self.$registryId); } }
- (void)foo46 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo46(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo46(self.$registryId); } }
- (void)foo47 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo47(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo47(self.$registryId); } }
- (void)foo48 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo48(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo48(self.$registryId); } }
- (void)foo49 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo49(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo49(self.$registryId); } }
- (void)foo50 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo50(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo50(self.$registryId); } }
- (void)foo51 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo51(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo51(self.$registryId); } }
- (void)foo52 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo52(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo52(self.$registryId); } }
- (void)foo53 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo53(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo53(self.$registryId); } }
- (void)foo54 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo54(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo54(self.$registryId); } }
- (void)foo55 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo55(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo55(self.$registryId); } }
- (void)foo56 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo56(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo56(self.$registryId); } }
- (void)foo57 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo57(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo57(self.$registryId); } }
- (void)foo58 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo58(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo58(self.$registryId); } }
- (void)foo59 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo59(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo59(self.$registryId); } }
- (void)foo60 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo60(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo60(self.$registryId); } }
- (void)foo61 { if (self.$initedFromObjC) { CJImpl_ObjC_cjworld_A_fwd_foo61(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo61(self.$registryId); } }
- (void)foo62 { if (self.$initedFromObjC) { printf("ObjC: A.foo62() about to call CJImpl_ObjC_cjworld_A_fwd_foo62\n"); CJImpl_ObjC_cjworld_A_fwd_foo62(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo62(self.$registryId); } }
- (void)foo63 { if (self.$initedFromObjC) { printf("ObjC: A.foo63() about to call CJImpl_ObjC_cjworld_A_fwd_foo63\n"); CJImpl_ObjC_cjworld_A_fwd_foo63(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo63(self.$registryId); } }
- (void)foo64 { if (self.$initedFromObjC) { printf("ObjC: A.foo64() about to call CJImpl_ObjC_cjworld_A_fwd_foo64\n"); CJImpl_ObjC_cjworld_A_fwd_foo64(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo64(self.$registryId); } }
- (void)foo65 { if (self.$initedFromObjC) { printf("ObjC: A.foo65() about to call CJImpl_ObjC_cjworld_A_fwd_foo65\n"); CJImpl_ObjC_cjworld_A_fwd_foo65(self.$registryId); } else { CJImpl_ObjC_cjworld_A_foo65(self.$registryId); } }

@end
