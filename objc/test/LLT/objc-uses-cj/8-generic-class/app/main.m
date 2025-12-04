#import <Foundation/Foundation.h>
#import "GenericClassInt32.h"
#import "GenericClassFloat32.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        GenericClassInt32 *numberContainer1 = [[GenericClassInt32 alloc] init:10];
        [numberContainer1 setValue:20];
        int32_t result1 = [numberContainer1 getValue];

        GenericClassFloat32 *numberContainer2 = [[GenericClassFloat32 alloc] init:10.2];
        [numberContainer2 setValue:0.5];
        float_t result2 = [numberContainer2 getValue];
    }
    return 0;
}
