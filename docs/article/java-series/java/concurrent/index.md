# 概述

HashMap的问题

## 线程安全

- 原子性，简单说就是相关操作不会中途被其他线程干扰，一般通过同步机制实现。</p>
- 可见性，是一个线程修改了某个共享变量，其状态能够立即被其他线程知晓，通常被解释为将线程本地状态反映到主内存上，volatile 就是负责保证可见性的。
- 有序性，是保证线程内串行语义，避免指令重排等。

## 提供的同步方法

### 低效

Vector Stack Hashtable  

Synchronized Wrapper  

### 高效

- 并发容器  ConcurrentHashMap(基于分离锁)、CopyOnWriteArrayList
- 线程安全队列  ArrayBlockingQueue、SynchronousQueue

Queque Deque ConcurrentHashMap CopyOnWriteArrayList

## 其他

现代 JDK 中，synchronized 已经被不断优化，可以不再过分担心性能差异，另外，相比于 ReentrantLock，它可以减少内存消耗，这是个非常大的优势。

## FAQ

- AQS是什么  
  http://ifeve.com/java-special-troops-aqs/
