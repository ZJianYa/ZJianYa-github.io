# 概述

源码：  
http://hg.openjdk.java.net/jdk7/jdk7/jdk/file/9b8c96f96a0f/src/share/classes/java/util/concurrent/ConcurrentHashMap.java

数据存储利用 volatile 来保证可见性。

## jdk 8之前

- 分离锁，也就是将内部进行分段（Segment），里面则是 HashEntry 的数组，和 HashMap 类似，哈希相同的条目也是以链表形式存放。
  通过分段加锁segment，一个hashmap里有若干个segment，每个segment里有若干个桶，桶里存放K-V形式的链表，put数据时通过key哈希得到该元素要添加到的segment，然后对segment进行加锁，然后在哈希，计算得到给元素要添加到的桶，然后遍历桶中的链表，替换或新增节点到桶中。
- HashEntry 内部使用 volatile 的 value 字段来保证可见性，也利用了不可变对象的机制以改进利用 Unsafe 提供的底层能力，比如 volatile access，去直接完成部分操作，以最优化性能，毕竟 Unsafe 中的很多操作都是 JVM intrinsic 优化过的。

所以，从上面的源码清晰的看出，在进行并发写操作时：

- ConcurrentHashMap 会获取再入锁，以保证数据一致性，Segment 本身就是基于 ReentrantLock 的扩展实现，所以，在并发修改期间，相应 Segment 是被锁定的。
- 在最初阶段，进行重复性的扫描，以确定相应 key 值是否已经在数组里面，进而决定是更新还是放置操作，你可以在代码里看到相应的注释。重复扫描、检测冲突是 ConcurrentHashMap 的常见技巧。
- 在 ConcurrentHashMap 中扩容时不是整体的扩容，而是单独对 Segment 进行扩容，细节就不介绍了。
- Map 的 size 方法同样需要关注，它的实现涉及分离锁的一个副作用。
  分段计算两次，两次结果相同则返回，否则对所以段加锁重新计算。

## JDK 8

- 总体结构上是大的桶（bucket）数组，segment数量与桶数量一致，然后内部也是一个个所谓的链表结构（bin），同步的粒度要更细致一些。
  其内部仍然有 Segment 定义，但仅仅是为了保证序列化时的兼容性而已，不再有任何结构上的用处。
- 初始化：因为不再使用 Segment，初始化操作大大简化，修改为 lazy-load 形式，这样可以有效避免初始开销，解决了老版本很多人抱怨的这一点。
  首先判断容器是否为空，为空则进行初始化利用volatile的sizeCtl作为互斥手段，如果发现竞争性的初始化，就暂停在那里，等待条件恢复，否则利用CAS设置排他标志（U.compareAndSwapInt(this, SIZECTL, sc, -1)）;否则重试。
- 数据存储利用 volatile 来保证可见性。
- 使用 CAS 等操作，在特定场景进行无锁并发操作。
  对key hash计算得到该key存放的桶位置，判断该桶是否为空，为空则利用CAS设置新节点。否则使用synchronize加锁，遍历桶中数据，替换或新增加点到桶中。
  最后判断是否需要转为红黑树，转换之前判断是否需要扩容。  
- 使用 Unsafe、LongAdder 之类底层手段，进行极端情况的优化。
  如，size()中利用LongAdd累加计算获得。


