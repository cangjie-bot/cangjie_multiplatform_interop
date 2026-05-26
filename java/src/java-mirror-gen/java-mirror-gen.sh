#!/bin/sh
# Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
# This source file is part of the Cangjie project, licensed under Apache-2.0
# with Runtime Library Exception.
#
# See https://cangjie-lang.cn/pages/LICENSE for license information.

inputClasses=""
classPath=""
androidJarPath=""
outputDirectory="."
packageName=""
jarName=""
bootClassPath=""
packageList=""
importsConfig=""
closureDepthLimit=""
help=""
verbose=""
jarMode=false
optionValue=false
pathSeparator=":"
javaMirrorGen=`find -L ${CANGJIE_HOME} -name java-mirror-gen.jar`

if [ -z "$javaMirrorGen" ]; then
    echo "java-mirror-gen.jar is not found in CANGJIE_HOME"
    exit 1
fi;

if [ "$(uname)" = "WindowsNT" ]; then
    pathSeparator=";";
fi;

for arg in "$@"; do
    shift
    case "$arg" in
        "--android-jar") set -- "$@" "-a"; optionValue=true ;;
        "-android-jar") set -- "$@" "-a"; optionValue=true ;;
        "-a") set -- "$@" "$arg"; optionValue=true ;;
        "--class-path") set -- "$@" "-t"; optionValue=true ;;
        "-cp") set -- "$@" "-t"; optionValue=true ;;
        "--package-name") set -- "$@" "-p"; optionValue=true ;;
        "-p") set -- "$@" "$arg"; optionValue=true ;;
        "--destination") set -- "$@" "-d"; optionValue=true ;;
        "-d") set -- "$@" "$arg"; optionValue=true ;;
        "-jar") set -- "$@" "-j"; optionValue=true ;;
        "--package-list") set -- "$@" "-l"; optionValue=true ;;
        "-l") set -- "$@" "$arg"; optionValue=true ;;
        "--imports") set -- "$@" "-i"; optionValue=true ;;
        "--import-mappings") set -- "$@" "-i"; optionValue=true ;;
        "-i") set -- "$@" "$arg"; optionValue=true ;;
        "--closure-depth-limit") set -- "$@" "-c"; optionValue=true ;;
        "-c") set -- "$@" "$arg"; optionValue=true ;;
        "--help") set -- "$@" "-h"; optionValue=false ;;
        "-?") set -- "$@" "-h"; optionValue=false ;;
        "-h") set -- "$@" "$arg"; optionValue=false ;;
        "--verbose") set -- "$@"; optionValue=false; verbose="true" ;;
        "-verbose") set -- "$@"; optionValue=false; verbose="true" ;;
        "-v") set -- "$@"; optionValue=false; verbose="true" ;;
        *) set -- "$@" "$arg";
            if [ "$optionValue" = true ]; then
                optionValue=false;
            else
                inputClasses="$inputClasses $arg";
            fi;
        ;;
    esac
done

while getopts "a:t:d:p:j:l:i:c:h" option
do
    case "${option}"
        in
        a)androidJarPath=${OPTARG};;
        t)classPath=${OPTARG};;
        d)outputDirectory=${OPTARG};;
        p)packageName=${OPTARG};;
        j)jarName=${OPTARG};;
        l)packageList=${OPTARG};;
        i)importsConfig=${OPTARG};;
        c)closureDepthLimit=${OPTARG};;
        h)help="true";;
        *);;
    esac
done

jvmGeneratorArgs="-Dpackage.mode"
if [ -n "$packageName" ]; then
    jvmGeneratorArgs="$jvmGeneratorArgs -Dpackage.name=$packageName"
fi;

if [ -n "$jarName" ]; then
    jvmGeneratorArgs="$jvmGeneratorArgs -Djar.mode"
    inputClasses="$jarName"
    jarMode=true
fi;

if [ "$jarMode" = true ]; then
    if [ -n "$packageList" ]; then
        jvmGeneratorArgs="$jvmGeneratorArgs -Djar.mode.packages=$packageList"
    fi;
fi;

