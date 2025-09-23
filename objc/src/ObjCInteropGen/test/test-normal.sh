# Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
# This source file is part of the Cangjie project, licensed under Apache-2.0
# with Runtime Library Exception.
#
# See https://cangjie-lang.cn/pages/LICENSE for license information.

#!/bin/bash

rm -r generated
../build/output/ObjCInteropGen test.toml --mode=normal
cp main.cj generated/objc/foundation
cjc-frontend generated/objc/foundation/*.cj -Woff unused -Woff parser
