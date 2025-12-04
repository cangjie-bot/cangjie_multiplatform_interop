#import <Foundation/Foundation.h>
#import "GenericEnumInt32.h"
#import "GenericEnumFloat32.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        [[GenericEnumInt32 Red:50] printValue];
        [[GenericEnumInt32 Green:1] printValue];
        [[GenericEnumInt32 Blue:20] printValue];

        [[GenericEnumFloat32 Red:0.8] printValue];
        [[GenericEnumFloat32 Green:10.6] printValue];
        [[GenericEnumFloat32 Blue:9.9] printValue];
    }
    return 0;
}
