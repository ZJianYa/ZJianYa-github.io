# 概述

<p>从内存区域的角度，G1 同样存在着年代的概念，但是与我前面介绍的内存结构很不一样，其内部是类似棋盘状的一个个 region 组成，请参考下面的示意图。<br>
<img src="https://static001.geekbang.org/resource/image/a6/f1/a662fda0de8af087c37c40a86a9cf3f1.png" alt=""></p>

<p>region 的大小是一致的，数值是在 1M 到 32M 字节之间的一个 2 的幂值数，JVM 会尽量划分 2048 个左右、同等大小的 region，这点可以从源码<a href="http://hg.openjdk.java.net/jdk/jdk/file/fa2f93f99dbc/src/hotspot/share/gc/g1/heapRegionBounds.hpp">heapRegionBounds.hpp</a>中看到。当然这个数字既可以手动调整，G1 也会根据堆大小自动进行调整。</p>

在 G1 实现中，年代是个逻辑概念，具体体现在，一部分 region 是作为 Eden，一部分作为 Survivor，除了意料之中的 Old region，G1 会将超过 region 50% 大小的对象（在应用中，通常是 byte 或 char 数组）归类为 Humongous 对象，并放置在相应的 region 中。逻辑上，Humongous region 算是老年代的一部分，因为复制这样的大对象是很昂贵的操作，并不适合新生代 GC 的复制算法。

<p>例如，region 大小和大对象很难保证一致，这会导致空间的浪费。不知道你有没有注意到，我的示意图中有的区域是 Humongous 颜色，但没有用名称标记，这是为了表示，特别大的对象是可能占用超过一个 region 的。并且，region 太小不合适，会令你在分配大对象时更难找到连续空间，这是一个长久存在的情况，请参考<a href="http://mail.openjdk.java.net/pipermail/hotspot-gc-use/2017-November/002726.html">OpenJDK 社区的讨论</a>。这本质也可以看作是 JVM 的 bug，尽管解决办法也非常简单，直接设置较大的 region 大小，参数如下：</p>

-XX:G1HeapRegionSize=<N, 例如 16>M

在新生代，G1 采用的仍然是并行的复制算法，所以同样会发生 Stop-The-World 的暂停。

在老年代，大部分情况下都是并发标记，而整理（Compact）则是和新生代 GC 时捎带进行，并且不是整体性的整理，而是增量进行的。

## 算法

<ul>
<li>
<p>在新生代，G1 采用的仍然是并行的复制算法，所以同样会发生 Stop-The-World 的暂停。</p>
</li>
<li>
<p>在老年代，大部分情况下都是并发标记，而整理（Compact）则是和新生代 GC 时捎带进行，并且不是整体性的整理，而是增量进行的。</p>
</li>
</ul>

习惯上人们喜欢把新生代 GC（Young GC）叫作 Minor GC，老年代 GC 叫作 Major GC，区别于整体性的 Full GC。  
但是现代 GC 中，这种概念已经不再准确，对于 G1 来说：  

<ul>
<li>
<p>Minor GC 仍然存在，虽然具体过程会有区别，会涉及 Remembered Set 等相关处理。</p>
</li>
<li>
<p>老年代回收，则是依靠 Mixed GC。并发标记结束后，JVM 就有足够的信息进行垃圾收集，Mixed GC 不仅同时会清理 Eden、Survivor 区域，而且还会清理部分 Old 区域。可以通过设置下面的参数，指定触发阈值，并且设定最多被包含在一次 Mixed GC 中的 region 比例。</p>
</li>
</ul>

G1 相关概念非常多，有一个重点就是 Remembered Set，用于记录和维护 region 之间对象的引用关系。为什么需要这么做呢？试想，新生代 GC 是复制算法，也就是说，类似对象从 Eden 或者 Survivor 到 to 区域的“移动”，其实是“复制”，本质上是一个新的对象。在这个过程中，需要必须保证老年代到新生代的跨区引用仍然有效。下面的示意图说明了相关设计。

我们知道老年代对象回收，基本要等待并发标记结束。这意味着，如果并发标记结束不及时，导致堆已满，但老年代空间还没完成回收，就会触发 Full GC，所以触发并发标记的时机很重要。早期的 G1 调优中，通常会设置下面参数，但是很难给出一个普适的数值，往往要根据实际运行结果调整

## FAQ

humongous 对象直接分配在老年代，避免复制。在 major gc 的时候回收，那么问题是如果这个对象其实生存周期很短，那么会不会被回收的相对迟了？  
