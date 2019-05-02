---
sidebar: auto
---
# 概述

JVM的设计其实和操作系统有很多相像之处，毕竟很大程度上它干的就是OS的活儿，OS从某种意义上讲也是VM。

## JVM 内存模型

### 程序计数器
  
  PC，Program Counter Register  
  在 JVM 规范中，每个线程都有它自己的程序计数器，并且任何时间一个线程都只有一个方法在执行，也就是所谓的当前方法。  
  程序计数器会存储当前线程正在执行的 Java 方法的 JVM 指令地址；或者，如果是在执行native方法，则是未指定值（undefined）。  

### Java虚拟机栈

  Java Virtual Machine Stack  
  早期也叫 Java 栈。每个线程在创建时都会创建一个虚拟机栈，其内部保存一个个的栈帧（Stack Frame），对应着一次次的 Java 方法调用。  
  前面谈程序计数器时，提到了当前方法；同理，在一个时间点，对应的只会有一个活动的栈帧，通常叫作当前帧，方法所在的类叫作当前类。  
  如果在该方法中调用了其他方法，对应的新的栈帧会被创建出来，成为新的当前帧，一直到它返回结果或者执行结束。  
  JVM 直接对 Java 栈的操作只有两个，就是对栈帧的压栈和出栈。
  栈帧中存储着局部变量表、操作数（operand）栈、动态链接、方法正常退出或者异常退出的定义等。  

### Heap  

  它是 Java 内存管理的核心区域，用来放置 Java 对象实例，几乎所有创建的 Java 对象实例都是被直接分配在堆上。  
  堆被所有的线程共享，在虚拟机启动时，我们指定的“Xmx”之类参数就是用来指定最大堆空间等指标。  
  理所当然，堆也是垃圾收集器重点照顾的区域，所以堆内空间还会被不同的垃圾收集器进行进一步的细分，最有名的就是新生代、老年代的划分。  

### 方法区  

  Method Area。这也是所有线程共享的一块内存区域，用于存储所谓的元（Meta）数据，例如类结构信息，以及对应的运行时常量池、字段、方法代码等。  
  由于早期的 Hotspot JVM 实现，很多人习惯于将方法区称为永久代（Permanent Generation）。  
  Oracle JDK 8 中将永久代移除，同时增加了元数据区（Metaspace）。

#### 运行时常量池  

  Run-Time Constant Pool，这是方法区的一部分。  
  如果仔细分析过反编译的类文件结构，你能看到版本号、字段、方法、超类、接口等各种信息，还有一项信息就是常量池。  
  Java 的常量池可以存放各种常量信息，不管是编译期生成的各种字面量，还是需要在运行时决定的符号引用，所以它比一般语言的符号表存储的信息更加宽泛。  

### 本地方法栈  

  Native Method Stack。它和 Java 虚拟机栈是非常相似的，支持对本地方法的调用，也是每个线程都会创建一个。  
  在 Oracle Hotspot JVM 中，本地方法栈和 Java 虚拟机栈是在同一块儿区域，这完全取决于技术实现的决定，并未在规范中强制。  

![内存结构图](https://static001.geekbang.org/resource/image/36/bc/360b8f453e016cb641208a6a8fb589bc.png)  

### 其他区域

- 直接内存（Direct Memory）区域
  Direct Buffer 占用的区域，可参考NIO相关知识。

- 其他内存  
  JVM 本身是个本地程序，还需要其他的内存去完成各种基本任务，比如，JIT Compiler 在运行时对热点方法进行编译，就会将编译后的方法储存在 Code Cache 里面；GC 等功能需要运行在本地线程之中，类似部分都需要占用内存空间。这些是实现 JVM JIT 等功能的需要，但规范中并不涉及。

### 堆区域

{Young: {Eden ,Survivor: {S0 S1}, Virtual}, Old: {Tenured, Virtual},Permanent: {Permanent, Virtual}}

- Eden  
  Thread Local Allocation Buffer  
  OpenJDK 衍生出来的 JVM 都提供了 TLAB 的设计。这是 JVM 为每个线程分配的一个私有缓存区域，否则，多线程同时分配内存时，为避免操作同一地址，可能需要使用加锁等机制，进而影响分配速度。  
- Survivor  
  from to ?
- Old  
  放置长生命周期的对象，通常都是从 Survivor 区域拷贝过来的对象。当然，也有特殊情况，我们知道普通的对象会被分配在 TLAB 上；如果对象较大，JVM 会试图直接分配在 Eden 其他位置上；如果对象太大，完全无法在新生代找到足够长的连续空闲空间，JVM 就会直接分配到老年代。  
- Permanent  
  这部分是早期 Hotspot JVM 的方法区实现方式，储存 Java 类元数据、常量池、Intern 字符串缓存，在 JDK 8 之后就不存在永久代这块儿了。
  
## 参数

### 堆区域内存

-Xms value  初始堆最小值

-Xmx value  堆最大值

-XX:NewRatio=value  新老代比例值
默认情况下，这个数值是 3，意味着老年代是新生代的 3 倍大；换句话说，新生代是堆大小的 1/4。

-XX:NewSize=value  直接设置新生代大小

-XX:SurvivorRatio=value  设置幸存区比值，相对于Eden的比值  
Eden 和 Survivor 的大小是按照比例设置的，如果 SurvivorRatio 是 8，那么 Survivor 区域就是 Eden 的 1/8 大小，也就是新生代的 1/10，因为 YoungGen=Eden + 2*Survivor  

在 JVM 内部，如果 Xms 小于 Xmx，堆的大小并不会直接扩展到其上限，也就是说保留的空间（reserved）大于实际能够使用的空间（committed）。当内存需求不断增长的时候，JVM 会逐渐扩展新生代等区域的大小，所以 Virtual 区域代表的就是暂时不可用（uncommitted）的空间。

### 堆外内存

首先是准备工作，开启 NMT 并选择 summary 模式

-XX:NativeMemoryTracking=summary

为了方便获取和对比 NMT 输出，选择在应用退出时打印 NMT 统计信息

-XX:+UnlockDiagnosticVMOptions -XX:+PrintNMTStatistics

### GC

-XX:+UseSerialGC

### Code Cache

接下来是 Code 统计信息，显然这是 CodeCache 相关内存，也就是 JIT compiler 存储编译热点方法等信息的地方，JVM 提供了一系列参数可以限制其初始值和最大值等，例如：

-XX:InitialCodeCacheSize=value  

-XX:ReservedCodeCacheSize=value

### Metaspace

是 Class 内存占用，它所统计的就是 Java 类元数据所占用的空间，JVM 可以通过类似下面的参数调整其大小：

-XX:MaxMetaspaceSize=value
