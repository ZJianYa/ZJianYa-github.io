# 概述

- 基本语法  
  增删改查  
  resultType  
  parameterType  
- SQL 注入  
  http://www.cnblogs.com/heartlifes/p/6971015.html  druid 配置  
  http://xdxd.love/2016/03/14/%E5%AE%A1%E8%AE%A1mybatis%E7%9A%84sql%E6%B3%A8%E5%85%A5/   审计mybatis的sql注入  
  https://c0d3p1ut0s.github.io/MyBatis%E6%A1%86%E6%9E%B6%E4%B8%AD%E5%B8%B8%E8%A7%81%E7%9A%84SQL%E6%B3%A8%E5%85%A5/  MyBatis框架中常见的SQL注入  
- 事务  
- 缓存  
- mapper关联，我有两个这个xml 文件 都跟这个 dao 建立关系了，那不是就是冲突了？  
  通过动态代理来创建 mapper 的代理对象，执行每一个方法实际上都是由 InvocationHandler 来实现的  
  mapper应该不会因为重复在xml中配置而报错，因为 MapperRegistry 中用 HashMap 存储的 mapper 接口。    
- 执行流程