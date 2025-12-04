#import <Foundation/Foundation.h>
#import "GenericInterfaceInt32.h"
#import "GenericInterfaceFloat32.h"

int main(int argc, const char* argv[]) {
    @autoreleasepool {
        id<GenericInterfaceInt32> v1 = [[GenericInterfaceInt32Impl alloc] init];
        [v1 setValue:111];
        [v1 printValue:[v1 getValue]];

        [v1 setValue:222];
        [v1 printValue:[v1 getValue]];

        id<GenericInterfaceFloat32> v2 = [[GenericInterfaceFloat32Impl alloc] init];
        [v2 setValue:0.11];
        [v2 printValue:[v2 getValue]];

        [v2 setValue:10.33];
        [v2 printValue:[v2 getValue]];
    }
    return 0;
}
