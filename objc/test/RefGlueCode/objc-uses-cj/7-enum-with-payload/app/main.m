// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#import <Foundation/Foundation.h>

#import "TimeUnit.h"

int main(int argc, char** argv) {
    @autoreleasepool {
        printf("main: Year(2) =>\n");
        TimeUnit* tuYearP1 = [TimeUnit Year:2];
        CJPrintMonthCount(tuYearP1);

        printf("\nmain: Year =>\n");
        TimeUnit* tuYear = [TimeUnit Year];
        CJPrintMonthCount(tuYear);

        printf("\nmain: Month(24) =>\n");
        TimeUnit* tuMonthP1 = [TimeUnit Month:24];
        CJPrintMonthCount(tuMonthP1);

        printf("\nmain: Month =>\n");
        TimeUnit* tuMonth = [TimeUnit Month];
        CJPrintMonthCount(tuMonth);

        printf("\n");
        printf("main: Year(3) has %lld months\n", (long long) [[TimeUnit Year:3] CalcMonth]);

        printf("\n");
        printf("main: TenYear() has %lld months\n", (long long) [[TimeUnit TenYear] CalcMonth]);
    }
    return 0;
}
