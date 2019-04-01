# log-destinations

MySQL 8.0 Reference Manual  /  MySQL Server Administration  /  MySQL Server Logs  /  Selecting General Query Log and Slow Query Log Output Destinations  
https://dev.mysql.com/doc/refman/8.0/en/log-destinations.html  

如果启用了这些日志，MySQL Server可以灵活地控制写入常规查询日志和慢查询日志的输出目标。  
输出目标是可以日志文件或者 mysql 数据库中的 `general_log` 和 `slow_log` 表。可以选择文件输出、表格输出或两者都选。  

## 服务启动时

`log_output` 只能指明位置，不能启用日志，启用日志需要单独命令

- 如果`log_output`在启动时未指定，则默认日志记录目标为 FILE。

- 如果`log_output`在启动时指定，则`log_output`的值只能是`TABLE (log to tables), FILE (log to files), or NONE (do not log to tables or files).`中的任何一个，或者多个（多个的话用逗号分隔），`NONE` 优先级最高

## 服务运行时

## 日志表的好处和特点
