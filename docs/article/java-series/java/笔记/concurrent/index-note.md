# 概述

JDK 官方文档并没有详尽的，或者按照 JDK 中的类来讲述整个并发方面的知识。  
我们从 3 个视角来学习并发方面的知识：  
1. 官方 JDK
2. Java 并发编程实战
3. JDK 类库的角度
4. 并发编程本身背景、因果的角度  

因为这一部分强调了并发，那么数据结构和并发之间要做权衡，并发优先  
最终的知识点都落在各个具体的文章中，这里只提供 逻辑梳理 、 TODO  

## 资源

https://docs.oracle.com/javase/tutorial/essential/index.html  
https://www.baeldung.com/java-fork-join  

https://mp.weixin.qq.com/s?__biz=MzAxODcyNjEzNQ==&mid=2247485701&idx=1&sn=471710ed79f15283edc0f341f17364ba&chksm=9bd0a49daca72d8bd4269f8980f412bbd5de0367e2bb9889694cedeefb9bbf8dace6165c6118&scene=27#wechat_redirect  HashMap? ConcurrentHashMap?  

## 目录

### 多线程

为了并行执行多任务，比如基本的 web 容器内部都是用了多线程  
背景 / 用户内核线程 / 线程生命周期 / 性能指标：吞吐量和延迟  

### 线程安全

#### 底层支撑（线程安全的）

#### Java 内存模型

同步，通信

#### Java 线程安全实现

##### synchronized

##### Java 类库  

## TODO

* 为什么可以利用对象不可变性，和 final 是一会事吗？  
* volatile 是否可以用来做锁使用？依赖了 happen-before 规则  
  condition 是怎么回事
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

