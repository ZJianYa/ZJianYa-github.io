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

## 索引

### [索引和回表](./8.0/optimizing/index/索引.md)

### [索引和排序](./8.0/optimizing/index/索引-order.md)

### [索引和关联查询](./8.0/optimizing/index/索引-order.md)

## [执行计划](./8.0/optimizing/index/执行计划.md)

## 慢查询

### [慢查询日志](./8.0/admin/server/logs/slow-query-log.md)

### [mysqldumpslow](./8.0/mysql-programs/mysqldumpslow.md)