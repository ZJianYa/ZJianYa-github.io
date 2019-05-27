# 概述

https://dev.mysql.com/doc/refman/8.0/en/semi-joins.html  

MySQL 8.0 Reference Manual  /  Optimization  /  Optimizing SQL Statements  /  Optimizing Subqueries, Derived Tables, View References, and Common Table Expressions  /  Optimizing Subqueries, Derived Tables, View References, and Common Table Expressions with Semi-Join Transformations

8.2.2.1 Optimizing Subqueries, Derived Tables, View References, and Common Table Expressions with Semi-Join Transformations

semi-join 是一个 `preparation-time transformation`，可以使用多种执行策略： `table pullout, duplicate weedout, first match, loose scan, and materializtion`。优化器可以使用`semi-join`策略提高子查询的执行。

对于一个两个表的内连接，会采用嵌套循环的方式去扫盘。

假设有一个 class 表保存了班级编号和班级课程 和 roster 表保存了班级的花名册。现在要列出实际注册学生的课程，您可以使用此连接：

```{}
SELECT class.class_num, class.class_name
FROM class INNER JOIN roster
WHERE class.class_num = roster.class_num;
```

但是这个结果会有重复数据。  

我们假设 class_num 是 class 表的主键，可以使用 SELECT DISTINCT ，但是效率很低。那么我们可以使用子查询来优化：

```{}
SELECT class_num, class_name
FROM class
WHERE class_num IN (SELECT class_num FROM roster);
```

这时候，优化器可以识别 IN 语句中的子查询每个 class number 只需要返回一个实例。这时候查询可以使用`semi-join`;class 表中和roster表中匹配的每一行都只会返回一个实例。  

`the outer query specification`是允许外关联和内关联语法的，表引用可以是基表，派生表，视图引用或公用表表达式。

在MySQL中，子查询必须满足这些条件才能作为`semi-join`接处理：

- 必须是在顶级的 where 或者 on 子句中的 in 或 any 子查询，可能作为 and 表达式的一项。
- 查询不能有 union
- 不能包含 group by 或者 having
- 它不能隐式分组（不能包含聚合函数）
- 不能有 order by ,limit
- 不能使用 STRAIGHT_JOIN
- 内外表数量必须小于可以join的数量。

...