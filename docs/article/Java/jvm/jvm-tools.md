# 概述

官方文档：https://docs.oracle.com/javase/8/docs/technotes/guides/troubleshoot/

## 前提

你至少已经熟悉了JMM，也就是首先你懂了理论。  

## 工具

### JConsole  

jconsole概览图和主要的功能：概述、内存、线程、类、VM、MBeans。

#### 概述界面

事件和数量两个维度：  
堆内存使用量、活动线程数、加载的类数量、CUP占用率的折线图，可以非常清晰的观察在程序执行过程中的变动情况。

#### 内存

可以切换时间范围，可以切换内存的区域类型，也可以手动触发GC的执行

1. 已用/已提交是什么意思？
2. 是否可以看到

#### 线程

可以查看线程详情

#### 类



### JVisualVM  

### jstat  

### jmap  

### 容器工具  

Tomcat、Weblogic等J2EE工具自身也会提供一些工具

### Java Mission Control（JMC) 和 JFR

这里有一个相对特殊的部分，就是是堆外内存中的直接内存，前面的工具基本不适用，可以使用 JDK 自带的 Native Memory Tracking（NMT）特性，它会从 JVM 本地内存分配的角度进行解读。

