# 概述

https://docs.spring.io/spring/docs/current/spring-framework-reference/core.html#aop  

Aspect-oriented Programming (AOP) complements Object-oriented Programming (OOP) by providing another way of thinking about program structure. The key unit of modularity in OOP is the class, whereas in AOP the unit of modularity is the aspect. Aspects enable the modularization of concerns (such as transaction management) that cut across multiple types and objects. (Such concerns are often termed “crosscutting” concerns in AOP literature.)  
面向切面编程提供另外一种编程结构思路来补充OOP。 OOP 中的关键单元是类，而 AOP 中的关键单元是 aspect。 Aspect 实现了横切多种类型和多个对象的模块化概念。 （这些概念在 AOP 术语中被称之为 “横切” 问题）

One of the key components of Spring is the AOP framework. While the Spring IoC container does not depend on AOP (meaning you do not need to use AOP if you don’t want to), AOP complements Spring IoC to provide a very capable middleware solution.  
Spring的一个关键组件是AOP框架。 虽然Spring IoC 容器不依赖于 AOP（意味着您不需要使用AOP），但 AOP 补充了 Spring IoC 以提供非常强大的中间件解决方案。

...

Spring AOP defaults to using standard JDK dynamic proxies for AOP proxies. This enables any interface (or set of interfaces) to be proxied.  
Spring AOP 默认使用 JDK 动态代理。这使得任何接口（或接口集）都可以被代理。  

Spring AOP can also use CGLIB proxies. This is necessary to proxy classes rather than interfaces. By default, CGLIB is used if a business object does not implement an interface. As it is good practice to program to interfaces rather than classes, business classes normally implement one or more business interfaces. It is possible to force the use of CGLIB, in those (hopefully rare) cases where you need to advise a method that is not declared on an interface or where you need to pass a proxied object to a method as a concrete type.  
Spring AOP 也可以使用 CGLIB 代理，用来代理 classes 而不是 interfaces。默认， 如果业务对象未实现接口默认使用 CGLIB 。也可以强制使用 CGLIB，当你需要在一个接口没有声明的方法上  advise 时或者当你把代理对象作为一个具体类型传入一个方法时，这种情况下（你需要强制使用）。  

