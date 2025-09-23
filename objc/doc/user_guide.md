# Cangjie-ObjC 互操作用户指南

## 简介

> **注意：**
>
> 仓颉-ObjC 互操作特性为实验性功能，特性还在持续完善中。

仓颉 SDK 支持仓颉与 ObjC(Objective-C) 的互操作，因此在 IOS 应用中可以使用仓颉编程语言开发业务模块。整体调用流程如下：

- 场景一：从 ObjC 调用仓颉，ObjC code → (glue code) → 仓颉 code
- 场景二：从仓颉调用 ObjC，仓颉 code → (glue code) → ObjC code

**涉及的概念：**

1. Mirror Type：镜像类型，Java 类型使用仓颉语法形式的表达，供开发者使用仓颉的方式调用 ObjC 方法。
2. CFFI：C Foreign Function Interface，是 Java/Objetive C/仓颉等高级编程语言提供的 C 语言外部接口。
3. 胶水代码：用于弥合不同编程语言差异的中间代码。
4. 互操作代码：ObjC 调用仓颉方法的实现代码，或仓颉调用 ObjC 的实现代码。

**涉及的工具：**

1. 仓颉 SDK：仓颉的开发者工具集。
2. cjc：指代仓颉编译器。
3. ObjCInteropGen: ObjC 镜像生成工具
4. IOS 工具链：IOS 应用开发所需的工具集合。

仓颉与 ObjC 之间的调用，通常需要利用 ObjC 编程语言或仓颉编程语言的 CFFI 编写"胶水代码"。然而，人工书写这种胶水代码（Glue Code）对于开发者来说特别繁琐。

仓颉 SDK 中包含的仓颉编译器（cjc）支持自动生成必要的胶水代码，减轻开发者负担。

cjc 自动生成胶水代码需要获取在跨编程语言调用中涉及的 ObjC 类型（类和接口）的符号信息，该符号信息包含在 Mirror Type 中。

**语法映射：**

|            仓颉类型                            |                    ObjC 类型                       |
|:----------------------------------------------|:---------------------------------------------------|
|`@ObjCMirror public interface A <: id`         |        `@protocol A`                               |
|  `@ObjCMirror public class A <: id`           |        `@interface A`                              |
|     `@ObjCMirror struct S`                    |        `struct S`                                  |
|    `func fooAndB(a: A, b: B): R`              |        `- (R)foo:(A)a andB:(B)b`                   |
|  `static func fooAndB(a: A, b: B): R`         |        `+ (R)foo:(A)a andB:(B)b`                   |
|    `prop foo: R`                              |        `@property(readonly) R foo`                 |
|    `mut prop foo: R`                          |        `@property R foo`                           |
|     `static prop foo: R`                      |        `@property(readonly, class) R foo`          |
|     `static mut prop foo: R`                  |        `@property(class) R foo`                    |
|    `init()`                                   |        `- (instancetype)init`                      |
|    `let x: R`                                 |        `const R x`                                 |
|     `var x: R`                                |        `R x`                                       |
|`@ObjCMirror public interface test <: NSObject`|`@protocol test <NSObject>`                         |

**类型映射：**

| 仓颉类型         |                ObjC 类型      |
|:----------------|:------------------------------|
|    `Unit`       |        `void`                 |
|     `Int8`      |        `signed char`          |
|    `Int16`      |        `short`                |
|     `Int32`     |        `int`                  |
|     `Int64`     |        `long/NSInteger`       |
|     `Int64`     |        `long long`            |
|     `UInt8`     |        `unsigned char`        |
|    `UInt16`     |        `unsigned short`       |
|    `UInt32`     |        `unsigned int`         |
|    `UInt64`     |   `unsigned long/NSUInteger`  |
|    `UInt64`     |   `unsugned long long`        |
|    `Float32`    |        `float`                |
|   `Float64`     |        `double`               |
|  `Bool`         |        `bool/BOOL`            |

