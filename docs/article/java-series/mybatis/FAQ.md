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

- 所有的 UPDATE 都不能直接 byPrimaryKey  
- http://www.mybatis.org/mybatis-3/ Selective 做什么用  
- https://blog.csdn.net/u010398771/article/details/70768280 $和#的问题  
- 批量插入，返回主键  
  https://www.cnblogs.com/xiao-lei/p/6809884.html
- 经常为中间表生成单独类  
- 一对多查询分页 
  先在"一"的一面做分页，然后关联"多"的一面做外关联查询

## TODO

- HTTP 请求和 MySQL 的连接通常是 M:N ，且通常都是 M>N，这时候就会有问题，一定会出现多个 HTTP 请求共享 MySQL 连接。  
  按照正常理解，如果一个 connection 正在被使用，那么其他线程就不能访问。  
  那么什么情况下才会被使用呢？  
  连接池的链接如果不够用呢？  
  如果服务端的链接不够用呢？  

- 多数据源  
  https://xli1224.github.io/2018/03/11/spring-mybatis-multiple-datasource/  静态配置方法  
  https://blog.csdn.net/tuesdayma/article/details/81081666 静态配置和动态切换的方法  
  https://www.baeldung.com/spring-abstract-routing-data-source  
  https://fizzylogic.nl/2016/01/24/make-your-spring-boot-application-multi-tenant-aware-in-2-steps/  
  https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/jdbc/datasource/lookup/IsolationLevelDataSourceRouter.html  