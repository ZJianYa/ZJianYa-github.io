## 初识

### 课程概述

### Spring 的主要项目

### Spring 的技术趋势

### 第一个 Spring 程序

## JDBC

### 如何配置单数据源

### 如何配置多数据源

### HikariCP

### Druid

### 使用 JDBC

### 事务上

### 事务下

### JDBC 异常抽象

## ORM

### JPA

### 定义 JPA 的实体对象

### 开始 SpringBucks

### JPA 操作数据库

### Repository

### Mybatis

### Mybatis Generator

### Mybatis PageHelper

### 小结

## NoSQL

### Docker

### MongoDB

### Redis

### Redis 的哨兵和集群

### Spring 的缓存抽象

### Redis 的其他用法

### 小结

## 数据库访问进阶

### Project Reactor

### Project Reactor

### Reactive 访问 Redis

### Reactive 访问 MongoDB

### Reactive 访问 RDBMS

### AOP

### AOP

### 小结

## Spring MVC

### 39 Controller

### 40 上下文

### 41 请求处理机制

没有讲细节，主要说了一下 doService 和 dispatch() 方法 

### 42 如何处理定义的方法

* @RequestMapping(path method, parames, headers,consumes , produces)
* @RestController
* @GetMapping @PostMapping @PutMapping @DeleteMapping @PatchMapping
* @RequestBody @ResponseBody @ResponseStatus 
* @PathVariable @RequestParam @RequestHeader
* HttpEntity ResponseEntity

这里要求我们必须做的更加细致，我们只适配 JSON
Accept 
Context-type

### 如何处理定义的方法

WebMvcConfigurer Converter Formater Validator boundresult 
MultipartResolver MultiparAutoConfiguration 

### 视图解析上

ViewResolver
  * AbstractCachingViewResolver
  * UrlBasedViewResolver
  * FreeMarkerViewResolver
  * ContentNegotiatingViewResolver
  * ....

### 视图解析下

* @ResponseBody  
  HandlerAdapter.handle()

### 常用视图上

主要是 JSON 和 XML

### 常用视图下

主要是 Thymeleaf
默认配置项  

### 静态资源与缓存

xxx.static-locations = classpath:/META-INF/resources/,classpath:/resources/,classpath:/static/;classpath:/public/

### 异常处理

HandlerExceptionResolver
  - Simple
  - Default
  - Response
  - Exception

@ExceptionHandler
@Controller / @RestController
@ControllerAdvice / @RestControllerAdvice

### Spring MVC 切入点

@Interceptor  

### 项目小结

### 答疑

## 访问 WEB 资源

## WEB 进阶开发

## 重识 Spring Boot

## 运行中的 Spring Boot

### Actuator

主要是各种 endpoint。

## Spring Cloud 和 Spring Native

### 86 简单理解微服务

- 回顾之间的 Springboot 相关
- 微服务的优点
  与组织结构对齐
- 缺点
  - 分布式的缺点它都有
  - 依赖复杂性，导致整个软件生命周期的复杂  开发 -- 测试 -- 运维（监控、治理）
- FAQ
  - 如何独立更新，比如 CA 中心的升级，比如财务模块的升级  
    一个微服务模块不可访问的情况可以有很多，其中常见的：访问量过大，系统升级中...  

### 87 理解云原生

- 适用于云环境的部署、运行、监控
  - DevOps 方面的考虑，意外故障，中断与恢复
  - 持续交付，不以版本为交付点    
  - 微服务  
  - 容器  
- CNCF 和其主要项目

### 88-89 12 Factor

对依赖是扫描？ 发现漏洞和升级？  
发布平台可以批量发布应用程序  
优雅关闭，而不是粗暴关闭，尤其是底层被依赖的服务  



### 90 Spring cloud 的组成部分

外围（客户端）应用 --> gateway--> 微服务 --> database / message brokers  
微服务周围: config service / Service Registry / distributed tracing / 断路 board 

## 服务注册和发现

### 91 Euraka

### 92 Loadbalancer

### 93 Feign

### 94 DiscoveryClient

### 95 Zookeeper

### Consul

### Nacos

### 定制 DiscoveryClient  

### 99 项目小结

## 服务熔断

### 100~101 Hystrix

### 如何观察服务熔断

### 102~105 

### 106 项目小结

## 服务配置

### 107 Git 配置中心

### 108 Git 配置中心

### Zookeeper

### Spring Cloud 的配置抽象

### Consul

### Nacos

### 项目小结

## Spring Cloud Stream ok

### 114 认识 Spring Cloud Stream

### RabbitMQ

### Kafka

### 117 小结

## 服务链路追踪 ok

### 118 Dapper 

- 搞清楚请求流程，以及故障点（有可能并非软件层面，而是物理层面）  
- 每个请求的耗时节点  
- 概念
  - Span
  - Trace
  - Anotation
   - cs,sr,ss,cr

### 119 Sleuth

### 120 追踪消息链路

### 121 除了链路还需要治理什么

- 识别核心链路，能够通观全局  
- 全栈压测，识别瓶颈和  
- 依赖管理，代码静态检测，代码 review 和  

### 122 小结

综合运行 SpringBucks

### 结束语

## TODO

- 网关: （路由）转发请求，灰度升级，负载均衡，应用下线？  
- cloud native 会包含大量客户端: 服务注册，断路器，消息队列，日志采集/记录  
- 服务注册/发现  
- 服务治理，上下线，发布回滚，限流  
- 数据库，MySQL 和 ES 之间的对接  
- 消息队列  
- 单点登录  
- Sleuth 怎么判断和生成TracId、 SpanID , exportable 是什么？     