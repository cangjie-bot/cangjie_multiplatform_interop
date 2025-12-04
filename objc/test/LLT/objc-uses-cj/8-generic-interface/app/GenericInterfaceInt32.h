#import <Foundation/Foundation.h>

@protocol GenericInterfaceInt32
- (void)setValue:(int32_t)t;
- (int32_t)getValue;
- (void)printValue:(int32_t)t;
@end

@interface GenericInterfaceInt32Impl : NSObject <GenericInterfaceInt32>
@end
