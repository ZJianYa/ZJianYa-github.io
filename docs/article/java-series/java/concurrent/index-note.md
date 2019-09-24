# 概述

首先我们讲清楚所有类的功能，以及各个类之间的关系。  
比如 Executor 定义了 scheduler 的接口，实现了 scheduler 和 task （线程是 task ） 的分离。  
ExecutorService 接口则进一步扩充了功能，增加了 shoutdown ... submit ... 等相关接口。  
ThreadPoolExecutor 是 ExecutorService 的一个重要实现类。  
Executors 则提供各种各样的 ExecutorService。  

lock 和 condition  
http://gee.cs.oswego.edu/dl/cpj/index.html  
我们都知道

核心是 lock{lock,release} condition{wait,notify}  
如何去阅读源码，比如并发模块的源码。  
1. 要把"各个朋友"认识一下，各自都干啥
2. 这些朋友之间都是什么关系，亲疏远近、继承组合的关系要搞清楚，是怎么协调配合的。

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



## 