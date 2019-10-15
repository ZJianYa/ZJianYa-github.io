# 概述

JDK 官方 tutorial 文档并没有详尽的，或者按照 JDK 中的类来讲述整个并发方面的知识。  
我们从 3 个来源来学习并发方面的知识：  
1. JDK 官方 tutorial  
2. JDK 类库的 API  
  这是核心，我们既要知道如何用，也应该知道为什么这样用。  
  当你知道了为什么，你才更容易记住如何用。前者是死记硬背，而后者是理解性记忆。  
3. Java 并发编程实战  
4. 并发编程本身背景、因果的角度  

因为这一部分强调了并发，那么数据结构和并发之间要做权衡，并发优先。  
最终的知识点都落在各个具体的文章中，这里只提供 逻辑梳理 、 TODO  

## 多线程起源  
https://dzone.com/articles/understanding-thread-interruption-in-java  
## jmm-volatile  
## 计算机内存和CPU  
## happen-before  
## volatile  
略
## 概述
### 如何学习这部分知识  
### E-R 梳理  
### 参考资源  
## unsafe 和 cas  
## AbstractQueuedSynchronizer  
- AQS 使用说明
- AQS 实现细节
## lock condition  
- lock  
- condition  
## 常见同步结构
- CountDownlatch  
  当前线程等待多个线程执行结束  
- CyclicBarrier  
  多个线程在内部执行过程中，等待达到某个点  
- Semaphore  
  
## 线程安全的容器  

- ConcurrentHashMap  
  即用了 CAS 也用了 synchronized  
- ConcurrentSkipListMap  
  TODO  
- CopyOnWriteArrayList  
- BlockedQueue  
  - ArrayBlockingQueue  
  - SynchrousQueue  
  - PriorityBlockingQueue  

## 调度框架和线程池

- Executor  
  - ExecutorService I  
   - ThreadPoolExecutor C  

## sycnronized  

## TODO

* 为什么可以利用对象不可变性，和 final 是一会事吗？  
* volatile 是否可以用来做锁使用？依赖了 happen-before 规则  
  condition 是怎么回事
* CAS vs 管程 vs synchronized  
  CAS 的版本号究竟是如何控制的  
* 管程和信号量  
  https://en.wikipedia.org/wiki/Reference_monitor  
  https://www.jianshu.com/p/32e1361817f0  管程  
  信号量和管程的区别是什么？  
  管程可以暂时释放锁，而信号量不可以释放锁  
* happen-before 的几个规则  
* 方法可以被中断吗？如何防止被中断，或者什么情况下不能被中断  
  这可能涉及到 CPU 乱序执行的规则  
* 管程的实现  
* 即便是用NIO，也是需要 await 和 signAll() ？  
* 相对于 Semaphore 或者管程， 信号量 是不能允许多线程访问临界资源的？  
* AQS是什么  
  http://ifeve.com/java-special-troops-aqs/  


https://mp.weixin.qq.com/s?__biz=MzI4NDY5Mjc1Mg==&mid=2247486871&idx=1&sn=df2adfad945bd34d27dee557537a0782&chksm=ebf6d5e8dc815cfee8b282b31580ba8504f76b052f3ac9431b26f4f7e057a0cff5f57dfbead6&scene=27#wechat_redirect 『浅入浅出』MySQL 和 InnoDB 关于锁，这里解释的不错。

https://mp.weixin.qq.com/s?__biz=MzI3NzE0NjcwMg==&mid=2650121186&idx=1&sn=248d37be27d3bbeb103464b2a96a0ae4&chksm=f36bbec3c41c37d59277ac8539a616b65ec44637f341325056e98323e8780e09c6e4f7cc7a85&scene=21#wechat_redirect 多线程和锁优化