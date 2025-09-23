#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
# This source file is part of the Cangjie project, licensed under Apache-2.0
# with Runtime Library Exception.
#
# See https://cangjie-lang.cn/pages/LICENSE for license information.

"""Cangjie ObjectiveC interoperability build script"""
import argparse
import logging
import multiprocessing
import os
import platform
import shutil
import subprocess
import sys
from enum import Enum
from logging.handlers import TimedRotatingFileHandler
from subprocess import PIPE

IS_DARWIN = platform.system() == "Darwin"

BUILD_DIR = os.path.dirname(os.path.abspath(__file__))
HOME_DIR = os.path.dirname(BUILD_DIR)

OBJC_INTEROP_GEN_DIR = os.path.join(HOME_DIR, 'src', 'ObjCInteropGen')
CMAKE_BUILD_DIR = os.path.join(OBJC_INTEROP_GEN_DIR, 'build', 'build')
DEFAULT_INSTALL_DIR = os.path.join(HOME_DIR, 'dist')

INTEROPLIB_DIR = os.path.join(HOME_DIR, 'src', 'interoplib')
INTEROPLIB_OUT = os.path.join(INTEROPLIB_DIR, 'output')
DYLIB_EXT = "dylib" if IS_DARWIN else "so"
OBJC_INTEROP_THIRD_PARTY = os.path.join(HOME_DIR, 'third_party')

RELEASE = "release"
INTEROPLIB_NAME_IN_TOML = "interoplib"
OBJC_NAME_IN_TOML = "objc"
INTEROPLIB_OUT_PREFIX = os.path.join(INTEROPLIB_OUT, RELEASE, INTEROPLIB_NAME_IN_TOML)
OBJC_OUT_PREFIX = os.path.join(INTEROPLIB_OUT, RELEASE, OBJC_NAME_IN_TOML)

OUT_INTEROPLIB_COMMON_DYLIB = os.path.join(INTEROPLIB_OUT_PREFIX, f"libinteroplib.common.{DYLIB_EXT}")
OUT_INTEROPLIB_COMMON_A     = os.path.join(INTEROPLIB_OUT_PREFIX, "libinteroplib.common.a")
OUT_INTEROPLIB_COMMON_CJO   = os.path.join(INTEROPLIB_OUT_PREFIX, "interoplib.common.cjo")

OUT_INTEROPLIB_OBJC_DYLIB = os.path.join(INTEROPLIB_OUT_PREFIX, f"libinteroplib.objc.{DYLIB_EXT}")
OUT_INTEROPLIB_OBJC_A     = os.path.join(INTEROPLIB_OUT_PREFIX, "libinteroplib.objc.a")
OUT_INTEROPLIB_OBJC_CJO   = os.path.join(INTEROPLIB_OUT_PREFIX, "interoplib.objc.cjo")

OUT_OBJC_LANG_DYLIB = os.path.join(OBJC_OUT_PREFIX, f"libobjc.lang.{DYLIB_EXT}")
OUT_OBJC_LANG_A     = os.path.join(OBJC_OUT_PREFIX, "libobjc.lang.a")
OUT_OBJC_LANG_CJO   = os.path.join(OBJC_OUT_PREFIX, "objc.lang.cjo")

LOG_DIR = os.path.join(BUILD_DIR, 'logs')
LOG_FILE = os.path.join(LOG_DIR, 'ObjCInteropGen.log')

clang_path = shutil.which('clang')
clang_pp_path = shutil.which('clang++')
if not clang_path:
  LOG.error('clang is required to build cangjie compiler')
if not clang_pp_path:
  LOG.error('clang++ is required to build cangjie compiler')

os.environ['CC'] = clang_path
os.environ['CXX'] = clang_pp_path

def log_output(output):
    """log command output"""
    while True:
        line = output.stdout.readline()
        if not line:
            output.communicate()
            returncode = output.returncode
            if returncode != 0:
                LOG.error('build error: %d!\n', returncode)
                sys.exit(1)
            break
        try:
            LOG.info(line.decode('ascii', 'ignore').rstrip())
        except UnicodeEncodeError:
            LOG.info(line.decode('utf-8', 'ignore').rstrip())

