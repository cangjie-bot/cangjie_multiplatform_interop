:: Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
:: This source file is part of the Cangjie project, licensed under Apache-2.0
:: with Runtime Library Exception.
::
:: See https://cangjie-lang.cn/pages/LICENSE for license information.
ECHO OFF

SET classPath=
SET generatorArgs=
SET inputClasses=
SET bootClassPath=
SET outputDirectory=.
SET jvmGeneratorArgs=-Dpackage.mode
SET help=
SET JAVACMD=%JAVA_HOME%\bin\java
SET pathSeparator=;
SET jarMode=false

SET javaMirrorGen=
IF EXIST "%CANGJIE_HOME%" (
    FOR /F "delims=" %%i IN ('WHERE /R %CANGJIE_HOME% java-mirror-gen.jar') DO (
        SET javaMirrorGen=%%i
    )
)

IF NOT EXIST "%javaMirrorGen%" (
    ECHO "java-mirror-gen.jar is not found in CANGJIE_HOME"
    EXIT /B 1
)

SETLOCAL
SET ERRORLEVEL=

:loop
IF NOT "%ERRORLEVEL%"=="0" (
    EXIT /B %ERRORLEVEL%
)
IF NOT "%1"=="" (
    IF "%1"=="--android-jar" (
        CALL :setAndroidJarPath %2
        SHIFT & SHIFT
        GOTO :loop
    )
    IF "%1"=="-android-jar" (
        CALL :setAndroidJarPath %2
        SHIFT & SHIFT
        GOTO :loop
    )
    IF "%1"=="-a" (
        CALL :setAndroidJarPath %2
        SHIFT & SHIFT
        GOTO :loop
    )
    IF "%1"=="--class-path" (
        CALL :setClassPath %2
        SHIFT & SHIFT
        GOTO :loop
    )
    IF "%1"=="-cp" (
        CALL :setClassPath %2
        SHIFT & SHIFT
        GOTO :loop
    )
    IF "%1"=="--package-name" (
        CALL :setPackageName %2
        SHIFT & SHIFT
        GOTO :loop
    )
    IF "%1"=="-p" (
        CALL :setPackageName %2
        SHIFT & SHIFT
        GOTO :loop
    )
    IF "%1"=="--destination" (
        CALL :setOutputDirectory %2
        SHIFT & SHIFT
        GOTO :loop
    )
    IF "%1"=="-d" (
        CALL :setOutputDirectory %2
        SHIFT & SHIFT
        GOTO :loop
    )
    IF "%1"=="-jar" (
        CALL :setJarName %2
        SHIFT & SHIFT
        GOTO :loop
    )
    IF "%1"=="--package-list" (
        CALL :setPackageList %2
        SHIFT & SHIFT
        GOTO :loop
    )
    IF "%1"=="-l" (
        CALL :setPackageList %2
        SHIFT & SHIFT
        GOTO :loop
    )
    IF "%1"=="--imports" (
        CALL :setImportsConfig %2
        SHIFT & SHIFT
        GOTO :loop
    )
    IF "%1"=="--import-mappings" (
        CALL :setImportsConfig %2
        SHIFT & SHIFT
        GOTO :loop
    )
    IF "%1"=="-i" (
        CALL :setImportsConfig %2
        SHIFT & SHIFT
        GOTO :loop
    )
    IF "%1"=="--closure-depth-limit" (
        CALL :setClosureDepthLimit %2
        SHIFT & SHIFT
        GOTO :loop
    )
    IF "%1"=="-c" (
        CALL :setClosureDepthLimit %2
        SHIFT & SHIFT
        GOTO :loop
    )
    IF "%1"=="--help" (
        CALL :setHelp
        SHIFT
        GOTO :eof
    )
    IF "%1"=="-?" (
        CALL :setHelp
        SHIFT
        GOTO :eof
    )
    IF "%1"=="-h" (
        CALL :setHelp
        SHIFT
        GOTO :eof
    )
    IF "%1"=="--verbose" (
        CALL :setVerbose
        SHIFT
        GOTO :loop
    )
    IF "%1"=="-verbose" (
        CALL :setVerbose
        SHIFT
        GOTO :loop
    )
    IF "%1"=="-v" (
        CALL :setVerbose
        SHIFT
        GOTO :loop
    )
    CALL :setInputClasses %1
    SHIFT
    GOTO :loop
)

SET generatorArgs=%generatorArgs% -d "%outputDirectory%"
IF NOT "%classPath%"=="" (
    SET generatorArgs=%generatorArgs% -cp "%classPath%"
)

:generatorRun
call :setJavaCommand

echo %jvmGeneratorArgs% -jar %javaMirrorGen% %generatorArgs% %inputClasses% > javac.args
%JAVACMD% @javac.args

EXIT /B 0

:setPackageName
    SET jvmGeneratorArgs=%jvmGeneratorArgs% -Dpackage.name=%1
EXIT /B 0

:setOutputDirectory
    SET outputDirectory=%1
EXIT /B 0

