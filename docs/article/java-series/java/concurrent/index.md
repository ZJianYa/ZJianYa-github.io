# 概述

Computer users take it for granted that their systems can do more than one thing at a time. They assume that they can continue to work in a word processor, while other applications download files, manage the print queue, and stream audio. Even a single application is often expected to do more than one thing at a time. For example, that streaming audio application must simultaneously read the digital audio off the network, decompress it, manage playback, and update its display. Even the word processor should always be ready to respond to keyboard and mouse events, no matter how busy it is reformatting text or updating the display. Software that can do such things is known as concurrent software.

计算机用户理所当然地认为他们的系统一次可以做多件事。他们假设他们可以继续在文字处理器中工作，而其他应用程序则下载文件，管理打印队列和流式传输音频。即使是单个应用程序通常也希望一次完成多个任务。例如，流式音频应用程序必须同时从网络读取数字音频，解压缩，管理播放和更新其显示。即使文字处理器应始终准备好响应键盘和鼠标事件，无论重新格式化文本或更新显示有多繁忙。可以执行此类操作的软件称为并发软件。

The Java platform is designed from the ground up to support concurrent programming, with basic concurrency support in the Java programming language and the Java class libraries. Since version 5.0, the Java platform has also included high-level concurrency APIs. This lesson introduces the platform's basic concurrency support and summarizes some of the high-level APIs in the java.util.concurrent packages.

Java平台的设计初衷是为了支持并发编程，在Java编程语言和Java类库中提供基本的并发支持。从5.0版开始，Java平台还包含高级并发API。本课程介绍了平台的基本并发支持，并总结了 java.util.concurrent 包中的一些高级API 。

## 资源

https://docs.oracle.com/javase/tutorial/essential/concurrency/index.html 
https://docs.oracle.com/javase/tutorial/essential/index.html 
https://www.baeldung.com/java-fork-join  

https://mp.weixin.qq.com/s?__biz=MzAxODcyNjEzNQ==&mid=2247485701&idx=1&sn=471710ed79f15283edc0f341f17364ba&chksm=9bd0a49daca72d8bd4269f8980f412bbd5de0367e2bb9889694cedeefb9bbf8dace6165c6118&scene=27#wechat_redirect  HashMap? ConcurrentHashMap?  

https://mp.weixin.qq.com/s?__biz=MzI3NzE0NjcwMg==&mid=2650123032&idx=1&sn=9b2d029e66cfe1a40454bdf2da37a915&chksm=f36bb639c41c3f2fbf55aa6a8b43dafb15c90af49b8565782866f68a776bde646a232608938b&scene=27#wechat_redirect  一篇文章彻底了解ThreadLocal的原理  
https://www.cnblogs.com/xzwblog/p/7227509.html  同上
https://www.jianshu.com/p/98b68c97df9b  同上

## 目录

### Processes and Threads

### Thread Objects

#### Defining and Starting a Thread

#### Pausing Execution with Sleep

#### Interrupts

#### Joins

#### The SimpleThreads Example

### Synchronization

### Liveness 活性

### Guarded Blocks

### Immutable Objects

### High Level Concurrency Objects

### For Further Reading

### Questions and Exercises: Concurrency




