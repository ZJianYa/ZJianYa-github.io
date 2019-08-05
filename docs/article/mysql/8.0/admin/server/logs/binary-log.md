# 5.4.4 The Binary Log

MySQL 8.0 Reference Manual  /  MySQL Server Administration  /  MySQL Server Logs  /  The Binary Log

https://dev.mysql.com/doc/refman/8.0/en/binary-log.html

5.4.4.1 Binary Logging Formats
5.4.4.2 Setting The Binary Log Format
5.4.4.3 Mixed Binary Logging Format
5.4.4.4 Logging Format for Changes to mysql Database Tables

The binary log contains “events” that describe database changes such as table creation operations or changes to table data. It also contains events for statements that potentially could have made changes (for example, a DELETE which matched no rows), unless row-based logging is used. The binary log also contains information about how long each statement took that updated data. The binary log has two important purposes:

binary log 包含 描述数据库变化的事件，例如建表或者改表数据的 事件。 
它还包含可能发生更改的语句的事件（例如，不匹配任何行的DELETE），除非使用基于行的日志记录。 
二进制日志还包含有关 每个更新数据的语句花费的时间。 二进制日志有两个重要目的：

- For replication, the binary log on a master replication server provides a record of the data changes to be sent to slave servers. The master server sends the events contained in its binary log to its slaves, which execute those events to make the same data changes that were made on the master. See Section 17.2, “Replication Implementation”.
  用于复制，主服务器上的 binary log 提供数据变化的记录，被发送到从服务器上。 主服务器发送给从服务器的事件包含在 binary log 中，执行这些事件发生相同的数据变化。

- Certain data recovery operations require use of the binary log. After a backup has been restored, the events in the binary log that were recorded after the backup was made are re-executed. These events bring databases up to date from the point of the backup. See Section 7.5, “Point-in-Time (Incremental) Recovery Using the Binary Log”.  
  某些数据恢复操作需要使用二进制日志。备份被还原之后， 记录在 binary log 中的在备份之后的事件被重新执行。这些事件使数据库从备份点更新。 请参见第7.5节“使用二进制日志进行时间点（增量）恢复”。

The binary log is not used for statements such as SELECT or SHOW that do not modify data. To log all statements (for example, to identify a problem query), use the general query log. See Section 5.4.3, “The General Query Log”.

二进制日志不用于不修改数据的 SELECT或SHOW等语句。 要记录所有语句（例如，标识问题查询），请使用常规查询日志。 请参见第5.4.3节“常规查询日志”。

Running a server with binary logging enabled makes performance slightly slower. However, the benefits of the binary log in enabling you to set up replication and for restore operations generally outweigh this minor performance decrement.  
运行启用了二进制日志记录的服务器会使性能稍慢。 但是，二进制日志使您能够设置复制和还原操作的好处通常会超过此次要性能下降。  

The binary log is resilient to unexpected halts. Only complete events or transactions are logged or read back.  
二进制日志可以抵御意外停止。 仅记录或回读完整的事件或事务。  

Passwords in statements written to the binary log are rewritten by the server not to occur literally in plain text. See also Section 6.1.2.3, “Passwords and Logging”.  
写入二进制日志的语句中的密码由服务器重写，不会以纯文本形式出现。 另请参见第6.1.2.3节“密码和日志记录”。  

From MySQL 8.0.14, binary log files and relay log files can be encrypted, helping to protect these files and the potentially sensitive data contained in them from being misused by outside attackers, and also from unauthorized viewing by users of the operating system where they are stored. You enable encryption on a MySQL server by setting the binlog_encryption system variable to ON. For more information, see Section 17.3.10, “Encrypting Binary Log Files and Relay Log Files”.  
从 MySQL 8.0.14 开始，二进制 log 文件 和 relay 日志 文件可以被加密，有助于保护这些文件及.....  

The following discussion describes some of the server options and variables that affect the operation of binary logging. For a complete list, see Section 17.1.6.4, “Binary Logging Options and Variables”.  
下面的套路描述了一些影响 binary log 的可配置选项。  

