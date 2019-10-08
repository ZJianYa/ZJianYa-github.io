
## CAS 

## 锁

### 悲观锁/乐观锁/锁的升级 降级

在 Java 中并没有独立的悲观锁，乐观锁。  
优化后 synchronized 会从乐观锁升级到悲观锁，当然在一定条件下也会做锁的降级。

### synchronized

现在的 JDK 中，synchronized 已经被不断优化，可以不再过分担心性能差异，另外，相比于 ReentrantLock，它可以减少内存消耗，这是个非常大的优势。  

### 同步器

所有的基础是 `AbstractQueuedSynchronizer` ，其他的 `Sync` 都是继承于此  
AbstractQueuedSynchronizer 本质上使用的是 CAS 的方式判断和更改信号量  

- CountDownLatch 内部使用 `Sync extends AbstractQueuedSynchronizer` 同步，可以用作指定数量线程的“一次性同步器”
- CyclicBarrier 内部使用 ReentrantLock 同步，是 CountDownLatch 的一个改进版，可以多次复用
- Semaphore 内部使用 `Sync extends AbstractQueuedSynchronizer` 同步，是一个信号量  
- Phaser 

- lock  
  大多数的  
  - ReentrantLock 内部使用 `Sync` 同步  
- StampedLock 信号量 使用 Unsafe  

