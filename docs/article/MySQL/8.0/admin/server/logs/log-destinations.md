# log-destinations

MySQL 8.0 Reference Manual  /  MySQL Server Administration  /  MySQL Server Logs  /  Selecting General Query Log and Slow Query Log Output Destinations  
https://dev.mysql.com/doc/refman/8.0/en/log-destinations.html  

MySQL可以灵活控制`general query log`和`the slow query log`的输出位置。  
输出目标是可以日志文件或者 mysql 数据库中的 `general_log` 和 `slow_log` 表。可以选择文件输出、表格输出或两者都选。  

## 服务启动时

`log_output` 只能指明位置，不能启用日志，启用日志需要单独命令.

- 如果`log_output`在启动时未指定，则默认日志记录目标为 `FILE`。

- 如果`log_output`在启动时指定，则`log_output`的值只能是`TABLE (log to tables), FILE (log to files), or NONE (do not log to tables or files).`中的任何一个，或者多个（多个的话用逗号分隔），`NONE` 优先级最高

`general_log`系统变量指明了日志输出的位置。如果在服务启动时指定，`general_log`带一个可选的参数1或0，表示是否启用日志。为了指明一个文件名，而不是用默认文件名，需要设置`general_log_file`。`slow_query_log`、`slow_query_log_file`也是同样。如果启用了任一日志，则服务器将打开相应的日志文件并将启动消息写入其中。但是如果log输出类型不是 FILE ，那么后续的查询日志不会写入文件。

例如：

- 要将常规查询日志写入日志表和日志文件，请使用 --log_output=TABLE,FILE 选择两个日志类型，并用 --general_log启用常规查询日志。

- 要仅将常规和慢查询日志条目写入日志表，请使用 `--log_output=TABLE` 选择表作为日志类型，并用 `--general_log` 和 `--slow_query_log` 启用这两个日志。

- 要将慢查询日志仅写入日志文件，请使用 `--log_output=FILE` 选择文件作为日志类型，并用 `--slow_query_log`启用慢查询日志。在这种情况下，由于默认日志类型是FILE，您可以省略该 log_output 设置。

## 服务运行时

运行时修改系统变量，设置日志表或者日志文件：

- `log_output` 同之前
- `general_log`和`slow_query_log` 同之前
- `general_log_file`和`slow_query_log_file` 同之前
- 如果只是想要开启或关闭当前会话的`general query log`，设置`sql_log_off`为`ON`或者`OFF`

## 日志表的好处和特点

TODO