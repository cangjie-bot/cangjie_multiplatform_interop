# 仓颉语言互操作子系统

## 简介

仓颉语言为开发者提供了与 Java 语言和 ObjC 语言互操作的能力，在成功安装仓颉工具链后，即可根据手册说明使用这些能力。

## 系统架构
仓颉-Java互操作整体架构：

![Cangjie-Java互操作架构图](java/figures/Cangjie-Java.png)

仓颉-ObjC互操作整体架构：

![Cangjie-ObjC互操作架构图](objc/figures/Cangjie-ObjC.png)

本仓库提供了互操作工具链中的下述工具：

* java binding-generotor：仓颉 SDK 中提供的工具，文件名为 java-mirror-gen.jar，用于根据 Java 的.class 文件自动生成仓颉格式的 Mirror Type
* ObjC binding-generotor: ObjC 镜像文件生成工具

## 目录结构

```
|--java
   |-- build   # 构建脚本
   |-- doc     # 介绍文档
   |-- src     # 源码文件
       |-- interoplib # 互操作库
       |-- java-mirror-gen # 仓颉镜像文件生成工具
   |-- test # 测试用例
|--objc
   |-- build  # 构建脚本
   |-- doc    # 介绍文档
   |-- src    #源码文件
       |-- interoplib    # 互操作库
       |-- ObjCInteropGen    # 仓颉镜像生成器源码
   |-- test    # 测试用例
   |-- third_party    # toml 文件读写功能代码
```

若想获取详细信息，请参阅各组件 `doc` 目录下的使用指南：

- Cangjie-Java:
    - [Cangjie-Java 用户指南](https://gitcode.com/Cangjie/cangjie_docs/tree/dev/docs/dev-guide/source_zh_cn/multiplatform/cangjie-android-Java.md)
    - [Cangjie-Java 开发者指南](./java/doc/developer_guide.md)
- Cangjie-ObjC:
    - [Cangjie-ObjC 用户指南](https://gitcode.com/Cangjie/cangjie_docs/tree/dev/docs/dev-guide/source_zh_cn/multiplatform/cangjie-ios-objc.md)
    - [Cangjie-ObjC 开发者指南](./objc/doc/developer_guide.md)

## 构建依赖

仓颉互操作工具集构建依赖于仓颉 `SDK`，请参考[仓颉 SDK 集成构建指南](https://gitcode.com/Cangjie/cangjie_build/blob/dev/README_zh.md)

## 开源协议

本项目基于 [Apache-2.0 with Runtime Library Exception](./LICENSE)，请自由地享受和参与开源。

## 相关仓

* [cangjie compiler](https://gitcode.com/Cangjie/cangjie_compiler)
* [cangjie test](https://gitcode.com/Cangjie/cangjie_test)

## 使用的开源软件声明

| 开源软件名称               | 开源许可协议              | 使用说明                  | 使用主体 | 使用方式         |
|----------------------|---------------------|-----------------------|------|--------------|
| bishengjdk         | GPL V2.0  | Java Mirror生成工具利用javac源码解析java class文件并在语法解析阶段生成对应mirror| 语言服务 | 集成在工具发布包中 |
| tinytoml  | BSD-2-Clause        | ObjC Mirror生成工具用于解析toml配置文件      | 语言服务 | 集成在工具发布包中 |
## 参与贡献

欢迎开发者们提供任何形式的贡献，包括但不限于代码、文档、issue 等。
