# High Level Concurrency Objects

So far, this lesson has focused on the low-level APIs that have been part of the Java platform from the very beginning. These APIs are adequate for very basic tasks, but higher-level building blocks are needed for more advanced tasks. This is especially true for massively concurrent applications that fully exploit today's multiprocessor and multi-core systems.

In this section we'll look at some of the high-level concurrency features introduced with version 5.0 of the Java platform. Most of these features are implemented in the new java.util.concurrent packages. There are also new concurrent data structures in the Java Collections Framework.

## Lock Objects

Synchronized code relies on a simple kind of reentrant lock. This kind of lock is easy to use, but has many limitations. More sophisticated locking idioms are supported by the java.util.concurrent.locks package. We won't examine this package in detail, but instead will focus on its most basic interface, Lock.

同步代码依赖于简单的可重入锁定。这种锁易于使用，但有许多限制。 `java.util.concurrent.locks` 包装支持更复杂的锁定习语 。我们不会详细检查这个包，而是将重点放在它最基本的接口上 Lock。  

Lock objects work very much like the implicit locks used by synchronized code. As with implicit locks, only one thread can own a Lock object at a time. Lock objects also support a wait/notify mechanism, through their associated Condition objects.

Lock 对象的工作方式与同步代码使用的隐式锁非常相似。与隐式锁一样，一次只有一个线程可以拥有一个Lock对象。Lock对象还支持 wait/notify 机制通过其关联的Condition对象。

The biggest advantage of Lock objects over implicit locks is their ability to back out of an attempt to acquire a lock. The tryLock method backs out if the lock is not available immediately or before a timeout expires (if specified). The lockInterruptibly method backs out if another thread sends an interrupt before the lock is acquired.

Lock对象相对于隐式锁定的最大优点是它们能够退出获取锁定的尝试。tryLock如果不能立即获得或者在一个`timeout`之前获得锁，则该方法退出。 如果另一个线程在获取锁之前发送中断，则 lockInterruptibly 方法退出。

Let's use Lock objects to solve the deadlock problem we saw in Liveness. Alphonse and Gaston have trained themselves to notice when a friend is about to bow. We model this improvement by requiring that our Friend objects must acquire locks for both participants before proceeding with the bow. Here is the source code for the improved model, Safelock. To demonstrate the versatility of this idiom, we assume that Alphonse and Gaston are so infatuated with their newfound ability to bow safely that they can't stop bowing to each other:

让我们使用Lock对象来解决我们在Liveness中看到的死锁问题。当朋友即将鞠躬时，阿方斯和加斯顿已经训练自己注意到了。我们通过要求我们的Friend对象必须在继续执行弓之前获取两个参与者的锁来对此改进进行建模。以下是改进模型的源代码 Safelock。为了证明这个成语的多样性，我们假设阿尔方斯和加斯顿如此迷恋他们新发现的安全鞠躬能力，他们不能停止相互鞠躬：

```{}
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;
import java.util.Random;

public class Safelock {
  ...
}
```

> 如果使用了 trylock，我个人觉得还是要合理重试以保证业务在正常情况下的成功率。