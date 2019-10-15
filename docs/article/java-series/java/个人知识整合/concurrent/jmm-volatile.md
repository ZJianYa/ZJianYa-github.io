其实我觉得这里的重点不是内存结构，而且这种内存结构也不是 JMM 特有的，重点应该在于规则定义，规则定义是 JMM 特有的。  

## 计算机内存结构

## happen-before 规则

## volatile

Volatile 变量修饰符如果使用恰当的话,它比 synchronized 的使用和执行成本会更低,因为它不会引起线程上下文的切换和调度。  
volatile 变量修饰的共享变量，进行写操作的时候会多出一行汇编代码 （Java 代码转成汇编代码），即一个 Lock 前缀的指令（Lock# 信号），即插入指令屏障。  
http://tutorials.jenkov.com/java-concurrency/volatile.html  
