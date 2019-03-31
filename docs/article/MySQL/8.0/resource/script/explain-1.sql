/*
初始化环境
*/

drop table if exists  t1,t2,t3,t4;

CREATE TABLE `t1` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `col1` char(20) DEFAULT NULL,
  `col2` char(20) DEFAULT NULL,
  `col3` char(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `general_key` (`col1`)
) ENGINE=InnoDB AUTO_INCREMENT=677 DEFAULT CHARSET=utf8;

CREATE TABLE `t2` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `col1` char(20) DEFAULT NULL,
  `col2` char(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_key` (`col2`)
) ENGINE=InnoDB AUTO_INCREMENT=677 DEFAULT CHARSET=utf8;

create table t3(
id int primary key auto_increment,
other_column varchar(50)
);

CREATE TABLE t4 (s1 INT, s2 CHAR(5), s3 FLOAT);

/*
  准备测试数据
*/

set global innodb_flush_log_at_trx_commit = 0;
drop procedure idata;

delimiter ;;
create procedure idata()
begin

  declare i,ch,j int;
  set i=0,ch=97 ;
  while(i<26)do
    set j = 0;
      while(j<26)do
		  insert into t1 (col1,col2,col3) values (CONCAT(char(ch+i),char(ch+j)),CONCAT(char(ch+i+1),char(ch+j)),CONCAT(char(ch+i+2),char(ch+j)));
		  insert into t2 (col1,col2) values (CONCAT(char(ch+i),char(ch+j)),CONCAT(char(ch+i+1),char(ch+j)));
          insert into t3 (other_column) values (CONCAT(char(ch+i),char(ch+j),char(ch+i+1),char(ch+j)));
          set j=j+1;
      end while;
    set i=i+1;
  end while;

end;;
delimiter ;

call idata();
-- 还原事务设置
set global innodb_flush_log_at_trx_commit = 1;

insert into t3 (other_column) values ('');
INSERT INTO t4 VALUES (1,'1',1.0);
INSERT INTO t4 VALUES (2,'2',2.0);


