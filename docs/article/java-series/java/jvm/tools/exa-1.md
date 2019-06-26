# CPU爆表

## 背景

Java线上服务运行一周后，某个周六晚上CPU使用率突然持续99%，Java进程处于假死状态，不响应请求。秉着先恢复服务再排查问题的原则，在我连接VPN采用重启大法后，CPU使用率恢复正常，服务也正常响应了。  

## 处理过程

### Java 错误日志分析

首先，我查了相关的错误日志，发现故障的时间段内有大量的`ckv`请求超时，但请求超时并不是`ckv server`的问题，而是`ckv client`的请求并没有发出去。那么，为什么`ckv client`的请求没有发出去呢？日志并没有提供更多的信息给我。

### JMX 观察

我在Java服务上开启了JMX，本地采用`jvisualvm`来观察Java进程运行时的堆栈内存、线程使用情况。如图二所示：

通过观察Heap内存的使用情况，发现其是缓慢增加的，每隔一小段时间被GC回收，图形呈锯齿状，似乎没有什么问题；Threads也没有存在死锁的问题，线程运行良好；在Sampler查看`Thread CPU Time`的时候发现，log4j的异步日志线程占用的CPU时间是最多的。于是，初步怀疑这是log4j的锅。接着，我对项目代码进行了review，发现某些接口打印了大量的无用日志，日志级别使用也不规范。最后，我对项目的日志进行了整体的梳理，优化后发布上线，并继续观察。

我本以为问题已经解决了。然而，几天后又出现了CPU爆表的情况，这时，我才发现自己错怪了log4j。与上次爆表的情况不同，这次我在公司（表示很淡定），于是我机智地保留了一台机器来做观察，其他机器做重启处理。现在，要开始我的表演了，具体如下：

### Linux 观察

登陆机器，用 top 命令查看进程资源占用情况。不出所料，Java进程把CPU撑爆了，如下图三所示：

Java进程把CPU都占用完了，那么具体是进程内的哪些线程占用的呢？于是，我用了 top -H -p6902 （6902是Java进程的PID）命令找出了具体的线程资源占用情况，如下图四所示：

图四中的PID为Java线程的id，可以看到id为6904、6905、6906、6907这四个线程基本把CPU资源全部吃完了。  

### 分析线程

现在，我们已经拿到耗尽CPU资源的线程id了。这时，我们就可以使用jstack来查找这些id对应的具体线程堆栈信息了。jstack是JDK内置的堆栈跟踪工具，位于JDK根目录的bin文件夹下面，可用于打印的Java堆栈信息。我用命令 jstack 6902 > jstack.txt （6902是Java进程的PID）打印出了Java进程的堆栈信息放到jstack.txt文件了；由于堆栈打印的线程的native id是十六机制的，所以，我把十进制的线程id（6904、6905、6906、6907）转化成十六进制（0x1af8、0x1af9、0x1afa、0x1afb）；最后，通过 cat jstack.txt  | grep -C 20 0x1af8 命令找到了具体的线程信息，如下图五所示：

通过图五可以发现，把CPU占满的线程是GC的线程，Java的垃圾回收把CPU的资源耗尽了。

现在，我们已经定位到是GC的问题了。那么，我们就来看看GC的回收情况，我们可以通过jstat来观察。jstat是JDK内置的JVM检测统计工具，位于JDK根目录的bin文件夹下面，可以对堆内存的使用情况进行实时统计。我使用了命令 jstat -gcutil 6902 2000 10 （6902是Java进程的PID）来观察GC的运行信息，如下图六所示：

通过图六可以知道，E（Eden区）跟O（Old区）的内存已经被耗尽了，FGC（Full GC）的次数高达6989次，FGCT（Full GC Time）的时间高达36453秒，即平均每次FGC的时间为：36453/6989 ≈ 5.21秒。也就是说，Java进程都把时间花在GC上了，所以就没有时间来处理其他事情。

### 分析heap

GC出现图六的这种情况，基本可以确认是在程序中存在内存泄露的问题。那么，如何确定是哪些代码导致的这个问题呢？这时候，我们就可以使用jmap查看Java的内存占用信息。jmap是JDK内置的内存映射工具，位于JDK根目录的bin文件夹下面，可用于获取java进程的内存映射信息。通过命令 jmap -histo 6902 （6902是Java进程的PID）打印出了Java的内存占用信息，如下图七所示：



## FAQ 

1. ckv client 请求发不出去和内存泄露有关系吗？