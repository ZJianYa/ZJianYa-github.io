## javadoc

Provides a framework for implementing blocking locks and related synchronizers (semaphores, events, etc) that rely on first-in-first-out (FIFO) wait queues. This class is designed to be a useful basis for most kinds of synchronizers that rely on a single atomic int value to represent state. Subclasses must define the protected methods that change this state, and which define what that state means in terms of this object being acquired or released. Given these, the other methods in this class carry out all queuing and blocking mechanics. Subclasses can maintain other state fields, but only the atomically updated int value manipulated using methods getState, setState and compareAndSetState is tracked with respect to synchronization.

提供一个用于实现阻塞用的 locks 和依赖 FIFO 等待队列的 synchronizers 的框架。  
此类旨在提供 依赖单个原子 int 值来表示状态的大多数同步器的基础框架。  
子类必须定义 protected 方法来修改 state ，并定义该状态在获取或释放的此对象时的含义。  
本 class 中的其他方法执行所有排队和阻塞机制，基于（上面）这些（前提）。  
子类可以维护其他状态字段，但只跟踪使用方法 `getState` ， `setState` 和 `compareAndSetState` 操作的原子更新的int值。  

Subclasses should be defined as non-public internal helper classes that are used to implement the synchronization properties of their enclosing class. Class AbstractQueuedSynchronizer does not implement any synchronization interface. Instead it defines methods such as acquireInterruptibly that can be invoked as appropriate by concrete locks and related synchronizers to implement their public methods.  

子类应该定义为非公共的内部辅助类（这句话比较难理解，只有你在很多 lock 中看到他们如何使用 sync 的你会觉得这句话很简单）用于实现他们内部类（封装的）同步属性。  
AbstractQueuedSynchronizer 不实现任何 synchronization 接口。他定义了 acquireInterruptibly 这样的方法可以被实现了他们(synchronization)公共方法的具体的锁和相关的 synchronizers 调用。（这里说的比较绕，其实很简单，就是一些 lock 或者相关的 synchronizers （实现类） 会定义一些内部类实现 AbstractQueuedSynchronizer， 然后在他们实现的公共方法内部调用 ） 

This class supports either or both a default exclusive mode and a shared mode. When acquired in exclusive mode, attempted acquires by other threads cannot succeed. Shared mode acquires by multiple threads may (but need not) succeed. This class does not "understand" these differences except in the mechanical sense that when a shared mode acquire succeeds, the next waiting thread (if one exists) must also determine whether it can acquire as well. Threads waiting in the different modes share the same FIFO queue. Usually, implementation subclasses support only one of these modes, but both can come into play for example in a ReadWriteLock. Subclasses that support only exclusive or only shared modes need not define the methods supporting the unused mode.  

此类支持默认独占模式和共享模式之一或两者。 在独占模式下获取时，其他线程尝试获取不能成功。多个线程获取的共享模式可能（但不一定）成功。  
这个类不“了解”这些差异，除非在物理意义上，当共享模式获取成功时，下一个等待线程（如果存在）还必须确定它是否也可以获取。  
在不同模式下等待的线程共享相同的FIFO队列。  
通常，实现子类仅支持这些模式中的一种，但两者都可以在 ReadWriteLock 中发挥作用。   
仅支持独占模式或仅支持共享模式的子类无需定义支持未使用模式的方法。

This class defines a nested `ConditionObject` class that can be used as a Condition implementation by subclasses supporting exclusive mode for which method isHeldExclusively reports whether synchronization is exclusively held with respect to the current thread, method release invoked with the current getState value fully releases this object, and acquire, given this saved state value, eventually restores this object to its previous acquired state. No AbstractQueuedSynchronizer method otherwise creates such a condition, so if this constraint cannot be met, do not use it. The behavior of ConditionObject depends of course on the semantics of its synchronizer implementation. 

这个 class 定义了一个嵌套的 ConditionObject ，ConditionObject 可以被支持独占模式的子类用作Condition实现，，ConditionObject 的 isHeldExclusively 方法报告 当前线程 是否独占 synchronization ，调用当前 `getState` 值的 release 方法完全释放此对象，在给定此保存的状态值的情况下，最终将此对象恢复到其先前获取的状态。  否则，没有 AbstractQueuedSynchronizer 方法创建此类条件，因此如果无法满足此约束，请不要使用它。 ConditionObject 的行为当然取决于其同步器实现的语义。？？？？？

This class provides inspection, instrumentation, and monitoring methods for the internal queue, as well as similar methods for condition objects. These can be exported as desired into classes using an AbstractQueuedSynchronizer for their synchronization mechanics.   

这个类为内部队列和 condition 对象提供 inspection, instrumentation, and monitoring 方法。这个可以根据意愿使用 AbstractQueuedSynchronizer 为他们的同步机制导出到 classes 中。  

Serialization of this class stores only the underlying atomic integer maintaining state, so deserialized objects have empty thread queues. Typical subclasses requiring serializability will define a readObject method that restores this to a known initial state upon deserialization. 

此类的序列化仅存储基础原子整数维护状态，因此反序列化对象具有空线程队列。需要可串行化的典型子类将定义一个 `readObject` 方法，该方法在反序列化时将其恢复为已知的初始状态。

Usage

To use this class as the basis of a synchronizer, redefine the following methods, as applicable, by inspecting and/or modifying the synchronization state using getState, setState and/or compareAndSetState: 

* tryAcquire 
* tryRelease 
* tryAcquireShared 
* tryReleaseShared 
* isHeldExclusively 

