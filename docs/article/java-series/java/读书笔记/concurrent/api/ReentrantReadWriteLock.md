ReentrantLock 内部有两个 sync 的实现

ReentrantLock.lock 调用  sync.lock()

ReentrantLock.tryLock 调用 非公平锁

### 公平锁

```{公平锁}
protected final boolean tryAcquire(int acquires) {
    final Thread current = Thread.currentThread();// 获取当前线程 
    int c = getState();  // 获取父类 AQS 中的标志位 
    if (c == 0) {
        if (!hasQueuedPredecessors() && 
            // 如果队列中没有其他线程  说明没有线程正在占有锁！
            compareAndSetState(0, acquires)) { 
            // 修改一下状态位，注意：这里的 acquires 是在 lock 的时候传递来的，从上面的图中可以知道，这个值是写死的 1
            setExclusiveOwnerThread(current);
            // 如果通过 CAS 操作将状态为更新成功则代表当前线程获取锁，因此，将当前线程设置到 AQS 的一个变量中，说明这个线程拿走了锁。
            return true;
        }
    }
    else if (current == getExclusiveOwnerThread()) {
      // 如果不为 0 意味着，锁已经被拿走了，但是，因为 ReentrantLock 是重入锁，
      // 是可以重复 lock,unlock 的，只要成对出现行。一次。这里还要再判断一次 获取锁的线程是不是当前请求锁的线程。
        int nextc = c + acquires;// 如果是的，累加在 state 字段上就可以了。
        if (nextc < 0)
            throw new Error("Maximum lock count exceeded");
        setState(nextc);
        return true;
    }
    return false;
}
```

### addWaiter  

### acquireQueued  

```{}
final boolean acquireQueued(final Node node, int arg) {
    boolean failed = true;
    try {
        boolean interrupted = false;
        for (;;) {
            final Node p = node.predecessor();
            if (p == head && tryAcquire(arg)) {
                // 如果当前的节点是 head 说明他是队列中第一个“有效的”节点，因此尝试获取，上文中有提到这个类是交给子类去扩展的。
                setHead(node);// 成功后，将上图中的黄色节点移除，Node1 变成头节点。
                p.next = null; // help GC
                failed = false;
                return interrupted;
            }
            if (shouldParkAfterFailedAcquire(p, node) && 
            // 否则，检查前一个节点的状态为，看当前获取锁失败的线程是否需要挂起。
                parkAndCheckInterrupt()) 
            // 如果需要，借助 JUC 包下的 LockSopport 类的静态方法 Park 挂起当前线程。知道被唤醒。
                interrupted = true;
        }
    } finally {
        if (failed) // 如果有异常 
            cancelAcquire(node);// 取消请求，对应到队列操作，就是将当前节点从队列中移除。
    }
}
```

## FAQ 

1. enq 中死循环，“自旋”方式修改。