It is important to grasp the fact that Spring AOP is proxy-based. See Understanding AOP Proxies for a thorough examination of exactly what this implementation detail actually means.  
掌握 Spring AOP 是基于代理的这一事实非常重要。请参阅 [理解AOP代理](https://docs.spring.io/spring/docs/current/spring-framework-reference/core.html#aop-understanding-aop-proxies)，以全面了解此实现细节的实际含义。

## 动态代理  

上面提到了 Spring AOP 默认使用的是 JDK 动态代理，这里我们就先看看动态代理  

TODO  

## CGLIB

TODO  

## Spring AOP 的建立

前面讲到 AbstractApplicationContext.refresh() 方法时，有一行代码（一个步骤）是：  

```{}
    // Instantiate all remaining (non-lazy-init) singletons.
    finishBeanFactoryInitialization(beanFactory);
```

会执行到 createAopProxy 阶段，产生如下调用链  

```{}
DefaultAopProxyFactory.createAopProxy(AdvisedSupport) line: 51	
ProxyFactory(ProxyCreatorSupport).createAopProxy() line: 105	
ProxyFactory.getProxy(ClassLoader) line: 110	
AnnotationAwareAspectJAutoProxyCreator(AbstractAutoProxyCreator).createProxy(Class<?>, String, Object[], TargetSource) line: 471	
AnnotationAwareAspectJAutoProxyCreator(AbstractAutoProxyCreator).wrapIfNecessary(Object, String, Object) line: 350	
AnnotationAwareAspectJAutoProxyCreator(AbstractAutoProxyCreator).postProcessAfterInitialization(Object, String) line: 299	
DefaultListableBeanFactory(AbstractAutowireCapableBeanFactory).applyBeanPostProcessorsAfterInitialization(Object, String) line: 429	
DefaultListableBeanFactory(AbstractAutowireCapableBeanFactory).initializeBean(String, Object, RootBeanDefinition) line: 1782	
DefaultListableBeanFactory(AbstractAutowireCapableBeanFactory).doCreateBean(String, RootBeanDefinition, Object[]) line: 593	
DefaultListableBeanFactory(AbstractAutowireCapableBeanFactory).createBean(String, RootBeanDefinition, Object[]) line: 515	
DefaultListableBeanFactory(AbstractBeanFactory).lambda$doGetBean$0(String, RootBeanDefinition, Object[]) line: 320	
176683244.getObject() line: not available	
DefaultListableBeanFactory(DefaultSingletonBeanRegistry).getSingleton(String, ObjectFactory<?>) line: 222	
DefaultListableBeanFactory(AbstractBeanFactory).doGetBean(String, Class<T>, Object[], boolean) line: 318	
DefaultListableBeanFactory(AbstractBeanFactory).getBean(String) line: 199	
DependencyDescriptor.resolveCandidate(String, Class<?>, BeanFactory) line: 277	
DefaultListableBeanFactory.doResolveDependency(DependencyDescriptor, String, Set<String>, TypeConverter) line: 1248	
DefaultListableBeanFactory.resolveDependency(DependencyDescriptor, String, Set<String>, TypeConverter) line: 1168	
AutowiredAnnotationBeanPostProcessor$AutowiredFieldElement.inject(Object, String, PropertyValues) line: 593	
InjectionMetadata.inject(Object, String, PropertyValues) line: 90	
AutowiredAnnotationBeanPostProcessor.postProcessProperties(PropertyValues, Object, String) line: 374	
DefaultListableBeanFactory(AbstractAutowireCapableBeanFactory).populateBean(String, RootBeanDefinition, BeanWrapper) line: 1411	
DefaultListableBeanFactory(AbstractAutowireCapableBeanFactory).doCreateBean(String, RootBeanDefinition, Object[]) line: 592	
DefaultListableBeanFactory(AbstractAutowireCapableBeanFactory).createBean(String, RootBeanDefinition, Object[]) line: 515	
DefaultListableBeanFactory(AbstractBeanFactory).lambda$doGetBean$0(String, RootBeanDefinition, Object[]) line: 320	
176683244.getObject() line: not available	
DefaultListableBeanFactory(DefaultSingletonBeanRegistry).getSingleton(String, ObjectFactory<?>) line: 222	
DefaultListableBeanFactory(AbstractBeanFactory).doGetBean(String, Class<T>, Object[], boolean) line: 318	
DefaultListableBeanFactory(AbstractBeanFactory).getBean(String) line: 199	
DefaultListableBeanFactory.preInstantiateSingletons() line: 843	
AnnotationConfigApplicationContext(AbstractApplicationContext).finishBeanFactoryInitialization(ConfigurableListableBeanFactory) line: 877	
AnnotationConfigApplicationContext(AbstractApplicationContext).refresh() line: 549	
SpringApplication.refresh(ApplicationContext) line: 775	
SpringApplication.refreshContext(ConfigurableApplicationContext) line: 397	
SpringApplication.run(String...) line: 316	
SpringApplication.run(Class<?>[], String[]) line: 1260	
SpringApplication.run(Class<?>, String...) line: 1248	
App.main(String[]) line: 18	
```

执行到 getProxy 阶段会产生如下调用链  

```
ClassUtils.isCglibProxyClass(Class<?>) line: 859	
ObjenesisCglibAopProxy(CglibAopProxy).getProxy(ClassLoader) line: 169	
ProxyFactory.getProxy(ClassLoader) line: 110	
AnnotationAwareAspectJAutoProxyCreator(AbstractAutoProxyCreator).createProxy(Class<?>, String, Object[], TargetSource) line: 471	
AnnotationAwareAspectJAutoProxyCreator(AbstractAutoProxyCreator).wrapIfNecessary(Object, String, Object) line: 350	
AnnotationAwareAspectJAutoProxyCreator(AbstractAutoProxyCreator).postProcessAfterInitialization(Object, String) line: 299	 
...
```


其中 `.DefaultAopProxyFactory.createAopProxy()` 方法可以创建 JDK 动态代理类，或者 Cglib 的代理类。  
```{}
org.springframework.aop.framework.DefaultAopProxyFactory.createAopProxy(AdvisedSupport) {
  	if (config.isOptimize() || config.isProxyTargetClass() || hasNoUserSuppliedProxyInterfaces(config)) {
			Class<?> targetClass = config.getTargetClass();
			if (targetClass == null) {
				throw new AopConfigException("TargetSource cannot determine target class: " +
						"Either an interface or a target is required for proxy creation.");
			}
			if (targetClass.isInterface() || Proxy.isProxyClass(targetClass)) {
				return new JdkDynamicAopProxy(config);
			}
			return new ObjenesisCglibAopProxy(config);
		}
		else {
			return new JdkDynamicAopProxy(config);
		}
}
```

其中 ClassUtils.isCglibProxyClass(rootClass) 判断的标准是通过类名是否包含 "$$" 来判断

### 基于 JDK 动态代理的实现

从前面代理的原理我们知道，代理的目的是调用目标方法时我们可以转而执行 InvocationHandler 类的 invoke 方法，所以如何在 InvocationHandler 上做文章就是 Spring 实现 Aop 的关键所在。

Spring 的 Aop 实现是遵守 Aop 联盟的约定。同时 Spring 又扩展了它，增加了如 Pointcut、Advisor 等一些接口使得更加灵活。

下面是 Jdk 动态代理的类图：


### 基于 CGLIB 的实现

TODO

## 参考

https://www.baeldung.com/cglib  cglib demo

## TODO

- Spring 中使用 JDK 动态代理 和 cglib  
  虽然 Spring 自称默认使用 JDK 动态代理，但是我没有发现使用动态代理  
  为什么必须进入容器才可以实现 AOP ，因为 AOP 对象的创建是在程序初始化的？并非如此，是因为你所有的依赖需要向容器索要，所以他才可以控制。  

