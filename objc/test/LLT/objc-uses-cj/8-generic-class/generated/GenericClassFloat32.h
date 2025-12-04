#import <Foundation/Foundation.h>

__attribute__((objc_subclassing_restricted))
@interface GenericClassFloat32 : NSObject

@property (readwrite) int64_t $registryId;
@property (readwrite, getter=getValue, setter=setValue:) float_t value;
- (id)init:(float_t)v;
- (void)dealloc;
- (float_t)getValue;
- (void)setValue:(float_t)t;

@end
