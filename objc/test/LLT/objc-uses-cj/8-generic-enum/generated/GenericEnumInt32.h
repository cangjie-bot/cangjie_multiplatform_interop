#import <Foundation/Foundation.h>

__attribute__((objc_subclassing_restricted))
@interface GenericEnumInt32 : NSObject

@property (readwrite) int64_t $registryId;
@property (readonly, getter=value) int32_t value;
- (int32_t)value;
- (void)printValue;
+ (GenericEnumInt32*)Red:(int32_t)v;
+ (GenericEnumInt32*)Green:(int32_t)v;
+ (GenericEnumInt32*)Blue:(int32_t)v;
- (void)deleteCJObject;
- (void)dealloc;
@end
