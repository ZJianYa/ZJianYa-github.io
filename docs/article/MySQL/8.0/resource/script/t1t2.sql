
-- 创建表1
create table t1(id int primary key, a int, b int, index(a));

-- 创建表2
create table t2 like t1;

/*
 * 往表1、表2中插入数据
 */
-- 修改事务设置，加快插入语句的执行
set global innodb_flush_log_at_trx_commit = 0;
drop procedure idata;
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
  while(i<=1000000)do
    insert into t2 values(i, i, i);
    set i=i+1;
  end while;

end;;
delimiter ;
call idata();
-- 还原事务设置
set global innodb_flush_log_at_trx_commit = 1;


