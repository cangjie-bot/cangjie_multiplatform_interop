#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
# This source file is part of the Cangjie project, licensed under Apache-2.0
# with Runtime Library Exception.
#
# See https://cangjie-lang.cn/pages/LICENSE for license information.

"""Cangjie Java interoperability build script"""
import argparse
import glob
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
IS_WINDOWS = platform.system() == "Windows"
JAVA_HOME = os.environ['JAVA_HOME']
JAVA_INCLUDE = os.path.join(JAVA_HOME, 'include')
JAVA_INCLUDE_ARCH = os.path.join(JAVA_INCLUDE, 'darwin') if IS_DARWIN else os.path.join(JAVA_INCLUDE, 'win32') if IS_WINDOWS else os.path.join(JAVA_INCLUDE, 'linux')

CJ_HOME = os.environ['CANGJIE_HOME']
CJ_RUNTIME_LIB = os.path.join(CJ_HOME, 'runtime', 'lib')

BUILD_DIR = os.path.dirname(os.path.abspath(__file__))
HOME_DIR = os.path.dirname(BUILD_DIR)

MIRROR_GEN_DIR = os.path.join(HOME_DIR, 'src', 'java-mirror-gen')
DIST_DIR = os.path.join(HOME_DIR, 'dist')
DEFAULT_INSTALL_DIR = os.path.join(DIST_DIR, 'install')

INTEROPLIB_DIR = os.path.join(HOME_DIR, 'src', 'interoplib')
LIBRARY_LOADER_JAR = "library-loader.jar"
JAVA_INTEROP_THIRD_PARTY = os.path.join(MIRROR_GEN_DIR, 'third_party')

OUT_INTEROPLIB_CJO = os.path.join(DIST_DIR, "interoplib.interop.cjo")
OUT_JAVA_LANG_CJO = os.path.join(DIST_DIR, "java.lang.cjo")

LOG_DIR = os.path.join(BUILD_DIR, 'logs')
LOG_FILE = os.path.join(LOG_DIR, 'JavaInterop.log')

CJC_BASE_ARGS = ["--strip-all", "-O2", "--output-dir=" + DIST_DIR, "--int-overflow=wrapping", "--import-path=" + DIST_DIR, "-L" + DIST_DIR]

CJC_STATIC_ARGS = [*CJC_BASE_ARGS, "--output-type=staticlib"]

CJC_DYLIB_ARGS = [*CJC_BASE_ARGS, "--output-type=dylib"]
if not IS_DARWIN:
    CJC_DYLIB_ARGS += ["--link-options", "-z relro", "--link-options", "-z now"]

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

def fatal(message):
    """Log the message as CRITICAL and raise Exception with the same message"""
    LOG.critical(message)
    raise Exception(message)

def command(*args, cwd=None, env=None):
    """Execute a child program via 'subprocess.Popen' and log the output"""
    output = subprocess.Popen(args, stdout=PIPE, cwd=cwd, env=env)
    log_output(output)
    if output.returncode:
        fatal('"' + ' '.join(args) + '" returned ' + output.returncode)

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

def lib_pref(target):
    if "windows" in target:
        return ""
    else:
        return "lib"

def dylib_ext(target):
    if "darwin" in target or "ios" in target:
        return "dylib"
    elif "windows" in target:
        return "dll"
    else:
        return "so"

def staticlib_ext(target):
    # Windows MinGW uses .a, not .lib
    return "a"

def object_ext(target):
    # Windows MinGW uses .o, not .obj
    return "o"

def copy_with_exclusions(src, dst, exclusions):
    """Copy the folder while excluding specified files and folders"""
    os.makedirs(dst, exist_ok=True)

    # Traverse the source directory tree
    for root, dirs, files in os.walk(src):
        # Calculate the relative path
        rel_root = os.path.relpath(root, src)

        # Check if the current directory is in the exclusion list.
        skip_dir = False
        for exclusion in exclusions:
            if rel_root == exclusion or rel_root.startswith(exclusion + os.sep):
                skip_dir = True
                break

        if skip_dir:
            # Remove subdirectories from the traversal
            dirs[:] = []
            continue

        # Creating a target directory
        dest_dir = os.path.join(dst, rel_root)
        os.makedirs(dest_dir, exist_ok=True)

        # Copy files
        for file in files:
            src_file = os.path.join(root, file)
            dest_file = os.path.join(dest_dir, file)

            # Check if the file is in the exclusion list
            rel_file = os.path.join(rel_root, file)
            skip_file = False
            for exclusion in exclusions:
                if rel_file == exclusion or rel_file.startswith(exclusion + os.sep):
                    skip_file = True
                    break

            if not skip_file:
                shutil.copy2(src_file, dest_file)

