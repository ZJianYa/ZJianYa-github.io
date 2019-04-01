# 概述

https://dev.mysql.com/doc/refman/8.0/en/slow-query-log.html

## 功能

记录查询慢的SQL语句： long_query_time， min_examined_row_limit  
需要结合 mysqldumpslow 命令来查看分析慢查询日志  

获取初始锁定的时间不计入执行时间。在语句执行完以及所有锁释放之后mysqld写入慢查询日志，所以日志顺序可能和执行顺序不同。  

### 参数设置

- long_query_time  
  默认最小值和默认值是0,10.这个值是可以精确到`microseconds`。
- log_slow_admin_statements  
  默认不记录 administrative statements 。  
  如果你开启了这个环境变量，`Administrative statements include ALTER TABLE, ANALYZE TABLE, CHECK TABLE, CREATE INDEX, DROP INDEX, OPTIMIZE TABLE, and REPAIR TABLE.`都会被记录下来。  
- log_queries_not_using_indexe  
  默认也不记录未使用索引的查询。  
  如果你开启了这个变量，就会记录不使用索引的查询。（但是不会记录由于表少于两行而无法从索引中获益的查询。）   
- slow_query_log
  设置  `--slow_query_log[={0|1}]`  
- slow_query_log_file  
  指定慢查询日志文件名 `--slow_query_log_file=file_name`
