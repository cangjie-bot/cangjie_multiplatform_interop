# linux_x86_64_cjnative
mkdir -p ./output
cd ./output

cjc --output-type=dylib ../generated/*.cj -L. -linteroplib.interop -lcinteroplib -ljava.lang

javac ../generated/*.java ../original-java/*.java -h ../generated -d ./ -cp .:/home/xuwenhao/cangjie/lib/library-loader.jar

java -cp .:/home/xuwenhao/cangjie/lib/library-loader.jar -Djava.library.path=./ UNNAMED.Main
cd ../