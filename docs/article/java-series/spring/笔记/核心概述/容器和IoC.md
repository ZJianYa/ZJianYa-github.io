
## 核心组件

Spring 框架中的核心组件有三个：Core、Context 和 Beans。它们构建起了整个 Spring 的骨骼架构。  
而三者之中，Beans 又是核心，Spring 就是面向 Bean 的编程（BOP,Bean Oriented Programming）。  
Bean 在 Spring 中作用就像 Object 对 OOP 的意义一样，没有对象的概念就像没有面向对象编程。  

- Context  
  Bean 包装的是 Object，而 Object 必然有数据，如何给这些数据提供生存环境就是 Context 要解决的问题，对 Context 来说他就是要发现每个 Bean 之间的关系，为它们建立这种关系并且要维护好这种关系。所以 Context 就是一个 Bean 关系的集合，这个关系集合又叫 Ioc 容器，一旦建立起这个 Ioc 容器后 Spring 就可以为你工作了。  
- Core  
  Core 就是发现、建立和维护每个 Bean 之间的关系所需要的一些列的工具，从这个角度看来，Core 这个组件叫 Util 更能让你理解。  
  里面包含了 cglib 、 asm 、 objenesis 等其他相关的 Package 。  

### Bean 组件

主要解决了三件事：Bean 的定义、Bean 的创建以及对 Bean 的解析。  

#### Bean 的创建

