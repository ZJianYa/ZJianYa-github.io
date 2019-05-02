# 概述

## 背景

### ORM的主要作用

ORM中间件的主要功能在于实现数据的自动转化，日后ORM也许会消失，也许无法消失。  

### ORM框架 选择

我们始终不太同意使用JPA的原因是：querydsl 没有SQL好。而且ORM工作也不需要手动去做。
http://www.querydsl.com  
http://www.eclipse.org/eclipselink/  Java Persistence Query Language  
https://www.sojson.com/blog/294.html Springboot JPA 执行原生sql ，自定义SQL占位符增加参数 JPA简单了解 spring.jpa.show-sql=true  

从某种程度上讲，JPA还是可以提供相对于Mybatis的一些便捷性。主要是减少了大量的配置文件。

https://blog.jooq.org/tag/mybatis/  
http://www.mybatis.org/mybatis-3/java-api.html  

## 关联框架

mybatis-Spring

## 关于注解和文件配置方式的选择

1. 自动化 > 手动配置
2. 可以配置 > 修改源码
3. 数据尽量要可配置，凡是数据不能放在注解中（可以通过注解注入）