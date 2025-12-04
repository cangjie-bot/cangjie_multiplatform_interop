#import <dlfcn.h>
#import "Cangjie.h"
#import "GenericEnumFloat32.h"

extern int64_t CJImpl_ObjC_cjworld_GenericEnumFloat32_RedInitCJObject(float_t);

extern int64_t CJImpl_ObjC_cjworld_GenericEnumFloat32_GreenInitCJObject(float_t);

extern int64_t CJImpl_ObjC_cjworld_GenericEnumFloat32_BlueInitCJObject(float_t);

extern void CJImpl_ObjC_cjworld_GenericEnumFloat32_printValue(int64_t);

extern void CJImpl_ObjC_cjworld_GenericEnumFloat32_deleteCJObject(int64_t);

extern float_t CJImpl_ObjC_cjworld_GenericEnumFloat32_value_get(int64_t);

static void* CJWorldDLHandle = NULL;

static struct RuntimeParam defaultCJRuntimeParams = {0};

@implementation GenericEnumFloat32

+ (void)initialize {
    if (self == [GenericEnumFloat32 class]) {
        defaultCJRuntimeParams.logParam.logLevel = RTLOG_ERROR;
	if (InitCJRuntime(&defaultCJRuntimeParams) != E_OK) {
            NSLog(@"ERROR: Failed to initialize Cangjie Runtime");
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

+ (GenericEnumFloat32*)Red:(float_t)v {
    int64_t regId = CJImpl_ObjC_cjworld_GenericEnumFloat32_RedInitCJObject(v);
    return [[GenericEnumFloat32 alloc] initWithRegistryId:regId];
}

+ (GenericEnumFloat32*)Green:(float_t)v {
    int64_t regId = CJImpl_ObjC_cjworld_GenericEnumFloat32_GreenInitCJObject(v);
    return [[GenericEnumFloat32 alloc] initWithRegistryId:regId];
}

+ (GenericEnumFloat32*)Blue:(float_t)v {
    int64_t regId = CJImpl_ObjC_cjworld_GenericEnumFloat32_BlueInitCJObject(v);
    return [[GenericEnumFloat32 alloc] initWithRegistryId:regId];
}

- (void)printValue {
    return CJImpl_ObjC_cjworld_GenericEnumFloat32_printValue(self.$registryId);
}

- (float_t)value {
    return CJImpl_ObjC_cjworld_GenericEnumFloat32_value_get(self.$registryId);
}

- (void)deleteCJObject {
    CJImpl_ObjC_cjworld_GenericEnumFloat32_deleteCJObject(self.$registryId);
}

- (void)dealloc {
    [self deleteCJObject];
}

@end