Spring Bean 的创建时典型的工厂模式，它的顶级接口是 BeanFactory，下图是这个工厂的继承层次关系：  
![图示](https://www.ibm.com/developerworks/cn/java/j-lo-spring-principle/image003.png)  
那为何要定义这么多层次的接口呢？  
查阅这些接口的源码和说明发现，每个接口都有使用的场合，它主要是为了区分在 Spring 内部对象的传递和转化过程中，对对象的数据访问所做的限制。  
其中，ListableBeanFactory 接口表示这些 Bean 是可列表的。  
而 HierarchicalBeanFactory 表示的这些 Bean 是有继承关系的，也就是每个 Bean 有可能有父 Bean。  
AutowireCapableBeanFactory 接口定义 Bean 的自动装配规则。这四个接口共同定义了 Bean 的集合、Bean 之间的关系、以及 Bean 行为。

最终的默认实现类是 DefaultListableBeanFactory ，实现了所有的接口。  

#### Bean 的定义

Bean 的定义主要有 BeanDefinition 描述，如下图说明了这些类的层次关系：
![图示](https://www.ibm.com/developerworks/cn/java/j-lo-spring-principle/image004.png)
（如果使用的是 schema 方式配置）Bean 的定义就是完整的描述了在 Spring 的配置文件中你定义的 `<bean/>` 节点中所有的信息，包括各种子节点。  
当 Spring 成功解析你定义的一个 `<bean/>` 节点后，在 Spring 的内部就被转化成 BeanDefinition 对象。以后所有的操作都是对这个对象完成的。  

#### Bean 的解析

Bean 的解析过程非常复杂，功能被分的很细，因为这里需要被扩展的地方很多，必须保证有足够的灵活性，以应对可能的变化。Bean 的解析主要就是对 Spring 配置文件的解析。这个解析过程主要通过下图中的类完成：  
![图示](https://www.ibm.com/developerworks/cn/java/j-lo-spring-principle/image005.png)

### Context 组件

前面讲到，Context 组件的作用是给 Spring 提供一个运行时的环境，用以保存各个对象的状态。接下来看一下这个环境是如何构建的。

ApplicationContext 是 Context 的顶级父类。  

```{}
public interface ApplicationContext extends EnvironmentCapable, ListableBeanFactory, HierarchicalBeanFactory,
		MessageSource, ApplicationEventPublisher, ResourcePatternResolver {
    }
```

他除了能标识一个应用环境的基本信息外，他还继承了五个接口，这五个接口主要是扩展了 Context 的功能。下面是 Context 的类结构图：  
![图示](https://www.ibm.com/developerworks/cn/java/j-lo-spring-principle/origin_image006.png)

其中 ResourceLoader 接口表示 ApplicationContext 可以访问到任何外部资源。  
ApplicationContext 有两个主要子类： ConfigurableApplicationContext 、 WebApplicationContext 。

1. ConfigurableApplicationContext 表示该 Context 是可修改的，也就是在构建 Context 中用户可以动态添加或修改已有的配置信息，它下面又有多个子类，其中最经常使用的是可更新的 Context，即 AbstractRefreshableApplicationContext 类。  
2. WebApplicationContext 顾名思义，就是为 web 准备的 Context 他可以直接访问到 ServletContext ，通常情况下，这个接口使用的少。

Context 作为 Spring 的 Ioc 容器，基本上整合了 Spring 大部分功能的基础。

### Core 组件

Core 组件作为 Spring 的核心组件，他其中包含了很多的关键类，其中一个重要组成部分就是定义了资源的访问方式。这种把所有资源都抽象成一个接口的方式很值得在以后的设计中拿来学习。下面就重要看一下这个部分在 Spring 的作用。  
下图是 Resource 相关的类结构图：  
![图示](https://www.ibm.com/developerworks/cn/java/j-lo-spring-principle/origin_image007.png)  

Resource 接口封装了各种可能的资源类型，也就是对使用者来说屏蔽了文件类型的不同。  
ResourceLoader 接口完成，他屏蔽了所有的资源加载者的差异，只需要实现这个接口就可以加载所有的资源，他的默认实现是 DefaultResourceLoader。  

Context 和 Resource 是如何建立关系的？首先看一下他们的类关系图：  
![图示](https://www.ibm.com/developerworks/cn/java/j-lo-spring-principle/image008.png)  

Context 是把资源的加载、解析和描述工作委托给了 ResourcePatternResolver 类来完成，他相当于一个接头人，他把资源的加载、解析和资源的定义整合在一起便于其他组件使用。Core 组件中还有很多类似的方式。  

## IoC 容器

前面介绍了 Core 组件、Bean 组件和 Context 组件的结构与相互关系，下面这里从使用者角度看一下他们是如何运行的，以及我们如何让 Spring 完成各种功能，Spring 到底能有那些功能，这些功能是如何得来的。  

Ioc 容器实际上就是 Context 组件结合其他两个组件共同构建了一个 Bean 关系网，如何构建这个关系网？构建的入口就在 AbstractApplicationContext 类的 refresh 方法中。这个方法的代码如下：

```
public void refresh() throws BeansException, IllegalStateException { 
    synchronized (this.startupShutdownMonitor) { 
        // Prepare this context for refreshing. 
        prepareRefresh(); 
        // Tell the subclass to refresh the internal bean factory. 
        ConfigurableListableBeanFactory beanFactory = obtainFreshBeanFactory(); 
        // Prepare the bean factory for use in this context. 
        prepareBeanFactory(beanFactory); 
        try { 
            // Allows post-processing of the bean factory in context subclasses. 
            postProcessBeanFactory(beanFactory); 
            // Invoke factory processors registered as beans in the context. 
            invokeBeanFactoryPostProcessors(beanFactory); 
            // Register bean processors that intercept bean creation. 
            registerBeanPostProcessors(beanFactory); 
            // Initialize message source for this context. 
            initMessageSource(); 
            // Initialize event multicaster for this context. 
            initApplicationEventMulticaster(); 
            // Initialize other special beans in specific context subclasses. 
            onRefresh(); 
            // Check for listener beans and register them. 
            registerListeners(); 
            // Instantiate all remaining (non-lazy-init) singletons. 
            finishBeanFactoryInitialization(beanFactory); 
            // Last step: publish corresponding event. 
            finishRefresh(); 
        } 
        catch (BeansException ex) { 
            // Destroy already created singletons to avoid dangling resources. 
            destroyBeans(); 
            // Reset 'active' flag. 
            cancelRefresh(ex); 
            // Propagate exception to caller. 
            throw ex; 
        } 
    } 
}
```

这段代码主要包含这样几个步骤：

- 构建 BeanFactory    
- 注册可能感兴趣的事件
- 创建 Bean 实例并构建 Bean 的关系网
- 触发被监听的事件

### 创建 BeanFactory 工厂

如上所述，创建过程中还实现了 Bean 的解析和登记：  

  `ConfigurableListableBeanFactory beanFactory = obtainFreshBeanFactory(); `  
  `org.springframework.context.support.AbstractRefreshableApplicationContext.refreshBeanFactory()`   
  `org.springframework.web.context.support.XmlWebApplicationContext.loadBeanDefinitions(DefaultListableBeanFactory)`  
  ...  
  `org.springframework.beans.factory.support.AbstractBeanDefinitionReader.loadBeanDefinitions(String)`  
  `org.springframework.beans.factory.xml.XmlBeanDefinitionReader.loadBeanDefinitions(Resource)`  
  ...   
  `org.springframework.beans.factory.xml.DefaultBeanDefinitionDocumentReader.registerBeanDefinitions(Document, XmlReaderContext)`  
  `org.springframework.beans.factory.xml.DefaultBeanDefinitionDocumentReader.parseBeanDefinitions(Element, BeanDefinitionParserDelegate)`

创建工厂的流程：  

```{}
org.springframework.context.support.AbstractRefreshableApplicationContext.refreshBeanFactory() {
  	refreshBeanFactory();
		ConfigurableListableBeanFactory beanFactory = getBeanFactory();
		if (logger.isDebugEnabled()) {
			logger.debug("Bean factory for " + getDisplayName() + ": " + beanFactory);
		}
		return beanFactory;
}
```

```{}
org.springframework.context.support.AbstractRefreshableApplicationContext.createBeanFactory() {
  	return new DefaultListableBeanFactory(getInternalParentBeanFactory());
}
```

创建好 BeanFactory 后，接下去添加一些 Spring 本身需要的一些工具类，这个操作在 AbstractApplicationContext 的 prepareBeanFactory 方法完成。

### 注册事件

AbstractApplicationContext 中接下来的三行代码对 Spring 的功能扩展性起了至关重要的作用。  
前两行主要是让你现在可以对已经构建的 BeanFactory 的配置做修改，后面一行就是让你可以对以后再创建 Bean 的实例对象时添加一些自定义的操作。所以他们都是扩展了 Spring 的功能，所以我们要学习使用 Spring 必须对这一部分搞清楚。  

其中在 invokeBeanFactoryPostProcessors 方法中主要是获取实现 BeanFactoryPostProcessor 接口的子类。并执行它的 postProcessBeanFactory 方法，这个方法的声明如下：  

```{}
void postProcessBeanFactory(ConfigurableListableBeanFactory beanFactory) 
    throws BeansException;
```

它的参数是 beanFactory，说明可以对 beanFactory 做修改，这里注意这个 beanFactory 是 ConfigurableListableBeanFactory 类型的，这也印证了前面介绍的不同 BeanFactory 所使用的场合不同，这里只能是可配置的 BeanFactory，防止一些数据被用户随意修改。

registerBeanPostProcessors 方法也是可以获取用户定义的实现了 BeanPostProcessor 接口的子类，并执行把它们注册到 BeanFactory 对象中的 beanPostProcessors 变量中。BeanPostProcessor 中声明了两个方法： postProcessBeforeInitialization 、 postProcessAfterInitialization 分别用于在 Bean 对象初始化时执行。可以执行用户自定义的操作。

后面的几行代码是初始化监听事件和对系统的其他监听者的注册，监听者必须是 ApplicationListener 的子类。

### 容器的扩展点

### 容器化的好处

Spring 的所有特性功能都是基于这个 Ioc 容器工作的，比如后面要介绍的 AOP。  
Ioc 它实际上就是为你构建了一个魔方，这个魔方到底能变出什么好的东西出来，需要我们自己发挥。  
这就是前面说的要了解 Spring 中有哪些扩展点，我们通过实现那些扩展点来改变 Spring 的通用行为。  
至于如何实现扩展点来得到我们想要的个性结果，Spring 中有很多例子，其中 AOP 的实现就是 Spring 本身实现了其扩展点来达到了它想要的特性功能，可以拿来参考。  

## 参考

https://www.ibm.com/developerworks/cn/java/j-lo-spring-principle/


如何学习源码

1. 一个是使用 Debug 的方式去查看流程  
2. 要总的看一下包目录，看看类目录，看看方法签名  
  看类的时候，有需要看类关系图  
3. 既要小心细节，又要超脱细节  