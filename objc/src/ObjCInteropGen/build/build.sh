#!/bin/bash
# Copyright Huawei Technologies Co., Ltd. 2025. All rights reserved.

#sudo apt -y install clang libclang-dev

BACK=$(pwd)
BUILD="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
OUT=${BUILD}/output

cd ${BUILD}/..

cmake -B ${OUT}
cmake --build ${OUT}

cd ${BACK}
