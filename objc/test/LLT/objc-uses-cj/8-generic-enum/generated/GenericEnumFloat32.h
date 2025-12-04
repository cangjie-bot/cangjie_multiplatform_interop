#import <Foundation/Foundation.h>

__attribute__((objc_subclassing_restricted))
@interface GenericEnumFloat32 : NSObject

@property (readwrite) int64_t $registryId;
@property (readonly, getter=value) float_t value;
- (float_t)value;
- (void)printValue;
+ (GenericEnumFloat32*)Red:(float_t)v;
+ (GenericEnumFloat32*)Green:(float_t)v;
+ (GenericEnumFloat32*)Blue:(float_t)v;
- (void)deleteCJObject;
- (void)dealloc;
@end
