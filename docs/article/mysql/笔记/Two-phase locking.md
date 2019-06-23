# [两阶段锁](https://en.wikipedia.org/wiki/Two-phase_locking)

This article is about concurrency control. For commit consensus within a distributed transaction, see Two-phase commit protocol.

In databases and transaction processing, two-phase locking (2PL) is a concurrency control method that guarantees serializability.[1][2] It is also the name of the resulting set of database transaction schedules (histories). The protocol utilizes locks, applied by a transaction to data, which may block (interpreted as signals to stop) other transactions from accessing the same data during the transaction's life.

在数据库事务处理中，2PL 是一个保证串行化的并发控制的方法。他也是生成的数据库事务调度集（历史记录）的名称。这个协议利用由事务应用于数据的锁，阻止其他事务在本事务的执行期间访问相同数据。  

By the 2PL protocol, locks are applied and removed in two phases:

- Expanding phase: locks are acquired and no locks are released.  
  扩张阶段：申请锁，且不释放锁
- Shrinking phase: locks are released and no locks are acquired.  
  收缩阶段：释放锁，且不申请锁  

Two types of locks are utilized by the basic protocol: Shared and Exclusive locks. Refinements of the basic protocol may utilize more lock types. Using locks that block processes, 2PL may be subject to deadlocks that result from the mutual blocking of two or more transactions.  

基本协议使用两种锁：共享锁和排它锁。基本协议的细化可以使用更多锁类型。使用锁阻塞进程，2PL可能会因两个或多个事务的相互阻塞而导致死锁。

## Data-access locks

A lock is a system object associated with a shared resource such as a data item of an elementary type, a row in a database, or a page of memory. In a database, a lock on a database object (a data-access lock) may need to be acquired by a transaction before accessing the object. Correct use of locks prevents undesired, incorrect or inconsistent operations on shared resources by other concurrent transactions. When a database object with an existing lock acquired by one transaction needs to be accessed by another transaction, the existing lock for the object and the type of the intended access are checked by the system. If the existing lock type does not allow this specific attempted concurrent access type, the transaction attempting access is blocked (according to a predefined agreement/scheme). In practice, a lock on an object does not directly block a transaction's operation upon the object, but rather blocks that transaction from acquiring another lock on the same object, needed to be held/owned by the transaction before performing this operation. Thus, with a locking mechanism, needed operation blocking is controlled by a proper lock blocking scheme, which indicates which lock type blocks which lock type.  

一个锁是与共享资源相关联的系统对象，例如基本类型的数据项，数据库中的行或内存页。在数据库中，在访问对象之前，事务可能需要获取数据对象上的锁（数据访问锁）。正确使用锁可以防止其他并发事务对共享资源执行不必要的，不正确的或不一致的操作。当一个事务获取的具有现有锁的数据库对象需要被另一个事务访问时，系统将检查该对象的现有锁和预期访问的类型。如果现有锁定类型不允许此特定尝试并发访问类型，则阻止尝试访问的事务（根据预定义的协议/方案）。在实践中，对对象的锁定不直接阻止事务对对象的操作，而是阻止该事务获取同一对象上的另一个锁，在执行此操作之前需要由事务保持/拥有。因此，利用锁定机制，所需的操作阻塞由适当的锁定阻塞方案控制，该方案指示哪种锁定类型阻止哪种锁定类型。

两种主要类型的锁：  
Two major types of locks are utilized:  

- Write-lock (exclusive lock) is associated with a database object by a transaction (Terminology: "the transaction locks the object," or "acquires lock for it") before writing (inserting/modifying/deleting) this object.  
在写入（插入/修改/删除）此对象之前，写入锁定（独占锁定）与事务（术语：“事务锁定对象”或“获取锁定”）与数据库对象相关联。  

- Read-lock (shared lock) is associated with a database object by a transaction before reading (retrieving the state of) this object.

The common interactions between these lock types are defined by blocking behavior as follows:  
这些锁之间常见的交互定义如下：

- An existing write-lock on a database object blocks an intended write upon the same object (already requested/issued) by another transaction by blocking a respective write-lock from being acquired by the other transaction. The second write-lock will be acquired and the requested write of the object will take place (materialize) after the existing write-lock is released.  
一个写锁阻塞其他事务在同样的对象上执行写操作通过阻塞另一个事务获取一个写锁。第二个写锁需要已存在的这个写锁释放之后才能获得。  

- A write-lock blocks an intended (already requested/issued) read by another transaction by blocking the respective read-lock .  
一个写锁阻塞读锁  

- A read-lock blocks an intended write by another transaction by blocking the respective write-lock.  
一个读锁阻塞写锁 

- A read-lock does not block an intended read by another transaction. The respective read-lock for the intended read is acquired (shared with the previous read) immediately after the intended read is requested, and then the intended read itself takes place.
一个读锁并不会阻塞读锁

Several variations and refinements of these major lock types exist, with respective variations of blocking behavior. If a first lock blocks another lock, the two locks are called incompatible; otherwise the locks are compatible. Often, lock types blocking interactions are presented in the technical literature by a Lock compatibility table. The following is an example with the common, major lock types:  
这些主要的锁类型存在若干变体和改进，通过改进阻塞行为。兼容性见下表：  

......

X indicates incompatibility, i.e, a case when a lock of the first type (in left column) on an object blocks a lock of the second type (in top row) from being acquired on the same object (by another transaction). An object typically has a queue of waiting requested (by transactions) operations with respective locks. The first blocked lock for operation in the queue is acquired as soon as the existing blocking lock is removed from the object, and then its respective operation is executed. If a lock for operation in the queue is not blocked by any existing lock (existence of multiple compatible locks on a same object is possible concurrently), it is acquired immediately.
Comment: In some publications, the table entries are simply marked "compatible" or "incompatible", or respectively "yes" or "no".