if [ -n "$importsConfig" ]; then
    if [ -e "$importsConfig" ]; then
        jvmGeneratorArgs="$jvmGeneratorArgs -Dimports.config=$importsConfig"
    else
        jvmGeneratorArgs="$jvmGeneratorArgs -Dimports.config"
    fi;
fi;

if [ -n "$closureDepthLimit" ]; then
    jvmGeneratorArgs="$jvmGeneratorArgs -Dgen.closure.depth=$closureDepthLimit"
fi;

generatorArgs="-d $outputDirectory"

if [ -n "$androidJarPath" ]; then
    if [ ! -e "$androidJarPath" ]; then
        echo "Improper path to android.jar : $androidJarPath"
        exit 1
    fi;
    if [ -n "$classPath" ]; then
        classPath="$pathSeparator$classPath"
    fi;
    classPath="$androidJarPath$classPath"
    bootClassPath="$androidJarPath"
fi;

if [ -n "$bootClassPath" ]; then
    generatorArgs="$generatorArgs -bootclasspath $bootClassPath"
fi;

if [ -n "$classPath" ]; then
    generatorArgs="$generatorArgs -cp $classPath"
fi;

if [ -n "$help" ]; then
    echo "Usage: Java mirror generator [options] [type-names]
    The Java mirror generator can be run in two ways:
      sh ./java-mirror-gen.sh [options] [type-names]
    or
      sh ./java-mirror-gen.sh [options] -jar jar-file (single-jar mode)
    where
      [type-names] are the fully qualified names of Java classes and interfaces
      [jar-file] is the pathname of a single jar file
      possible [options] include:
        --android-jar <pathname>, -a <pathname>    (mandatory when Android API is used)
          <pathname> must point to the android.jar file from the Android SDK

        --destination <directory>, -d <directory>
          Specify output directory for generated mirrors files.
          If this option is not specified, the current directory is assumed.

        --class-path <path>, -cp <path>
          <path> is list of pathname of directories, .jar files and .zip files, separated with semicolons : to
          containing input .class files or .jar file dependencies.

        --package-name <name>, -p <name>
          <name> is the name of the Cangjie package into which all generated mirror types will be placed.
          If this option is not specified, package name will be UNNAMED.

        --closure-depth-limit <number>, -c <number>
          <number> is a non-negative decimal integer limiting the depth of dependency graph
          scanning when determining the set of types and their members that will be mirrored.

        -jar jar-file
          jar-file is the pathname of the jar file to be processed in the "single-jar" mode.

        --package-list <pathname>, -l <pathname>
          <pathname> is the pathname of a plain text file containing a list of package names.
          Only the class files that belong to the listed packages and their dependencies will be mirrored.
          Requires -jar.

        --imports <pathname>, --import-mappings <pathname>, -i <pathname>
          <pathname> is the pathname of a plain text file containing mirror type mappings
          accumulated during previous mirror generator runs.
          Requires -l and -jar.

        --help, -h, -?
          Prints a help message with a brief description of the command-line syntax and all options and exits.

        --verbose, -v
          Instructs the mirror generator to emit messages about what it is doing.

        For example, to generate mirrors types for java.util.HashMap run:
          sh ./java-mirror-gen.sh -d hmpackage -p hashmap java.util.HashMap
    "
    exit 0
fi;

if [ -n "$verbose" ]; then
    generatorArgs="$generatorArgs -verbose"
fi;

# Determine the Java command to use to start JVM
if [ -n "$JAVA_HOME" ]; then
    if [ -x "$JAVA_HOME/jre/sh/java" ]; then
        JAVACMD=$JAVA_HOME/jre/sh/java
    else
        JAVACMD=$JAVA_HOME/bin/java
    fi
    if [ ! -x "$JAVACMD" ]; then
        die "ERROR: JAVA_HOME is set to an invalid directory: $JAVA_HOME

Please set the JAVA_HOME variable in your environment to match the
location of your Java installation."
    fi
else
    JAVACMD=java
    which java >/dev/null 2>&1 || die "ERROR: JAVA_HOME is not set and no 'java' command could be found in your PATH.

Please set the JAVA_HOME variable in your environment to match the
location of your Java installation."
fi

echo "$jvmGeneratorArgs -jar $javaMirrorGen $generatorArgs $inputClasses" > javac.args
$JAVACMD @javac.args