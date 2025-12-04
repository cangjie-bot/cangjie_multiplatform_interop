cjc --output-type=dylib   --int-overflow=wrapping api/*.cj -o out/

cd out && cjc -j4 --output-type=dylib --int-overflow wrapping ../generated/*_glue.cj -L. -lgenericClass -linteroplib.objc -lobjc.lang -L${CANGJIE_HOME}/runtime/lib/darwin_aarch64_cjnative

cd ../

clang -fno-modules -fobjc-arc -shared -undefined dynamic_lookup generated/*.m  -o out/libgluecode.dylib -L$CANGJIE_HOME/runtime/lib/darwin_aarch64_cjnative -I$CANGJIE_HOME/include -Igenerated -lcangjie-runtime

clang -fno-modules -fobjc-arc  app/*.m  -o out/main -L$CANGJIE_HOME/runtime/lib/darwin_aarch64_cjnative -I$CANGJIE_HOME/include -Iapp -Igenerated -Lout -lgenericClass -lcjworld -lgluecode  -lcangjie-runtime

cd out && DYLD_LIBRARY_PATH="./:$CANGJIE_HOME/runtime/lib/darwin_aarch64_cjnative:$DYLD_LIBRARY_PATH" LD_LIBRARY_PATH="./:$CANGJIE_HOME/runtime/lib/darwin_aarch64_cjnative:$LD_LIBRARY_PATH" ./main