def fetch_jdk(target_dir):
    """Download only required folders from bishengjdk-21 repository"""
    repo_url = "https://gitee.com/openeuler/bishengjdk-21"
    tag_name = "jdk-21.0.8-ga-b011"
    required_folders_src = ["jdk.compiler", "java.compiler"]
    required_folders_tools = ["anttasks", "compileproperties", "propertiesparser"]

    # Define files and folders to exclude
    exclusions_src = {
        "java.compiler": [
            "share/classes/module-info.java"
        ],
        "jdk.compiler": [
            "share/classes/com/sun/tools/javac/launcher",
            "share/classes/jdk",
            "share/classes/module-info.java",
            "share/classes/sun",
            "share/data",
            "share/man"
        ]
    }

    exclusions_tools = {
        "anttasks": [
            "DumpClassesTask.java",
            "GenStubsTask.java",
            "SelectToolTask.java"
        ]
    }

    # Creating a target directory
    jdk_src_dir = os.path.join(target_dir, "jdk", "src")
    jdk_tools_dir = os.path.join(target_dir, "jdk", "make", "langtools", "tools")
    clone_dir = os.path.join(target_dir, "bishengjdk-21")

    if not os.path.exists(clone_dir) and not os.path.exists(jdk_src_dir):
        # Download the BishengJDK
        LOG.info(f'Cloning bishengjdk-21 repository (tag: {tag_name})...\n')
        output = subprocess.run(
            ["git", "clone", "--depth=1", "-b", tag_name, repo_url, clone_dir],
            stdout=PIPE,
        )

    if not os.path.exists(jdk_src_dir):
        # Source directory exists
        if not os.path.exists(clone_dir):
            LOG.error(f"Source directory does not exist: {clone_dir}")

        # Target durectory exists
        os.makedirs(jdk_src_dir, exist_ok=True)
        LOG.info(f"The target directory has been created: {jdk_src_dir}")
        # Traverse and copy the required folders
        for folder in required_folders_src:
            src_path = os.path.join(clone_dir, "src", folder)
            dest_path_src = os.path.join(jdk_src_dir, folder)
            dest_path_tools = os.path.join(jdk_tools_dir, folder)
            if not os.path.exists(src_path):
                LOG.error(f"The required folder does not exist: {src_path}")
                continue

            # If the target folder already exists, delete it first
            if os.path.exists(dest_path_src):
                LOG.info(f"The target folder already exists and is being deleted: {dest_path_src}")
                shutil.rmtree(dest_path_src)

            # Copy folder
            LOG.info(f"Copying: {src_path} -> {dest_path_src}")
            copy_with_exclusions(src_path, dest_path_src, exclusions_src.get(folder, []))
            LOG.info(f"Copy Successfully: {folder}")

        for folder in required_folders_tools:
            src_path = os.path.join(clone_dir, "make", "langtools", "tools", folder)
            dest_path_tools = os.path.join(jdk_tools_dir, folder)
            if not os.path.exists(src_path):
                LOG.error(f"The required folder does not exist: {src_path}")
                continue

            # If the target folder already exists, delete it first
            if os.path.exists(dest_path_tools):
                LOG.info(f"The target folder already exists and is being deleted: {dest_path_tools}")
                shutil.rmtree(dest_path_tools)

            # Copy folder
            LOG.info(f"Copying: {src_path} -> {dest_path_tools}")
            copy_with_exclusions(src_path, dest_path_tools, exclusions_tools.get(folder, []))
            LOG.info(f"Copy Successfully: {folder}")

        LOG.info(f"Delete temporary clone directory: {clone_dir}")
        shutil.rmtree(clone_dir)
        # Apply Jdk_interop specific modification
        """Apply a patch file to the target directory"""
        patch_path = os.path.join(JAVA_INTEROP_THIRD_PARTY, "jdk_interop.patch")
        if os.path.exists(patch_path):
            patch_cmd = f"patch -p1 -l -f < {patch_path}"
            LOG.info("CMDPATH: %s", HOME_DIR)
            patch_process = subprocess.run(patch_cmd, shell=True, stdout=PIPE, cwd=HOME_DIR, check=True)
            LOG.info('Patch applied successfully')
        else:
            LOG.info("Warning: jdk_interop.patch not found at %s", HOME_DIR)
    else:
        LOG.info('jdk directory already exists, skipping fetch\n')

