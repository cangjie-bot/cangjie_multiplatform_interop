#!/bin/sh
set -e
#export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
#input param $1 target arch
# $1: linux_x86_64_cjnative

cd ../
mkdir -p dist

cd ./src/interoplib
clang -fstack-protector-strong -s -Wl,-z,relro,-z,now -fPIC -shared -o ../../dist/libcinteroplib.so -lcangjie-runtime -L${CANGJIE_HOME}/runtime/lib/$1 -I${JAVA_HOME}/include/ -I${JAVA_HOME}/include/linux c_core.c
cjc --strip-all --link-options "-z relro" --link-options "-z now" -O2 --output-type=dylib --output-dir=../../dist --int-overflow wrapping jni.cj registry.cj -L../../dist -lcinteroplib
cjc --strip-all --link-options "-z relro" --link-options "-z now" --output-type=dylib --output-dir=../../dist --import-path=../../dist --int-overflow wrapping ./javalib/*.cj

javac -d ../../dist LibraryLoader.java
javac -d ../../dist \$\$NativeConstructorMarker.java
cd ../../dist
jar cf library-loader.jar cangjie/lang/LibraryLoader.class cangjie/lang/internal/\$\$NativeConstructorMarker.class

cd ../build