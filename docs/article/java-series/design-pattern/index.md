# 概述

设计模式，我觉得可能应用场景比知道本身结构更有意义。  
像是一种规范：比如我们通常会把代码组件化，我们会使用事件通信或者xxx的方式来

## 创建模式（创建对象的）

###  Factory  

https://cloud.tencent.com/developer/article/1161095 双检锁

AbstractFactory  
双检锁，更多的情况不用加锁，而且如果 `new Object` 的过程如果是多线程的...

```{}
private static final Runtime currentRuntime = new Runtime();
private static Version version;
// …
public static Runtime getRuntime() {
	return currentRuntime;
}
/** Don't let anyone else instantiate this class */
private Runtime() {}
```

### singleton  

### builder  

```{}
HttpRequest request = HttpRequest.newBuilder(new URI(uri))
                     .header(headerAlice, valueAlice)
                     .headers(headerBob, value1Bob,
                      headerCarl, valueCarl,
                      headerBob, value2Bob)
                     .GET()
                     .build();
```

### Prototype

## 结构性

### Bridge

### Adapter

大量的默认方法，可以选择覆盖。如果接口中也都提供了默认方法，从某种程度上来讲，挤兑了Adapter的使用。  

### Decorator

### Proxy

cglib 优点

- 有的时候调用目标可能不便实现额外接口，从某种角度看，限定调用者实现接口是有些侵入性的实践，类似 cglib 动态代理就没有这种限制。
- 只操作我们关心的类，而不必为其他相关类增加工作量。
- 高性能。

另外，从性能角度，我想补充几句。记得有人曾经得出结论说 JDK Proxy 比 cglib 或者 Javassist 慢几十倍。坦白说，不去争论具体的 benchmark 细节，在主流 JDK 版本中，JDK Proxy 在典型场景可以提供对等的性能水平，数量级的差距基本上不是广泛存在的。而且，反射机制性能在现代 JDK 中，自身已经得到了极大的改进和优化，同时，JDK 很多功能也不完全是反射，同样使用了 ASM 进行字节码操作。

静态代理，是你必须实现知道 principal 的接口，且 agent 只能事先写好。  
动态代理，是你不需要事先写好 agent。 

静态代理：事先写好代理类，可以手工编写，也可以用工具生成。缺点是每个业务类都要对应一个代理类，非常不灵活。
动态代理：运行时自动生成代理对象。缺点是生成代理代理对象和调用代理方法都要额外花费时间。
JDK动态代理：基于Java反射机制实现，必须要实现了接口的业务类才能用这种办法生成代理对象。新版本也开始结合ASM机制。
cglib动态代理：基于ASM机制实现，通过生成业务类的子类作为代理类。
Java 发射机制的常见应用：动态代理（AOP、RPC）、提供第三方开发者扩展能力（Servlet容器，JDBC连接）、第三方组件创建对象（DI）……

### Composite

### Facade

### Flyweight

## 行为型模式  

### Strategy

### Interpreter

### Command

### Observer

### Iterator

### Template Method

### Visitor