def init_log(name):
    """init log config"""
    if not os.path.exists(LOG_DIR):
        os.makedirs(LOG_DIR)

    log = logging.getLogger(name)
    log.setLevel(logging.DEBUG)
    formatter = logging.Formatter(
        '[%(asctime)s:%(module)s:%(lineno)s:%(levelname)s] %(message)s')
    streamhandler = logging.StreamHandler(sys.stdout)
    streamhandler.setLevel(logging.DEBUG)
    streamhandler.setFormatter(formatter)
    log.addHandler(streamhandler)
    filehandler = TimedRotatingFileHandler(LOG_FILE,
                                           when='W6',
                                           interval=1,
                                           backupCount=60)
    filehandler.setLevel(logging.DEBUG)
    filehandler.setFormatter(formatter)
    log.addHandler(filehandler)
    return log

def runtime_name(target):
    return target+"_cjnative"

def fetch_tomlplusplus(target_dir):
    """Fetch tomlplusplus from GitHub if it doesn't exist"""
    tomlplusplus_dir = os.path.join(target_dir, 'tomlplusplus')
    if not os.path.exists(tomlplusplus_dir):
        LOG.info('Fetching tomlplusplus from GitHub...\n')
        output = subprocess.Popen(
            ["git", "clone", "--depth=1", "-b", "v3.4.0", "https://github.com/marzer/tomlplusplus.git",
             tomlplusplus_dir], stdout=PIPE,
        )
        log_output(output)
        LOG.info('Finished fetching tomlplusplus\n')
    else:
        LOG.info('tomlplusplus directory already exists, skipping fetch\n')

def build(args):
    """interoplib or objc-interop-gen build"""
    if args.target:
        runtime = runtime_name(args.target)
        LOG.info('begin build interoplib for ' + runtime + '\n')

        CJPM_CONFIG = "--cfg_darwin_objc" if IS_DARWIN else "--cfg_linux_objc"

        cjpm_env = os.environ.copy()
        # interoplib/cjpm.toml passes these _OPTION to cjc via CJPM_CONFIG
        if args.target_lib:
            cjpm_target = args.target_lib
            if cjpm_target == "ios-aarch64":
                cjpm_target = "arm64-apple-ios11"
            if cjpm_target == "ios-simulator-aarch64":
                cjpm_target = "arm64-apple-ios11-simulator"
            cjpm_env["TARGET_OPTION"] = "--target=" + cjpm_target
        if args.target_sysroot:
            cjpm_env["SYSROOT_OPTION"] = "--sysroot=" + args.target_sysroot
        # target_toolchain is not used for now

        output = subprocess.Popen(
            ["cjpm", "build", "--target-dir=" + INTEROPLIB_OUT, CJPM_CONFIG],
            env=cjpm_env,
            cwd=INTEROPLIB_DIR,
            stdout=PIPE,
        )
        log_output(output)

        LOG.info('end build interoplib for ' + runtime + '\n')
    else:
        LOG.info('begin build objc-interop-gen...\n')

        # Fetch tomlplusplus before building
        fetch_tomlplusplus(OBJC_INTEROP_THIRD_PARTY)

        output = subprocess.Popen(
            ["cmake", "-B", CMAKE_BUILD_DIR, '-DCMAKE_BUILD_TYPE=' + args.build_type.value],
            cwd=OBJC_INTEROP_GEN_DIR,
            stdout=PIPE,
        )
        log_output(output)

        output = subprocess.Popen(
            ["cmake", "--build", CMAKE_BUILD_DIR],
            cwd=OBJC_INTEROP_GEN_DIR,
            stdout=PIPE,
        )
        log_output(output)

        LOG.info('end build objc-interop-gen\n')


def clean(args):
    """clean build outputs and logs"""
    LOG.info("begin clean objc-interop-gen...\n")
    if os.path.isdir(CMAKE_BUILD_DIR):
        shutil.rmtree(CMAKE_BUILD_DIR, ignore_errors=True)
    LOG.info("end clean objc-interop-gen\n")

    LOG.info("begin clean interoplib...\n")
    output = subprocess.Popen(
        ["cjpm", "clean", "--target-dir=" + INTEROPLIB_OUT],
        cwd=INTEROPLIB_DIR,
        stdout=PIPE,
    )
    log_output(output)
    LOG.info("end clean interoplib\n")

