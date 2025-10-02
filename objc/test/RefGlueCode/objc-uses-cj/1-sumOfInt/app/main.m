// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#import <Foundation/Foundation.h>
#import "CjAdd.h"

int main(int argc, char** argv) {
    @autoreleasepool {
        int32_t staticSum = [CjAdd staticAddII :1 :2];
        printf("ObjC: main [CjAdd staticAddII] returned: %d\n", staticSum);

        int32_t globalSum = globalAddII(3, 4);
        printf("ObjC: main globalAddII returned: %d\n", globalSum);
    }
    return 0;
}