Binary logging is enabled by default (the log_bin system variable is set to ON). The exception is if you use mysqld to initialize the data directory manually by invoking it with the --initialize or --initialize-insecure option, when binary logging is disabled by default, but can be enabled by specifying the --log-bin option.  
binary log 默认是启用的。例外情况是你使用 mysqld 通过 --initialize 或者 --initialize-insecure 选项手动初始化数据目录 默认 binary logging 是禁用的，但是可以通过 --log-bin 选项开启。  

To disable binary logging, you can specify the --skip-log-bin or --disable-log-bin option at startup. If either of these options is specified and --log-bin is also specified, the option specified later takes precedence.  
要禁用二进制日志记录，可以 在启动时指定 --skip-log-bin 或 --disable-log-bin选项。如果指定了这些选项中的任何一个并且--log-bin也指定了这些选项 ，则稍后指定的选项优先。  

The --log-slave-updates and --slave-preserve-commit-order options require binary logging. If you disable binary logging, either omit these options, or specify --skip-log-slave-updates and --skip-slave-preserve-commit-order. MySQL disables these options by default when --skip-log-bin or --disable-log-bin is specified. If you specify --log-slave-updates or --slave-preserve-commit-order together with --skip-log-bin or --disable-log-bin, a warning or error message is issued.  
在--log-slave-updates和 --slave-preserve-commit-order 选项需要二进制日志。如果禁用二进制日志记录，请省略这些选项，或指定 --skip-log-slave-updates 和 --skip-slave-preserve-commit-order。MySQL时，默认情况下禁用这些选项 --skip-log-bin 或 --disable-log-bin 指定的。如果指定 --log-slave-updates或 --slave-preserve-commit-order 连同 --skip-log-bin 或者 --disable-log-bin，发出警告或错误信息。

The `--log-bin[=base_name]` option is used to specify the base name for binary log files. If you do not supply the --log-bin option, MySQL uses binlog as the default base name for the binary log files. For compatibility with earlier releases, if you supply the --log-bin option with no string or with an empty string, the base name defaults to host_name-bin, using the name of the host machine. It is recommended that you specify a base name, so that if the host name changes, you can easily continue to use the same binary log file names (see Section B.4.7, “Known Issues in MySQL”). If you supply an extension in the log name (for example, --log-bin=base_name.extension), the extension is silently removed and ignored.  
该选项用于指定二进制日志文件的基本名称。如果您不提供该选项，MySQL将使用二进制日志文件的默认基本名称。为了与早期版本兼容，如果提供的选项没有字符串或空字符串，则基本名称默认为 使用主机名称。建议您指定基本名称，以便在主机名更改时，您可以轻松地继续使用相同的二进制日志文件名（请参见 第B.4.7节“MySQL中的已知问题”）。如果在日志名称中提供扩展名（例如， ），则会以静默方式删除并忽略该扩展名。 --log-bin[=base_name]--log-binbinlog--log-binhost_name-bin--log-bin=base_name.extension  

mysqld appends a numeric extension to the binary log base name to generate binary log file names. The number increases each time the server creates a new log file, thus creating an ordered series of files. The server creates a new file in the series each time it starts or flushes the logs. The server also creates a new binary log file automatically after the current log's size reaches max_binlog_size. A binary log file may become larger than max_binlog_size if you are using large transactions because a transaction is written to the file in one piece, never split between files.  
mysqld 将数字扩展名附加到二进制日志基本名称以生成二进制日志文件名。每次服务器创建新日志文件时，该数字都会增加，从而创建一系列有序的文件。每次启动或刷新日志时，服务器都会在系列中创建一个新文件。服务器还会在当前日志大小达到后自动创建新的二进制日志文件 max_binlog_size。使用大型事务时二进制日志文件可能会比 max_binlog_size 更大， 因为事务是以一个部分写入文件，而不是在文件之间分割。

To keep track of which binary log files have been used, mysqld also creates a binary log index file that contains the names of the binary log files. By default, this has the same base name as the binary log file, with the extension '.index'. You can change the name of the binary log index file with the --log-bin-index[=file_name] option. You should not manually edit this file while mysqld is running; doing so would confuse mysqld.