注意：

1. ObjC 源码中标记为 `unavailable` 的类型不做映射转化
2. 当前版本不支持 ObjC 中的全局函数与全局变量的转化
3. 匿名 `C enumeration` 的类型不做映射转化
4. `C unions` 的类型不做映射转化
5. `const` `volatile` `restrict`  的类型不做映射转化

以仓颉调用 ObjC 为例，整体开发过程描述如下：

1. 开发者进行接口设计，确定函数调用流程和范围。

2. 根据步骤 1，为被调用的 ObjC 类和接口生成 Mirror Type。

    ```objc
    // original-objc/Base.h
    #import <Foundation/Foundation.h>

    @interface Base : NSObject

    - (void)f;

    @end
    ```

    ```objc
    // original-objc/Base.m
    #import "Base.h"

    @implementation Base

    - (void) f {
        printf("Hello from ObjC Base f()\n");
    }

    @end
    ```

    并创建配置文件，以`example.toml`为例：

    ```toml
    # Place mirrors of the Foundation framework classes in the 'objc.foundation' package:
    [[packages]]
    filters = { include = ["NS.+"] }
    package-name = "objc.foundation"

    # Place the mirror of the class Base in the 'example' package:
    [[packages]]
    filters = { include = "Base" }
    package-name = "example"

    # Write the output files with mirror type definitions to the './mirrors' directory:
    [output-roots.default]
    path = "mirrors"

    # Specify the pathnames of input files
    [sources.all]
    paths = ["original-objc/Base.h"]

    # Extra settings for testing with GNUstep
    [sources-mixins.default]
    sources = [".*"]
    arguments-append = [
        "-F", "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/System/Library/Frameworks",
        "-isystem", "/Library/Developer/CommandLineTools/usr/lib/clang/15.0.0/include",
        "-isystem", "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/usr/include",
        "-DTARGET_OS_IPHONE"
    ]
    ```

    配置文件格式如下:

    ```toml
    # 可选，import其他的toml配置文件，值为字符串数组，每行表示相对于当前工作目录的toml文件路径
    imports = [
        "../path_to_file.toml"
    ]

    # 生成的Mirror Type文件存放路径,当目标文件夹不存在时会自动创建
    [output-roots]
    path = "path_to_mirrors"

    # Mirror Type的输入文件列表，与Clang编译选项
    [sources]
    path = "path_to_ObjC_header_file"
    # 编译选项
    arguments-append = [
        "-F", "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/System/Library/Frameworks",
        "-isystem", "/Library/Developer/CommandLineTools/usr/lib/clang/15.0.0/include",
        "-isystem", "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/usr/include",
        "-DTARGET_OS_IPHONE"
    ]

    # 多个sources属性的集合
    [sources-mixins]
    sources = [".*"]

    # 指定包名
     [[packages]]
    # 如果转换的代码隐式的使用到某些符号，如Uint32/Bool等，需要将该符号一并添加到filters中（如未添加运行 ObjCInteropGen 时会出现Entity Uint32/Bool from `xx.h` is ambiguous between x packages报错信息)
    filters = { include = "Base" }
    package-name = "example"
    ```

    使用 ObjC 的镜像生成工具生成 ObjC 的镜像文件：

    ```bash
    ObjCInteropGen example.toml
    ```

    生成的镜像文件 `Base.cj` 如下：

    ```cangjie
    // Base.cj
    package example

    import interoplib.objc.*

    @ObjCMirror
    open class Base {
        public open func f(): Unit
    }
    ```

    如果需要基于 `Base` 对部分函数进行重写，示例如下：

    ```cangjie
    // Interop.cj
    package example

    import interoplib.objc.*

    @ObjCImpl
    public open class Interop <: Base {
        override public func f(): Unit {
            println("Hello from overridden Cangjie Interop.f()")
            super.f()
        }
    }
    ```

