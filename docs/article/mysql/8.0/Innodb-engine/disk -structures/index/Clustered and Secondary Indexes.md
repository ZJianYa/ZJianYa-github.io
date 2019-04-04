
# 15.8.2.1 Clustered and Secondary Indexes

MySQL 8.0 Reference Manual  /  The InnoDB Storage Engine  /  InnoDB On-Disk Structures  /  Indexes  /  Clustered and Secondary Indexes

Every InnoDB table has a special index called the clustered index where the data for the rows is stored. Typically, the clustered index is synonymous with the primary key. To get the best performance from queries, inserts, and other database operations, you must understand how InnoDB uses the clustered index to optimize the most common lookup and DML operations for each table.

每个InnoDB表都有一个称为聚簇索引的特殊索引， 其中存储了行的数据。通常，聚簇索引与主键同义。要从查询，插入和其他数据库操作中获得最佳性能，您必须了解InnoDB如何使用聚簇索引来优化每个表的最常见查找和DML操作。

- When you define a PRIMARY KEY on your table, InnoDB uses it as the clustered index. Define a primary key for each table that you create. If there is no logical unique and non-null column or set of columns, add a new auto-increment column, whose values are filled in automatically.  

在表上定义`PRIMARY KEY`时，InnoDB将其用作聚簇索引。  
为您创建的每个表定义主键。如果没有逻辑唯一且非空的列或一组列，请添加一个新的自动增量列，其值将自动填充。  

- If you do not define a PRIMARY KEY for your table, MySQL locates the first UNIQUE index where all the key columns are NOT NULL and InnoDB uses it as the clustered index.

如果你不定义主键，MySQL会找到第一个唯一索引，作为聚簇索引。

- If the table has no PRIMARY KEY or suitable UNIQUE index, InnoDB internally generates a hidden clustered index named GEN_CLUST_INDEX on a synthetic column containing row ID values. The rows are ordered by the ID that InnoDB assigns to the rows in such a table. The row ID is a 6-byte field that increases monotonically as new rows are inserted. Thus, the rows ordered by the row ID are physically in insertion order.

如果两个都没有，InnoDB 会在内部生产一个隐藏的名为 `GEN_CLUST_INDEX` 的聚合索引，在一个包含rowID值的合成列上。字段会按照 `InnoDB` 分配的ID排序。ID是一个6字节的字段，随着新行的插入而单调增加。 因此，数据行按照ID的顺序物理上处于插入顺序。  
