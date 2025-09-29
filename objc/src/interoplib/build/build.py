# Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
# This source file is part of the Cangjie project, licensed under Apache-2.0
# with Runtime Library Exception.
#
# See https://cangjie-lang.cn/pages/LICENSE for license information.

import argparse
import os
import platform
import shutil
import subprocess
import traceback

HOME_DIR = os.path.dirname(os.path.abspath(__file__))
BUILD_DIR = os.path.join(HOME_DIR, "output")

INTEROPLIB_DIR = os.path.dirname(HOME_DIR)
INTEROPLIB_COMMON_PKG_DIR = os.path.join(INTEROPLIB_DIR, "src", "common")
INTEROPLIB_OBJC_PKG_DIR = os.path.join(INTEROPLIB_DIR, "src", "objc")

def build(args):
    IS_DARWIN = platform.system() == "Darwin"

    if IS_DARWIN:
        DYLIB_EXT="dylib"
    else:
        DYLIB_EXT="so"

    OUT_INTEROPLIB_COMMON_DYLIB=f"libinteroplib.common.{DYLIB_EXT}"
    OUT_INTEROPLIB_COMMON_A="libinteroplib.common.a"
    OUT_INTEROPLIB_COMMON_CJO="interoplib.common.cjo"

    OUT_INTEROPLIB_OBJC_DYLIB=f"libinteroplib.objc.{DYLIB_EXT}"
    OUT_INTEROPLIB_OBJC_A="libinteroplib.objc.a"
    OUT_INTEROPLIB_OBJC_CJO="interoplib.objc.cjo"

    ARGS_COMMON=("--int-overflow", "wrapping")
    if IS_DARWIN:
        ARGS_DYLIB=(*ARGS_COMMON, "--output-type", "dylib", "-L.", "-lobjc", "-o")
    else:
        ARGS_DYLIB=(*ARGS_COMMON, "--output-type", "dylib", "-L.", "-o")

    ARGS_A=(*ARGS_COMMON, "--output-type", "staticlib", "-o")
    XCRUN=("xcrun", "codesign", "--sign", "-")
    CJC="cjc"
    INSTALL_NAME_TOOL="install_name_tool"

    TARGET_ARGS = []
    
    if args.target:
        TARGET_ARGS += ["--target", args.target]

    if args.target_sysroot:
        TARGET_ARGS += ["--sysroot", args.target_sysroot]

    if os.path.exists(BUILD_DIR):
        shutil.rmtree(BUILD_DIR)
    os.makedirs(BUILD_DIR)
    os.chdir(BUILD_DIR)

    ok = set()
    expected = 0

    if args.dynamic:
        expected += 1
        try:
            subprocess.run([CJC, "-p", INTEROPLIB_COMMON_PKG_DIR, *TARGET_ARGS, *ARGS_DYLIB, OUT_INTEROPLIB_COMMON_DYLIB], check=True)
            if IS_DARWIN:
                subprocess.run([INSTALL_NAME_TOOL, "-id", "@rpath/" + OUT_INTEROPLIB_COMMON_DYLIB, OUT_INTEROPLIB_COMMON_DYLIB], check=True)
                subprocess.run([*XCRUN, OUT_INTEROPLIB_COMMON_DYLIB], check=True)

            ok.add("interoplib.common-dynamic")
        except Exception:
            traceback.print_exc()

    if args.static:
        expected += 1
        try:
            subprocess.run([CJC, "-p", INTEROPLIB_COMMON_PKG_DIR, *TARGET_ARGS, *ARGS_A, OUT_INTEROPLIB_COMMON_A], check=True)
            ok.add("interoplib.common-static")
        except Exception:
            traceback.print_exc()

    if args.dynamic:
        expected += 1
        try:
            subprocess.run([CJC, "-p", INTEROPLIB_OBJC_PKG_DIR, "-linteroplib.common", *TARGET_ARGS, *ARGS_DYLIB, OUT_INTEROPLIB_OBJC_DYLIB], check=True)
            if IS_DARWIN:
                subprocess.run([INSTALL_NAME_TOOL, "-id", "@rpath/" + OUT_INTEROPLIB_OBJC_DYLIB, OUT_INTEROPLIB_OBJC_DYLIB], check=True)
                subprocess.run([*XCRUN, OUT_INTEROPLIB_OBJC_DYLIB], check=True)

            ok.add("interoplib.objc-dynamic")
        except Exception:
            traceback.print_exc()

    if args.static:
        expected += 1
        try:
            subprocess.run([CJC, "-p", INTEROPLIB_OBJC_PKG_DIR, *TARGET_ARGS, *ARGS_A, OUT_INTEROPLIB_OBJC_A], check=True)
            ok.add("interoplib.objc-static")
        except Exception:
            traceback.print_exc()

    if args.install_prefix:
        assert args.runtime
        DEST_DYLIB = os.path.join(args.install_prefix, "runtime", "lib", args.runtime)
        DEST_A = os.path.join(args.install_prefix, "lib", args.runtime)
        DEST_CJO = os.path.join(args.install_prefix, "modules", args.runtime)
        if "interoplib.common-dynamic" in ok:
            shutil.copy2(OUT_INTEROPLIB_COMMON_DYLIB, DEST_DYLIB)
        if "interoplib.objc-dynamic" in ok:
            shutil.copy2(OUT_INTEROPLIB_OBJC_DYLIB, DEST_DYLIB)
        if "interoplib.common-static" in ok:
            shutil.copy2(OUT_INTEROPLIB_COMMON_A, DEST_A)
        if "interoplib.objc-static" in ok:
            shutil.copy2(OUT_INTEROPLIB_OBJC_A, DEST_A)
        if ("interoplib.common-dynamic" in ok) or ("interoplib.common-static" in ok):
            shutil.copy2(OUT_INTEROPLIB_COMMON_CJO, DEST_CJO)
        if ("interoplib.objc-dynamic" in ok) or ("interoplib.objc-static" in ok):
            shutil.copy2(OUT_INTEROPLIB_OBJC_CJO, DEST_CJO)

    assert len(ok) == expected


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Objective-C interop library build script"
    )
    parser.add_argument(
        "--install-prefix", dest="install_prefix", type=str,
        help="install into specified Cangjie SDK root directory"
    )
    parser.add_argument(
        "--target", dest="target", type=str,
        help="build for the specified target triple"
    )
    parser.add_argument(
        "--target-toolchain", dest="target_toolchain", type=str,
        help="use the tools under the given path to cross-compile (should point to bin directory)"
    )
    parser.add_argument(
        "--target-sysroot", dest="target_sysroot", type=str,
        help="pass this argument to the compilers as --sysroot"
    )
    parser.add_argument(
        "--runtime", dest="runtime", type=str,
        help="install into specified runtime directories"
    )
    def flag(name: str, description: str):
        group = parser.add_mutually_exclusive_group()
        group.add_argument(
            f"--{name}", dest=name, action="store_true", default=True,
            help=description
        )
        group.add_argument(
            f"--no-{name}", dest=name, action="store_false",
            help=f"do not {description}"
        )
    flag("static", description="build static libraries")
    flag("dynamic", description="build dynamic libraries")
    args = parser.parse_args()

    if args.target == "ios-aarch64":
        args.target = "arm64-apple-ios11"
    if args.target == "ios-simulator-aarch64":
        args.target = "arm64-apple-ios11-simulator"

    build(args)
