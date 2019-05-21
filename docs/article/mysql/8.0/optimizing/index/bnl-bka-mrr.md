# 概述

```{}
drop table if exists  t1,t2;
create table t1(id int primary key, a int, b int, index(a));
create table t2 like t1;
drop procedure if exists idata;
delimiter ;;
create procedure idata()
begin
  declare i int;
  set i=1;
  while(i<=1000)do
    insert into t1 values(i, 1001-i, i);
    set i=i+1;
  end while;
  
  set i=1;
  while(i<=10000)do
    insert into t2 values(i, i, i);
    set i=i+1;
  end while;

end;;
delimiter ;
call idata();
```

## MRR

如果执行：

select * from t1 where a>=1 and a<=100;

如我们之前所讲，会发生回表，且回表的过程是随机读取的。

**因为大多数的数据都是按照主键递增顺序插入得到的，所以我们可以认为，如果按照主键的递增顺序查询的话，对磁盘的读比较接近顺序读，能够提升读性能。**  

这就是 MRR 的优化思路：

- 根据索引 a，定位到满足条件的记录，将 id 值放入 read_rnd_buffer 中 ;
- 将 read_rnd_buffer 中的 id 进行递增排序；
- 排序后的 id 数组，依次到主键 id 索引中查记录，并作为结果返回。

这里的 `read_rnd_buffer` 大小是由 `read_rnd_buffer_size` 控制。

需要说明的是，如果你想要稳定地使用 MRR 优化的话，需要设置`set optimizer_switch=mrr_cost_based=off`。  
官方文档的说法，现在的优化器策略，判断消耗的时候，会更倾向于不使用 MRR，把 mrr_cost_based 设置为 off，就是固定使用 MRR 了。  

```{}
id, select_type, table, partitions, type, possible_keys, key, key_len, ref, rows, filtered, Extra
'1', 'SIMPLE', 't1', NULL, 'range', 'a', 'a', '5', NULL, '100', '100.00', 'Using index condition; Using MRR'
```

## BKA

https://dev.mysql.com/doc/refman/8.0/en/bnl-bka-optimization.html

Batched Key Access (BKA) 关联逻辑在都是用索引访问关联表和`join buffer`时可用。  
支持内连接、外链接、`semi-join`，嵌套外链接。  
BKA的优点：可以更高效的表扫描，从而提高join执行效率。  
BNL也不再局限于内连接时可用，也可用于外连接和半连接操作，嵌套外连接。  

### Join Buffer 管理

MySQL 可以使用连接缓冲区执行`inner joins without index access to the inner table`，也可以执行`outer joins and semi-joins that appear after subquery flattening`。此外，当存在对内部表的索引访问时，可以有效（更高效）地使用连接缓冲区。  

### BNL

### Batched Key Access Joins

MySQL实现了一个称之为`Batched Key Access (BKA)`的join表的方法，当使用索引访问被join的表时，能用BKA。  
像`BNL join`算法，`BKA join`算法使用一个 `join buffer` 连接缓冲区来累积由第一个操作产生的所有行。  
然后`BKA`在缓冲区构建这些索引，然后批量提交给数据库做索引查询。  
这些 `keys` 通过 MRR 接口提交给搜索引擎。  
提交了这些 key 之后，MRR 引擎函数以最佳方式在索引中执行查找，根据找到的索引从被关联表中`fetching the rows`，开始把要匹配的行反馈给 BKA join 算法。每个匹配行与 `join buffer` 中的`a reference to a row`对接起来。

...

如果要使用BKA，`optimizer_switch`的`batched_key_access`必须设置为 on。 BKA 使用 MRR，所以 mrr 必须设置为 on。  
目前，MRR的成本估算过于悲观。因此，也有必要对 mrr_cost_based 设置为 off，如果要使用BKA。以下设置启用BKA：

```{}
mysql> SET optimizer_switch='mrr=on,mrr_cost_based=off,batched_key_access=on';
```

MRR功能有两种执行方式：

...