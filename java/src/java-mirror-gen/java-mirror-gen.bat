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
FOR /F "delims=" %%i IN ('WHERE java-mirror-gen.jar') DO (
    SET javaMirrorGen=%%i
)

IF NOT EXIST "%javaMirrorGen%" (
    ECHO "java-mirror-gen.jar is not found in PATH"
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
        GOTO :generatorRun
    )
    IF "%1"=="-?" (
        CALL :setHelp
        SHIFT
        GOTO :generatorRun
    )
    IF "%1"=="-h" (
        CALL :setHelp
        SHIFT
        GOTO :generatorRun
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
    SET jvmGeneratorArgs=
    SET generatorArgs=--help
    SET inputClasses=
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