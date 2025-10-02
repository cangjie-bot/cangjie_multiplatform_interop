#!/usr/bin/env bash
# Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
# This source file is part of the Cangjie project, licensed under Apache-2.0
# with Runtime Library Exception.
#
# See https://cangjie-lang.cn/pages/LICENSE for license information.
set -e

# Add example directory here, supported examples must contain origin-objc folder
EXAMPLES=(
    1-simple
    2-string-parameter
    ctor_without_params
    field
    method_without_params
    mirror_inherit_from_mirror
    prop
    objc_pointer
)

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
INTEROPLIB_TARGET_PATH=../../../target
INTEROPLIB_DYLIB_PATH="$INTEROPLIB_TARGET_PATH"/release/interoplib
OBJ_C_LANG_DYLIB_PATH="$INTEROPLIB_TARGET_PATH"/release/objc

MODES=(origin-objc mock real)
MODE=real

build_interoplib() {
    printf "Building interoplib.objc and objc.lang...\n"

    cd ../

    cjpm build --cfg_"$OS_FAMILY"_objc

    cd - > /dev/null

    printf "interoplib.objc and objc.lang were built successfully!\n"
}

clean_example() {
    printf "Cleaning \"%s\" example old artifacts...\n" "$1"

    cd "$1"

    rm -rf build out

    cd - > /dev/null

    printf "\"%s\" example was cleaned successfully!\n" "$1"
}

