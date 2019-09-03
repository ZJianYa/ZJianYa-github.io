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

## 其他

https://www.infoq.cn/article/G5EuHYT6i43w_ybjkYa3  MySQL漏洞  
https://mp.weixin.qq.com/s?__biz=MjM5ODYxMDA5OQ==&mid=2651961444&idx=1&sn=830a93eb74ca484cbcedb06e485f611e&chksm=bd2d0db88a5a84ae5865cd05f8c7899153d16ec7e7976f06033f4fbfbecc2fdee6e8b89bb17b&scene=21#wechat_redirect  快照读
https://mp.weixin.qq.com/s?__biz=MzI4NDY5Mjc1Mg==&mid=2247486871&idx=1&sn=df2adfad945bd34d27dee557537a0782&chksm=ebf6d5e8dc815cfee8b282b31580ba8504f76b052f3ac9431b26f4f7e057a0cff5f57dfbead6&scene=27#wechat_redirect 浅入浅出』MySQL 和 InnoDB

https://mp.weixin.qq.com/s?__biz=MzI3NzE0NjcwMg==&mid=2650123710&idx=1&sn=4601abda3d87a7d8651db8c6511a47f9&chksm=f36bb09fc41c3989e4eb6a6674279707328a0cdeebcc67e6c2138137530f0c8c446f75a403eb&scene=27#wechat_redirect 数据库死锁排查
http://hedengcheng.com/?p=577  SQL中的where条件，在数据库中提取与应用浅析  

https://www.cnblogs.com/acm-bingzi/p/mysql-current-timestamp.html ON UPDATE CURRENT_TIMESTAMP
https://www.cnblogs.com/tosee/p/5538007.html CTT GMT与UTC
http://ju.outofmemory.cn/entry/364945 时间标准的问题 GMT,CST,UTC
https://dev.mysql.com/doc/connector-j/8.0/en/connector-j-reference-configuration-properties.html mysql jdbc 

https://baike.baidu.com/item/数据库加密/7798419  
https://baike.baidu.com/item/数据库审计/7882064?fr=aladdin  数据库安全

neo4j  非关系型数据库  
Apache geode 高效内存数据库  
mysql 灾备恢复  

#### 安装

https://blog.csdn.net/u010025494/article/details/82382124 CentOS7安装MySQL8.011的解压包方式
https://www.cnblogs.com/h--d/p/9556758.html 【Linux】CentOS 7.4 安装 MySQL 8.0.12 解压版
https://www.cnblogs.com/ocean-sky/p/8392444.html centos7 安装jdk 1.8
https://www.cnblogs.com/manong--/p/8012324.html tar

https://www.cnblogs.com/h--d/p/9556758.html 安装解压版，启动不报错，也不成功
http://aiezu.com/article/mysql_cant_connect_through_socket.html ERROR 2002 (HY000): Can't connect to local MySQL server through socket '/var/lib/mysql/mysql.sock' (2)
https://blog.csdn.net/yeyuyyy/article/details/53765660 mysql 配置文件加载位置与顺序： 