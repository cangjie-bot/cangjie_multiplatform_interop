The `CMakeLists.txt` file provides building the Objective-C binding generator for Cangjie.

On macOS and Linux, the libclang development environment must be installed.

On Ubuntu, it means installing the _clang_ and _libclang-dev_ packages. No additional configuring is needed.

On macOS, a development version of libclang can be installed with the _llvm_ Homebrew formula. And the _Clang_DIR_ cmake cache entry must be defined. It should specify the directory (for example, `/opt/homebrew/Cellar/llvm/20.1.6/lib/cmake/clang`) that contains the _libclang_ configuration file (`ClangConfig.cmake` or `clang-config.cmake`).

The `build.sh` script configures and builds the generator with default parameters:
```
cmake -B build
cmake --build build
```
It builds the default _CMAKE_BUILD_TYPE_ (normally _Release_) configuration with the default build system (normally _make_) and the system toolchain (normally _gcc_).

On Windows, there are no universally accepted pre-built binaries of _libclang_. It must be built by yourself from the LLVM sources. The _Clang_DIR_ cmake cache entry must be explicitly defined as well.