build_example_origin_objc() {
    printf "Building \"%s\" example...\n" "$1"

    cd "$1"

    mkdir build
    mkdir out

    cp origin-objc/* build/

    if [ "$OS_FAMILY" = "darwin" ]; then
        clang -fmodules -fobjc-arc build/*.m -o out/main -I. -Lout
    else
        # shellcheck disable=SC2046
        clang-10 $(gnustep-config --objc-flags) $(gnustep-config --base-libs) -fobjc-arc build/*.m -o out/main -I. -Lout
    fi

    cd - > /dev/null
    printf "\"%s\" example was built successfully!\n" "$1"
}

build_example() {
    printf "Building \"%s\" example...\n" "$1"

    cd "$1"

    mkdir -p build/cjworld build/objc-gen
    mkdir out

    cp origin-objc/* build/

    if [ "$MODE" = "real" ]; then
        cp -r cjworld build/
    else
        cp -r generated/objc-gen build/
        cp -r generated/cjworld build/
    fi

    cd build

    cjc --output-type=dylib --int-overflow=wrapping cjworld/* -o ../out/ -L"$INTEROPLIB_DYLIB_PATH" -L"$OBJ_C_LANG_DYLIB_PATH" --import-path="$INTEROPLIB_DYLIB_PATH" --import-path="$OBJ_C_LANG_DYLIB_PATH" -linteroplib.common -lobjc.lang -linteroplib.objc

    # crutch to replace *.dylib to *.so when loading cj libraries
    [ "$OS_FAMILY" = "linux" ] && sed -i "s/\.dylib/\.so/g" objc-gen/*

    cp -f objc-gen/* .

    if [ "$OS_FAMILY" = "darwin" ]; then
        clang -fmodules -fobjc-arc *.m -o ../out/main -I"$CANGJIE_RUNTIME_INCLUDE_PATH" -I. -L../out -lcangjie-runtime -lcjworld -L"$CANGJIE_RUNTIME_LIB_PATH"
    else
        # shellcheck disable=SC2046
        clang-10 $(gnustep-config --objc-flags) $(gnustep-config --base-libs) *.m -o ../out/main -I"$CANGJIE_RUNTIME_INCLUDE_PATH" -I. -L../out -ldl -lcangjie-runtime -lcjworld -L"$CANGJIE_RUNTIME_LIB_PATH"
    fi

    cd ../../ > /dev/null
    printf "\"%s\" example was built successfully!\n" "$1"
}

run_example() {
    printf "Running \"%s\" example...\n" "$1"

    cd "$1"/out
    DYLD_LIBRARY_PATH="./:$OBJ_C_LANG_DYLIB_PATH:$INTEROPLIB_DYLIB_PATH:$CANGJIE_RUNTIME_LIB_PATH:$DYLD_LIBRARY_PATH" LD_LIBRARY_PATH="./:$OBJ_C_LANG_DYLIB_PATH:$INTEROPLIB_DYLIB_PATH:$CANGJIE_RUNTIME_LIB_PATH:$LD_LIBRARY_PATH" ./main
    cd - > /dev/null

    printf "\"%s\" example was runned successfully!\n" "$1"
}

print_run_help() {
    examples_str=$(
        IFS="|"
        echo "${EXAMPLES[*]}"
    )

    modes_str=$(
        IFS="|"
        echo "${MODES[*]}"
    )

    cat <<EOF
Run examples.
This command runs all examples one by one.

If some '--example <value>' are specified, then only enumerated examples will be executed.
Note: unknown examples are skipped.

If '--mode origin-objc' option is set, then script will only use handwritten Objective-C source files.
Note 1: Objective-C files are expected to be found in the <example>/origin-objc directory.
Note 2: Interoplib won't build in this mode.

If '--mode mock' option is set, then script will use handwritten Cangjie and Objective-C source files, which emulate the expected behaviour from cjc-frontend.
Note: mock files are expected to be found in the <example>/generated directory.

If '--mode real' option is set, then script will Cangjie files with annotations and Objective-C source files, generated by cjc-frontend.
Note: Cangjie files are expected to be found in the <example>/cjworld directory.

Usage:
    ./examples.sh run [option]

Available options:
    -h, --help      print this message
    --example <$examples_str>       run the specified example
    --mode <$modes_str>     run mode, defaults to "real".
EOF
}

check_example() {
    printf "%s\0" "${EXAMPLES[@]}" | grep -Fxqz -- "$1"
}

check_mode() {
    printf "%s\0" "${MODES[@]}" | grep -Fxqz -- "$1"
}

run() {
    example_option_provided=no
    chosen=()

    while [ -n "$1" ]
    do

    case "$1" in
        -h|--help)
            print_run_help
            return 0
            ;;
        --example)
            if check_example "$2"; then
                chosen+=("$2")
                example_option_provided=yes
            else
                printf "Warning: %s is an unknown example, skipped\n" "$2"
            fi
            shift
            ;;
        --mode)
            if check_mode "$2"; then
                MODE=$2
            else
                printf "Warning: %s is an unknown mode, aborting...\n" "$2"
                return 1
            fi
            shift
            ;;
        *)
            printf "Error: %s is an unknown option.\n" "$1"
            return 1
            ;;
    esac

    shift
    done

    if [ -z "${chosen[*]}" ] && [ "$example_option_provided" = "yes" ]; then
        printf "No valid examples provided, exiting..."
        return 1
    elif [ -z "${chosen[*]}" ]; then
        chosen=("${EXAMPLES[@]}")
    fi

    [ "$MODE" != "origin-objc" ] && build_interoplib && printf "\n"

    printf "The following examples are chosen for run:\n"
    for cur in "${chosen[@]}"
    do
        printf "%s\n" "$cur"
    done
    printf "\n"

    for cur in "${chosen[@]}"
    do
        if [ ! -d "$cur/origin-objc" ]; then
            echo "Warning: $cur example is not supported (not a cj2oc example)."
            continue # skip it
        fi
        printf "Processing \"%s\" example...\n" "$cur"

        clean_example "$cur"
        if [ "$MODE" = "origin-objc" ]; then
            build_example_origin_objc "$cur"
        else
            build_example "$cur"
        fi
        run_example "$cur"

        printf "\"%s\" example processed successfully!\n\n" "$cur"
    done
}

print_main_help() {
    cat <<EOF
Interop with Objective-C examples

Usage:
    ./examples-cj2oc.sh [command] [option]

Available commands:
    run             Run examples

Available options:
    -h, --help      print this message

Use "./examples-cj2oc.sh [command] --help" for more information about a command.
EOF
}

main() {
    case $1 in
        run)
            shift
            run "$@"
            ;;
        -h|--help|*)
            print_main_help
            ;;

    esac
}

main "$@"
