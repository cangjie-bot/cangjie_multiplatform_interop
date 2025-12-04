#import <dlfcn.h>
#import "Cangjie.h"
#import "GenericInterfaceInt32.h"

@implementation GenericInterfaceInt32Impl {
    int32_t value;
}

- (int32_t)getValue {
    return value;
}

- (void)setValue:(int32_t)t {
    value = t;
}

- (void)printValue:(int32_t)val {
    NSLog(@"objc: int32_t: printValue: %d", val);
}
@end
