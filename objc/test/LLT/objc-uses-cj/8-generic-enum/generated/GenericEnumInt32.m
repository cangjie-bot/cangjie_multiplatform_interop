#import <dlfcn.h>
#import "Cangjie.h"
#import "GenericEnumInt32.h"

extern int64_t CJImpl_ObjC_cjworld_GenericEnumInt32_RedInitCJObject(int32_t);

extern int64_t CJImpl_ObjC_cjworld_GenericEnumInt32_GreenInitCJObject(int32_t);

extern int64_t CJImpl_ObjC_cjworld_GenericEnumInt32_BlueInitCJObject(int32_t);

extern void CJImpl_ObjC_cjworld_GenericEnumInt32_printValue(int64_t);

extern void CJImpl_ObjC_cjworld_GenericEnumInt32_deleteCJObject(int64_t);

extern int32_t CJImpl_ObjC_cjworld_GenericEnumInt32_value_get(int64_t);

static void* CJWorldDLHandle = NULL;

static struct RuntimeParam defaultCJRuntimeParams = {0};

@implementation GenericEnumInt32

+ (void)initialize {
    if (self == [GenericEnumInt32 class]) {
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

+ (GenericEnumInt32*)Red:(int32_t)v {
    int64_t regId = CJImpl_ObjC_cjworld_GenericEnumInt32_RedInitCJObject(v);
    return [[GenericEnumInt32 alloc] initWithRegistryId:regId];
}

+ (GenericEnumInt32*)Green:(int32_t)v {
    int64_t regId = CJImpl_ObjC_cjworld_GenericEnumInt32_GreenInitCJObject(v);
    return [[GenericEnumInt32 alloc] initWithRegistryId:regId];
}

+ (GenericEnumInt32*)Blue:(int32_t)v {
    int64_t regId = CJImpl_ObjC_cjworld_GenericEnumInt32_BlueInitCJObject(v);
    return [[GenericEnumInt32 alloc] initWithRegistryId:regId];
}

- (void)printValue {
    return CJImpl_ObjC_cjworld_GenericEnumInt32_printValue(self.$registryId);
}

- (int32_t)value {
    return CJImpl_ObjC_cjworld_GenericEnumInt32_value_get(self.$registryId);
}

- (void)deleteCJObject {
    CJImpl_ObjC_cjworld_GenericEnumInt32_deleteCJObject(self.$registryId);
}

- (void)dealloc {
    [self deleteCJObject];
}

@end