3. 开发互操作代码，使用步骤 2 中生成的 Mirror Type 创建 ObjC 对象、调用 ObjC 方法。

    `互操作代码.cj` + `Mirror Type.cj`→ 实现仓颉调用 ObjC

    例如如下示例，可通过 ObjCImpl 类型继承 Mirror Type 调用 ObjC 类型构造函数：

    ```cangjie
    // A.cj
    package cjworld

    import interoplib.objc.*

    @ObjCImpl
    public class A <: M {
        override public func goo(): Unit {
            println("Hello from overridden A goo()")
            super.goo()
        }
    }
    ```

4. 使用 cjc 编译互操作代码和 'Mirror Type.cj' 类型。cjc 将生成：

    - 胶水代码。
    - 实际进行互操作的 ObjC 源代码。

    `Mirror Type.cj`\+`互操作代码.cj`→ cjc → `仓颉代码.so`和 `互操作.m`/`互操作.h`

5. 将步骤 4 中生成的文件添加到 macOs/iOS 项目中：

    - `互操作.m/h`：cjc 生成的文件
    - `仓颉代码.so`：cjc 生成的文件
    - 仓颉 SDK 包含的运行时库

    在 ObjC 源代码中插入必要的调用并重新生成该程序。

    macOs/iOS 项目 + `互操作.m/h` + `仓颉代码.so` → macOS/iOS 工具链 → 可执行文件

## 环境准备

**系统要求：**

- **硬件/操作系统**：macOS 12.0 及以上版本(aarch64)运行

**ObjCInteropGen 工具使用环境准备步骤：**

