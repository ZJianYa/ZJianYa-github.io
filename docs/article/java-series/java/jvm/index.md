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

* 如何知道当前线程使用了哪种 GC，当然在 GC 日志中也必然会存在 GC 类型
```
[elsearch@localhost bin]$ ./jinfo -flags 3649
VM Flags:
-XX:+AlwaysPreTouch -XX:CICompilerCount=12 -XX:CMSInitiatingOccupancyFraction=75 -XX:ErrorFile=logs/hs_err_pid%p.log -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=data -XX:InitialHeapSize=1073741824 -XX:MaxDirectMemorySize=536870912 -XX:MaxHeapSize=1073741824 -XX:MaxNewSize=357892096 -XX:MaxTenuringThreshold=6 -XX:MinHeapDeltaBytes=196608 -XX:NewSize=357892096 -XX:NonNMethodCodeHeapSize=7591728 -XX:NonProfiledCodeHeapSize=122033256 -XX:OldSize=715849728 -XX:-OmitStackTraceInFastThrow -XX:ProfiledCodeHeapSize=122033256 -XX:ReservedCodeCacheSize=251658240 -XX:+SegmentedCodeCache -XX:ThreadStackSize=1024 -XX:+UseCMSInitiatingOccupancyOnly -XX:+UseCompressedClassPointers -XX:+UseCompressedOops -XX:+UseConcMarkSweepGC -XX:+UseFastUnorderedTimeStamps 
[elsearch@localhost bin]$ 
```
* 查看可用的 GC 类型

