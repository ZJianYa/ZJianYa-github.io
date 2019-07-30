# 概述

## SQL 执行与优化

### 索引  

- 索引类型 函数索引
- 字段类型
- 主键/唯一索引/普通索引
  - 回表
  - 唯一索引的优劣  
  - 普通索引的优劣
- 联合主键 回表/最左原则  
  实际的存储结构  
- 关联查询  NLJ BNL MRR BKA  
- limit 优化

### 缓存

读写缓存  

### 慢查询  

### 事务 / 日志

- 避免长事务
- 锁对查询的影响
- 热点数据处理

https://dev.mysql.com/doc/refman/8.0/en/innodb-parameters.html#sysvar_innodb_flush_log_at_trx_commit  日志刷新，会影响插入效率  
https://mp.weixin.qq.com/s?__biz=MjM5ODYxMDA5OQ==&mid=2651962432&idx=1&sn=3459e82428cb9bb1de4677fa6b5a1c2d&chksm=bd2d099c8a5a808af5926a8be9c900c0bca57a8b8e61b192272d919e38d607a03b5ac4e0990a&scene=27#wechat_redirect  MySQL 死锁？

### 连接池  


## 事务

### 特性

ACID：原子性（Atomicity）、一致性（Consistency）、隔离性（Isolation）、持久性（Durability）

### 隔离级别

分别能够解决什么问题？

### 锁

- 乐观锁
- 锁的升级降级
- 死锁检测和处理
- 间隙锁

### 事务的传递

### 事务的查询

## 其他

https://www.javazhiyin.com/38497.html 分页如何处理









