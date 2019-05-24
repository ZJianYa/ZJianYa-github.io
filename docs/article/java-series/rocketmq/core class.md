
## 主要对象

### DefaultMQProducer

  DefaultMQProducer("please_rename_unique_group_name")
  setNamesrvAddr()

  start()
  send()
  shutdown()
  
  start()
  setRetryTimesWhenSendAsyncFailed()
  send()
  shutdown()

  sendOneway(msg);

### Message

### RemotingHelper

### DefaultMQPushConsumer

  DefaultMQPushConsumer("please_rename_unique_group_name");  
  setNamesrvAddr("localhost:9876");  
  subscribe("TopicTest", "*");  
  registerMessageListener()  
  start();



## 场景

### A

### B

#### MessageQueueSelector

#### MessageListenerOrderly

### C

## FAQ

- 生产者消费者的在线情况，是必须都同时在线吗？

生产方式/broker如何处理\在线情况  同时在线  生产者先于消费者在线  生产者比消费者上线晚

- 多生产者/消费者的情况呢？

