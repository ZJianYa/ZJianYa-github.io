# 概述

## 背景

### 性能

高内存/高CPU：性能问题，可能是内存泄露，也可能是参数不合理，如果并发量并不高则内存泄露的可能性比较大。  

低内存/高CPU：编码问题，比如正则表达式没有写好。  

目标：延时、吞吐量。  

### OOM

### 原因

参数不合理/内存泄露

## 预备知识

JVM 内存结构

工具和日志解读

## 思路

### 明确目标

### 手段

其实应该分为线上线下情况。  

jstat 查看 GC 状态  

#### 开启日志

打开 GC 日志

-XX:+PrintGCDetails
-XX:+PrintGCDateStamps

上面这两项在 JDK 9 中已经分别被废弃和移除。可以使用 `java -Xlog:help` 替代

-XX:+PrintAdaptiveSizePolicy // 打印 G1 Ergonomics 相关信息

我们知道 GC 内部一些行为是适应性的触发的，利用 PrintAdaptiveSizePolicy，我们就可以知道为什么 JVM 做出了一些可能我们不希望发生的动作。例如，G1 调优的一个基本建议就是避免进行大量的 Humongous 对象分配，如果 Ergonomics 信息说明发生了这一点，那么就可以考虑要么增大堆的大小，要么直接将 region 大小提高。

如果是怀疑出现引用清理不及时的情况，则可以打开下面选项，掌握到底是哪里出现了堆积。

-XX:+PrintReferenceGC

另外，建议开启选项下面的选项进行并行引用处理。

-XX:+ParallelRefProcEnabled

#### 针对情况做处理

- Young GC

如果发现 Young GC 非常耗时，这很可能就是因为新生代太大了，我们可以考虑减小新生代的最小比例。

-XX:G1NewSizePercent

降低其最大值同样对降低 Young GC 延迟有帮助。

-XX:G1MaxNewSizePercent

如果我们直接为 G1 设置较小的延迟目标值，也会起到减小新生代的效果，虽然会影响吞吐量。  

- Mixed GC

还记得前面说的，部分 Old region 会被包含进 Mixed GC，减少一次处理的 region 个数，就是个直接的选择之一。  

 我在上面已经介绍了 `G1OldCSetRegionThresholdPercent` 控制其最大值，还可以利用下面参数提高 Mixed GC 的个数，当前默认值是 8，Mixed GC 数量增多，意味着每次被包含的 region 减少。

 -XX:G1MixedGCCountTarget
