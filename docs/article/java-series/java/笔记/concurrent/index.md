# 概述

JDK 官方文档并没有详尽的，或者按照 JDK 中的类来讲述整个并发方面的知识。  
我们从 3 个视角来学习并发方面的知识：  
1. 官方 JDK
2. Java 并发编程实战
3. JDK 类库的角度
4. 并发编程本身背景、因果的角度  

因为这一部分强调了并发，那么数据结构和并发之间要做权衡，并发优先  
最终的知识点都落在各个具体的文章中，这里只提供 逻辑梳理 、 TODO  

## JDK 类库

JDK 类库大致分为  
同步容器： Collections.synchronizedList(new ArrayList());  Vector Stack HashTable  
并发容器： List（CopyOnWriteArrayList） Map（ConcurrentHashMap ConcurrentSkipListMap） Set  
阻塞队列 非阻塞队列 单端队列 双端队列 有界队列 无界队列  Queue/Deque  
同步结构:  CountDownLatch 、 CyclicBarrier 、 Semaphore    
Executor：  
Future:  
Fork/Join： 

## TODO

* 为什么可以利用对象不可变性，和 final 是一会事吗？  
* volatile 是否可以用来做锁使用？依赖了 happen-before 规则  
* CAS vs 管程 vs synchronized  
  CAS 的版本号究竟是如何控制的  
  管程究竟是如何实现的  
* happen-before 的几个规则  
* 方法可以被中断吗？如何防止被中断，或者什么情况下不能被中断  
  这可能涉及到 CPU 乱序执行的规则  
* 管程的实现  
* 即便是用NIO，也是需要 await 和 signAll() ？  
* 相对于 Semaphore 或者管程， 信号量 是不能允许多线程访问临界资源的？  
* AQS是什么  
  http://ifeve.com/java-special-troops-aqs/  

