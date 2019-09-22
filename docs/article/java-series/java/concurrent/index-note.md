# 概述

首先我们讲清楚所有类的功能，以及各个类之间的关系。  
比如 Executor 定义了 scheduler 的接口，实现了 scheduler 和 task （线程是 task ） 的分离。  
ExecutorService 接口则进一步扩充了功能，增加了 shoutdown ... submit ... 等相关接口。  
ThreadPoolExecutor 是 ExecutorService 的一个重要实现类。  
Executors 则提供各种各样的 ExecutorService。  

## E-R

- lock  
  - java.util.concurrent.locks.ReentrantLock  
    - `java.util.concurrent.ConcurrentHashMap.Segment<K, V>`  
    - `org.springframework.util.ConcurrentReferenceHashMap.Segment`  
  - java.util.concurrent.locks.ReentrantReadWriteLock.ReadLock  
  - java.util.concurrent.locks.ReentrantReadWriteLock.WriteLock  
  - java.util.concurrent.locks.StampedLock.ReadLockView  
  - java.util.concurrent.locks.StampedLock.WriteLockView  

- java.util.concurrent.locks.AbstractOwnableSynchronizer
  - java.util.concurrent.locks.AbstractQueuedLongSynchronizer
  - java.util.concurrent.locks.AbstractQueuedSynchronizer
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