为了跟踪已使用的二进制日志文件， mysqld还创建了一个二进制日志索引文件，其中包含二进制日志文件的名称。默认情况下，它具有与二进制日志文件相同的基本名称，并带有扩展名 '.index'。您可以使用该 选项更改二进制日志索引文件的名称 。在mysqld运行时，您不应手动编辑此文件 ; 这样做会让mysqld感到困惑 。 --log-bin-index[=file_name]

The term “binary log file” generally denotes an individual numbered file containing database events. The term “binary log” collectively denotes the set of numbered binary log files plus the index file.  
术语“ 二进制日志文件 ”通常表示包含数据库事件的单个编号文件。术语 “ 二进制日志 ”共同表示编号的二进制日志文件集加上索引文件。

The default location for binary log files and the binary log index file is the data directory. You can use the --log-bin option to specify an alternative location, by adding a leading absolute path name to the base name to specify a different directory. When the server reads an entry from the binary log index file, which tracks the binary log files that have been used, it checks whether the entry contains a relative path. If it does, the relative part of the path is replaced with the absolute path set using the --log-bin option. An absolute path recorded in the binary log index file remains unchanged; in such a case, the index file must be edited manually to enable a new path or paths to be used. The binary log file base name and any specified path are available as the log_bin_basename system variable.  
二进制日志文件和二进制日志索引文件的默认位置是数据目录。您可以使用该 --log-bin选项指定备用位置，方法是在基本名称中添加前导绝对路径名以指定其他目录。当服务器从二进制日志索引文件中读取条目时，该文件跟踪已使用的二进制日志文件，它会检查条目是否包含相对路径。如果是，则路径的相对部分将替换为使用的设置的绝对路径 --log-bin选项。二进制日志索引文件中记录的绝对路径保持不变; 在这种情况下，必须手动编辑索引文件以启用新路径。二进制日志文件基本名称和任何指定的路径都可用作 log_bin_basename系统变量  

In MySQL 5.7, a server ID had to be specified when binary logging was enabled, or the server would not start. In MySQL 8.0, the server_id system variable is set to 1 by default. The server can be started with this default ID when binary logging is enabled, but an informational message is issued if you do not specify a server ID explicitly using the --server-id option. For servers that are used in a replication topology, you must specify a unique nonzero server ID for each server.  
在MySQL 5.7中，在启用二进制日志记录时必须给服务器指定ID，否则服务器将无法启动。在MySQL 8.0中，server_id 系统变量默认设置为1。启用二进制日志记录时，可以使用此缺省ID启动服务器，但如果未使用该--server-id 选项明确指定服务器标识，则会发出信息性消息。对于复制拓扑中使用的服务器，必须为每个服务器指定唯一的非零服务器ID。  

A client that has privileges sufficient to set restricted session system variables (see Section 5.1.9.1, “System Variable Privileges”) can disable binary logging of its own statements by using a SET sql_log_bin=OFF statement.  
具有足以设置受限会话系统变量的权限的客户端（请参见 第5.1.9.1节“系统变量权限”）可以使用SET sql_log_bin=OFF语句禁用其自己的语句的二进制日志记录 。

By default, the server logs the length of the event as well as the event itself and uses this to verify that the event was written correctly. You can also cause the server to write checksums for the events by setting the binlog_checksum system variable. When reading back from the binary log, the master uses the event length by default, but can be made to use checksums if available by enabling the master_verify_checksum system variable. The slave I/O thread also verifies events received from the master. You can cause the slave SQL thread to use checksums if available when reading from the relay log by enabling the slave_sql_verify_checksum system variable.  
默认情况下，服务器记录事件的长度以及事件本身，并使用它来验证事件是否正确写入。您还可以通过设置 binlog_checksum 系统变量使服务器为事件编写校验和 。从二进制日志中读回时，主服务器默认使用事件长度，但如果可用，则可以通过启用 master_verify_checksum 系统变量来使用校验和 。从 I/O 线程还验证从主站接收的事件。通过启用 slave_sql_verify_checksum 系统变量从中继日志读取时，可以使从属SQL线程使用校验和（如果可用） 。  

