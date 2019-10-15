

## 需求和概述

从应用层面讲，我们需要 lock 功能来保护临界资源的访问，通过 wait 功能在条件不满足的时候退出临界区，需要通过 notify 方法来唤醒等待的线程。Java 主要提供了两种实现：

- Synchronized 关键字
  synchronized 原理涉及了偏斜锁、自旋锁、轻量级锁、重量级锁、锁的膨胀、降级等概念。  
- 编程式的 lock  
  lock 借助了 happen-before 规则和 unsafe 的 CAS 类的方法来保证临界区的互斥和同步。  
  通过 unsafe 提供的 park 方法来实现等待，通过 unpark 来实现唤醒。  

乐观锁的实现不仅包括 CAS，其实偏斜锁、轻量级锁在我看来都是乐观锁。  

## CAS

略

### ABA

略

## 简述 unsafe

https://juejin.im/entry/595c599e6fb9a06bc6042514  
unsafe 中的方法大致分为如下几类

### 内存管理
#### 变量
- 基本类型
- 数组
- 对象
### 并发相关

#### CAS 相关

```
//第一个参数 o 为给定对象， offset 为对象内存的偏移量，通过这个偏移量迅速定位字段并设置或获取该字段的值，
// expected 表示期望值，x 表示要设置的值，下面3个方法都通过CAS原子指令执行操作。
public final native boolean compareAndSwapObject(Object o, long offset,Object expected, Object x);

public final native boolean compareAndSwapInt(Object o, long offset,int expected,int x);

public final native boolean compareAndSwapLong(Object o, long offset,long expected,long x);
```

有关 BAB 问题，可以参照

#### 挂起与恢复 

```
//线程调用该方法，线程将一直阻塞直到超时，或者是中断条件出现。  
public native void park(boolean isAbsolute, long time);  

//终止挂起的线程，恢复正常.java.util.concurrent包中挂起操作都是在LockSupport类实现的，其底层正是使用这两个方法，  
public native void unpark(Object thread); 
```

将一个线程进行挂起是通过park方法实现的，调用 park后，线程将一直阻塞直到超时或者中断等条件出现。unpark可以终止一个挂起的线程，使其恢复正常。Java对线程的挂起操作被封装在 LockSupport类中，LockSupport类中有各种版本pack方法，其底层实现最终还是使用Unsafe.park()方法和Unsafe.unpark()方法

#### 内存屏障

略

### 其他

略

## lock condition

所有的 Lock 都是基于 AQS 来实现了。 AQS 和 Condition 各自维护了不同的队列，在使用 lock 和 condition 的时候，其实就是两个队列的互相移动。  
如果我们想自定义一个同步器，可以实现 AQS 。它提供了获取共享锁和互斥锁的方式，都是基于对 state 操作而言的。  

ReentranLock 这个是可重入的。其实要弄明白它为啥可重入的呢，咋实现的呢。其实它内部自定义了同步器Sync，这个又实现了AQS，同时又实现了 AOS ，而后者就提供了一种互斥锁持有的方式。其实就是每次获取锁的时候，看下当前维护的那个线程和当前请求的线程是否一样，一样就可重入了。

## ReentrantLock

ReentrantLock，通常翻译为再入锁，是 Java 5 提供的锁实现，它的语义和 synchronized 基本相同。  
再入锁通过代码直接调用 lock() 方法获取，代码书写也更加灵活。  
与此同时，ReentrantLock 提供了很多实用的方法，能够实现很多细节控制，比如可以控制 fairness，也就是公平性，或者利用定义条件等。  
但是，编码中也需要注意，必须要明确调用 unlock() 方法释放，不然就会一直持有该锁。  
synchronized 和 ReentrantLock 的性能不能一概而论，早期版本 synchronized 在很多场景下性能相差较大，在后续版本进行了较多改进，在低竞争场景中表现可能优于 ReentrantLock。  

