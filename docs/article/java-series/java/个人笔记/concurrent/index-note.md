# 概述

JDK 官方文档并没有详尽的，或者按照 JDK 中的类来讲述整个并发方面的知识。  
我们从 3 个视角来学习并发方面的知识：  
1. 官方 JDK  
2. JDK 类库的角度  
  这是核心，我们既要知道如何用，也应该知道为什么这样用。  
  学习过程中，要以
3. Java 并发编程实战  
4. 并发编程本身背景、因果的角度  

因为这一部分强调了并发，那么数据结构和并发之间要做权衡，并发优先  
最终的知识点都落在各个具体的文章中，这里只提供 逻辑梳理 、 TODO  

## 资源

https://docs.oracle.com/javase/tutorial/essential/index.html  
https://www.baeldung.com/java-fork-join  

https://mp.weixin.qq.com/s?__biz=MzAxODcyNjEzNQ==&mid=2247485701&idx=1&sn=471710ed79f15283edc0f341f17364ba&chksm=9bd0a49daca72d8bd4269f8980f412bbd5de0367e2bb9889694cedeefb9bbf8dace6165c6118&scene=27#wechat_redirect  HashMap? ConcurrentHashMap?  

## 如何学习这部分知识

阅读源码和文档。如何去阅读源码，比如并发模块的源码？  
1. 要把"各个朋友"认识一下，各自都干啥  
2. 这些朋友之间都是什么关系，亲疏远近、继承组合的关系要搞清楚，是怎么协调配合的。  

比如 Executor 定义了 scheduler 的接口，实现了 scheduler 和 task （线程是 task ） 的分离。  
ExecutorService 接口则进一步扩充了功能，增加了 shoutdown ... submit ... 等相关接口。  
ThreadPoolExecutor 是 ExecutorService 的一个重要实现类。  
Executors 则提供各种各样的 ExecutorService。  

核心是 lock{lock,release} condition{wait,notify}  
1. 使用 lock 来封锁临界区  
2. 通过 lock 和 Sync 相关， Condition 可以操作 Sync ？  

## E-R

- lock  
  - java.util.concurrent.locks.ReentrantLock  
    ReentrantLock 本身只是 lock ，使用的 Sync 提供了 Condition 。  
    - `java.util.concurrent.ConcurrentHashMap.Segment<K, V>`  
    - `org.springframework.util.ConcurrentReferenceHashMap.Segment`  
  - java.util.concurrent.locks.ReentrantReadWriteLock.ReadLock  
  - java.util.concurrent.locks.ReentrantReadWriteLock.WriteLock  
  - java.util.concurrent.locks.StampedLock.ReadLockView  
  - java.util.concurrent.locks.StampedLock.WriteLockView  

- java.util.concurrent.locks.AbstractOwnableSynchronizer  
  - java.util.concurrent.locks.AbstractQueuedLongSynchronizer  
  - java.util.concurrent.locks.AbstractQueuedSynchronizer  
    其中包含了 Condition ，本身又是 Sync  
    - java.util.concurrent.CountDownLatch.Sync  
    - java.util.concurrent.locks.ReentrantLock.Sync  
      - java.util.concurrent.locks.ReentrantLock.FairSync  
      - java.util.concurrent.locks.ReentrantLock.NonFairSync  
    - java.util.concurrent.locks.ReentrantReadWriteLock.Sync  
      - java.util.concurrent.locks.ReentrantReadWriteLock.Sync  
      - java.util.concurrent.locks.ReentrantReadWriteLock.Sync  
    - java.util.concurrent.Semaphore.Sync  
      - java.util.concurrent.Semaphore.Sync  
      - java.util.concurrent.Semaphore.Sync  
    - java.util.concurrent.ThreadPoolExecutor.Worker  

- java.util.concurrent.locks.Condition  
  - java.util.concurrent.locks.AbstractQueuedLongSynchronizer.ConditionObject  
  - java.util.concurrent.locks.AbstractQueuedSynchronizer.ConditionObject  

- java.util.concurrent.ThreadFactory  
  - java.util.concurrent.Executors.DefaultThreadFactory  
  - com.zaxxer.hikari.util.UtilityElf.DefaultThreadFactory  

- `java.util.concurrent.Future<V>`
  - `java.util.concurrent.ForkJoinTask<V>`  
  - `java.util.concurrent.RunnableFuture<V>`  
    - `java.util.concurrent.FutureTask<V>`  
      - `javafx.concurrent.Task<V>`  

## 目录

### 多线程起源

略

### lock 

一方面是借助了 happen-before 来保证了临界区的互斥和同步, 通过 unsafe 提供的一些能力，比如 park 方法来实现等待？  

#### sycnronized

#### volatile

#### cas 和原子类

#### lock condition



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


https://mp.weixin.qq.com/s?__biz=MzI4NDY5Mjc1Mg==&mid=2247486871&idx=1&sn=df2adfad945bd34d27dee557537a0782&chksm=ebf6d5e8dc815cfee8b282b31580ba8504f76b052f3ac9431b26f4f7e057a0cff5f57dfbead6&scene=27#wechat_redirect 关于锁，这里解释的不错。

https://mp.weixin.qq.com/s?__biz=MzI3NzE0NjcwMg==&mid=2650121186&idx=1&sn=248d37be27d3bbeb103464b2a96a0ae4&chksm=f36bbec3c41c37d59277ac8539a616b65ec44637f341325056e98323e8780e09c6e4f7cc7a85&scene=21#wechat_redirect 多线程和锁优化