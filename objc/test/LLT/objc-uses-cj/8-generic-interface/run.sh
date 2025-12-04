mkdir out

cjc -j4 --output-type=dylib --int-overflow wrapping generated/*.cj api/generic.cj -o out/ -L. -linteroplib.objc -lobjc.lang -L${CANGJIE_HOME}/runtime/lib/darwin_aarch65_cjnative

clang -fno-modules -fobjc-arc  app/*.m  -o out/main -L$CANGJIE_HOME/runtime/lib/darwin_aarch64_cjnative -I$CANGJIE_HOME/include -Iapp -Igenerated -Lout -lcjworld  -lcangjie-runtime

cd out && DYLD_LIBRARY_PATH="./:$CANGJIE_HOME/runtime/lib/darwin_aarch64_cjnative:$DYLD_LIBRARY_PATH" LD_LIBRARY_PATH="./:$CANGJIE_HOME/runtime/lib/darwin_aarch64_cjnative:$LD_LIBRARY_PATH" ./main
