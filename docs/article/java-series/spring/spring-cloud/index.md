# 概述

- 服务
  - 配置 common/cloud config/Eureka/Consul  
  - 注册/发现/健康监测  缓存时效  Ribbon  Feign。
  - 网关:流量调度/限流/负载均衡（客户端负载均衡/服务端负载均衡)  
  - 管理:启停，扩容，调度，限流  
  - 监控:链路/健康监测(内存/存储/网络/应用运行状态)  Dapper Sleuth  
  - 埋点 手动/agent  
  - CAS，SSO  
  - 容错:网络故障/熔断/降级/多副本(同时可以负载均衡，还需要能自动切换，数据一致性)/
    缓存时效/自我健康监测  

- 常见手段
  - 消息队列，适用性：缓冲，削峰填谷，解耦合。FAQ：幂等性，事务性。  
  - 缓存:  
  - RPC:事务性，幂等性。  
  - zookeeper 是一个综合管家  
  - 分布式事务  

大型的数据中心和我们想象的一定是不一样的，一定分了很多区域，既要实现区域自治，又要实现区域协调。  
区域内部时效一定很强，区域之间时效可以稍弱。  

## 资源  

https://cloud.spring.io/spring-cloud-static/spring-cloud-commons/2.1.2.RELEASE/single/spring-cloud-commons.html  
https://resilience4j.readme.io/  
https://resilience4j.readme.io/docs/circuitbreaker  断路器  

https://spring.io/projects/spring-cloud  
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

Ribbon是一个基于HTTP和TCP的客户端负载均衡工具，它基于Netflix Ribbon实现。通过Spring Cloud的封装，可以让我们轻松地将面向服务的REST模版请求自动转换成客户端负载均衡的服务调用。

通常Ribbon是和Feign以及Eureka紧密协作：  

- 首先Ribbon会从 Eureka Client里获取到对应的服务注册表，也就知道了所有的服务都部署在了哪些机器上，在监听哪些端口号。
- 然后Ribbon就可以使用默认的Round Robin算法，从中选择一台机器

Feign就会针对这台机器，构造并发起请求。  

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