Each of these methods by default throws UnsupportedOperationException. Implementations of these methods must be internally thread-safe, and should in general be short and not block. Defining these methods is the only supported means of using this class. All other methods are declared final because they cannot be independently varied. 
You may also find the inherited methods from AbstractOwnableSynchronizer useful to keep track of the thread owning an exclusive synchronizer. You are encouraged to use them -- this enables monitoring and diagnostic tools to assist users in determining which threads hold locks. 

Even though this class is based on an internal FIFO queue, it does not automatically enforce FIFO acquisition policies. The core of exclusive synchronization takes the form: 

Acquire:

```
     while (!tryAcquire(arg)) {
        enqueue thread if it is not already queued;
        possibly block current thread;
     }
```

Release:

```
     if (tryRelease(arg))
        unblock the first queued thread;
``` 

(Shared mode is similar but may involve cascading signals.) 
Because checks in acquire are invoked before enqueuing, a newly acquiring thread may barge ahead of others that are blocked and queued. However, you can, if desired, define tryAcquire and/or tryAcquireShared to disable barging by internally invoking one or more of the inspection methods, thereby providing a fair FIFO acquisition order. In particular, most fair synchronizers can define tryAcquire to return false if hasQueuedPredecessors (a method specifically designed to be used by fair synchronizers) returns true. Other variations are possible. 

Throughput and scalability are generally highest for the default barging (also known as greedy, renouncement, and convoy-avoidance) strategy. While this is not guaranteed to be fair or starvation-free, earlier queued threads are allowed to recontend before later queued threads, and each recontention has an unbiased chance to succeed against incoming threads. Also, while acquires do not "spin" in the usual sense, they may perform multiple invocations of tryAcquire interspersed with other computations before blocking. This gives most of the benefits of spins when exclusive synchronization is only briefly held, without most of the liabilities when it isn't. If so desired, you can augment this by preceding calls to acquire methods with "fast-path" checks, possibly prechecking hasContended and/or hasQueuedThreads to only do so if the synchronizer is likely not to be contended. 

This class provides an efficient and scalable basis for synchronization in part by specializing its range of use to synchronizers that can rely on int state, acquire, and release parameters, and an internal FIFO wait queue. When this does not suffice, you can build synchronizers from a lower level using atomic classes, your own custom java.util.Queue classes, and LockSupport blocking support. 

Usage Examples

Here is a non-reentrant mutual exclusion lock class that uses the value zero to represent the unlocked state, and one to represent the locked state. While a non-reentrant lock does not strictly require recording of the current owner thread, this class does so anyway to make usage easier to monitor. It also supports conditions and exposes one of the instrumentation methods: 

```
 class Mutex implements Lock, java.io.Serializable {

   // Our internal helper class
   private static class Sync extends AbstractQueuedSynchronizer {
     // Reports whether in locked state
     protected boolean isHeldExclusively() {
       return getState() == 1;
     }

     // Acquires the lock if state is zero
     public boolean tryAcquire(int acquires) {
       assert acquires == 1; // Otherwise unused
       if (compareAndSetState(0, 1)) {
         setExclusiveOwnerThread(Thread.currentThread());
         return true;
       }
       return false;
     }

     // Releases the lock by setting state to zero
     protected boolean tryRelease(int releases) {
       assert releases == 1; // Otherwise unused
       if (getState() == 0) throw new IllegalMonitorStateException();
       setExclusiveOwnerThread(null);
       setState(0);
       return true;
     }

     // Provides a Condition
     Condition newCondition() { return new ConditionObject(); }

     // Deserializes properly
     private void readObject(ObjectInputStream s)
         throws IOException, ClassNotFoundException {
       s.defaultReadObject();
       setState(0); // reset to unlocked state
     }
   }

   // The sync object does all the hard work. We just forward to it.
   private final Sync sync = new Sync();

   public void lock()                { sync.acquire(1); }
   public boolean tryLock()          { return sync.tryAcquire(1); }
   public void unlock()              { sync.release(1); }
   public Condition newCondition()   { return sync.newCondition(); }
   public boolean isLocked()         { return sync.isHeldExclusively(); }
   public boolean hasQueuedThreads() { return sync.hasQueuedThreads(); }
   public void lockInterruptibly() throws InterruptedException {
     sync.acquireInterruptibly(1);
   }
   public boolean tryLock(long timeout, TimeUnit unit)
       throws InterruptedException {
     return sync.tryAcquireNanos(1, unit.toNanos(timeout));
   }
 }}
```

Here is a latch class that is like a CountDownLatch except that it only requires a single signal to fire. Because a latch is non-exclusive, it uses the shared acquire and release methods. 

```
 class BooleanLatch {

   private static class Sync extends AbstractQueuedSynchronizer {
     boolean isSignalled() { return getState() != 0; }

     protected int tryAcquireShared(int ignore) {
       return isSignalled() ? 1 : -1;
     }

     protected boolean tryReleaseShared(int ignore) {
       setState(1);
       return true;
     }
   }

   private final Sync sync = new Sync();
   public boolean isSignalled() { return sync.isSignalled(); }
   public void signal()         { sync.releaseShared(1); }
   public void await() throws InterruptedException {
     sync.acquireSharedInterruptibly(1);
   }
 }}
```

Since: 1.5  
Author:Doug Lea  

## 分析

https://www.infoq.cn/article/jdk1.8-abstractqueuedsynchronizer  
https://www.infoq.cn/article/java8-abstractqueuedsynchronizer  

## FAQ

还是没有搞清楚这个类究竟能做什么，以及如何使用。  