The format of the events recorded in the binary log is dependent on the binary logging format. Three format types are supported: row-based logging, statement-based logging and mixed-base logging. The binary logging format used depends on the MySQL version. For general descriptions of the logging formats, see Section 5.4.4.1, “Binary Logging Formats”. For detailed information about the format of the binary log, see MySQL Internals: The Binary Log.  
二进制日志中记录的事件格式取决于二进制日志记录格式。支持三种格式类型：基于行的日志记录，基于语句的日志记录和基于混合的日志记录。使用的二进制日志记录格式取决于MySQL版本。有关日志记录格式的一般说明，请参见 第5.4.4.1节“二进制日志格式”。有关二进制日志格式的详细信息，请参阅 MySQL内部：二进制日志。

The server evaluates the --binlog-do-db and --binlog-ignore-db options in the same way as it does the --replicate-do-db and --replicate-ignore-db options. For information about how this is done, see Section 17.2.5.1, “Evaluation of Database-Level Replication and Binary Logging Options”.  
服务器以 --binlog-do-db 与执行和 --binlog-ignore-db 选项相同的方式 评估 --replicate-do-db 和 --replicate-ignore-db 选项。有关如何完成此操作的信息，请参见 第17.2.5.1节“数据库级复制和二进制日志记录选项的评估”。  

A replication slave server is started with the --log-slave-updates setting enabled by default, meaning that the slave writes to its own binary log any data modifications that are received from the replication master. The binary log must be enabled for this setting to work (see Section 17.1.6.3, “Replication Slave Options and Variables”). This setting enables the slave to act as a master to other slaves in chained replication.
--log-slave-updates 默认情况下启用设置启动 复制从属服务器，这意味着从属服务器 会将从复制主服务器接收的任何数据修改写入其自己的二进制日志。必须启用二进制日志才能使此设置生效（请参见第17.1.6.3节“复制从属选项和变量”）。此设置使从站可以充当链式复制中其他从站的主站。  

You can delete all binary log files with the RESET MASTER statement, or a subset of them with PURGE BINARY LOGS. See Section 13.7.7.6, “RESET Syntax”, and Section 13.4.1.1, “PURGE BINARY LOGS Syntax”.  
您可以使用该RESET MASTER语句或其子集删除所有二进制日志文件 PURGE BINARY LOGS。请参见 第13.7.7.6节“RESET语法”和第13.4.1.1节“PURGE BINARY LOGS语法”。

If you are using replication, you should not delete old binary log files on the master until you are sure that no slave still needs to use them. For example, if your slaves never run more than three days behind, once a day you can execute mysqladmin flush-logs on the master and then remove any logs that are more than three days old. You can remove the files manually, but it is preferable to use PURGE BINARY LOGS, which also safely updates the binary log index file for you (and which can take a date argument). See Section 13.4.1.1, “PURGE BINARY LOGS Syntax”.  

如果您正在使用复制，则在确定没有从属设备仍需要使用它们之前，不应删除主服务器上的旧二进制日志文件。例如，如果您的奴隶从未跑过三天以上，那么您每天可以在主服务器上执行mysqladmin flush-logs，然后删除任何超过三天的日志。您可以手动删除文件，但最好使用PURGE BINARY LOGS，它也可以安全地为您更新二进制日志索引文件（可以使用日期参数）。请参见 第13.4.1.1节“PURGE BINARY LOGS语法”。  

You can display the contents of binary log files with the mysqlbinlog utility. This can be useful when you want to reprocess statements in the log for a recovery operation. For example, you can update a MySQL server from the binary log as follows:  
您可以使用mysqlbinlog实用程序显示二进制日志文件的内容 。当您想要在日志中重新处理语句以进行恢复操作时，这非常有用。例如，您可以从二进制日志更新MySQL服务器，如下所示：

```
shell> mysqlbinlog log_file | mysql -h server_name
```

