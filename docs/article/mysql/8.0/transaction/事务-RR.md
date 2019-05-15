
# 事务

ACID（Atomicity、Consistency、Isolation、Durability，即原子性、一致性、隔离性、持久性）

## 测试准备

```{}
mysql> CREATE TABLE `t` (
  `id` int(11) NOT NULL,
  `k` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;
insert into t(id, k) values(1,1),(2,2);
```

### RR和两阶段提交

两阶段锁

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

在这个例子中，事务 C 没有显式地使用 begin/commit，表示这个 update 语句本身就是一个事务，语句完成的时候会自动提交。  
这时，而事务 A 查到的 k 的值是 1；事务 B 查到的 k 的值是 3。

#### 事务启动方式

begin/start transaction 命令并不是一个事务的起点，在执行到它们之后的第一个操作 InnoDB 表的语句，事务才真正启动。  
如果你想要马上启动一个事务，可以使用 start transaction with consistent snapshot 这个命令。  

>第一种启动方式，一致性视图是在第执行第一个快照读语句时创建的；  
>第二种启动方式，一致性视图是在执行 start transaction with consistent snapshot 时创建的。  

#### 再谈快照读

在实现 MVCC 时用到的一致性读视图（也叫快照读），即 consistent read view，用于支持 RC（Read Committed，读提交）和 RR（Repeatable Read，可重复读）隔离级别的实现。  


事务：  
在系统中，每个事务都有一个ID叫Transaction id，所有事务ID都全局唯一。  

快照读：  
只有涉及到事务的数据（通常是行数据），才会生成快照（也只是为这一行数据生成快照），这个快照编号=row_id+trx_id  
也就是说，一行数据在不同事务中，快照编号是不一样的  

当前读：  
更新数据都是先读后写的，而这个读，只能读当前的值，称为“当前读”（current read）。  
这里我们提到了一个概念，叫作当前读。其实，除了 update 语句外，select 语句如果加锁，也是当前读。如：  

```{}
mysql> select k from t where id=1 lock in share mode;
mysql> select k from t where id=1 for update;
```

#### 当前读

假设

| 事务A                                        | 事务B                                       | 事务C1                         |
| ------------------------------------------- | ------------------------------------------- | ----------------------------- |
| start transaction with consistent snapshot; |                                             |                               |
|                                             | start transaction with consistent snapshot; |                               |
|                                             |                                             | start transaction with consistent snapshot;|
|                                             |                                             | update t set k=k+1 where id=1 |
|                                             | update t set k=k+1 where id=1 ;             |                               |
|                                             | select k from t where t = 1;                |                               |
| select k from t where id = 1 ;              |                                             | commit;                       |
|                                commit;      |                                             |                               |
|                                             | commit;                                     |                               |

这时候，我们会发现，在事务C1提交之前，事务B是不能创建RR视图或者使用当前读创建视图的。  
而对于对于之前的例子，事务B使用了当前读，我则理解为事务B把RR视图的窗口做了重建，这种窗口重建的情况是加锁读写引起的。  

总结一下：  
事务中查询语句会创建RR视图，而加锁的语句会尝试重建RR视图，这时候是需要加锁之后重建RR视图。  
如果重建RR视图时未能获得需要的锁，（尽管已经销毁了过去的RR视图）但是依旧不能创建新的RR视图，直到锁释放。  

RR视图的创建和销毁需要考虑两个因素：事务，锁。两者发生时间的不一致面提高了并发性，却造成了理解上的困难。  
事务和锁虽然发生时间不一致，但是锁的释放时间和事务的结束时间是一致的。  

## 问题监控和排查

- 检测 general_log  
- 检测 information_schema.Innodb_trx  
- innodb_undo_tablespaces设置为2  