def build(args):
    """Java binding generator or interoplib build"""
    """ target-lib is a marker that interoplib should be built """
    if args.target_lib:
        LOG.info('begin build interoplib for ' + args.target_lib + '\n')

        LIB_PREF = lib_pref(args.target_lib)
        DYLIB_EXT = dylib_ext(args.target_lib)
        OBJECT_EXT = object_ext(args.target_lib)
        STATICLIB_EXT = staticlib_ext(args.target_lib)
        OUT_CINTEROPLIB_O = os.path.join(DIST_DIR, f"{LIB_PREF}cinteroplib.{OBJECT_EXT}")
        OUT_INTEROPLIB_A = os.path.join(DIST_DIR, f"{LIB_PREF}interoplib.interop.{STATICLIB_EXT}")

        if not os.path.exists(DIST_DIR):
            os.makedirs(DIST_DIR)

        #clang c_core.c
        clang_args = ["-D_XOPEN_SOURCE=600"] if IS_DARWIN else []
        clang_args += ["-fstack-protector-strong", "-fPIC"]
        clang_args += ["-I" + JAVA_INCLUDE, "-I" + JAVA_INCLUDE_ARCH]
        clang_args += ["-c", "c_core.c"]
        clang_args += ["-o", OUT_CINTEROPLIB_O]

        if args.target:
            clang_args += ["--target=" + args.target]
        if args.target_sysroot:
            clang_args += ["-isysroot", args.target_sysroot]

        command(
            "clang", *clang_args,
            cwd=INTEROPLIB_DIR,
        )

        cjc_static_args = list(CJC_STATIC_ARGS)
        cjc_dylib_args = list(CJC_DYLIB_ARGS)
        if args.target:
            arg = ["--target=" + args.target]
            cjc_static_args += arg
            cjc_dylib_args += arg
        if args.target_sysroot:
            arg = ["--sysroot", args.target_sysroot]
            cjc_static_args += arg
            cjc_dylib_args += arg
        if args.target_toolchain:
            arg = ["-B", args.target_toolchain]
            cjc_static_args += arg
            cjc_dylib_args += arg

        #cjc jni.cj registry.cj
        command(
            "cjc", *cjc_static_args, OUT_CINTEROPLIB_O, "jni.cj", "registry.cj",
            cwd=INTEROPLIB_DIR,
        )
        command(
            "cjc", *cjc_dylib_args, OUT_CINTEROPLIB_O, "jni.cj", "registry.cj",
            cwd=INTEROPLIB_DIR,
        )
        command(
            "ar", "-cr", OUT_INTEROPLIB_A, OUT_CINTEROPLIB_O,
            cwd=DIST_DIR,
        )
        command(
            "ranlib", OUT_INTEROPLIB_A,
            cwd=DIST_DIR,
        )

        #cjc javalib/*.cj
        javalib_sources = tuple(glob.glob(os.path.join(INTEROPLIB_DIR, "javalib") + "/*.cj", recursive=False))
        command(
            "cjc", *cjc_static_args, "-linteroplib.interop", *javalib_sources,
            cwd=INTEROPLIB_DIR,
        )
        command(
            "cjc", *cjc_dylib_args, "-linteroplib.interop", *javalib_sources,
            cwd=INTEROPLIB_DIR,
        )

        command(
            "javac", "-d", DIST_DIR, "-source", "8", "-target", "8", "LibraryLoader.java", "$$NativeConstructorMarker.java", "ClassAnalyser.java", "MethodDef.java",
            cwd=INTEROPLIB_DIR,
        )

        class_files = (
            "cangjie/lang/LibraryLoader.class",
            "cangjie/lang/internal/$$NativeConstructorMarker.class",
            "cangjie/interop/java/ClassAnalyser.class",
            "cangjie/interop/java/MethodDef.class",
        )
        command(
            "jar", "cf",  LIBRARY_LOADER_JAR, *class_files,
            cwd=DIST_DIR,
        )

        LOG.info('end build interoplib for ' + args.target_lib + '\n')
    else:
        LOG.info('begin build java-binding-gen...\n')

        # Fetch jdk before building
        fetch_jdk(JAVA_INTEROP_THIRD_PARTY)

        command(
            "ant", "clean", "build",
            cwd=MIRROR_GEN_DIR,
        )

        LOG.info('end build java-binding-gen\n')


def clean(args):
    """clean build outputs and logs"""
    LOG.info("begin clean java-binding-gen...\n")
    command(
        "ant", "clean",
        cwd=MIRROR_GEN_DIR,
    )
    jdk_dir = os.path.join(JAVA_INTEROP_THIRD_PARTY, "jdk")
    subprocess.run(f"rm -rf {jdk_dir}", shell=True, check=True)
    LOG.info("end clean java-binding-gen\n")
    LOG.info("begin clean interoplib...\n")
    if os.path.isdir(DIST_DIR):
        shutil.rmtree(DIST_DIR, ignore_errors=True)
    LOG.info("end clean interoplib\n")

