# 概述

JVM会出现异常，或者变慢，或者有时卡顿的现象。  

## 异常类型

内存泄露，还是分配不足，都可能导致OOM

OutOfMemoryError

## 必备知识和解决思路

### 必备知识

对 Java 内存有所了解

会看日志和使用工具

## 工具列表

### jps(Java Virtual Machine Process Status Tool)

jps主要用来输出JVM中运行的进程状态信息。语法格式如下：

jps [options] [hostid]

如果不指定hostid就默认为当前主机或服务器。

命令行参数选项说明如下：

-q 不输出类名、Jar名和传入main方法的参数

-m 输出传入main方法的参数

-l 输出main类或Jar的全限名

-v 输出传入JVM的参数
比如下面：

root@ubuntu:/# jps -m -l
2458 org.artifactory.standalone.main.Main /usr/local/artifactory-2.2.5/etc/jetty.xml
29920 com.sun.tools.hat.Main -port 9998 /tmp/dump.dat
3149 org.apache.catalina.startup.Bootstrap start
30972 sun.tools.jps.Jps -m -l
8247 org.apache.catalina.startup.Bootstrap start
25687 com.sun.tools.hat.Main -port 9999 dump.dat
21711 mrf-center.jar

### jstack

jstack主要用来查看某个Java进程内的线程堆栈信息。语法格式如下：

```{}
jstack [option] pid
jstack [option] executable core
jstack [option] [server-id@]remote-hostname-or-ip
```

-l long listings，会打印出额外的锁信息，在发生死锁时可以用jstack -l pid来观察锁持有情况-m mixed mode，不仅会输出Java堆栈信息，还会输出C/C++堆栈信息（比如Native方法）

jstack可以定位到线程堆栈，根据堆栈信息我们可以定位到具体代码，所以它在JVM性能调优中使用得非常多。下面我们来一个实例找出某个Java进程中最耗费CPU的Java线程并定位堆栈信息，用到的命令有ps、top、printf、jstack、grep。

第一步先找出Java进程ID，我部署在服务器上的Java应用名称为mrf-center：

### 更好的手段

- 使用elk去检测，是否可用更好的方法？

https://zhuanlan.zhihu.com/p/58461333?utm_medium=hao.caibaojian.com&utm_source=hao.caibaojian.com JVM性能调优监控工具jps、jstack、jmap、jhat、jstat使用详解

## 参考资料

https://docs.oracle.com/javase/8/docs/technotes/guides/troubleshoot/  
https://docs.oracle.com/javase/8/docs/technotes/tools/unix/  
http://www.cnblogs.com/duanxz/archive/2012/07/10/2584249.html jvm 工具系列 这个写的自然是很不错
https://blog.csdn.net/lang_programmer/article/details/84726303  arthas排坑（一）：远程监控