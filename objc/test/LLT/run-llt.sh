#!/bin/sh

# Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
# This source file is part of the Cangjie project, licensed under Apache-2.0
# with Runtime Library Exception.
#
# See https://cangjie-lang.cn/pages/LICENSE for license information.


BASE="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
FRAMEWORK=${BASE}/../../../../cangjie_test_framework

BUILD=${BASE}/build
TMP=${BUILD}/test_tmp
mkdir -p ${TMP}
cd ${BUILD}

# TODO check ${FRAMEWORK} with framework/main.py inside is available

python3 ${FRAMEWORK}/main.py --fail_exit -pFAIL -pPASS --fail-verbose --debug ../ \
--temp_dir=${TMP} --json_output=${TMP}/run_result.json -j7 \
--test_cfg=../interop_test.cfg --test_list=../testlist

cd ${BASE}

