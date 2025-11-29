# linux_x86_64_cjnative
mkdir -p ./output
cd ./output
INTEROPLIB_DIR=../../../../src/interoplib

cjc --output-type=dylib $INTEROPLIB_DIR/jni.cj $INTEROPLIB_DIR/registry.cj
clang -o libcinteroplib.so -fPIC --shared -lcangjie-runtime -L${CANGJIE_HOME}/runtime/lib/$1 -I${JAVA_HOME}/include/ -I${JAVA_HOME}/include/linux $INTEROPLIB_DIR/c_core.c
javac -d . $INTEROPLIB_DIR/LibraryLoader.java

cjc --output-type=dylib ../generated/*.cj -L. -linteroplib.interop -libcinteroplib

export CLASSPATH=`pwd`
javac ../generated/*.java ../original-java/Main.java -h ../generated -d ./

LD_LIBRARY_PATH=$LD_LIBRARY_PATH
java -Djava.library.path=./ Main
cd ../