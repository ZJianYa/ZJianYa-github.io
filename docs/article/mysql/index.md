---
home: false
heroImage: /hero.png
actionText: 快速上手 →
actionLink: /article/mysql/
sidebarDepth: 2
---
# 概述

想要优化MySQL的速度（这里不仅是查询，还包括增删改）需要先要了解SQL语句的执行过程，以及有一定的数据结构的基础。  
明确了这两点，接下来就自然知道你什么情况下建索引，建什么类型的索引。知道通过慢查询和Explain去定位和分析执行较慢的SQL。  
知道通过Explain去查看MySQL优化器的实际执行情况。  

MySQL 的参考手册不会讲数据库理论，所以需要自行学习数据库相关理论。  
很多时候我们会看到所谓的权威指南，这种书（如果是理论书）在我看来就是比较好的参考书。  

## 索引  

### [索引和回表](./8.0/optimizing/index/索引.md)  

### [索引和排序](./8.0/optimizing/index/索引-order.md)  

### [索引和关联查询](./8.0/optimizing/index/索引-order.md)  

## [执行计划](./8.0/optimizing/index/执行计划.md)  

## 慢查询  

### [慢查询日志](./8.0/admin/server/logs/slow-query-log.md)  

### [mysqldumpslow](./8.0/mysql-programs/mysqldumpslow.md)  

## DBA/运维

show PROCESSLIST;  
SHOW PROCEDURE STATUS;  
SELECT * FROM information_schema.INNODB_TRX;  
SELECT * FROM INFORMATION_SCHEMA.INNODB_LOCKS;  
SELECT * FROM INFORMATION_SCHEMA.INNODB_LOCK_WAITS;  

对于数据库管理员而言，掌握数据库回滚，除了解决开发或者系统故障导致的数据库宕机之外，还可以解决自己误操作引起的问题。  
测试不仅可以做各种类型的测试，而且可以在系统演练（故障、安全等）发挥重要作用。 

https://blog.csdn.net/lxf0613050210/article/details/79611006 mysql提高insert into 插入速度的3种方法  
