# 概述

## 前提

你至少已经熟悉了JMM，也就是首先你懂了理论。  

## 工具

### JConsole  

### VisualVM  

### jstat  

### jmap  

### 容器工具  

Tomcat、Weblogic等J2EE工具自身也会提供一些工具

### Java Mission Control（JMC) 和 JFR

这里有一个相对特殊的部分，就是是堆外内存中的直接内存，前面的工具基本不适用，可以使用 JDK 自带的 Native Memory Tracking（NMT）特性，它会从 JVM 本地内存分配的角度进行解读。

