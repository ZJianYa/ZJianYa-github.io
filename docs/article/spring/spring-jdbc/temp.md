# 概述

## 缓存分层

页面缓存，读写比偏差较大，

技术分层/数据对象分层（可能也就是所说的领域层），都是通过接口来实现的

我们可能会考虑到 http 和 tcp 之间的对应应该是 m:n 而且肯定是 m >= n的，那么就一定会出现共享，那么这个共享是否会引起线程安全问题呢？

## 分布式

不合适不能代表不能用。  

我们还是考虑问题所在：

1. 数据量太大  
   1. 最大限度的提高单机能力：各个层面都要采取措施，应用层、数据库层、操作系统、网络
   2. 拆库拆表
2. 系统耦合性太高
3. 由于不稳定的压力，导致需要可伸缩的负载能力
4. 由于物理原因，人为误操作，

对于不同的数据，采用不同的处理手段。  
交易型的数据，一定要用关系型或者说支持事务的数据库。  
对于非交易型数据，可以考虑使用nosql数据库。  
交易型和非交易型数据之间有关联，关联部分应该如何处理。  

我们总想着要把事情做好，我们是不是更多的应该相信把事情做坏了又会怎样。

## restful

https://static001.infoq.cn/resource/ebook/8f/94/8fb1814994a046e0b3d76cfba649ce94.pdf

## 玩转 Spring 全家桶

言过其实，不过仍然有些收获

- spring5
- Spring Security  
  Oauth jwt sso  
- spring data jdbc 肯定是要看的  
- spring data redis 肯定是要看的  
- spring data rest 暂时不看  
- spring cloud 的未了解，暂时可以不管  

## Spring

https://www.infoq.cn/article/x-XFMSsN8IrDO2YR0T82 异常处理  
core：IoC container, Events, Resources, i18n, Validation, Data Binding, Type Conversion, SpEL, AOP  
Testing:Mock objects, TestContext framework, Spring MVC Test, WebTestClient.
Data Access:Transactions
WEB:Spring MVC, WebSocket, SockJS, STOMP messaging.
Integration:Tasks, Scheduling, Cache.

### spring jdbc

- 多数据源配置
- 数据库账号加密
- 事务的传播
- 事务的粒度

### spring redis

### mybatis

#### mybatis-generator  

#### mybatis-helper  

### spring cloud vs spring cloud alibaba

https://docs.spring.io/spring-boot/docs/  

## 短期可能

1. 赶快结束MySQL优化
2. 结束JVM优化  java 设计模式
3. 结束算法
4. 结束并发、多线程
5. 深入了解Spring
6. activity

## 不可能

1. 分布式

2. Spring cloud

我们暂时不考虑Junit，因为这个不会有人面试