mysqlbinlog also can be used to display replication slave relay log file contents because they are written using the same format as binary log files. For more information on the mysqlbinlog utility and how to use it, see Section 4.6.8, “mysqlbinlog — Utility for Processing Binary Log Files”. For more information about the binary log and recovery operations, see Section 7.5, “Point-in-Time (Incremental) Recovery Using the Binary Log”.  
mysqlbinlog 也可用于显示复制从属中继日志文件内容，因为它们使用与二进制日志文件相同的格式编写。有关 mysqlbinlog实用程序及其使用方法的更多信息，请参见 第4.6.8节“ mysqlbinlog  - 处理二进制日志文件的实用程序”。有关二进制日志和恢复操作的更多信息，请参见 第7.5节“使用二进制日志进行时间点（增量）恢复”。  

Binary logging is done immediately after a statement or transaction completes but before any locks are released or any commit is done. This ensures that the log is logged in commit order.  
Binary 日志在一个语句或者事务完成后，但是在释放任何锁或者任何提交之前，立即执行日志记录。这可以确保日志提交的顺序。  

Updates to nontransactional tables are stored in the binary log immediately after execution.  
非事务性表的更新在执行后立即存储在二进制日志中。  

Within an uncommitted transaction, all updates (UPDATE, DELETE, or INSERT) that change transactional tables such as InnoDB tables are cached until a COMMIT statement is received by the server. At that point, mysqld writes the entire transaction to the binary log before the COMMIT is executed.  
在未提交的事务中，所有更改事务表（如表）的更新（UPDATE， DELETE或 INSERT）都将InnoDB被缓存，直到COMMIT服务器收到语句为止 。此时，mysqld在COMMIT执行之前将整个事务写入二进制日志 。  

Modifications to nontransactional tables cannot be rolled back. If a transaction that is rolled back includes modifications to nontransactional tables, the entire transaction is logged with a ROLLBACK statement at the end to ensure that the modifications to those tables are replicated.  
无法回滚对非事务表的修改。如果回滚的事务包括对非事务表的修改，则会ROLLBACK 在末尾使用语句记录整个事务 ，以确保复制对这些表的修改。

When a thread that handles the transaction starts, it allocates a buffer of binlog_cache_size to buffer statements. If a statement is bigger than this, the thread opens a temporary file to store the transaction. The temporary file is deleted when the thread ends. From MySQL 8.0.17, if binary log encryption is active on the server, the temporary file is encrypted.  
当一个处理事务的线程启动时，它会 binlog_cache_size 为 buffer 语句分配一个缓冲区。如果语句大于此值，则线程会打开一个临时文件来存储事务。线程结束时删除临时文件。从MySQL 8.0.17开始，如果服务器上的二进制日志加密处于活动状态，则临时文件将被加密。  

The Binlog_cache_use status variable shows the number of transactions that used this buffer (and possibly a temporary file) for storing statements. The Binlog_cache_disk_use status variable shows how many of those transactions actually had to use a temporary file. These two variables can be used for tuning binlog_cache_size to a large enough value that avoids the use of temporary files.  
所述 Binlog_cache_use 状态变量表明，用这种缓冲（和可能的一个临时文件），用于存储语句事务的数目。该 Binlog_cache_disk_use状态变量显示许多这些交易实际上是如何不得不使用临时文件。这两个变量可用于调整 binlog_cache_size到足够大的值，避免使用临时文件。  

The max_binlog_cache_size system variable (default 4GB, which is also the maximum) can be used to restrict the total size used to cache a multiple-statement transaction. If a transaction is larger than this many bytes, it fails and rolls back. The minimum value is 4096.  
所述max_binlog_cache_size系统变量（默认4GB，这也是最大）可被用来限制用于高速缓存的多语句事务的总大小。如果事务大于这么多字节，它就会失败并回滚。最小值为4096。  

If you are using the binary log and row based logging, concurrent inserts are converted to normal inserts for CREATE ... SELECT or INSERT ... SELECT statements. This is done to ensure that you can re-create an exact copy of your tables by applying the log during a backup operation. If you are using statement-based logging, the original statement is written to the log.  
如果使用二进制日志和基于行的日志记录，则并发插入将转换为CREATE ... SELECT或 INSERT ... SELECT语句的正常插入。这样做是为了确保您可以通过在备份操作期间应用日志来重新创建表的精确副本。如果使用基于语句的日志记录，则会将原始语句写入日志。  