-  log_output  
  可以用`log_output`指明日志输出位置。  
  如果你没有指定慢查询日志文件名，默认的文件名是 `host_name-slow.log`。  
  服务会在data目录里创建日志文件，除非指定一个绝对路径。  
  服务运行期间禁用/启用慢查询日志，使用 global ` slow_query_log and slow_query_log_file`变量。 
  如果用`slow_query_log_file`指定了新文件，则旧文件会被关闭，打开一个新文件。  
  更多信息参考 [5.4.1 Selecting General Query Log and Slow Query Log Output Destinations](https://dev.mysql.com/doc/refman/8.0/en/log-destinations.html)
- log-short-format 
  如果你用了 `--log-short-format `了选项，则The server writes less information。
- log_throttle_queries_not_using_indexes  
  当记录不使用索引的查询时，慢查询日志可能会快速增长。可以通过设置 `log_throttle_queries_not_using_indexes` 系统变量对这些查询设置速率限制 。  
  0，表示没有限制。正值会对不使用索引的查询的日志记录施加每分钟限制。第一个这样的查询打开一个60秒的窗口，服务器在该窗口内将查询记录到给定的限制，然后禁止其他查询。如果窗口结束时存在被抑制的查询，则服务器会记录一个摘要，该摘要指示有多少查询以及在其中花费的总时间。当服务器记录下一个不使用索引的查询时，下一个60秒窗口开始。  

服务器按以下顺序使用控制参数来确定是否将查询写入慢查询日志：

- 是不是 administrative statement，如果是 log_slow_admin_statements 有没有开启。  
  可以先过滤
- 是否超过了 `long_query_time` 时间限制，是否启用了 `log_queries_not_using_indexes`。
- 是否超过了 ` min_examined_row_limit` 限制
- 是否有 `log_throttle_queries_not_using_indexes` 限制  
  （如果开启了`log_queries_not_using_indexes`，`log_throttle_queries_not_using_indexes`可以限制写入慢查询日志的每分钟此类查询的数量。值0（默认值）表示“ 无限制 ”。

`log_timestamps` 系统变量控制在写入慢查询日志文件消息的时间戳的时区（以及到一般查询日志文件和错误日志）。但是不影响写入到表中的一般查询日志和慢查询日志消息的时区，但是从表中查询到的行数据，可以用 `CONVERT_TZ()` 或者过会话变量 ` time_zone` 转为任意时区。

默认，从库不会复制慢查询，如果你需要你可以通过 `log_slow_slave_statements` 开启。

### 查看内容

启用慢查询日志时，服务器将输出写入 `log_output` 系统变量指定的任何目标 。如果启用了日志，则服务器将打开日志文件并将启动消息写入其中。但是，只有指定了日志目标为 `FILE`，否则不会进一步将查询记录到文件中。如果目标是 `NONE`，则即使启用了慢查询日志，服务器也不会写入任何查询。如果未指定输出目标为 `FILE`，则设置日志文件名对日志记录没有作用。

如果启用慢查询日志并`log_output`值为`FILE`，则写入日志的每个语句前面都有一个以#字符开头 并且包含这些字段的行（所有字段都在一行中）：

- Query_time: duration  语句执行时间（以秒为单位）。
- Lock_time: duration 在几秒钟内获得锁定的时间。
- Rows_sent: N  发送到客户端的行数。  
- Rows_examined: 优化程序检查的行数。 

如果启用 `log_slow_extra` 系统变量（从MySQL 8.0.14开始提供），服务器将以下额外字段写入 `FILE` 除了上面列出的那些（TABLE输出不受影响）。某些字段描述参照了服务状态变量。有关更多信息，请参阅[状态变量描述](https://dev.mysql.com/doc/refman/8.0/en/server-status-variables.html)。但是，在慢查询日志中，计数器是每个语句的值，而不是每个会话的累计值。

- Thread_id: ID
  语句线程标识符。
- Errno: error_number
  语句错误号，如果没有错误，则返回0。
- Killed: N
  如果语句终止，则错误号指示原因，如果语句正常终止，则返回0。
- Bytes_received: N  
  [Bytes_received](https://dev.mysql.com/doc/refman/8.0/en/server-status-variables.html#statvar_Bytes_received) 声明的值。
- Bytes_sent: N  
  [Bytes_sent](https://dev.mysql.com/doc/refman/8.0/en/server-status-variables.html#statvar_Bytes_received) 声明的值。
- Read_first: N  
  [Handler_read_first](https://dev.mysql.com/doc/refman/8.0/en/server-status-variables.html#statvar_Handler_read_first) 声明 的值。
- Read_last: N  
  [Handler_read_last](https://dev.mysql.com/doc/refman/8.0/en/server-status-variables.html#statvar_Handler_read_first) 声明 的值。
- Read_key: N  
  [Handler_read_key](https://dev.mysql.com/doc/refman/8.0/en/server-status-variables.html#statvar_Handler_read_key)声明 的值。
- Read_next: N  
  Handler_read_next 声明 的值。  
- Read_prev: N  
  Handler_read_prev 声明 的值。  
- Read_rnd: N  
  Handler_read_rnd声明 的值。  
- Read_rnd_next: N  
  Handler_read_rnd_next 声明 的值。
- Sort_merge_passes: N  
  Sort_merge_passes 声明 的值。
- Sort_range_count: N  
  Sort_range声明 的值。  
- Sort_rows: N  
  Sort_rows声明 的值。
- Sort_scan_count: N  
  Sort_scan声明 的值。
- Created_tmp_disk_tables: N  
  Created_tmp_disk_tables 声明 的 值。
- Created_tmp_tables: N  
  Created_tmp_tables 声明 的值。
- Start: timestamp  
  语句执行开始时间。
- End: timestamp
  语句执行结束时间。

给定的慢查询日志文件可能包含` a mix of lines with`，但是没有包含通过启用` log_slow_extra`而增加的字段。日志文件分析可以通过字段数量决定是否包含额外字段。

慢查询的每个语句前面都有一个包含时间戳的`SET`语句。从MySQL 8.0.14开始，时间戳表示慢速语句何时开始执行。在8.0.14之前，时间戳表示何时记录慢速语句（在语句完成执行后发生）。

写入慢查询日志的语句中的密码将由服务器重写，而不是以纯文本形式发生。请参见第6.1.2.3节“密码和日志记录”。

## 案例

### 配置文件配置

```{}
slow_query_log = 1
slow_query_log_file = /var/log/mysql/slow.log
long_query_time = 10
log_queries_not_using_indexes = 1
```

### 服务运行时配置

```{}
show variables like '%general%';
show variables like 'slow_query%';
set global slow_query_log = 1;
```

MySQL中的日志包括：错误日志、二进制日志、通用查询日志、慢查询日志等等。
https://www.cnblogs.com/luyucheng/p/6265594.html 慢查询

