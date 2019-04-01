# mysqldumpslow

https://dev.mysql.com/doc/refman/8.0/en/mysqldumpslow.html  

mysqldumpslow解析MySQL慢查询日志文件并总结其内容.

## 语法格式：

```{}
shell> mysqldumpslow [options] [log_file ...]
```

例如：

```{}
shell> mysqldumpslow

Reading mysql slow query log from /usr/local/mysql/data/mysqld80-slow.log
Count: 1  Time=4.32s (4s)  Lock=0.00s (0s)  Rows=0.0 (0), root[root]@localhost
 insert into t2 select * from t1

Count: 3  Time=2.53s (7s)  Lock=0.00s (0s)  Rows=0.0 (0), root[root]@localhost
 insert into t2 select * from t1 limit N

Count: 3  Time=2.13s (6s)  Lock=0.00s (0s)  Rows=0.0 (0), root[root]@localhost
 insert into t1 select * from t1
```

## 选项

mysqldumpslow支持以下选项。

| Format       | Description                    |
| ------------ | ------------------------------ |
| -a           | 别把数字抽象为N，String抽象为S |
| -n           | 至少抽象指定数字               |
| --debug / -d | 以调试模式运行                 |
| -g           | 只关心与模式匹配的语句         |
| --help       | 显示帮助消息并退出             |
| -h           | 日志文件名中服务器的主机名     |
| -i           | 服务器实例的名称               |
| -l           | 不要从总时间中减去锁定时间     |
| -r           | 反转排序顺序                   |
| -s           | 怎么排序                       |
| -t           | 仅显示第一个num查询            |
| --verbose    | 详细模式                       |

如何对输出进行排序。sort_type应从以下列表中选择值 ：

* t，at：按查询时间或平均查询时间排序
* l，al：按锁定时间或平均锁定时间排序
* r，ar：按发送的行或发送的平均行排序
* c：按计数排序

默认情况下，mysqldumpslow按平均查询时间（相当于-s at）排序。

## 案例

```{}
[root@localhost ~]# /home/mysql/mysql-8.0.13-el7-x86_64/bin/mysqldumpslow  -a -s  c   -t 1   /csmp/mysql/ea8335be4169-slow.log

Reading mysql slow query log from /csmp/mysql/ea8335be4169-slow.log
Count: 107  Time=0.09s (9s)  Lock=0.00s (0s)  Rows=0.0 (0), root[root]@5hosts
  commit

[root@localhost ~]# # 这个查询被执行了107次，平均耗时是0.09s，107次一共花费9秒
```

下面的例子中参数都被 S 和 N 替代

```{}
[root@localhost ~]# /home/mysql/mysql-8.0.13-el7-x86_64/bin/mysqldumpslow  -s c -r -t 1   /csmp/mysql/ea8335be4169-slow.log

Reading mysql slow query log from /csmp/mysql/ea8335be4169-slow.log
Count: 168  Time=0.06s (10s)  Lock=0.00s (0s)  Rows=1.0 (168), root[root]@3hosts
  select count(N) FROM (
  SELECT
  web.name AS webName,
  web.url AS webUrl,
  b.type AS type,
  b.name AS name,
  b.description AS detail,
  b.firm AS source,
  b.suggest AS remark,
  court.name AS courtName,
  CASE WHEN date_format(a.rectify_date, 'S') >= date_format(now(), 'S')
  THEN
  (datediff(date_format(a.rectify_date, 'S'), date_format(now(), 'S')) + N)
  ELSE
  (datediff(date_format(a.rectify_date, 'S'), date_format(now(), 'S')))
  END AS daysLeft,
  CASE WHEN date_format(a.rectify_date, 'S') >= date_format(now(), 'S') AND a.finish_date IS NULL
  THEN 'S'
  WHEN a.finish_date IS NOT NULL AND date_format(a.rectify_date, 'S') >= date_format(a.finish_date,
  'S')
  THEN 'S'
  WHEN (date_format(now(), 'S') >= date_format(a.rectify_date, 'S') AND a.finish_date IS NULL)
  OR date_format(a.finish_date, 'S') > date_format(a.rectify_date, 'S')
  THEN 'S' END AS billStatus,
  a.*
  FROM bill a
  LEFT JOIN security b ON a.security_id = b.id
  LEFT JOIN website web ON b.website_id = web.id
  LEFT JOIN sys_dept court ON court.id = web.dept_id
  WHERE a.isdel = N
  and web.dept_id = N
  ) t
  WHERE  t.billStatus = 'S'

```

## FAQ

* 没明白`-n`的实际意义  
