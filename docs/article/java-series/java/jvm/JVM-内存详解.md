# JVM 内存详解

## heap

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

### 参数

-Xms value  初始堆最小值

-Xmx value  堆最大值

-XX:NewRatio=value  新老代比例值
默认情况下，这个数值是 3，意味着老年代是新生代的 3 倍大；换句话说，新生代是堆大小的 1/4。

-XX:NewSize=value  直接设置新生代大小

-XX:SurvivorRatio=value  设置幸存区比值，相对于Eden的比值  
Eden 和 Survivor 的大小是按照比例设置的，如果 SurvivorRatio 是 8，那么 Survivor 区域就是 Eden 的 1/8 大小，也就是新生代的 1/10，因为 YoungGen=Eden + 2*Survivor  

在 JVM 内部，如果 Xms 小于 Xmx，堆的大小并不会直接扩展到其上限，也就是说保留的空间（reserved）大于实际能够使用的空间（committed）。当内存需求不断增长的时候，JVM 会逐渐扩展新生代等区域的大小，所以 Virtual 区域代表的就是暂时不可用（uncommitted）的空间。

## 堆外内存

### native

首先是准备工作，开启 NMT 并选择 summary 模式

-XX:NativeMemoryTracking=summary

为了方便获取和对比 NMT 输出，选择在应用退出时打印 NMT 统计信息

-XX:+UnlockDiagnosticVMOptions -XX:+PrintNMTStatistics

### Code Cache

接下来是 Code 统计信息，显然这是 CodeCache 相关内存，也就是 JIT compiler 存储编译热点方法等信息的地方，JVM 提供了一系列参数可以限制其初始值和最大值等，例如：

-XX:InitialCodeCacheSize=value  

-XX:ReservedCodeCacheSize=value

### Metaspace

是 Class 内存占用，它所统计的就是 Java 类元数据所占用的空间，JVM 可以通过类似下面的参数调整其大小：

-XX:MaxMetaspaceSize=value

### stack