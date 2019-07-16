# 15.6.5 Redo Log

MySQL 8.0 Reference Manual  /  The InnoDB Storage Engine  /  InnoDB On-Disk Structures  /  Redo Log

The redo log is a disk-based data structure used during crash recovery to correct data written by incomplete transactions. During normal operations, the redo log encodes requests to change table data that result from SQL statements or low-level API calls. Modifications that did not finish updating the data files before an unexpected shutdown are replayed automatically during initialization, and before the connections are accepted. For information about the role of the redo log in crash recovery, see Section [15.17.2, “InnoDB Recovery”](https://dev.mysql.com/doc/refman/8.0/en/innodb-recovery.html).

重做日志是在崩溃恢复期间用于纠正由未完成事务写入的数据的基于磁盘的数据结构。  
在正常操作期间，重做日志会对执行SQL（而造成的）更改表数据或者调用低级别API的请求进行编码。  
在初始化期间以及接受连接之前，意外关闭之前未完成的更新数据文件的修改 将被被自动重播。  
有关重做日志在崩溃恢复中的作用的信息，请参见 第15.17.2节“InnoDB恢复”。  

By default, the redo log is physically represented on disk by two files named ib_logfile0 and ib_logfile1. MySQL writes to the redo log files in a circular fashion. Data in the redo log is encoded in terms of records affected; this data is collectively referred to as redo. The passage of data through the redo log is represented by an ever-increasing LSN value.  

默认，redo log 物理形式是磁盘上的两个文件： ib_logfile0 和 ib_logfile1 。  
MySQL 以循环方式写 redo log 日志。  
重做日志中的数据根据受影响的记录进行编码; 这些数据统称为重做。  
通过重做日志的 数据的 passage 由不断增加的 LSN 值表示。  

For related information, see [Redo Log File Configuration](https://dev.mysql.com/doc/refman/8.0/en/innodb-init-startup-configuration.html#innodb-startup-log-file-configuration), and [Section 8.5.4, “Optimizing InnoDB Redo Logging”](https://dev.mysql.com/doc/refman/8.0/en/optimizing-innodb-logging.html).  
更多相关信息，请参阅 重做日志文件配置和 第8.5.4节“优化InnoDB重做日志记录”。

For information about [data-at-rest encryption](https://dev.mysql.com/doc/refman/8.0/en/innodb-tablespace-encryption.html#innodb-tablespace-encryption-redo-log) for redo logs, see [Redo Log Encryption](https://dev.mysql.com/doc/refman/8.0/en/innodb-tablespace-encryption.html#innodb-tablespace-encryption-redo-log).  
有关重做日志的数据静态加密的信息，请参阅 重做日志加密。  

## Changing the Number or Size of Redo Log Files

To change the number or the size of redo log files, perform the following steps:  
修改数量或者大小，需要执行下列步骤

- Stop the MySQL server and make sure that it shuts down without errors.
  停止服务器，确保停止过程中无错误。

- Edit my.cnf to change the log file configuration. To change the log file size, configure `innodb_log_file_size`. To increase the number of log files, configure `innodb_log_files_in_group`.
  编辑 my.cnf 文件

- Start the MySQL server again.

If InnoDB detects that the `innodb_log_file_size` differs from the redo log file size, it writes a log checkpoint, closes and removes the old log files, creates new log files at the requested size, and opens the new log files.    
如果InnoDB检测到 innodb_log_file_size 与重做日志文件大小不同，则会写入日志检查点，关闭并删除旧的日志文件，以请求的大小创建新的日志文件，并打开新的日志文件。

## Group Commit for Redo Log Flushing

InnoDB, like any other ACID-compliant database engine, flushes the redo log of a transaction before it is committed. InnoDB uses group commit functionality to group multiple such flush requests together to avoid one flush for each commit. With group commit, InnoDB issues a single write to the log file to perform the commit action for multiple user transactions that commit at about the same time, significantly improving throughput.  
InnoDB与任何其他 符合ACID标准的数据库引擎一样，在事务提交之前刷新事务的重做日志。InnoDB 使用组提交 功能将多个此类刷新请求组合在一起，以避免每次提交一次刷新。使用组提交， InnoDB对日志文件发出单个写入，为几乎同时提交的多个用户事务执行提交操作，从而显着提高吞吐量。  

For more information about performance of COMMIT and other transactional operations, see [Section 8.5.2, “Optimizing InnoDB Transaction Management”](https://dev.mysql.com/doc/refman/8.0/en/optimizing-innodb-transaction-management.html).  
更多的关于 COMMIT 和 其他事务操作的性能的信息，请参见第8.5.2节“优化InnoDB事务管理”。
