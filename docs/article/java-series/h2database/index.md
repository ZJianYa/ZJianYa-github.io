

http://h2database.com/html/cheatSheet.html

http://h2database.com/html/main.html


## FAQ

1. 为什么我用了内存数据库，然后连接的是 testdb，表/数据都能正常创建/插入，但是从外部就无法看到这些数据
   为什么使用了默认的test数据库，就没有问题了
2. spring boot集成h2指南 https://segmentfault.com/a/1190000007002140

```{}
show databases;
select * from information_schema.tables where table_name like 't_order_coffee';

show tables;
select database();
show databases;
use database testdb;
```