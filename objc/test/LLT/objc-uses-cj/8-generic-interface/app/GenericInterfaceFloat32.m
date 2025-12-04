#import <dlfcn.h>
#import "Cangjie.h"
#import "GenericInterfaceFloat32.h"

@implementation GenericInterfaceFloat32Impl {
    float_t value;
}

- (float_t)getValue {
    return value;
}

- (void)setValue:(float_t)t {
    value = t;
}

- (void)printValue:(float_t)val {
    NSLog(@"objc: float_t: printValue: %f", val);
}
@end
