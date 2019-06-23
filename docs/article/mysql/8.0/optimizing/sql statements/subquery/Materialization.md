# 8.2.2.2 Optimizing Subqueries with Materialization

The optimizer uses materialization to enable more efficient subquery processing. Materialization speeds up query execution by generating a subquery result as a temporary table, normally in memory. The first time MySQL needs the subquery result, it materializes that result into a temporary table. Any subsequent time the result is needed, MySQL refers again to the temporary table. The optimizer may index the table with a hash index to make lookups fast and inexpensive. The index contains unique values to eliminate duplicates and make the table smaller.

优化器使用 materialization 实现更改高效的子查询处理。 Materialization 通过在内存中生成一个临时表保存子查询结果来加速查询。 MySQL第一次需要子查询时，他会将结果实现为临时表。在随后需要是，MySQL 会再次引用临时表。 优化器可以使用 hash 索引查询临时表，速度更快，成本更低。 索引消除了重复数据项，临时表也更小。  

Subquery materialization uses an in-memory temporary table when possible, falling back to on-disk storage if the table becomes too large. See Section 8.4.4, [“Internal Temporary Table Use in MySQL”](https://dev.mysql.com/doc/refman/8.0/en/internal-temporary-tables.html).  
子查询 materialization 尽可能的会使用内存临时表，如果需要生成的临时表太大，就会存入磁盘。详情查看第8.4.4节“MySQL中的内部临时表使用”。

If materialization is not used, the optimizer sometimes rewrites a noncorrelated subquery as a correlated subquery. For example, the following IN subquery is noncorrelated (where_condition involves only columns from t2 and not t1):  
如果没有使用 materialization ，优化器有时会把非相关子查询重写为相关子查询。例如下面的子查询是不相关的子查询：

```
SELECT * FROM t1
WHERE t1.a IN (SELECT t2.b FROM t2 WHERE where_condition);
```

The optimizer might rewrite this as an EXISTS correlated subquery:  
优化器可能会将其重写为 EXISTS相关子查询：  

```{}
SELECT * FROM t1
WHERE EXISTS (SELECT t2.b FROM t2 WHERE where_condition AND t1.a=t2.b);
```

Subquery materialization using a temporary table avoids such rewrites and makes it possible to execute the subquery only once rather than once per row of the outer query.    
子查询  materialization 使用一个临时表避免这种重写，并可以仅仅执行一次子查询，而不是每执行一次外循环都会执行一次子查询。  

For subquery materialization to be used in MySQL, the optimizer_switch system variable materialization flag must be enabled. (See [Section 8.9.2, “Switchable Optimizations”](https://dev.mysql.com/doc/refman/8.0/en/switchable-optimizations.html).) With the materialization flag enabled, materialization applies to subquery predicates that appear anywhere (in the select list, WHERE, ON, GROUP BY, HAVING, or ORDER BY), for predicates that fall into any of these use cases:  
对于要在MySQL中使用的子查询实现， 必须启用optimizer_switch系统变量materialization标志。（参见第8.9.2节，“切换优化”）。随着 materialization 启用的标志，materialization 适用于子查询谓词出现的任何地方（在选择列表中，WHERE， ON，GROUP BY， HAVING，或ORDER BY），对于属于任何这些用例谓词：  

- The predicate has this form, when no outer expression oe_i or inner expression ie_i is nullable. N is 1 or larger.  
  当没有外部表达式oe_i或内部表达式 ie_i 可为空时，谓词具有此形式 。 N 是1或更大。

```
(oe_1, oe_2, ..., oe_N) [NOT] IN (SELECT ie_1, i_2, ..., ie_N ...)
```

- The predicate has this form, when there is a single outer expression oe and inner expression ie. The expressions can be nullable.  
  为此这种形式，

```
oe [NOT] IN (SELECT ie ...)
```

- The predicate is IN or NOT IN and a result of UNKNOWN (NULL) has the same meaning as a result of FALSE.  
  谓词是 in 或者 not in,unknown 和 false 是一样的含义。  

The following examples illustrate how the requirement for equivalence of UNKNOWN and FALSE predicate evaluation affects whether subquery materialization can be used. Assume that where_condition involves columns only from t2 and not t1 so that the subquery is noncorrelated.  
下面的例子说明了 unknown 和 false 谓词等效性，子查询 materialization 可以被使用。假设 where 条件只涉及 t2 ，不涉及 t1，那么subquery 是不想关。  

This query is subject to materialization:  
子查询

```
SELECT * FROM t1
WHERE t1.a IN (SELECT t2.b FROM t2 WHERE where_condition);
```

Here, it does not matter whether the IN predicate returns UNKNOWN or FALSE. Either way, the row from t1 is not included in the query result.  
在这里，不管 IN 谓词返回 unknown 还是 false。无论哪种方式，从 t1 查询的结果都不包含任何行。  

An example where subquery materialization is not used is the following query, where t2.b is a nullable column:  
下面的例子不使用 materialization，t2.b 是可空的列。  

```
SELECT * FROM t1
WHERE (t1.a,t1.b) NOT IN (SELECT t2.a,t2.b FROM t2
                          WHERE where_condition);
```

The following restrictions apply to the use of subquery materialization:  
以下适用子查询 materialization 的限制：

- The types of the inner and outer expressions must match. For example, the optimizer might be able to use materialization if both expressions are integer or both are decimal, but cannot if one expression is integer and the other is decimal.  
内表达式和外表达式的类型必须匹配。例如，如果两个表达式都是整数或两者都是 decimal ，则优化器可能能够使用实现，但如果一个表达式是整数而另一个表达式是 decimal 则不能。

- The inner expression cannot be a BLOB. inner 表达式不能是一个 BLOB。

Use of EXPLAIN with a query provides some indication of whether the optimizer uses subquery materialization:  
使用 EXPLAIN with 查询可以提供优化器是否使用子查询 materialization 的标识：

- Compared to query execution that does not use materialization, select_type may change from DEPENDENT SUBQUERY to SUBQUERY. This indicates that, for a subquery that would be executed once per outer row, materialization enables the subquery to be executed just once.  
与没使用 materialization 的查询执行相比，（使用了 materialization 的）select_type。 这表明，每次外循环都会执行一次内循环，materialization 实现子查询只执行一次。  

- For extended EXPLAIN output, the text displayed by a following SHOW WARNINGS includes materialize and materialized-subquery.  
  
