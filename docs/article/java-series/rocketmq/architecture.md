# RocketMQ Architecture

## Overview

Apache RocketMQ is a distributed messaging and streaming platform with low latency, high performance and reliability, trillion-level capacity and flexible scalability. It consists of four parts: name servers, brokers, producers and consumers. Each of them can be horizontally extended without a single Point of Failure. As shown in screenshot above.

Apache RocketMQ是一个分布式消息传递和 streaming 平台，具有低延迟，高性能和可靠性，万亿级容量和灵活的可扩展性。  
它由四部分组成：nameserver ，代理，生产者和消费者。它们中的每一个都可以水平扩展而没有单一的故障点。  

### NameServer Cluster

Name Servers provide lightweight service discovery and routing. Each Name Server records full routing information, provides corresponding reading and writing service, and supports fast storage expansion.

NameServer 提供轻量级服务发现和路由。每个 NameServer 记录完整的路由信息​​，提供相应的读写服务，并支持快速存储扩展。

### Broker Cluster

Brokers take care of message storage by providing lightweight TOPIC and QUEUE mechanisms. They support the Push and Pull model, contains fault tolerance mechanism (2 copies or 3 copies), and provides strong padding of peaks and capacity of accumulating hundreds of billion messages in their original time order. In addition, Brokers provide disaster recovery, rich metrics statistics, and alert mechanisms, all of which are lacking in traditional messaging systems.

Brokers 通过提供轻量级的 TOPIC 和 QUEUE 机制来处理消息存储。  
它们支持Push和Pull模型，包含容错机制（2个副本或3个副本），并提供强大的峰值填充和按原始时间顺序累积数千亿条消息的能力。  
此外，Brokers还提供灾难恢复，丰富的指标统计和警报机制，所有这些在传统的消息系统都缺乏。  

### Producer Cluster

Producers support distributed deployment. Distributed Producers send messages to the Broker cluster through multiple load balancing modes. The sending processes support fast failure and have low latency.

生产者支持分布式部署。  
Distributed Producers 通过多种负载均衡模式向 Broker 集群发送消息。  
发送过程支持快速故障并具有低延迟。

### Consumer Cluster

Consumers support distributed deployment in the Push and Pull model as well. It also supports cluster consumption and message broadcasting. It provides real-time message subscription mechanism and can meet most consumer requirements. RocketMQ’s website provides a simple quick-start guide to interested users.

消费者也支持分布式部署，Pull 和 Push 模型都支持。  
它还支持群集消费和消息广播。它提供实时消息订阅机制，可以满足大多数消费者的需求。  
RocketMQ 的网站为感兴趣的用户提供了一个简单的快速入门指南。  

## NameServer

NameServer is a fully functional server, which mainly includes two features:  
NameServer是一个功能齐全的服务器，主要包括两个功能：  

- Broker Management, NameServer accepts the register from Broker cluster and provides heartbeat mechanism to check whether a broker is alive.
Broker Management，NameServer 接受来自Broker集群的注册，并提供心跳机制来检查代理是否存活。  

- Routing Management, each NameServer will hold whole routing info about the broker cluster and the queue info for clients query.  
路由管理，每个 NameServer 将保存有关代理群集的整个路由信息和客户端查询的队列信息。

As we know, RocketMQ clients(Producer/Consumer) will query the queue routing info from NameServer, but how do clients find NameServer address?  
众所周知，RocketMQ客户端（生产者/消费者）将从NameServer查询队列路由信息，但客户端如何查找NameServer地址？

There are four methods to feed NameServer address list to clients:
将NameServer地址列表提供给客户端有四种方法：  

- Programmatic Way, like producer.setNamesrvAddr("ip:port").
- Java Options, use rocketmq.namesrv.addr.
- Environment Variable, use NAMESRV_ADDR.
- HTTP Endpoint.

More details about how to find NameServer address please refer to [here](http://rocketmq.apache.org/rocketmq/four-methods-to-feed-name-server-address-list/).
有关如何查找NameServer地址的更多详细信息，请参阅此处。  

## Broker Server

Broker server is responsible for message store and delivery, message query, HA guarantee, and so on.

As shown in image below, Broker server has several important sub modules:

Remoting Module, the entry of broker, handles the requests from clients.
Client Manager, manages the clients (Producer/Consumer) and maintains topic subscription of consumer.
Store Service, provides simple APIs to store or query message in physical disk.
HA Service, provides data sync feature between master broker and slave broker.
Index Service, builds index for messages by specified key and provides quick message query.