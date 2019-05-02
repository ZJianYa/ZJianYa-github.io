# 概述

任何框架都是为了解放人

## 整体结构

对象清单：

- Environment
- TransactionManager
- DataSource
- SqlSessionFactoryBuilder  
  实例的最佳作用域是方法作用域，以保证所有的 XML 解析资源开放给更重要的事情。
- SqlSessionFactory
  最佳作用域是应用作用域，即单例  
- SqlSession  
  每个线程都应该有它自己的 SqlSession 实例。SqlSession 的实例不是线程安全的，因此是不能被共享的，所以它的最佳的作用域是请求或方法作用域。
- Mapper

### Environment

```{yaml}
environments
  environment
    transactionManager
    dataSource
```

### SqlSessionFactory

```{}
DataSource dataSource = BlogDataSourceFactory.getBlogDataSource();
TransactionFactory transactionFactory = new JdbcTransactionFactory();
Environment environment = new Environment("development", transactionFactory, dataSource);
Configuration configuration = new Configuration(environment);
configuration.addMapper(BlogMapper.class);
SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(configuration);
```

## 配置

https://blog.csdn.net/fangwenzheng88/article/details/78469976 mybatis underscoreToCamelCase的两种配置
http://www.mybatis.org/spring/zh/mappers.html mybatis-spring 中文没有 mybatis-spring-boot-autoconfigure
