# 其他

- ERROR 1449  
  grant all privileges on *.* to root@"%" identified by ".";  
  flush privileges;  
- mysql经典的8小时问题  
  `https://blog.csdn.net/lzwglory/article/details/78752563`  
- MySQL按照汉字的拼音排序  
  `https://www.cnblogs.com/diony/p/5483108.html`  
  但是如果是按照级别排序，那么拼音也无济于事，比如高中低  
- 导数据太慢
  innodb_flush_log_at_trx_commit = 0  
  create database `jiaotong` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
  `https://www.cnblogs.com/littlehb/p/6877148.html` mysql 如何提高批量导入的速度

## 安装

- 缺失 msvcr120d.dll
  `https://answers.microsoft.com/en-us/windows/forum/windows_8-hardware/missing-msvcr120ddll/28b03b3b-1d15-4e47-ba31-8ace6920b9ba?auth=1`  
  Error unserializing GRT data  
- 新建用户，分配权限  
   `http://blog.csdn.net/lawmansoft/article/details/7268473`  
   > GRANT ALL PRIVILEGES ON `csmp-shaoxing`.* TO 'qgs'@'%' IDENTIFIED BY 'Qgs@2018';  
- 编码问题  
  `http://blog.csdn.net/yougoule/article/details/56680952`  数据库编码等配置  
- Access denied for user 'root'@'localhost'  
  `http://blog.csdn.net/keepd/article/details/77151006`  

## 分组、聚合查询错误

- case语句的错误用法  
 case 语句不能用来分组
 select CASE rank_level
      WHEN rank_level = 1 THEN '一级'
      WHEN rank_level = 2 THEN '二级'
      WHEN rank_level = 3 THEN '三级'
      ELSE '未定级'
  END AS name,web.* from website_level web where dept_id in (102);
- group by 出错了?  
  case is_ranked when 0 then '未定级' else then rank_level ... as rank 
- sum函数的错误  
  sum(ifnull(,0)=1)  
  count(ifnull(=,null))  
  select null = 1;  

## SQL优化的常见要点

count(0) or count(id)  
distinct会影响效率吗？

## ID的问题：  

关于Id是否能够保证初始化的时候Id和程序中的Id一致性？究竟用逻辑Id，还是业务Id。  
序列的问题，以及序列承担的职责  

### 字符问题：

`http://blog.csdn.net/followmyinclinations/article/details/50822963` mysql默认不区分大小写

#### 更新or插入

`https://www.cnblogs.com/xing901022/p/6837604.html`  on DUPLICATE key  
`https://www.cnblogs.com/parryyang/p/5586873.html` batch update  
  Error Code: 1175. SET SQL_SAFE_UPDATES = 0;  
`https://www.cnblogs.com/liuchao233/p/6962379.html` 自动转为大写  

### 设计相关

#### 层次查询

见spboot项目

#### 视图的问题

我们存储的数据只存储存在的事件  
不存在事件的情况我们不做记录。但是我们可能需要按照月份、季度、年，展示连续的数据。这样的话，我们需要将不连续的数据，连续起来。
另一种情况是，我们的数据存储的都是时间段，而实际上呢，我们可能需要把时间段拆成点，分别算在不同时间段内；也可能我们需要把连续的时间按照某个周期进行分段。  

#### 逻辑删除和物理删除

#### 复用性的问题

SQL的拓展，留意查询条件和结果。条件，可以是map，可以是bean，可以是string等

#### 扩展性的问题

永恒问题，无限延展  

1. 列表查询  
  对于列表查询，我们希望复杂度越小越好。需要把问题抽象之后，统一处理。
  列表查询条件和总数查询条件应该是完全一致。I相同O不同。处理参数的逻辑应该是一致的。也就是说应该是个T泛型，唯一不同在于Controller。  

2. 多选项存储  
  因为选项是可变的  
  选项是不确定的，所以关联查询最合适  
  题目：省级单位下达任务，可以包含9个市中的部分或者全部。每个市只能查看自己的任务  
  解决方案：任务表，任务单位关联表，单位表3个表解决。  

3. only_full_group_by

4. 1093 You can't specify target table  
   `https://www.cnblogs.com/benxiaohaihh/p/5715938.html`

## 修改端口

`http://blog.csdn.net/lawmansoft/article/details/7268473`  MySQL配置端口访问规则 - 允许外网访问 3306
> GRANT ALL PRIVILEGES ON `csmp-shaoxing`.* TO 'qgs'@'%' IDENTIFIED BY 'Qgs@2018';  