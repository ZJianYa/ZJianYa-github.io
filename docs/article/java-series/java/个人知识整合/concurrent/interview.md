
## CAS 
## 锁
### 悲观锁/乐观锁
### 锁的升级 降级
### synchronized

现在的 JDK 中，synchronized 已经被不断优化，可以不再过分担心性能差异，另外，相比于 ReentrantLock，它可以减少内存消耗，这是个非常大的优势。  

### 同步器

所有的基础是 `AbstractQueuedSynchronizer` ，其他的 `Sync` 都是继承于此  
AbstractQueuedSynchronizer 本质上使用的是 CAS 的方式判断和更改信号量  

### 其他提问

* 如何优雅的关闭线程  
* 如何保证线程安全  
* 如何保证线程顺序执行  
* 如何保证按条件执行  
* 为什么要使用线程池？哪些地方用到了线程池？使用线程池的注意事项  