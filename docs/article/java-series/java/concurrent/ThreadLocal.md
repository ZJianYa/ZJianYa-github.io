# 概述

主要是因为大部分的处理数据的对象都是单例的，在单例对象中存储数据是有线程安全的风险的，所以 ThreadLocal 在多线程场景下是一个解决变量独享的方法。  

## 应用场景

在一个请求会话中，获取上下文中的信息，比如Token。  

## 使用方法  

## 源码解析  

## 坑

- 为啥要在 ThreadLocalMap 要存储在 Thread 中，而不是存储在 ThreadLocal 中？  
  因为根据亲缘原则应该这样分配
- ThreadLocal 最好不要和线程池功用，否则很容易内存泄漏。 如果一定要用，记着用 try{}finally{ threadlocal.remove()} 移除与线程绑定的变量。

## FAQ

- ThreadLocal 是一个工具类，那为啥不提供静态方法使用？  
  因为 ThreadLocal 可以定义多个，一旦定义为静态则需要重构 ThreadLocal  
- ThreadLocal 只能存储一个数据，那么为什么还要使用一个 Map (ThreadLocalMap) 存储数据？  
  因为 ThreadLocal 可以定义为多个，那么 get 的时候都是从一个线程中取，而且是 Thread 只定义一个属性。  
- 为啥 entry 要定义为  
  jdk1.2以后，引用就被分为四种类型：强引用、弱引用、软引用和虚引用。强引用就是我们常用的Object obj = new Object()，obj就是一个强引用，指向了对象内存空间。  
  当内存空间不足时，Java垃圾回收程序发现对象有一个强引用，宁愿抛出OutofMemory错误，也不会去回收一个强引用的内存空间。  
  而弱引用，即WeakReference，意思就是当一个对象只有弱引用指向它时，垃圾回收器不管当前内存是否足够，都会进行回收。  
  反过来说，这个对象是否要被垃圾回收掉，取决于是否有强引用指向。  
  ThreadLocalMap这么做，是不想因为自己存储了ThreadLocal对象，而影响到它的垃圾回收，而是把这个主动权完全交给了调用方，一旦调用方不想使用，设置ThreadLocal对象为null，内存就可以被回收掉。  
  https://mp.weixin.qq.com/s?__biz=MzI3NzE0NjcwMg==&mid=2650123032&idx=1&sn=9b2d029e66cfe1a40454bdf2da37a915&chksm=f36bb639c41c3f2fbf55aa6a8b43dafb15c90af49b8565782866f68a776bde646a232608938b&scene=27#wechat_redirect  

  