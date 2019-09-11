# 概述

学习指南：  
* 需要先了解一下什么是微服务，其特点和常见要素  
* Spring Cloud 更多的是体现了一种架构思想，而并不旨在提供具体实现，有一点 cncf 的意思。  
  我们应该先从 Application Context Services 和 Common Abstractions 入手。  
* 当然最终我们还是要用某种具体实现来落地的  

## 官方目录

https://cloud.spring.io/spring-cloud-static/Greenwich.SR1/multi/multi_spring-cloud.html

### Cloud Native Applications

#### Spring Cloud Context: Application Context Services

#### Spring Cloud Commons: Common Abstractions

### Spring Cloud Config

#### Quick Start

#### Spring Cloud Config Server

#### 6. Serving Alternative Formats
#### 7. Serving Plain Text
#### 8. Embedding the Config Server
#### 9. Push Notifications and Spring Cloud Bus
#### 10. Spring Cloud Config Client

### III. Spring Cloud Netflix

#### 11. Service Discovery: Eureka Clients
#### 12. Service Discovery: Eureka Server
#### 13. Circuit Breaker: Hystrix Clients
#### 14. Circuit Breaker: Hystrix Dashboard
#### 15. Hystrix Timeouts And Ribbon Clients
#### 16. Client Side Load Balancer: Ribbon
#### 17. External Configuration: Archaius
#### 18. Router and Filter: Zuul
#### 19. Polyglot support with Sidecar
#### 20. Retrying Failed Requests
#### 21. HTTP Clients
#### 22. Modules In Maintenance Mode

### IV. Spring Cloud OpenFeign
### V. Spring Cloud Stream
### VI. Binder Implementations
### VII. Spring Cloud Bus
### VIII. Spring Cloud Sleuth
### IX. Spring Cloud Consul
### X. Spring Cloud Zookeeper
### XI. Spring Cloud Security
### XII. Spring Cloud for Cloud Foundry
### XIII. Spring Cloud Contract
### XIV. Spring Cloud Vault
### XV. Spring Cloud Gateway
### XVI. Spring Cloud Function
### XVII. Spring Cloud Kubernetes
### XVIII. Spring Cloud GCP
### XIX. Appendix: Compendium of Configuration Properties

## 资源  

https://spring.io/projects/spring-cloud
https://cloud.spring.io/spring-cloud-static/spring-cloud-commons/2.1.2.RELEASE/single/spring-cloud-commons.html  
https://resilience4j.readme.io/  
https://resilience4j.readme.io/docs/circuitbreaker  断路器  
  
http://developer.51cto.com/art/201809/583184.htm zookeeper  
https://www.infoq.cn/article/h7RHGYekxZ_QvLPZ6I8y  微服务脚手架工具 vole  
https://time.geekbang.org/course/detail/156-93922 nacos  

http://www.infoq.com/cn/news/2016/08/Monomer-architecture-Micro-servi 从单体架构迁移到微服务，8个关键的思考、实践和经验
https://en.wikipedia.org/wiki/Microservices 基础概念和理论
微服务实际上和分库、分表并无太多关系。分布式应用和分布式数据库是两个层面、两个概念。

https://projects.spring.io/spring-cloud/  
https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/  
http://www.infoq.com/cn/articles/basis-frameworkto-implement-micro-service 实施微服务，我们需要哪些框架
http://www.infoq.com/cn/articles/boot-microservices 使用SpringBoot创建微服务

微服务使得服务便于自治、便于协作。割据总会带来性能上的代价。中央集权和地方自治总是需要不断磨合，然后才能愈加协调。

## 案例

http://dockone.io/article/8599  小团队的微服务之路
https://www.infoq.cn/article/WHt0wFMDRrBU-dtkh1Xp 如何从零开始搭建 CI/CD 流水线
http://dy.163.com/v2/article/detail/EASFV4380518DLIO.html  不要让你的微服务化之路，止步于组织架构的不匹配

## 注册/发现

Consul Nacos

- Eureka Client：负责将这个服务的信息注册到Eureka Server中  
- Eureka Server：注册中心，里面有一个注册表，保存了各个服务所在的机器和端口号  

在应用启动时，Eureka客户端向服务端注册自己的服务信息？  
同时将服务端的服务信息缓存到本地。客户端会和服务端周期性的进行心跳交互，以更新服务租约和服务信息？  
注册中心要最先启动，疑问注册中心是动态变化的吗？  

通常配合着 Feign。  

Feign遇到异常的时候呢？  

## Ribbon 负载均衡

Ribbon 是一个基于HTTP和TCP的客户端负载均衡工具，它基于 Netflix Ribbon 实现。通过 Spring Cloud 的封装，可以让我们轻松地将面向服务的REST模版请求自动转换成客户端负载均衡的服务调用。

通常 Ribbon 是和 Feign 以及 Eureka 紧密协作：  

- 首先 Ribbon 会从 Eureka Client 里获取到对应的服务注册表，也就知道了所有的服务都部署在了哪些机器上，在监听哪些端口号。
- 然后 Ribbon 就可以使用默认的 Round Robin 算法，从中选择一台机器

Feign 就会针对这台机器，构造并发起请求。  

## Hystrix 隔离、熔断以及降级、限流

隔离：让独立的服务之间不因调用顺序而相互影响，有点像多线程  
熔断：直接取消掉某个挂掉的服务  
降级：可以对某个挂掉的服务做记录，以便事后处理的需要  

服务与服务之间的依赖性，故障会传播，会对整个微服务系统造成灾难性的严重后果，这就是服务故障的“雪崩”效应。

## Zuul 网关

像android、ios、pc前端、微信小程序、H5等等，不用去关心后端有几百个服务，就知道有一个网关，所有请求都往网关走，网关会根据请求中的一些特征，将请求转发给后端的各个服务。

有一个网关之后，还有很多好处，比如可以做统一的降级、限流、认证授权、安全，等等。

## 链路监控

Dapper Sleuth