1. 安装对应版本的仓颉 SDK，安装方法请参见[开发指南](https://cangjie-lang.cn/docs?url=%2F1.0.0%2Fuser_manual%2Fsource_zh_cn%2Ffirst_understanding%2Finstall_Community.html)。
2. 执行如下命令安装 LLVM 15。

    ```bash
    brew install llvm@15
    ```

3. 将 `llvm@15/lib/` 子目录添加到 `DYLD_LIBRARY_PATH` 环境变量中。

   ```bash
    export DYLD_LIBRARY_PATH=/opt/homebrew/opt/llvm@15/lib:$DYLD_LIBRARY_PATH
    ```

4. 检测是否安装成功：执行如下命令，如果出现 ObjCInteropGen 使用说明，则证明安装成功。

    ```bash
    ObjCInteropGen --help
    ```

## ObjCMirror 规格

ObjCMirror 为 ObjC 类型使用仓颉语法形式的表达，由工具自动生成，供开发者使用仓颉的方式调用 ObjC 方法。

> **注意：**
>
> 本特性尚为实验特性，用户仅可使用文档已说明的特性，若使用了未被提及的特性，将可能出现如编译器崩溃等的未知错误。

### 调用构造函数

```objc
// M.h
@interface M : NSObject
// Constructor w/out parameters
- (id)init;
// Constructor w/ scalar parameters
- (id)initWithArg0:(int)arg0 andArg1:(float)arg1;
@end

// M.m
#import "M.h"

@implementation M
// -- implement constructors --
@end
```

```cangjie
// M.cj
package cjworld

import interoplib.objc.*

@ObjCMirror
open class M {
    public init()
    // Annotation is required, because we cannot declare method with such name in CJ
    @ForeignName["initWithArg0:andArg1:"]
    public init(arg0: IntNative, arg1: Float32)
}
```

```cangjie
// A.cj
package cjworld

import interoplib.objc.*

@ObjCImpl
class A <: M {
    @ForeignName["initWithArg2:"]
    public init(arg2: Bool) {
        super(0, 0.0) // or super()
        println("arg2 is ${arg2}")
    }
}
```

### 成员函数

```objc
// M.h
@interface M : NSObject

// Static method with parameters and return type
+ (int64_t) booWithArg0: (int32_t)arg0 andArg1: (bool)arg1;

// Instance method with parameters and return type
- (double) gooWithArg0: (int16_t)arg0 andArg1: (float)arg1;

@end

// M.m
#import "M.h"

@implementation M
// -- implement methods --
@end
```

```cangjie
// M.cj
package cjworld

import interoplib.objc.*

@ObjCMirror
open class M {
    @ForeignName["booWithArg0:andArg1:"]
    public static func boo(arg0: Int32, arg1: Bool): Int64

    @ForeignName["gooWithArg0:andArg1:"]
    public open func goo(arg0: Int16, arg1: Float32): Float64
}
```

```cangjie
// A.cj
package cjworld

import interoplib.objc.*

@ObjCImpl
class A <: M {
    @ForeignName["gooWithArg0:andArg1:"]
    public override goo(arg0: Int16, arg1: Float32): Float64 {
        super.goo(arg0, arg1) + 1
        // we could also call M.boo(...)
    }
}
```

### 属性

```objc
// M.h
@interface M : NSObject

@property int f

@end
```

```cangjie
// M.cj
package cjworld

import interoplib.objc.*

@ObjCMirror
open class M {
    protected open mut prop f: IntNative
}
```

```cangjie
// A.cj
package cjworld

import interoplib.objc.*

@ObjCImpl
class A <: M {
    // we could override f
    // protected override mut prop f: IntNative { get() { super.f + 1 } }
    @ForeignName["gooWithArg0:"]
    public goo(arg0: IntNative): IntNative{
        this.f + arg0
    }
}
```

### 成员变量

```objc
// M.h
@interface M : NSObject
{
@public
double m;
}

@end
```

```cangjie
// M.cj
package cjworld

import interoplib.objc.*

@ObjCMirror
open class M {
    public var m: Float64
}
```

```cangjie
// A.cj
package cjworld

import interoplib.objc.*

@ObjCImpl
class A <: M {
    @ForeignName["initWithM:"]
    public init(m: Float64) {
        super()
        this.m = m
    }
    @ForeignName["gooWithArg0:"]
    public goo(arg0: Float64): Float64 {
        this.m + arg0
    }
}
```

## ObjCImpl 规格

ObjCImpl 为仓颉注解，语义为该类的方法与成员可以被 ObjC 函数调用。编译期间编译器会为 `@ObjcImpl` 的仓颉类生成对应的 objc 代码。

> **注意：**
>
> 本特性尚为实验特性，用户仅可使用文档已说明的特性，若使用了未被提及的特性，将可能出现如编译器崩溃等的未知错误。

### 调用 ObjcImpl 的构造或成员函数

在仓颉中调用 ObjcImpl 的构造或成员函数同普通仓颉方法。
在 Objc 中调用 ObjcImpl 的构造或成员函数如下：

```cangjie
// A.cj
package cjworld

import interoplib.objc.*

@ObjCImpl
class A <: M {
    @ForeignName["initWithM:"]
    public init(m: Float64) {
        super()
        this.m = m
    }
    @ForeignName["gooWithArg0:"]
    public goo(arg0: Float64): Float64 {
        this.m + arg0
    }
}
```

```objc
int main(int argc, char** argv) {
    @autoreleasepool {
        M* a = [[A alloc] init];
        [a goo];
        M* b = [[A alloc] init];
        [b goo];
    }
    return 0;
}
```

## 约束限制

1. 当前版本的 ObjCInteropGen 功能存在如下约束限制：

    - 不支持 ObjC 类/接口中的非静态成员变量转换
    - 不支持 ObjC 类/接口中的指针属性转换
    - 不支持对构造函数 init 方法的转换
    - 不支持同时转换多个 .h 头文件
    - 不支持 Bit fields 转换

2. 版本使用过程中需额外下载依赖文件 `cangjie.h` (下载地址： <https://gitcode.com/Cangjie/cangjie_runtime/blob/dev/runtime/src/Cangjie.h>),并集成至项目中。