再来看看 ReentrantLock。你可能好奇什么是再入？它是表示当一个线程试图获取一个它已经获取的锁时，这个获取动作就自动成功，这是对锁获取粒度的一个概念，也就是锁的持有是以线程为单位而不是基于调用次数。Java 锁实现强调再入性是为了和 pthread 的行为进行区分。

再入锁可以设置公平性（fairness），我们可在创建再入锁时选择是否是公平的。

```{}
ReentrantLock fairLock = new ReentrantLock(true);
```

通用场景中，公平性未必有想象中的那么重要，Java 默认的调度策略很少会导致 “饥饿”发生。与此同时，若要保证公平性则会引入额外开销，自然会导致一定的吞吐量下降。所以，我建议只有当你的程序确实有公平性需要的时候，才有必要指定它。

我们再从日常编码的角度学习下再入锁。为保证锁释放，每一个 lock() 动作，我建议都立即对应一个 try-catch-finally，典型的代码结构如下，这是个良好的习惯。

```{}
ReentrantLock fairLock = new ReentrantLock(true);// 这里是演示创建公平锁，一般情况不需要。
fairLock.lock();
try {
	// do something
} finally {
 	fairLock.unlock();
}
```

ReentrantLock 相比 synchronized ，因为可以像普通对象一样使用，所以可以利用其提供的各种便利方法，进行精细的同步操作，甚至是实现 synchronized 难以表达的用例，如：

- 带超时的获取锁尝试。
- 可以判断是否有线程，或者某个特定线程，在排队等待获取锁。
- 可以响应中断请求。

## Condition

这里我特别想强调 **条件变量**（java.util.concurrent.Condition），如果说 ReentrantLock 是 synchronized 的替代选择，Condition 则是将 wait、notify、notifyAll 等操作转化为相应的对象，将复杂而晦涩的同步操作转变为直观可控的对象行为。

条件变量最为典型的应用场景就是标准类库中的 ArrayBlockingQueue 等。

我们参考下面的源码，首先，通过再入锁获取条件变量：

```{}
/** Condition for waiting takes */
private final Condition notEmpty;

/** Condition for waiting puts */
private final Condition notFull;

public ArrayBlockingQueue(int capacity, boolean fair) {
  if (capacity <= 0)
      throw new IllegalArgumentException();
  this.items = new Object[capacity];
  lock = new ReentrantLock(fair);
  notEmpty = lock.newCondition();
  notFull =  lock.newCondition();
}
```

两个条件变量是从同一再入锁创建出来，然后使用在特定操作中，如下面的 take 方法，判断和等待条件满足：

```
public E take() throws InterruptedException {
	final ReentrantLock lock = this.lock;
	lock.lockInterruptibly();
	try {
    	while (count == 0)
        	notEmpty.await();
    	return dequeue();
	} finally {
    	lock.unlock();
	}
}
```

当队列为空时，试图 take 的线程的正确行为应该是等待入队发生，而不是直接返回，这是 BlockingQueue 的语义，使用条件 notEmpty 就可以优雅地实现这一逻辑。

那么，怎么保证入队触发后续 take 操作呢？请看 enqueue 实现：

```{}
private void enqueue(E e) {
	// assert lock.isHeldByCurrentThread();
	// assert lock.getHoldCount() == 1;
	// assert items[putIndex] == null;
	final Object[] items = this.items;
	items[putIndex] = e;
	if (++putIndex == items.length) putIndex = 0;
	count++;
	notEmpty.signal(); // 通知等待的线程，非空条件已经满足
}
```

通过 signal/await 的组合，完成了条件判断和通知等待线程，非常顺畅就完成了状态流转。注意，signal 和 await 成对调用非常重要，不然假设只有 await 动作，线程会一直等待直到被打断（interrupt）。

## 死锁

- 死锁
  - 原因  
    线程互斥，占有且不释放，不可抢占，循环等待
  - 解决方法
   - 事前  
     设置良好的通信、协调机制  
     - 等待超时  
     - 发现条件不满足，自动退让  
     - 支持中断响应  
   - 事中  
     - 检测和kill 线程  
   - 事后 