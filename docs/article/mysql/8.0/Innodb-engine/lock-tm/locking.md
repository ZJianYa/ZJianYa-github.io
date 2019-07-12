https://dev.mysql.com/doc/refman/8.0/en/innodb-locking.html

- 共享锁和独占锁  
  Shared and Exclusive Locks
- 意向锁  
  Intention Locks
- Record Locks
- 间隙锁
- next-key
- 插入意向锁  
  Insert Intention Locks
- AUTO-INC Locks  
- Predicate Locks for Spatial Indexes  
  空间索引的谓词锁


## Shared and Exclusive Locks

InnoDB implements standard row-level locking where there are two types of locks, shared (S) locks and exclusive (X) locks.

- A shared (S) lock permits the transaction that holds the lock to read a row.

- An exclusive (X) lock permits the transaction that holds the lock to update or delete a row.

If transaction T1 holds a shared (S) lock on row r, then requests from some distinct transaction T2 for a lock on row r are handled as follows:

A request by T2 for an S lock can be granted immediately. As a result, both T1 and T2 hold an S lock on r.

A request by T2 for an X lock cannot be granted immediately.

If a transaction T1 holds an exclusive (X) lock on row r, a request from some distinct transaction T2 for a lock of either type on r cannot be granted immediately. Instead, transaction T2 has to wait for transaction T1 to release its lock on row r.

## Intention Locks

InnoDB supports multiple granularity locking which permits coexistence of row locks and table locks. For example, a statement such as LOCK TABLES ... WRITE takes an exclusive lock (an X lock) on the specified table. To make locking at multiple granularity levels practical, InnoDB uses intention locks. Intention locks are table-level locks that indicate which type of lock (shared or exclusive) a transaction requires later for a row in a table. There are two types of intention locks:

An intention shared lock (IS) indicates that a transaction intends to set a shared lock on individual rows in a table.

An intention exclusive lock (IX) indicates that a transaction intends to set an exclusive lock on individual rows in a table.

For example, SELECT ... FOR SHARE sets an IS lock, and SELECT ... FOR UPDATE sets an IX lock.

The intention locking protocol is as follows:

Before a transaction can acquire a shared lock on a row in a table, it must first acquire an IS lock or stronger on the table.

Before a transaction can acquire an exclusive lock on a row in a table, it must first acquire an IX lock on the table.

Table-level lock type compatibility is summarized in the following matrix.

