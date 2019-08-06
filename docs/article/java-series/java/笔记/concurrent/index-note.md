# 概述

JDK 官方文档并没有详尽的，或者按照 JDK 中的类来讲述整个并发方面的知识。  
我们从 3 个视角来学习并发方面的知识：  
1. 官方 JDK
2. Java 并发编程实战
3. JDK 类库的角度
4. 并发编程本身背景、因果的角度  

因为这一部分强调了并发，那么数据结构和并发之间要做权衡，并发优先  
最终的知识点都落在各个具体的文章中，这里只提供 逻辑梳理 、 TODO  

## 目录

### 多线程

为了并行执行多任务，比如基本的 web 容器内部都是用了多线程  
背景 / 用户内核线程 / 线程生命周期 / 性能指标：吞吐量和延迟  

### 线程安全

原子性，简单说就是相关操作不会中途被其他线程干扰，
可见性，是一个线程修改了某个共享变量，其状态能够立即被其他线程知晓，通常被解释为将线程本地状态反映到主内存上，volatile 就是负责保证可见性的。
有序性，是保证线程内串行语义，避免指令重排等。

#### 线程安全的底层支撑

根本上需要硬件支持，需要 禁止缓存  
- synchronized
- lock condition
指令支持 / 管程 

#### 线程安全-Java编码

lock condition / CAS / Immutable / ThreadLocal  
信号量：可以实现互斥、协同，但是容易死锁，且不能退出，没有Condition的概念的  
管程：考虑了 Condition 即可以实现阻塞队列，可以退出  

##### 内存模型 锁

CAS

##### 通信

##### 不常用手段

###### Immutable

对象是 final 的，其属性也都是 final 的（即不允许子类继承）。  
然后通过享元模式来减少创建重复的对象。  
享元模式本质上是个对象池，比如 Long 内部维护了一个 [-128,127] 。  

但是实话说，我们发现有什么应用场景。  

###### copy on write

案例： Linux 系统的 fork() ， String 、 Integer 、 Long 都是（但并不是说都线程安全，确切的说你使用不当会经常不安全）。  
适合读多写少的场景，我个人觉得还是面试的时候用吧，真实需求太少了。  

#### ThreadLocal  


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

