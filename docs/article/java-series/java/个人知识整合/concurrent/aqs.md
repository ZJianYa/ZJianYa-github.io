
JDK 提供的编程式锁，核心类是 AbstractQueuedSynchronizer ，已经在“概述”中做过解释。  

```
public class ReentrantLock implements Lock, java.io.Serializable {
  abstract static class Sync extends AbstractQueuedSynchronizer{}
  static final class NonfairSync extends Sync {}
  static final class FairSync extends Sync {}
}
```

## 整体设计思路

AQS 的功能可以分为两类：独占功能和共享功能。  
它的所有子类中，要么实现并使用了它独占功能的 API，要么使用了共享锁的功能，而不会同时使用两套 API。  
它最有名的子类 ReentrantReadWriteLock ，也是通过两个内部类：读锁和写锁，分别实现的两套 API 来实现的，为什么这么做，后面我们再分析解释。  
到目前为止，我们只需要明白 AQS 在功能上有独占控制和共享控制两种功能即可。  

### 独占锁

```
reentrantLock.lock()
//do something
reentrantLock.unlock()
```

从这里可以看出，其实 ReentrantLock 实现的就是一个独占锁的功能：有且只有一个线程获取到锁，其余线程全部挂起，直到该拥有锁的线程释放锁，被挂起的线程被唤醒重新开始竞争锁。

#### 公平锁

- java.util.concurrent.locks.ReentrantLock.lock()  
  - java.util.concurrent.locks.ReentrantLock.FairSync.lock()  
    - java.util.concurrent.locks.AbstractQueuedSynchronizer.acquire(int)  
      - java.util.concurrent.locks.ReentrantLock.FairSync.tryAcquire(int)  
      - java.util.concurrent.locks.AbstractQueuedSynchronizer.addWaiter(Node)  
      - java.util.concurrent.locks.AbstractQueuedSynchronizer.acquireQueued(Node, int)  

```
    public void lock() {
        sync.lock();
    }
```

```
    final void lock() {
        acquire(1);
    }
```

```
    public final void acquire(int arg) {
        if (!tryAcquire(arg) &&
            acquireQueued(addWaiter(Node.EXCLUSIVE), arg))
            selfInterrupt();
    }
```

#### 重入锁

为什么需要有重入锁呢？  

## AQS 的应用

- CountDownLatch 内部使用 `Sync extends AbstractQueuedSynchronizer` 同步，可以用作指定数量线程的“一次性同步器”  
- CyclicBarrier 内部使用 ReentrantLock 同步，是 CountDownLatch 的一个改进版，可以多次复用  
- Semaphore 内部使用 `Sync extends AbstractQueuedSynchronizer` 同步，是一个信号量  
- Phaser  
- lock  
  大多数的  
  - ReentrantLock 内部使用 `Sync` 同步  
- StampedLock 信号量 使用 Unsafe  

## 可参考

https://www.infoq.cn/article/java8-abstractqueuedsynchronizer  Java 8：AbstractQueuedSynchronizer 的实现分析（下）  
https://www.infoq.cn/article/jdk1.8-abstractqueuedsynchronizer Java 8：AbstractQueuedSynchronizer 的实现分析（上）  
