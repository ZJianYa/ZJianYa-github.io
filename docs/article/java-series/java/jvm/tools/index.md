# 概述

如果是开发环境，我们直接用 VisualVM ，或者 eclipse Memory Analyzer (MAT) 来分析。  
如果是测试环境，可视化的工具那只能用 VisualVM ，或者 jconsole 。  
如果是生产环境，看规范要求，非可视化的工具我用 jcmd 看线程堆栈信息，用 jstat 查看。

## 工具列表

### VisualVM  

### Java Mission Control（JMC) 和 JFR

这里有一个相对特殊的部分，就是是堆外内存中的直接内存，前面的工具基本不适用，可以使用 JDK 自带的 Native Memory Tracking（NMT）特性，它会从 JVM 本地内存分配的角度进行解读。

### jmap  

### jinfo

### jConsole

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

```{}
root@ubuntu:/# jps -m -l
2458 org.artifactory.standalone.main.Main /usr/local/artifactory-2.2.5/etc/jetty.xml
29920 com.sun.tools.hat.Main -port 9998 /tmp/dump.dat
3149 org.apache.catalina.startup.Bootstrap start
30972 sun.tools.jps.Jps -m -l
8247 org.apache.catalina.startup.Bootstrap start
25687 com.sun.tools.hat.Main -port 9999 dump.dat
21711 mrf-center.jar
```

### jstack

jstack 主要用来查看某个Java进程内的线程堆栈信息。语法格式如下：

```{}
jstack [option] pid
jstack [option] executable core
jstack [option] [server-id@]remote-hostname-or-ip
```

-l long listings，会打印出额外的锁信息，在发生死锁时可以用jstack -l pid来观察锁持有情况-m mixed mode，不仅会输出Java堆栈信息，还会输出C/C++堆栈信息（比如Native方法）

jstack可以定位到线程堆栈，根据堆栈信息我们可以定位到具体代码，所以它在JVM性能调优中使用得非常多。下面我们来一个实例找出某个Java进程中最耗费CPU的Java线程并定位堆栈信息，用到的命令有ps、top、printf、jstack、grep。

第一步先找出Java进程ID，我部署在服务器上的Java应用名称为mrf-center：

### jstat

https://www.jianshu.com/p/213710fb9e40

### 其他手段

- 使用elk去检测，是否可用更好的方法？

https://zhuanlan.zhihu.com/p/58461333?utm_medium=hao.caibaojian.com&utm_source=hao.caibaojian.com JVM性能调优监控工具jps、jstack、jmap、jhat、jstat使用详解

## 阿里工具

#### arthas

#### TProfile

## 容器工具  

Tomcat、Weblogic等J2EE工具自身也会提供一些工具

## 参考资料

https://docs.oracle.com/javase/8/docs/technotes/guides/troubleshoot/  
https://docs.oracle.com/javase/8/docs/technotes/tools/unix/  
http://www.cnblogs.com/duanxz/archive/2012/07/10/2584249.html jvm 工具系列 这个写的自然是很不错  
https://blog.csdn.net/lang_programmer/article/details/84726303  arthas排坑（一）：远程监控  