:setClassPath
    IF NOT "%classPath%"=="" (
        SET classPath=%1%pathSeparator%%classPath%
    ) ELSE (
        SET classPath=%1
    )
EXIT /B 0

:setInputClasses
    SET inputClasses=%inputClasses% %1
EXIT /B 0

:setJarName
    SET jvmGeneratorArgs=%jvmGeneratorArgs% -Djar.mode
    SET inputClasses=%1
    SET jarMode=true
EXIT /B 0

:setAndroidJarPath
    IF NOT EXIST %1 (
        ECHO "Improper path to android.jar : %1"
        EXIT /B 1
    )
    IF NOT "%classPath%"=="" (
        SET classPath=%pathSeparator%%classPath%
    )
    SET classPath=%1%classPath%
    SET generatorArgs=%generatorArgs% -bootclasspath %1
EXIT /B 0

:setPackageList
    IF NOT "%jarMode%"=="true" (
        ECHO "Options --package-list, -l can be used only for jar file. Please pass it through -jar option."
        EXIT /B 1
    )
    SET jvmGeneratorArgs=%jvmGeneratorArgs% -Djar.mode.packages=%1
EXIT /B 0

:setImportsConfig
    IF EXIST %1 (
        SET jvmGeneratorArgs=%jvmGeneratorArgs% -Dimports.config=%1
    ) ELSE (
        SET jvmGeneratorArgs=%jvmGeneratorArgs% -Dimports.config
    )
EXIT /B 0

:setClosureDepthLimit
    SET jvmGeneratorArgs=%jvmGeneratorArgs% -Dgen.closure.depth=%1
EXIT /B 0

:setHelp
    ECHO Usage: Java mirror generator [options] [type-names]
    ECHO The Java mirror generator can be run in two ways:
    ECHO   sh ./java-mirror-gen.sh [options] [type-names]
    ECHO     or
    ECHO   sh ./java-mirror-gen.sh [options] -jar jar-file (single-jar mode)
    ECHO     where
    ECHO   [type-names] are the fully qualified names of Java classes and interfaces
    ECHO   [jar-file] is the pathname of a single jar file
    ECHO   possible [options] include:
    ECHO     --android-jar pathname, -a pathname    (mandatory when Android API is used)
    ECHO       pathname must point to the android.jar file from the Android SDK
    ECHO(
    ECHO     --destination directory, -d directory
    ECHO       Specify output directory for generated mirrors files.
    ECHO       If this option is not specified, the current directory is assumed.
    ECHO(
    ECHO     --class-path path, -cp path
    ECHO       path is list of pathname of directories, .jar files and .zip files, separated with semicolons : to
    ECHO       containing input .class files or .jar file dependencies.
    ECHO(
    ECHO     --package-name name, -p name
    ECHO       name is the name of the Cangjie package into which all generated mirror types will be placed.
    ECHO       If this option is not specified, package name will be UNNAMED
    ECHO(
    ECHO     --closure-depth-limit number, -c number
    ECHO       number is a non-negative decimal integer limiting the depth of dependency graph
    ECHO       scanning when determining the set of types and their members that will be mirrored.
    ECHO(
    ECHO     -jar jar-file
    ECHO       jar-file is the pathname of the jar file to be processed in the "single-jar" mode
    ECHO(
    ECHO     --package-list pathname, -l pathname
    ECHO       pathname is the pathname of a plain text file containing a list of package names.
    ECHO       Only the class files that belong to the listed packages and their dependencies will be mirrored.
    ECHO       Requires -jar.
    ECHO(
    ECHO     --imports pathname, --import-mappings pathname, -i pathname
    ECHO       pathname is the pathname of a plain text file containing mirror type mappings
    ECHO       accumulated during previous mirror generator runs.
    ECHO       Requires -l and -jar.
    ECHO(
    ECHO     --help, -h, -?,
    ECHO       Prints a help message with a brief description of the command-line syntax and all options and exits.
    ECHO(
    ECHO     --verbose, -v,
    ECHO       Instructs the mirror generator to emit messages about what it is doing.
    ECHO(
    ECHO     For example, to generate mirrors types for java.util.HashMap run:
    ECHO       sh ./java-mirror-gen.sh -d hmpackage -p hashmap java.util.HashMap
EXIT /B 0

:setVerbose
    SET generatorArgs=%generatorArgs% -verbose
EXIT /B 0

:setJavaCommand
:: Determine the Java command to use to start JVM
SET textMessage="Please set the JAVA_HOME variable in your environment to match the location of your Java installation."
IF "%JAVA_HOME%"=="" (
    ECHO %textMessage%
    EXIT /B 1
)
IF NOT EXIST "%JAVA_HOME%\bin\java.exe" (
    ECHO "ERROR: JAVA_HOME is set to an invalid directory: $JAVA_HOME"
    ECHO %textMessage%
    EXIT /B 1
)
SET JAVACMD="%JAVA_HOME%\bin\java.exe"
EXIT /B 0

ENDLOCAL