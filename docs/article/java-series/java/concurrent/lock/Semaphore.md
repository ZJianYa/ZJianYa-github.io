
## guide

简而言之，就是控制并发数量

A counting semaphore. Conceptually, a semaphore maintains a set of permits. Each acquire blocks if necessary until a permit is available, and then takes it. Each release adds a permit, potentially releasing a blocking acquirer. However, no actual permit objects are used; the Semaphore just keeps a count of the number available and acts accordingly. 

一个计数信号量。从概念上讲，一个信号量维护一组许可。  
如果有必要每一个请求都被阻塞直到有一个许可可用，然后取走（这个许可）。每个 release 增加一个（可用）许可，可能释放一个阻塞的请求。但是，没有实际的许可对象被使用；信号量只是控制可用数量和相应的 acts。

Semaphores are often used to restrict the number of threads than can access some (physical or logical) resource. For example, here is a class that uses a semaphore to control access to a pool of items: 

信号量经常用于限制可访问某些资源的线程数量。例如，这是一个类使用一个信号量控制线程池：

```{}
class Pool {
  private static final int MAX_AVAILABLE = 100;
  private final Semaphore available = new Semaphore(MAX_AVAILABLE, true);

  public Object getItem() throws InterruptedException {
    available.acquire();
    return getNextAvailableItem();
  }

  public void putItem(Object x) {
    if (markAsUnused(x))
      available.release();
  }

  // Not a particularly efficient data structure; just for demo

  protected Object[] items = ... whatever kinds of items being managed
  protected boolean[] used = new boolean[MAX_AVAILABLE];

  protected synchronized Object getNextAvailableItem() {
    for (int i = 0; i < MAX_AVAILABLE; ++i) {
      if (!used[i]) {
        used[i] = true;
        return items[i];
      }
    }
    return null; // not reached
  }

  protected synchronized boolean markAsUnused(Object item) {
    for (int i = 0; i < MAX_AVAILABLE; ++i) {
      if (item == items[i]) {
        if (used[i]) {
          used[i] = false;
          return true;
        } else
          return false;
      }
    }
    return false;
  }
}}
```

Before obtaining an item each thread must acquire a permit from the semaphore, guaranteeing that an item is available for use. When the thread has finished with the item it is returned back to the pool and a permit is returned to the semaphore, allowing another thread to acquire that item. Note that no synchronization lock is held when acquire is called as that would prevent an item from being returned to the pool. The semaphore encapsulates the synchronization needed to restrict access to the pool, separately from any synchronization needed to maintain the consistency of the pool itself. 

在获得一个 Item 之前，每个线程必须获得一个许可，保证一个有一个 item 可用。当线程结束的时候，item 被归还给pool，许可也归还给 semaphore，允许另一个线程获取那个 item。  
注意当 acquire 被调用的时候没有持有 synchronization 锁，因为那样会阻止 item 归还给 pool。  
信号量封装了限制访问池所需的同步，与维护池本身一致性所需的任何同步分开。  

A semaphore initialized to one, and which is used such that it only has at most one permit available, can serve as a mutual exclusion lock. This is more commonly known as a binary semaphore, because it only has two states: one permit available, or zero permits available. When used in this way, the binary semaphore has the property (unlike many java.util.concurrent.locks.Lock implementations), that the "lock" can be released by a thread other than the owner (as semaphores have no notion of ownership). This can be useful in some specialized contexts, such as deadlock recovery.   

一个 semaphore 初始化为1，最多有一个许可可用，可以提供类似排它锁的服务。这通常称为二进制信号量，因为它只有两种状态：一种是可用的，或者是零可用的。当以这种方式使用时，二进制信号量具有属性（与许多java.util.concurrent.locks.Lock实现不同），“lock”可以被所有者之外的线程释放（因为信号量没有所有权的概念） ）。这在某些特定的上下文中很有用，例如死锁恢复。  

The constructor for this class optionally accepts a fairness parameter. When set false, this class makes no guarantees about the order in which threads acquire permits. In particular, barging is permitted, that is, a thread invoking acquire can be allocated a permit ahead of a thread that has been waiting - logically the new thread places itself at the head of the queue of waiting threads. When fairness is set true, the semaphore guarantees that threads invoking any of the acquire methods are selected to obtain permits in the order in which their invocation of those methods was processed (first-in-first-out; FIFO). Note that FIFO ordering necessarily applies to specific internal points of execution within these methods. So, it is possible for one thread to invoke acquire before another, but reach the ordering point after the other, and similarly upon return from the method. Also note that the untimed tryAcquire methods do not honor the fairness setting, but will take any permits that are available.   

这个类的构造函数可选择接受 fairness 参数。设置为false时，此类不保证线程获取许可的顺序。特别是，允许插队，也就是说，调用获取的线程可以在已经等待的线程之前分配许可 - 逻辑上新线程将自己置于等待线程队列的头部。当公平性设置为true时，信号量保证选择调用任何获取方法的线程以按照它们调用这些方法的顺序（先进先出; FIFO）获得许可。请注意，FIFO排序必然适用于这些方法中的特定内部执行点。因此，一个线程可以在另一个线程之前调用获取，但是在另一个线程之后到达排序点，并且类似地从方法返回时。另请注意，不定时的tryAcquire方法不遵守公平性设置，但会接受任何可用的许可。

Generally, semaphores used to control resource access should be initialized as fair, to ensure that no thread is starved out from accessing a resource. When using semaphores for other kinds of synchronization control, the throughput advantages of non-fair ordering often outweigh fairness considerations.   
通常，用于控制资源访问的信号量应初始化为公平，以确保没有线程缺乏访问资源。当将信号量用于其他类型的同步控制时，非公平排序的吞吐量优势通常超过公平性考虑。

This class also provides convenience methods to acquire and release multiple permits at a time. Beware of the increased risk of indefinite postponement when these methods are used without fairness set true.   
该类还提供了一次获取和释放多个许可的便捷方法。当使用这些方法而没有公平地设定时，要注意无限期推迟的风险增加。  

Memory consistency effects: Actions in a thread prior to calling a "release" method such as release() happen-before actions following a successful "acquire" method such as acquire() in another thread.  
内存一致性效果：在调用“release”方法（如release（））之前的线程中的操作发生在成功的“获取”方法（例如另一个线程中的acquire（））之后的操作之前。  

## api

