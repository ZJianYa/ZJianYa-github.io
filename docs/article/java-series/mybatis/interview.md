# 概述

- 基本语法  
  增删改查  
  resultType  
  parameterType  
- SQL 注入  
  http://www.cnblogs.com/heartlifes/p/6971015.html  druid 配置
- 事务  
- 缓存  
- mapper关联，我有两个这个xml 文件 都跟这个 dao 建立关系了，那不是就是冲突了？  
  通过动态代理来创建 mapper 的代理对象，执行每一个方法实际上都是由 InvocationHandler 来实现的  
  mapper应该不会因为重复在xml中配置而报错，因为 MapperRegistry 中用 HashMap 存储的 mapper 接口。    
- 执行流程