# 15.6.6 Undo Logs

https://dev.mysql.com/doc/refman/8.0/en/innodb-undo-logs.html  

An undo log is a collection of undo log records associated with a single read-write transaction. An undo log record contains information about how to undo the latest change by a transaction to a clustered index record. If another transaction needs to see the original data as part of a consistent read operation, the unmodified data is retrieved from undo log records. Undo logs exist within undo log segments, which are contained within rollback segments. Rollback segments reside in undo tablespaces and in the global temporary tablespace.  
undo log 是与单个读写事务关联的 undo log 记录的集合。  
undo log 记录包含如何撤销最近事务的对一个聚簇索引记录的修改。  
如果另一个事务需要将原始数据视为一致读取操作的一部分，则从撤消日志记录中检索未修改的数据。（可以保证一致性读）  
undo log 存在于 undo log 段中，这些日志段包含在 回滚段中。回滚段驻留在 undo log 表空间和全局临时表空间中。

Undo logs that reside in the global temporary tablespace are used for transactions that modify data in user-defined temporary tables. These undo logs are not redo-logged, as they are not required for crash recovery. They are used only for rollback while the server is running. This type of undo log benefits performance by avoiding redo logging I/O.  
驻留在全局临时表空间中的 undo log 用于 修改户定义的临时表中的数据的事务。  
这些 undo logs 不会被重做日志记录，因为它们不是崩溃恢复所必需的。它们仅用于服务器运行时的回滚。  
这种类型的撤消日志通过避免 redo logging I/O 来提高性能。  

For information about data-at-rest encryption for undo logs, see Undo Log Encryption.

Each undo tablespace and the global temporary tablespace individually support a maximum of 128 rollback segments. The innodb_rollback_segments variable defines the number of rollback segments.  
每个 undo 表空间 和 全局临时表空间分别最多支持128个回滚段。`innodb_rollback_segments` 变量定义了 rollback segments 数量。  

The number of transactions that a rollback segment supports depends on the number of undo slots in the rollback segment and the number of undo logs required by each transaction.  
一个 rollback segment 支持的事务数量依赖于 rollback segment 的 undo slots 数量和每个事务需要的 undo logs 数量。

The number of undo slots in a rollback segment differs according to InnoDB page size.
回滚段中的 undo slots 数量根据InnoDB页面大小而不同。

| InnoDB Page Size | Number of Undo Slots in a Rollback Segment (InnoDB Page Size / 16) |
| ---------------- | ------------------------------------------------------------------ |
| 4096 (4KB)       | 256                                                                |
| 8192 (8KB)       | 512                                                                |
| 16384 (16KB)     | 1024                                                               |
| 32768 (32KB)     | 2048                                                               |
| 65536 (64KB)     | 4096                                                               |

A transaction is assigned up to four undo logs, one for each of the following operation types:  
事务 4个 undo logs ，每个日志对应于以下每种操作类型：  

* INSERT operations on user-defined tables  
插入操作

* UPDATE and DELETE operations on user-defined tables
更新和删除操作

* INSERT operations on user-defined temporary tables
对临时表的插入操作

* UPDATE and DELETE operations on user-defined temporary tables
对临时表的更新和删除操作

Undo logs are assigned as needed. For example, a transaction that performs INSERT, UPDATE, and DELETE operations on regular and temporary tables requires a full assignment of four undo logs. A transaction that performs only INSERT operations on regular tables requires a single undo log.   
Undo logs 按需分配。例如， 一个 Transaction 在普通表和临时表上执行 INSERT UPDATE DELETE 操作需要4个 undo logs 的完整分配。一个事务仅仅执行 INSERT 操作需要一个 undo log。  

A transaction that performs operations on regular tables is assigned undo logs from an assigned undo tablespace rollback segment. A transaction that performs operations on temporary tables is assigned undo logs from an assigned global temporary tablespace rollback segment.  
在常规表上执行操作的事务将从分配的撤消表空间回滚段中分配撤消日志。对临时表执行操作的事务将从分配的全局临时表空间回滚段中分配撤消日志。

An undo log assigned to a transaction remains tied to the transaction for its duration. For example, an undo log assigned to a transaction for an INSERT operation on a regular table is used for all INSERT operations on regular tables performed by that transaction.  
分配给事务的撤消日志在其持续时间内仍与事务相关联。例如，为INSERT 常规表上的操作分配给事务的撤消日志用于该事务执行的常规表上的所有 INSERT操作。

Given the factors described above, the following formulas can be used to estimate the number of concurrent read-write transactions that InnoDB is capable of supporting.  
鉴于上述因素，可以使用以下公式来估计InnoDB能够支持的并发读写事务的数量。

> Note
A transaction can encounter a concurrent transaction limit error before reaching the number of concurrent read-write transactions that InnoDB is capable of supporting. This occurs when a rollback segment assigned to a transaction runs out of undo slots. In such cases, try rerunning the transaction.  
在达到InnoDB能够支持的并发读写事务数之前，事务可能会遇到并发事务限制错误。当分配给事务的回滚段用完撤消槽时，会发生这种情况。在这种情况下，请尝试重新运行该事务。
> When transactions perform operations on temporary tables, the number of concurrent read-write transactions that InnoDB is capable of supporting is constrained by the number of rollback segments allocated to the global temporary tablespace, which is 128 by default.  
当事务对临时表执行操作时，InnoDB能够支持的并发读写事务 数受限于分配给全局临时表空间的回滚段数，默认情况下为128。

* If each transaction performs either an INSERT or an UPDATE or DELETE operation, the number of concurrent read-write transactions that InnoDB is capable of supporting is:  
如果每个事务执行一个 INSERT 或 一个UPDATE 或 一个 DELETE 操作，那么能够支持的并发读写事务的数量 是： INSERT UPDATE DELETE InnoDB

> (innodb_page_size / 16) * innodb_rollback_segments * number of undo tablespaces

* If each transaction performs an INSERT and an UPDATE or DELETE operation, the number of concurrent read-write transactions that InnoDB is capable of supporting is:  
如果每个事务执行一个 INSERT 和一个 UPDATE 或一个 DELETE 操作，那么能够支持的并发读写事务的数量 是：  

> (innodb_page_size / 16 / 2) * innodb_rollback_segments * number of undo tablespaces

* If each transaction performs an INSERT operation on a temporary table, the number of concurrent read-write transactions that InnoDB is capable of supporting is:  
如果每个事务 在临时表上执行 一个INSERT 操作，InnoDB则能够支持的并发读写事务的数量 为：  

> (innodb_page_size / 16) * innodb_rollback_segments

* If each transaction performs an INSERT and an UPDATE or DELETE operation on a temporary table, the number of concurrent read-write transactions that InnoDB is capable of supporting is:
如果每个事务在临时表上 执行一个 INSERT 和 一个 UPDATE 或 DELETE 操作，能够支持的并发读写的事务的数目是： 

> (innodb_page_size / 16 / 2) * innodb_rollback_segments