The binary log format has some known limitations that can affect recovery from backups. See Section 17.4.1, “Replication Features and Issues”.  
二进制日志格式具有一些已知的限制，可能会影响从备份中恢复。请参见第17.4.1节“复制功能和问题”。  

Binary logging for stored programs is done as described in Section 24.7, “Stored Program Binary Logging”.  
存储程序的二进制日志记录按 第24.7节“存储程序二进制日志记录”中所述完成。  

Note that the binary log format differs in MySQL 8.0 from previous versions of MySQL, due to enhancements in replication. See Section 17.4.2, “Replication Compatibility Between MySQL Versions”.  
请注意，由于复制的增强，MySQL 8.0与以前版本的MySQL的二进制日志格式不同。请参见第17.4.2节“MySQL版本之间的复制兼容性”。

If the server is unable to write to the binary log, flush binary log files, or synchronize the binary log to disk, the binary log on the replication master can become inconsistent and replication slaves can lose synchronization with the master. The binlog_error_action system variable controls the action taken if an error of this type is encountered with the binary log.  
如果服务器无法写入二进制日志，刷新二进制日志文件或将二进制日志同步到磁盘，则复制主服务器上的二进制日志可能会变得不一致，并且复制从服务器可能会失去与主服务器的同步。所述 binlog_error_action系统变量控制，如果这种类型的误差与二进制日志遇到所采取的行动。

* The default setting, ABORT_SERVER, makes the server halt binary logging and shut down. At this point, you can identify and correct the cause of the error. On restart, recovery proceeds as in the case of an unexpected server halt (see Section 17.3.2, “Handling an Unexpected Halt of a Replication Slave”).  
默认设置，ABORT_SERVER 使服务器暂停二进制日志记录并关闭。此时，您可以识别并更正错误原因。重新启动时，恢复将按照意外服务器暂停的情况继续进行（请参见 第17.3.2节“处理意外停止复制从站”）。  

* The setting IGNORE_ERROR provides backward compatibility with older versions of MySQL. With this setting, the server continues the ongoing transaction and logs the error, then halts binary logging, but continues to perform updates. At this point, you can identify and correct the cause of the error. To resume binary logging, log_bin must be enabled again, which requires a server restart. Only use this option if you require backward compatibility, and the binary log is non-essential on this MySQL server instance. For example, you might use the binary log only for intermittent auditing or debugging of the server, and not use it for replication from the server or rely on it for point-in-time restore operations.  
该设置IGNORE_ERROR提供与旧版MySQL的向后兼容性。使用此设置，服务器继续正在进行的事务并记录错误，然后暂停二进制日志记录，但继续执行更新。此时，您可以识别并更正错误原因。要恢复二进制日志记录 log_bin必须再次启用，这需要重新启动服务器。如果您需要向后兼容性，则仅使用此选项，并且二进制日志在此MySQL服务器实例上不是必需的。例如，您可以仅将二进制日志用于服务器的间歇性审计或调试，而不是将其用于从服务器进行复制或依赖它进行时间点还原操作。

By default, the binary log is synchronized to disk at each write (sync_binlog=1). If sync_binlog was not enabled, and the operating system or machine (not only the MySQL server) crashed, there is a chance that the last statements of the binary log could be lost. To prevent this, enable the sync_binlog system variable to synchronize the binary log to disk after every N commit groups. See Section 5.1.8, “Server System Variables”. The safest value for sync_binlog is 1 (the default), but this is also the slowest.  
默认情况下，二进制日志在每次 write（sync_binlog=1）时都会同步到磁盘。如果 sync_binlog 未启用，并且操作系统或计算机（不仅是MySQL服务器）崩溃，则二进制日志的最后一个语句可能会丢失。  
要防止这种情况，请 sync_binlog 在每个N提交组之后启用 系统变量以将二进制日志同步到磁盘 。请参见 第5.1.8节“服务器系统变量”。最安全的值 sync_binlog是1（默认值），但这也是最慢的。

