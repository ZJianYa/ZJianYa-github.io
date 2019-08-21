# 概述

https://docs.oracle.com/javase/specs/jvms/se11/html/index.html jvm Specification
https://www.artima.com/insidejvm/ed2/index.html  Inside the Java Virtual Machine  
http://blog.jamesdbloom.com/JVMInternals.html  
https://dzone.com/articles/jvm-architecture-explained The JVM Architecture Explained  
https://www.open-open.com/lib/view/open1420814127390.html  Linux与JVM的内存关系分析

## Specification

* 1. introduction
* 2. The Structure of the Java Virtual Machine  
  * 2.1. The class File Format
  * 2.2. Data Types
  * 2.3. Primitive Types and Values
  * 2.4. Reference Types and Values
  * 2.5. Run-Time Data Areas
  * 2.6. Frames
  * 2.7. Representation of Objects
  * 2.8. Floating-Point Arithmetic
  * 2.9. Special Methods
  * 2.10. Exceptions
  * 2.11. Instruction Set Summary
  * 2.12. Class Libraries
  * 2.13. Public Design, Private Implementation
* 3. Compiling for the Java Virtual Machine
* 4. The class File Format
* 5. Loading, Linking, and Initializing
* 6. The Java Virtual Machine Instruction Set
* 7. Opcode Mnemonics by Opcode
* A. Limited License Grant

## JVM 初识

JVM 内存结构

## JVM 内存详解

内存各部分如何配置

## JVM 调优

参见 GC-参数和调优

## GC 详解

GC 算法，GC 类型

### gc-over

### gc-opti

### gc-g1

## JVM tools

## JVM-调优

## 参考

http://blog.codinglabs.org/articles/consistent-hashing.html  一致性哈希
http://www.zhuxingsheng.com/blog/gc-and-jvm-parameters.html  GC及JVM参数  
https://www.jianshu.com/p/c76afd5b0df0  一个 JVM 参数引发的频繁 CMS GC  
https://mp.weixin.qq.com/s?__biz=MzIwMzY1OTU1NQ==&mid=2247485815&idx=1&sn=3fc93825f40866c5cf5395ed0adc82c8&chksm=96cd493ba1bac02d6e819ba6d6ab13ef9b0f1fee817766cb65288fee48a724de8143047e8e26&scene=27#wechat_redirect jvm 内存溢出分析
每个人碰到的问题都是不一样的，但是基本知识需要都是一样的  

https://yq.aliyun.com/articles/699342?spm=a2c4e.11155472.0.0.210c134dAs742j#  JVM十六道面试题！

类加载器 —> 内存模型—> JVM选项调优—> GC策略调优，内存泄露排查  

https://zhuanlan.zhihu.com/p/44886959 饿了么工具部  

https://mp.weixin.qq.com/s?__biz=MzI4NDY5Mjc1Mg==&mid=2247486558&idx=1&sn=4f2f8539e14510e39972d28979bee47c&chksm=ebf6d421dc815d37e59b83e4aa2156617d4d3c25d5afd93a439eb77c1a78af264b72c7e23be1&scene=27#wechat_redirect G1 特性