## Two-phase locking and its special cases

According to the two-phase locking protocol, a transaction handles its locks in two distinct, consecutive phases during the transaction's execution:  

Expanding phase (aka Growing phase): locks are acquired and no locks are released (the number of locks can only increase).
Shrinking phase (aka Contracting phase): locks are released and no locks are acquired.
The two phase locking rule can be summarized as: never acquire a lock after a lock has been released. The serializability property is guaranteed for a schedule with transactions that obey this rule.

Typically, without explicit knowledge in a transaction on end of phase 1, it is safely determined only when a transaction has completed processing and requested commit. In this case, all the locks can be released at once (phase 2).

### Two-phase locking

### Conservative two-phase locking  

The difference between 2PL and C2PL is that C2PL's transactions obtain all the locks they need before the transactions begin. This is to ensure that a transaction that already holds some locks will not block waiting for other locks. Conservative 2PL prevents deadlocks.

区别是 C2PL 的事务在事务开始之前就拿到了所有锁。确保不被其他线程阻塞。可以防止死锁。  

### Strict two-phase locking  

To comply with the S2PL protocol, a transaction needs to comply with 2PL, and release its write (exclusive) locks only after it has ended, i.e., being either committed or aborted. On the other hand, read (shared) locks are released regularly during phase 2. This protocol is not appropriate in B-trees because it causes Bottleneck (while B-trees always starts searching from the parent root).  

为了遵守S2PL协议，事务需要遵守2PL，并且释放写锁，即提交或终止（事务）。另一方面，读锁通常在第二阶段释放。该协议在B树中不合适，因为它引起瓶颈（B树总是从父根开始搜索）。

### Strong strict two-phase locking  

To comply with strong strict two-phase locking (SS2PL) the locking protocol releases both write (exclusive) and read (shared) locks applied by a transaction only after the transaction has ended, i.e., only after both completing executing (being ready) and becoming either committed or aborted. This protocol also complies with the S2PL rules. A transaction obeying SS2PL can be viewed as having phase 1 that lasts the transaction's entire execution duration, and no phase 2 (or a degenerate phase 2). Thus, only one phase is actually left, and "two-phase" in the name seems to be still utilized due to the historical development of the concept from 2PL, and 2PL being a super-class. The SS2PL property of a schedule is also called Rigorousness. It is also the name of the class of schedules having this property, and an SS2PL schedule is also called a "rigorous schedule". The term "Rigorousness" is free of the unnecessary legacy of "two-phase," as well as being independent of any (locking) mechanism (in principle other blocking mechanisms can be utilized). The property's respective locking mechanism is sometimes referred to as Rigorous 2PL.

为了遵守 SS2PL 锁协议在事务结束之后释放读锁和写锁，或者全部提交或者全部放弃。这个协议也遵循 S2PL 规则。 遵守 SS2PL 的事务可以视为有阶段1 ，没有阶段2 （或者一个退化的阶段2）。因此，实际上只留下了阶段1，两阶段这个名词似乎由于历史原因仍旧被使用，2PL成为了一个超类。 The SS2PL property of a schedule 称之为 Rigorousness。...... 

SS2PL is a special case of S2PL, i.e., the SS2PL class of schedules is a proper subclass of S2PL (every SS2PL schedule is also an S2PL schedule, but S2PL schedules exist that are not SS2PL).
SS2PL 是 S2PL 的一个特例，即， SS2PL 是 S2PL的一个子类。  

SS2PL has been the concurrency control protocol of choice for most database systems and utilized since their early days in the 1970s. It is proven to be an effective mechanism in many situations, and provides besides Serializability also Strictness (a special case of cascadeless Recoverability), which is instrumental for efficient database recovery, and also Commitment ordering (CO) for participating in distributed environments where a CO based distributed serializability and global serializability solutions are employed.   
Being a subset of CO, an efficient implementation of distributed SS2PL exists without a distributed lock manager (DLM), while distributed deadlocks (see below) are resolved automatically.   
The fact that SS2PL employed in multi database systems ensures global serializability has been known for years before the discovery of CO, but only with CO came the understanding of the role of an atomic commitment protocol in maintaining global serializability, as well as the observation of automatic distributed deadlock resolution (see a detailed example of Distributed SS2PL).   
As a matter of fact, SS2PL inheriting properties of Recoverability and CO is more significant than being a subset of 2PL, which by itself in its general form, besides comprising a simple serializability mechanism (however serializability is also implied by CO), in not known to provide SS2PL with any other significant qualities.   
2PL in its general form, as well as when combined with Strictness, i.e., Strict 2PL (S2PL), are not known to be utilized in practice. The popular SS2PL does not require marking "end of phase 1" as 2PL and S2PL do, and thus is simpler to implement. Also, unlike the general 2PL, SS2PL provides, as mentioned above, the useful Strictness and Commitment ordering properties.  

SS2PL 从 1970s 开始成为大多数数据库的并发控制协议。它被证明在大多数情况下是一个高效的机制，不仅提供了串行化也提供了 strictness (cascadeless Recoverability 的一个特殊案例)，是高效的数据库恢复工具......  
作为 CO 的一个子集，  

Many variants of SS2PL exist that utilize various lock types with various semantics in different situations, including cases of lock-type change during a transaction. Notable are variants that use Multiple granularity locking.  

很多的 SS2PL 变种在不同的情况下使用各种锁，包括在事务中锁类型变化的情况。值得注意的是使用多粒度锁的变种。

### Summary - Relationships among classes

## Deadlocks in 2PL