In earlier MySQL releases, there was a chance of inconsistency between the table content and binary log content if a crash occurred, even with sync_binlog set to 1. For example, if you are using InnoDB tables and the MySQL server processes a COMMIT statement, it writes many prepared transactions to the binary log in sequence, synchronizes the binary log, and then commits the transaction into InnoDB. If the server crashed between those two operations, the transaction would be rolled back by InnoDB at restart but still exist in the binary log. Such an issue was resolved in previous releases by enabling InnoDB support for two-phase commit in XA transactions. In 5.8.0 and higher, the InnoDB support for two-phase commit in XA transactions is always enabled.  
在早期的MySQL版本中，如果发生崩溃，表内容和二进制日志内容之间可能存在不一致，即使sync_binlog 设置为1.例如，如果您使用InnoDB 表并且MySQL服务器处理 COMMIT语句，则会编写许多准备按顺序对二进制日志进行事务处理，同步二进制日志，然后将事务提交到 InnoDB。如果服务器在这两个操作之间崩溃，则事务将InnoDB在重新启动时回滚 但仍存在于二进制日志中。通过InnoDB在XA事务中启用对两阶段提交的支持，在先前版本中解决了此类问题 。在5.8.0及更高版本中InnoDB 始终启用对XA事务中的两阶段提交的支持

InnoDB support for two-phase commit in XA transactions ensures that the binary log and InnoDB data files are synchronized. However, the MySQL server should also be configured to synchronize the binary log and the InnoDB logs to disk before committing the transaction. The InnoDB logs are synchronized by default, and sync_binlog=1 ensures the binary log is synchronized. The effect of implicit InnoDB support for two-phase commit in XA transactions and sync_binlog=1 is that at restart after a crash, after doing a rollback of transactions, the MySQL server scans the latest binary log file to collect transaction xid values and calculate the last valid position in the binary log file. The MySQL server then tells InnoDB to complete any prepared transactions that were successfully written to the to the binary log, and truncates the binary log to the last valid position. This ensures that the binary log reflects the exact data of InnoDB tables, and therefore the slave remains in synchrony with the master because it does not receive a statement which has been rolled back.  
InnoDB支持XA事务中的两阶段提交可确保二进制日志和 InnoDB数据文件同步。但是，MySQL服务器还应配置为InnoDB在提交事务之前将二进制日志和日志同步到磁盘。该InnoDB日志由缺省同步，并sync_binlog=1 保证了二进制日志是同步的。InnoDB在XA事务中隐式支持两阶段提交的效果 sync_binlog=1是在崩溃后重启，在执行事务回滚之后，MySQL服务器扫描最新的二进制日志文件以收集事务xid值并计算最后的有效位置。二进制日志文件。然后MySQL服务器告诉InnoDB完成任何已成功写入二进制日志的已准备事务，并将二进制日志截断到最后一个有效位置。这可确保二进制日志反映InnoDB表的确切数据 ，因此从站与主站保持同步，因为它不会收到已回滚的语句。

If the MySQL server discovers at crash recovery that the binary log is shorter than it should have been, it lacks at least one successfully committed InnoDB transaction. This should not happen if sync_binlog=1 and the disk/file system do an actual sync when they are requested to (some do not), so the server prints an error message The binary log file_name is shorter than its expected size. In this case, this binary log is not correct and replication should be restarted from a fresh snapshot of the master's data.  
如果MySQL服务器在崩溃恢复时发现二进制日志比它应该更短，那么它至少缺少一个成功提交的InnoDB事务。如果sync_binlog=1磁盘/文件系统在请求（有些没有）时执行实际同步，则不会发生这种情况，因此服务器会输出错误消息。在这种情况下，此二进制日志不正确，应从主数据的新快照重新启动复制。 The binary log file_name is shorter than its expected size

The session values of the following system variables are written to the binary log and honored by the replication slave when parsing the binary log:  
在解析二进制日志时，以下系统变量的会话值将写入二进制日志并由复制从站承担：

sql_mode (except that the NO_DIR_IN_CREATE mode is not replicated; see Section 17.4.1.38, “Replication and Variables”)

foreign_key_checks

unique_checks

character_set_client

collation_connection

collation_database

collation_server

sql_auto_is_null

