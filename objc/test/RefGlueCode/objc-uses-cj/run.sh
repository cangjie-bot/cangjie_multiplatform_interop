#!/usr/bin/env bash
# Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
# This source file is part of the Cangjie project, licensed under Apache-2.0
# with Runtime Library Exception.
#
# See https://cangjie-lang.cn/pages/LICENSE for license information.

set -e

# The script builds and runs the reference glue-code cases for scenario ObjC => Cangjie
# Each case provides the following folder structure:
# <case-name>
#   |
#   - api               original code in Cangjie to be used by ObjC application
#   |
#   - app               main in ObjC (application)
#   |
#   - generated         manually written reference glue-code


get_os_family() {
    unameOut="$(uname -s)"
    case "$unameOut" in
        Linux*)
            echo "linux"
            return 0
            ;;
        Darwin*)
            echo "darwin"
            return 0
            ;;
    esac

    return 1
}
OS_FAMILY=$(get_os_family)

get_hwarch() {
    unameOut="$(uname -m)"
    if [ -z "$unameOut" ]; then
        echo "x86_64"
    elif [ "$unameOut" = "arm64" ] && [ "$OS_FAMILY" = "darwin" ]; then
        echo "aarch64"
    else
        echo "$unameOut"
    fi
}
HWARCH=$(get_hwarch)

CANGJIE_RUNTIME_LIB_PATH="$CANGJIE_HOME"/runtime/lib/"$OS_FAMILY"_"$HWARCH"_cjnative
CANGJIE_RUNTIME_INCLUDE_PATH="$CANGJIE_HOME"/include

clean_example() {
    printf "Cleaning \"%s\" example old artifacts...\n" "$1"

    cd "$1"

    rm -rf build out

    cd - > /dev/null

    printf "\"%s\" example was cleaned successfully!\n" "$1"
}

build_example() {
    printf "Building \"%s\" example...\n" "$1"

    cd "$1"

    mkdir out

    # api/*.cj => out/libapi.dylib
    cjc --output-type=dylib --int-overflow=wrapping api/*.cj -o out/

    # generated/*.cj + libapi => out/libcjworld.dylib
    cjc --output-type=dylib --int-overflow=wrapping generated/*.cj --import-path out -Lout -lapi -o out/ \
        -linteroplib.common -lobjc.lang -linteroplib.objc

    # RefGlueCode/_common/*.cj => out/libinteroptest.dylib
    cjc --output-type=dylib --int-overflow=wrapping ../../_common/*.cj -o out/libinteroptest.dylib

    # crutch to replace *.dylib to *.so when loading cj libraries
    touch out/KEEP_DIR
    [ "$OS_FAMILY" = "linux" ] && sed -i "s/\.dylib/\.so/g" out/*

    # app/*.m + generated/*.m + libinteroptest + libapi + libcjworld => out/main
    if [ "$OS_FAMILY" = "darwin" ]; then
        # ARC is always OFF for glue-code
        # use ARC_MACRO to setup if [super dealloc] should be called in CJMirror classes
        [ "test$ARCOFF" != "test" ] && ARC_MACRO="-D CALL_SUPER_DEALLOC=1" || ARC_MACRO=""
        clang -fmodules $ARC_MACRO -shared -undefined dynamic_lookup generated/*.m -o out/libgluecode.dylib -I"$CANGJIE_RUNTIME_INCLUDE_PATH" -Igenerated -lcangjie-runtime -L"$CANGJIE_RUNTIME_LIB_PATH"

        # for app code ARC is ON by default, export ARCOFF with some value to turn it OFF
        [ "test$ARCOFF" != "test" ] && ARC="" || ARC="-fobjc-arc"
        clang -fmodules $ARC app/*.m -o out/main -I"$CANGJIE_RUNTIME_INCLUDE_PATH" -Iapp -Igenerated -Lout -lcangjie-runtime -linteroptest -lapi -lcjworld -lgluecode -L"$CANGJIE_RUNTIME_LIB_PATH"
    else
        # shellcheck disable=SC2046
        clang-10 $(gnustep-config --objc-flags) $(gnustep-config --base-libs) app/*.m generated/*.m -o out/main -I"$CANGJIE_RUNTIME_INCLUDE_PATH" -Iapp -Igenerated -Lout -ldl -lcangjie-runtime -lapi -lcjworld -L"$CANGJIE_RUNTIME_LIB_PATH"
    fi

    cd ../ > /dev/null
    printf "\"%s\" example was built successfully!\n" "$1"
}

run_example() {
    printf "Running \"%s\" example...\n" "$1"

    cd "$1"/out
    DYLD_LIBRARY_PATH="./:$CANGJIE_RUNTIME_LIB_PATH:$DYLD_LIBRARY_PATH" LD_LIBRARY_PATH="./:$CANGJIE_RUNTIME_LIB_PATH:$LD_LIBRARY_PATH" ./main
    cd - > /dev/null

    printf "\"%s\" example was runned successfully!\n" "$1"
}

run() {
    cur="$1"

    if [ ! -d "$cur/api" ] || [ ! -d "$cur/app" ] || [ ! -d "$cur/generated" ]; then
        echo "Error: $cur case is not formed properly."
        exit 1
    fi

    printf "Processing \"%s\" example...\n" "$cur"

    clean_example "$cur"
    build_example "$cur"
    run_example "$cur"

    printf "\"%s\" example processed successfully!\n\n" "$cur"
}

print_main_help() {
    cat <<EOF
Interop with Objective-C reference glue-code case runner

Usage:
    ./run.sh [case name]

Available options:
    -h, --help      print this message

Use "./examples-oc2cj.sh [command] --help" for more information about a command.
EOF
}

main() {
    case $1 in
        -h|--help)
            print_main_help
            ;;
        *)
            run "$@"
            ;;

    esac
}

main "$@"
