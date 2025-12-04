#import <Foundation/Foundation.h>

@protocol GenericInterfaceFloat32
- (void)setValue:(float_t)t;
- (float_t)getValue;
- (void)printValue:(float_t)t;
@end

@interface GenericInterfaceFloat32Impl : NSObject <GenericInterfaceFloat32>
@end
