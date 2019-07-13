## javadoc

Provides a framework for implementing blocking locks and related synchronizers (semaphores, events, etc) that rely on first-in-first-out (FIFO) wait queues. This class is designed to be a useful basis for most kinds of synchronizers that rely on a single atomic int value to represent state. Subclasses must define the protected methods that change this state, and which define what that state means in terms of this object being acquired or released. Given these, the other methods in this class carry out all queuing and blocking mechanics. Subclasses can maintain other state fields, but only the atomically updated int value manipulated using methods getState, setState and compareAndSetState is tracked with respect to synchronization.

提供一个用于实现阻塞用的 locks 和依赖 FIFO 等待队列的 synchronizers 的框架。  
此类旨在提供 依赖单个原子 int 值来表示状态的大多数同步器的基础框架。  
子类必须定义 protected 方法来修改 state，并根据要获取或释放的此对象定义该状态的含义。   
鉴于这些，本课程中的其他方法执行所有排队和阻塞机制。  
子类可以维护其他状态字段，但只跟踪使用方法getState，setState和 compareAndSetState 操作的原子更新的int值。  

Subclasses should be defined as non-public internal helper classes that are used to implement the synchronization properties of their enclosing class. Class AbstractQueuedSynchronizer does not implement any synchronization interface. Instead it defines methods such as acquireInterruptibly that can be invoked as appropriate by concrete locks and related synchronizers to implement their public methods.  

子类应该定义为  

## 分析

https://www.infoq.cn/article/jdk1.8-abstractqueuedsynchronizer  
https://www.infoq.cn/article/java8-abstractqueuedsynchronizer  

