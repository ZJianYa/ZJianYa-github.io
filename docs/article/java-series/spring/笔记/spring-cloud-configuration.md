# 概述

翻译：https://www.baeldung.com/spring-cloud-configuration

这个配置仓库由Git管理版本，且可以在程序运行时被修改。  
虽然它非常适合使用所有支持的配置文件格式以及`Environment`，`PropertySource`或`@Value`等构造的Spring应用程序，但它可以在任何运行任何编程语言的环境中使用。  

在本文中，我们举的例子将重点介绍如何设置基于Git的配置服务器，在一个简单的REST应用中使用它，及设置包含加密属性值的安全环境。

## 搭建项目

服务端依赖：

客户端依赖：

## 编写服务端

现在我们需要配置服务端端口，一个`Git-url`提供`version-controlled configuration content`.  
