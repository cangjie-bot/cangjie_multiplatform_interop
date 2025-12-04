#import <dlfcn.h>
#import "Cangjie.h"
#import "GenericClassInt32.h"

extern int64_t CJImpl_ObjC_cjworld_GenericClassInt32_initCJObjectG_1(int32_t);

extern void CJImpl_ObjC_cjworld_GenericClassInt32_deleteCJObject(int64_t);

extern void CJImpl_ObjC_cjworld_GenericClassInt32_setValueG_1(int64_t, int32_t);

extern int32_t CJImpl_ObjC_cjworld_GenericClassInt32_getValue(int64_t);

static void* CJWorldDLHandle = NULL;

static struct RuntimeParam defaultCJRuntimeParams = {0};

@implementation GenericClassInt32

+ (void)initialize {
    if (self == [GenericClassInt32 class]) {
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

- (id)init:(int32_t)v {
    if (self = [super init]) {
        self.$registryId = CJImpl_ObjC_cjworld_GenericClassInt32_initCJObjectG_1(v);
    }
    return self;
}

- (void)dealloc {
    CJImpl_ObjC_cjworld_GenericClassInt32_deleteCJObject(self.$registryId);
}

- (void)setValue:(int32_t)t {
    return CJImpl_ObjC_cjworld_GenericClassInt32_setValueG_1(self.$registryId, t);
}

-(int32_t)getValue {
    return CJImpl_ObjC_cjworld_GenericClassInt32_getValue(self.$registryId);
}

@end
