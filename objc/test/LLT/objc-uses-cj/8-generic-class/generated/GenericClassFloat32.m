#import <dlfcn.h>
#import "Cangjie.h"
#import "GenericClassFloat32.h"

extern int64_t CJImpl_ObjC_cjworld_GenericClassFloat32_initCJObjectG_1(float_t);

extern void CJImpl_ObjC_cjworld_GenericClassFloat32_deleteCJObject(int64_t);

extern void CJImpl_ObjC_cjworld_GenericClassFloat32_setValueG_1(int64_t, float_t);

extern float_t CJImpl_ObjC_cjworld_GenericClassFloat32_getValue(int64_t);

static void* CJWorldDLHandle = NULL;

static struct RuntimeParam defaultCJRuntimeParams = {0};

@implementation GenericClassFloat32

+ (void)initialize {
    if (self == [GenericClassFloat32 class]) {
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

- (id)init:(float_t)v {
    if (self = [super init]) {
        self.$registryId = CJImpl_ObjC_cjworld_GenericClassFloat32_initCJObjectG_1(v);
    }
    return self;
}

- (void)dealloc {
    CJImpl_ObjC_cjworld_GenericClassFloat32_deleteCJObject(self.$registryId);
}

- (void)setValue:(float_t)t {
    return CJImpl_ObjC_cjworld_GenericClassFloat32_setValueG_1(self.$registryId, t);
}

-(float_t)getValue {
    return CJImpl_ObjC_cjworld_GenericClassFloat32_getValue(self.$registryId);
}

@end
