# FAQ

- org.mybatis.spring.transaction.SpringManagedTransaction.getTimeout()Ljava/lang/Integer;  
  mybatis的jar包和mybatis-spring的jar包版本不对应，需要重新换成可以对应一起使用的jar包即可。
  匹配的版本（mybatis、mybatis-spring）:  
  3.3.1和1.1.1  
  3.4.1和1.3.1  
  3.4.2和1.3.0  

- 为什么不用注解  
  注解不支持联合映射  
  联合映射在注解 API中是不支持的。这是因为 Java 注解的限制,不允许循环引用。  
  大量的相似的代码，比如翻页。可不可以把翻页写成注解？或者可配置  
  从注解，到无注解。最好的代码是无注解。  

- 简化ORM映射  
  https://blog.csdn.net/L_BestCoder/article/details/72123589 mybatis可以省略resultMap的情况  
  typeAliases 可以做别名  
  resultMap的继承，paramType直接写类全名即可  
  https://www.cnblogs.com/flying607/p/8473075.html springboot configuration不好用  

- https://blog.csdn.net/fangwenzheng88/article/details/78469976 mybatis underscoreToCamelCase的两种配置  
  https://blog.csdn.net/pingguowang/article/details/44491777 Mybatis list常见  
  like  
  分页  

- http://www.mybatis.org/spring/zh/mappers.html mybatis-spring 中文没有 mybatis-spring-boot-autoconfigure

## 命名问题

1. 关联查询，字段名是个麻烦问题  
  关联查询如果父子都有ID属性，不好映射，也不好复用。  
  但是父表的ID和字表的外键如果重名，还是无法映射。不过除了ID，其他字段比如name倒是不大会出现冲突。  
  凡是关联查询，用generator也无法生成SQL。  
  当查询可能有多种情况的时候，比如字段不一致，或者...简单的用list是行的，就像update、insert一样，不过还是要以这些谓词作为前缀。  

## 使用中的FAQ

- 所有的UPDATE都不能直接byPrimaryKey  
- http://www.mybatis.org/mybatis-3/ Selective 做什么用  
- https://blog.csdn.net/u010398771/article/details/70768280 $和#的问题  
- 批量插入，返回主键  
  https://www.cnblogs.com/xiao-lei/p/6809884.html
- 经常为中间表生成单独类  
- 一对多查询分页
  先在"一"的一面做分页，然后关联"多"的一面做外关联查询
