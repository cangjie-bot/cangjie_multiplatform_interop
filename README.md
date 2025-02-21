# Java Mirrors binding generator

## Requirements
* JDK 17 (any other version will likely not work)
* Apache Ant 1.10.12 or later

## Building
* Make sure you have the `jdk17` property set in env.xml. It is necessary to compile `java-mirror-gen` itself.
* (Optional) Open the repository `java-mirror-gen` directory as an IntelliJ IDEA project.
* From the command line or IntelliJ IDEA:
  * Run `ant clean` to delete all compilation artifacts
  * Run `ant build` to build
  * Run `ant test` to build and run tests

Note that the use of Ant is required, since it generates source code for a couple of resource files present in the repository.

## Testing module structure
`cd java-mirror-gen`  
Under the `tests` directory, there are two subdirectories:
* `testData` keeps source Java files. Each subdirectory of the `testData` is separate test.
* `generated` keeps compiled *.class files and generated their Java Mirrors *.cj files containing generated Mirrors for
full closure by signatures imports with super class/interfaces.
   Compiled .class files are located in `generated/<test_name>/<java_package_name>` directory
   Generated mirrors *.cj are located in `generated/<test_name>/UNNAMED/src` 
   All files inside the `generated` directory are removed and auto-generated during the `ant test` task.

## How to compile generated Java Mirrors *.cj files
Setup CJNative environment running `source ./envsetup.sh`  
Generate mirrors *.cj files with `ant clean test`  
You can compile the generated files and build libUNNAMED.so from them using `./run_test.sh <test_name>` or `run_all.sh` for all tests.  

# CJ-Interop stuff - Interop support library, samples, benchmarks

### Samples
#### To build and run
Setup CJNative environment running ``source ./envsetup.sh``
```
cd samples
cd <sample-dir>
. ./run.sh
```

### Benchmarks
#### To build and run
```
cd benchmarks
. ./run.sh <iterations-number> > /dev/null
```
Take the results of measurements in `benchmarks/<benchmark>/output/<benchmark>.txt`
