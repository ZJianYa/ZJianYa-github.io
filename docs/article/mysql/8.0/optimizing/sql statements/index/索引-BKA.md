# 概述

https://dev.mysql.com/doc/refman/8.0/en/bnl-bka-optimization.html 

In MySQL, a Batched Key Access (BKA) Join algorithm is available that uses both index access to the joined table and a join buffer. The BKA algorithm supports inner join, outer join, and semi-join operations, including nested outer joins. Benefits of BKA include improved join performance due to more efficient table scanning. Also, the Block Nested-Loop (BNL) Join algorithm previously used only for inner joins is extended and can be employed for outer join and semi-join operations, including nested outer joins.

在 MySQL 中，Batched Key Access (BKA) Join 算法可以用在：使用索引访问 joined table 和 使用 join 缓冲区 的情况。  
BKA 算法支持 inner join, outer join, 和 `semi-join` operation, 包括 nested outer joins。  
BKA的优点包括提高连接性能，因为更高效的表扫描。  
此外，先前仅用于内连接的块嵌套循环（BNL）连接算法已扩展，可用于外连接和半连接操作，包括嵌套外连接。  

The following sections discuss the join buffer management that underlies the extension of the original BNL algorithm, the extended BNL algorithm, and the BKA algorithm. For information about semi-join strategies, see Section 8.2.2.1, “Optimizing Subqueries, Derived Tables, View References, and Common Table Expressions with Semi-Join Transformations”

以下部分讨论了连接缓冲区管理，它是原始BNL算法扩展，扩展BNL算法和BKA算法的基础。有关半连接策略的信息，请参见[第8.2.2.1节“使用半连接转换优化子查询，派生表，视图引用和公用表表达式”](https://dev.mysql.com/doc/refman/8.0/en/semi-joins.html)

* Join Buffer Management for Block Nested-Loop and Batched Key Access Algorithms  
  为 BNL 和 BKA 算法提供 Join Buffer 管理
* Block Nested-Loop Algorithm for Outer Joins and Semi-Joins
  `Outer Joins and Semi-Joins` 的 BNL 算法
* Batched Key Access Joins  
  BKA 算法的 Join
* Optimizer Hints for Block Nested-Loop and Batched Key Access Algorithms  
  BNL 和 BKA 算法的优化器提示


