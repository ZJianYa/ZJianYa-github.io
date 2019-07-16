# 概述

因为这一部分强调了并发，那么数据结构和并发之间要做权衡，并发优先

## 背景

1. 为了并行执行多任务，比如基本的 web 容器内部都是用了多线程

## 问题

- 线程安全
  - 不安全  
    当线程之间发生数据共享时，就存在安全风险  
    线程之间的通信也是需要使用共享数据的  
    - 如何实现安全
      - synchronization  
        - 锁  
    - 安全的标准
      - 原子性，简单说就是相关操作不会中途被其他线程干扰，一般通过同步机制实现。  
      - 可见性，是一个线程修改了某个共享变量，其状态能够立即被其他线程知晓，通常被解释为将线程本地状态反映到主内存上，volatile 就是负责保证可见性的。  
      - 有序性，是保证线程内串行语义，避免指令重排等。  
  - 安全  
    参考线程不安全  
    

## 锁

锁的分类，参见 lock.md

- synchronized  
  锁的升级降级
- lock

### synchronized  

### 同步器

所有的基础是 `AbstractQueuedSynchronizer` ，其他的 `Sync` 都是继承于此  
AbstractQueuedSynchronizer 本质上使用的是 CAS 的方式判断和更改信号量  

- CountDownLatch 内部使用 `Sync extends AbstractQueuedSynchronizer` 同步，可以用作指定数量线程的“一次性同步器”
- CyclicBarrier 内部使用 ReentrantLock 同步，是 CountDownLatch 的一个改进版，可以多次复用
- Semaphore 内部使用 `Sync extends AbstractQueuedSynchronizer` 同步，是一个信号量  
- Phaser 

### lock

- lock  
  大多数的
  - ReentrantLock 内部使用 `Sync` 同步
- StampedLock 信号量 使用 Unsafe

## JUC

### 锁

### 容器

- 低效  
  Vector Stack Hashtable  
  Synchronized Wrapper  
- 高效  
  - 并发容器  ConcurrentHashMap (基于分离锁) 、 CopyOnWriteArrayList
  - 线程安全队列  ArrayBlockingQueue、SynchronousQueue、Queque Deque ConcurrentHashMap CopyOnWriteArrayList  
    基本上都是使用 ReentrantLock 同步

### 队列

- ArrayBlockingQueue 内部使用 ReentrantLock 同步

### Executor


## 其他

现代 JDK 中，synchronized 已经被不断优化，可以不再过分担心性能差异，另外，相比于 ReentrantLock，它可以减少内存消耗，这是个非常大的优势。  

## FAQ

- AQS是什么  
  http://ifeve.com/java-special-troops-aqs/

- Condition