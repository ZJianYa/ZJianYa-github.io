# Repeatable

因为MySQL

ACID 原子性（Atomicity）、一致性（Consistency）、隔离性（Isolation）、持久性（Durability）  
脏读（read uncommited/repeatable read）、不可重复读（read commited/repeatable read）、幻读（serializable）

```{}
mysql> CREATE TABLE `t` (
  `id` int(11) NOT NULL,
  `k` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;
insert into t(id, k) values(1,1),(2,2);
```

| 事务A                                        | 事务B                                       | 事务C                         |
| ------------------------------------------- | ------------------------------------------- | ----------------------------- |
| start transaction with consistent snapshot; |                                             |                               |
|                                             | start transaction with consistent snapshot; |                               |
|                                             |                                             | update t set k=k+1 where id=1 |
|                                             | update t set k=k+1 where id=1 ;             |                               |
|                                             | select k from t where t = 1;                |                               |
| select k from t where id = 1 ;              |                                             |                               |
|                                commit;      |                                             |                               |
|                                             | commit;                                     |                               |

begin/start transaction 命令并不是一个事务的起点，在执行到它们之后的第一个操作 InnoDB 表的语句，事务才真正启动。如果你想要马上启动一个事务，可以使用 start transaction with consistent snapshot 这个命令。  

>第一种启动方式，一致性视图是在第执行第一个快照读语句时创建的；  
>第二种启动方式，一致性视图是在执行 start transaction with consistent snapshot 时创建的。  

在这个例子中，事务 C 没有显式地使用 begin/commit，表示这个 update 语句本身就是一个事务，语句完成的时候会自动提交。  
事务 B 在更新了行之后查询 ;  
事务 A 在一个只读事务中查询，并且时间顺序上是在事务 B 的查询之后。

这时，事务 B 查到的 k 的值是 3，而事务 A 查到的 k 的值是 1.

第一个视图是我们常理解的repeatable。
第二个视图也符合我期望：在实现 MVCC 时用到的一致性读视图，即 consistent read view，用于支持 RC（Read Committed，读提交）和 RR（Repeatable Read，可重复读）隔离级别的实现。  

InnoDB 里面每个事务有一个唯一的事务 ID，叫作 transaction id。它是在事务开始的时候向 InnoDB 的事务系统申请的，是按申请顺序严格递增的。  

数据表中的一行记录，其实可能有多个版本 (row)，每个版本有自己的 row trx_id。  

因此，一个事务只需要在启动的时候声明说，“以我启动的时刻为准，如果一个数据版本是在我启动之前生成的，就认；如果是我的事务启动以后才生成的，我就不认，我必须要找到它的上一个版本”看看是不是我启动前的...，直至到第一个可见版本。  
但是，如果是这个事务自己更新的数据，它自己还是要认的。  

这样，一行记录的（因事务产生的）多个版本，保证了事务的一致性视图。  

## 当前读

更新数据都是先读后写的，而这个读，只能读当前的值，称为“当前读”（current read），有别于 repeatable read 。

所以，如果把事务 A 的查询语句 select * from t where id=1 修改一下，加上 lock in share mode 或 for update，也都可以读到版本号是 101 的数据，返回的 k 的值是 3。下面这两个 select 语句，就是分别加了读锁（S 锁，共享锁）和写锁（X 锁，排他锁）。  

所有的当前读都会加读锁。

```{}
mysql> select k from t where id=1 lock in share mode;
mysql> select k from t where id=1 for update;
```

假如是下面的情况：

| 事务A                                        | 事务B                                       | 事务C                         |
| ------------------------------------------- | ------------------------------------------- | ----------------------------- |
| start transaction with consistent snapshot; |                                             |                               |
|                                             | start transaction with consistent snapshot; |                               |
|                                             |                                             | start transaction with consistent snapshot;|
|                                             |                                             | update t set k=k+1 where id=1 |
|                                             | update t set k=k+1 where id=1 ;             |                               |
|                                             | select k from t where t = 1;                |                               |
|                                             |                                             |  commit                       |
| select k from t where id = 1 ;              |                                             |                               |
|                                commit;      |                                             |                               |
|                                             | commit;                                     |                               |

