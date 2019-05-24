# Core Concept

## 主要概念

### Producer

多种生产方式：同步，异步，单向。

### Producer Group

具有相同角色的 Producer 。当一个 Producer 挂掉的时候， broker 会联系组内的其他一个实例回滚或者提交事务。  

> 警告：考虑到 Producer 高效强大，所以一个 Producer group 只允许实例（生成消息），避免不必要的 producer 实例初始化。

### Consumer

消费者从经纪人处获取消息并将其提供给应用程序。从用户应用的角度来看，提供了两种类型的消费者：

#### PullConsumer

这种对于IM，可能会比较合适，因为他不需要反馈，而且

#### PushConsumer

我认为这种 Consumer 是占主导的。因为：  
1. 通常是核心系统产生 MSG， 其他系统由MSG 驱动。  
2. 核心系统和其他系统如果有业务交互（比如商城和信贷/银行系统交互，还需要反馈）。  

### Consumer Group

与之前提到的生产者组类似，完全相同角色的消费者被组合在一起并命名为消费者组。

消费者群体是一个很好的概念，在消息消费方面实现负载平衡和容错目标非常容易。

警告：使用者组的使用者实例必须具有完全相同的主题订阅。

### Topic

Topic 是生产者传递消息和消费者提取消息的类别。主题与生产者和消费者的关系非常松散。  
具体而言，主题可能有零个，一个或多个 Producer 向其发送消息; 另一方面，Producer 可以发送不同主题的消息。  
从消费者的角度来看，主题可以由零个，一个或多个消费者群体订阅。类似地，消费者组可以订阅一个或多个主题，只要该组的实例保持其订阅一致即可。

### Message

Message is the information to be delivered. A message must have a topic, which can be interpreted as address of your letter to mail to. A message may also have an optional tag and extra key-value pairs. For example, you may set a business key to your message and look up the message on a broker server to diagnose issues during development.
消息是要传递的信息。消息必须有一个主题，可以将其解释为您要发送给的邮件地址。  
消息还可以具有可选标记和额外的 key-value 。  
例如，您可以为消息设置一个 business key ，并在代理服务器上查找消息以诊断开发期间的问题。

#### Message Queue

Topic is partitioned into one or more sub-topics, “message queues”.

#### Tag

#### Broker

### Name Server

Name Server 充当路由信息提供者。生产者/消费者客户查找主题以查找相应的代理列表。  
Name Server 实际上相当于花名册，或者路由表。  

### Message Model

- Clustering

- Broadcasting

### Message Order

使用DefaultMQPushConsumer时，您可能决定按顺序或并发使用消息。  

