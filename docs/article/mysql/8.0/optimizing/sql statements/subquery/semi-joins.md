# 概述

https://dev.mysql.com/doc/refman/8.0/en/semi-joins.html  

MySQL 8.0 Reference Manual  /  Optimization  /  Optimizing SQL Statements  /  Optimizing Subqueries, Derived Tables, View References, and Common Table Expressions  /  Optimizing Subqueries, Derived Tables, View References, and Common Table Expressions with Semi-Join Transformations

## 8.2.2 Optimizing Subqueries, Derived Tables, View References, and Common Table Expressions with Semi-Join Transformations

使用 Semi-Join 优化子查询，驱动表，视图引用，ctl

The MySQL query optimizer has different strategies available to evaluate subqueries:

优化器有不同的策略来评估子查询

......

### 8.2.2.1 Optimizing IN and EXISTS Subquery predicates with Semi-Join Transformations

A semi-join is a preparation-time transformation that enables multiple execution strategies such as table pullout, duplicate weedout, first match, loose scan, and materializtion. The optimizer uses semi-join strategies to improve subquery execution, as described in this section.

semi-join 是一个 `preparation-time transformation`，可以使用多种执行策略： `table pullout, duplicate weedout, first match, loose scan, and materializtion`。优化器可以使用`semi-join`策略提高子查询的执行。

For an inner join between two tables, the join returns a row from one table as many times as there are matches in the other table. But for some questions, the only information that matters is whether there is a match, not the number of matches. Suppose that there are tables named class and roster that list classes in a course curriculum and class rosters (students enrolled in each class), respectively. To list the classes that actually have students enrolled, you could use this join:

对于一个两个表的内连接，会采用嵌套循环的方式去扫盘。但是对于一些问题，关注的是有没有匹配的数据，而不是有多少匹配的数据。假设有一个 class 表保存了班级编号和班级课程 和 roster 表保存了班级的花名册。现在要列出实际有学生注册的课程，您可以使用此连接：

```{}
SELECT class.class_num, class.class_name
FROM class INNER JOIN roster
WHERE class.class_num = roster.class_num;
```

However, the result lists each class once for each enrolled student. For the question being asked, this is unnecessary duplication of information.
但是这个结果会有重复数据。  

Assuming that class_num is a primary key in the class table, duplicate suppression is possible by using SELECT DISTINCT, but it is inefficient to generate all matching rows first only to eliminate duplicates later.
我们假设 class_num 是 class 表的主键，可以使用 SELECT DISTINCT ，但是效率很低。

The same duplicate-free result can be obtained by using a subquery:
那么我们可以使用子查询来优化：

```{}
SELECT class_num, class_name
FROM class
WHERE class_num IN (SELECT class_num FROM roster);
```

Here, the optimizer can recognize that the IN clause requires the subquery to return only one instance of each class number from the roster table. In this case, the query can use a semi-join; that is, an operation that returns only one instance of each row in class that is matched by rows in roster.  
这时候，优化器可以识别 IN 语句中的子查询每个 class number 只需要返回一个实例。这时候查询可以使用`semi-join`;class 表中和roster表中匹配的每一行都只会返回一个实例。  

In MySQL 8.0.16 and later, this strategy can also be employed with EXISTS subqueries by transforming an EXISTS subquery that appears at the top level of a WHERE or ON clause of an IN or EXISTS predicate that refers to a subquery:  

这个优化策略也可以应用于 exists 子查询......

After this, the subquery operation can be handled as a semi-join.  
之后，子查询可以处理为 'semi-join'

Outer join and inner join syntax is permitted in the outer query specification, and table references may be base tables, derived tables, view references, or common table expressions.  
`the outer query specification`是允许外关联和内关联语法的，引用表可以是基表，派生表，视图引用或公用表表达式。

In MySQL, a subquery must satisfy these criteria to be handled as a semi-join:  
在MySQL中，子查询必须满足这些条件才能作为`semi-join`处理：

- 必须是在顶级的 where 或者 on 子句中的 in 或 any 子查询，可能作为 and 表达式的一项。
- 查询不能有 union
- 不能包含 group by 或者 having
- 它不能隐式分组（不能包含聚合函数）
- 不能有 order by ,limit
- 不能使用 STRAIGHT_JOIN
- 内外表数量必须小于可以join的数量。

The subquery may be correlated or uncorrelated. In MySQL 8.0.16 and later, decorrelation looks at equality predicates in the WHERE clause of a subquery used as the argument to EXISTS, and makes it possible to optimize it as if it was used within IN (SELECT b FROM ...). The term trivially correlated means that the predicate is an equality predicate, that it is the sole predicate in the WHERE clause (or is combined with AND), and that one operand is from a table referenced in the subquery and the other operand is from the outer query block.

DISTINCT is permitted, as is LIMIT unless ORDER BY is also used.

If a subquery meets the preceding criteria, MySQL converts it to a semi-join and makes a cost-based choice from these strategies:

