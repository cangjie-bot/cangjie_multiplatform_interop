#import <Foundation/Foundation.h>

__attribute__((objc_subclassing_restricted))
@interface GenericClassInt32 : NSObject

@property (readwrite) int64_t $registryId;
@property (readwrite, getter=getValue, setter=setValue:) int32_t value;
- (id)init:(int32_t)v;
- (void)dealloc;
- (int32_t)getValue;
- (void)setValue:(int32_t)t;

@end