def runtime_name(target):
    SUFFIX = "_cjnative"
    return target if target.endswith(SUFFIX) else target + SUFFIX

def prepare_dir(base_path, *relative_path):
    """
    Insure that the directory specified by the arguments exists (create it if it
    does not) and return its path.
    """
    path = os.path.join(base_path, *relative_path)
    if not os.path.exists(path):
        os.makedirs(path)
    return path

def install_file(install_dir, file):
    if os.path.isfile(file):
        shutil.copy2(file, install_dir)
    else:
        fatal("Cannot find \"" + file + "\" for installing to \"" + install_dir + "\"")

def install_files(install_dir, *files):
    for file in files:
        install_file(install_dir, file)

def install(args):
    """install java-binding-gen or interoplib"""
    install_path = os.path.abspath(args.install_prefix) if args.install_prefix else DEFAULT_INSTALL_DIR

    if args.target:
        LOG.info("begin install interoplib for " + args.target + "\n")
        runtime = runtime_name(args.target)

        LIB_PREF = lib_pref(args.target)
        STATICLIB_EXT = staticlib_ext(args.target)
        DYLIB_EXT = dylib_ext(args.target)
        OUT_INTEROPLIB_A = os.path.join(DIST_DIR, f"{LIB_PREF}interoplib.interop.{STATICLIB_EXT}")
        OUT_INTEROPLIB_SO = os.path.join(DIST_DIR, f"{LIB_PREF}interoplib.interop.{DYLIB_EXT}")
        OUT_JAVA_LANG_A = os.path.join(DIST_DIR, f"{LIB_PREF}java.lang.{STATICLIB_EXT}")
        OUT_JAVA_LANG_SO = os.path.join(DIST_DIR, f"{LIB_PREF}java.lang.{DYLIB_EXT}")

        installation_dir = prepare_dir(install_path, "runtime", "lib", runtime)
        install_files(
            installation_dir,
            OUT_INTEROPLIB_SO,
            OUT_JAVA_LANG_SO,
        )
        install_files(
            prepare_dir(install_path, "modules", runtime),
            OUT_INTEROPLIB_CJO,
            OUT_JAVA_LANG_CJO,
        )
        if args.install_static:
            install_files(
                prepare_dir(install_path, "lib", runtime),
                OUT_INTEROPLIB_A,
                OUT_JAVA_LANG_A,
            )

        lib_loader_jar = os.path.join(DIST_DIR, LIBRARY_LOADER_JAR)
        if os.path.isfile(lib_loader_jar):
            install_file(
                prepare_dir(install_path, "lib"),
                lib_loader_jar
            )

        LOG.info("end install interoplib for " + args.target + "\n")
    else:
        LOG.info("begin install java-binding-gen...")

        mirror_gen_jar = os.path.join(MIRROR_GEN_DIR, 'java-mirror-gen.jar')
        if os.path.isfile(mirror_gen_jar):
            install_file(
                prepare_dir(install_path, "tools", "bin"),
                mirror_gen_jar
            )

        LOG.info("end install java-binding-gen")

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
    parser = argparse.ArgumentParser(description='build Java binding generator or interoplib')
    subparsers = parser.add_subparsers(help='sub command help')
    parser_build = subparsers.add_parser('build', help='build Java binding generator or interoplib')
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

    parser_install = subparsers.add_parser("install", help="install Java binding generator or interoplib")
    parser_install.add_argument(
        "--target", dest="target", type=str,
        help="install interoplib for the specified target"
    )
    parser_install.add_argument('--prefix',
                            dest='install_prefix',
                            help='target install prefix')
    parser_install.add_argument(
        "--with-static", action="store_true", dest='install_static',
        help="install static libraries in addition to dynamic libraries"
    )
    parser_install.set_defaults(func=install)

    parser_clean = subparsers.add_parser("clean", help="clean for both Java binding generator and interoplib")
    parser_clean.set_defaults(func=clean)

    args = parser.parse_args()


    if hasattr(args, 'target'):
        if args.target == "android-aarch64":
            args.target = "aarch64-linux-android31"
        if args.target == "ios-aarch64":
            args.target = "arm64-apple-ios11"
        if args.target == "ios-simulator-aarch64":
            args.target = "arm64-apple-ios11-simulator"

    if not hasattr(args, 'func'):
        args = parser.parse_args(['build'] + sys.argv[1:])

    args.func(args)

if __name__ == '__main__':
    LOG = init_log('root')
    os.environ['LANG'] = "C.UTF-8"
    main()