def install(args):
    """install objc-interop-gen or interoplib"""
    install_path = os.path.abspath(args.install_prefix) if args.install_prefix else DEFAULT_INSTALL_DIR

    if args.target:
        # while cjpm does not support install command for libs, just copy to install them 
        runtime = runtime_name(args.target)
        LOG.info("begin install interoplib for " + runtime + "\n")

        DEST_DYLIB = os.path.join(install_path, "runtime", "lib", runtime)
        DEST_A = os.path.join(install_path, "lib", runtime)
        DEST_CJO = os.path.join(install_path, "modules", runtime)
        if not os.path.exists(DEST_DYLIB):
            os.makedirs(DEST_DYLIB)
        if not os.path.exists(DEST_A):
            os.makedirs(DEST_A)
        if not os.path.exists(DEST_CJO):
            os.makedirs(DEST_CJO)
        if os.path.isfile(OUT_INTEROPLIB_COMMON_DYLIB):
            shutil.copy2(OUT_INTEROPLIB_COMMON_DYLIB, DEST_DYLIB)
        if os.path.isfile(OUT_INTEROPLIB_OBJC_DYLIB):
            shutil.copy2(OUT_INTEROPLIB_OBJC_DYLIB, DEST_DYLIB)
        if os.path.isfile(OUT_OBJC_LANG_DYLIB):
            shutil.copy2(OUT_OBJC_LANG_DYLIB, DEST_DYLIB)
        if os.path.isfile(OUT_INTEROPLIB_COMMON_A):
            shutil.copy2(OUT_INTEROPLIB_COMMON_A, DEST_A)
        if os.path.isfile(OUT_INTEROPLIB_OBJC_A):
            shutil.copy2(OUT_INTEROPLIB_OBJC_A, DEST_A)
        if os.path.isfile(OUT_OBJC_LANG_A):
            shutil.copy2(OUT_OBJC_LANG_A, DEST_A)
        if os.path.isfile(OUT_INTEROPLIB_COMMON_CJO):
            shutil.copy2(OUT_INTEROPLIB_COMMON_CJO, DEST_CJO)
        if os.path.isfile(OUT_INTEROPLIB_OBJC_CJO):
            shutil.copy2(OUT_INTEROPLIB_OBJC_CJO, DEST_CJO)
        if os.path.isfile(OUT_OBJC_LANG_CJO):
            shutil.copy2(OUT_OBJC_LANG_CJO, DEST_CJO)

        LOG.info("end install interoplib for " + runtime + "\n")
    else:
        LOG.info("begin install objc-interop-gen...")

        output = subprocess.Popen(
            ["cmake", "--install", CMAKE_BUILD_DIR, "--prefix", install_path],
            cwd=OBJC_INTEROP_GEN_DIR,
            stdout=PIPE,
        )
        log_output(output)
        if output.returncode != 0:
            LOG.fatal("install failed")

        LOG.info("end install objc-interop-gen")

class BuildType(Enum):
    """CMAKE_BUILD_TYPE options"""
    debug = 'Debug'
    release = 'Release'

    def __str__(self):
        return self.name

    def __repr__(self):
        return str(self)

    @staticmethod
    def argparse(s):
        try:
            return BuildType[s]
        except KeyError:
            return s

def main():
    """build entry"""
    parser = argparse.ArgumentParser(description='build Objective-C binding generator or interoplib')
    subparsers = parser.add_subparsers(help='sub command help')
    parser_build = subparsers.add_parser('build', help='build Objective-C binding generator or interoplib')
    parser_build.add_argument('-t',
                              '--build-type',
                              type=BuildType.argparse,
                              dest='build_type',
                              default=BuildType.release,
                              choices=list(BuildType),
                              help='select target build type')
    parser_build.add_argument(
        "--target", dest="target", type=str,
        help="build interoplib for the specified target"
    )
    parser_build.add_argument(
        "--target-lib", dest="target_lib", type=str,
        help="when build interoplib, use the specified target triple"
    )
    parser_build.add_argument(
        "--target-toolchain", dest="target_toolchain", type=str,
        help="when build interoplib, use the tools under the given path to cross-compile (should point to bin directory)"
    )
    parser_build.add_argument(
        "--target-sysroot", dest="target_sysroot", type=str,
        help="when build interoplib, pass this argument to the compilers as --sysroot"
    )
    parser_build.set_defaults(func=build)

    parser_install = subparsers.add_parser("install", help="install Objective-C binding generator or interoplib")
    parser_install.add_argument(
        "--target", dest="target", type=str,
        help="install interoplib for the specified target"
    )
    parser_install.add_argument('--prefix',
                            dest='install_prefix',
                            help='target install prefix')
    parser_install.set_defaults(func=install)

    parser_clean = subparsers.add_parser("clean", help="clean for both Objective-C binding generator and interoplib")
    parser_clean.set_defaults(func=clean)

    args = parser.parse_args()
    if not hasattr(args, 'func'):
        args = parser.parse_args(['build'] + sys.argv[1:])

    args.func(args)

if __name__ == '__main__':
    LOG = init_log('root')
    os.environ['LANG'] = "C.UTF-8"
    main()
