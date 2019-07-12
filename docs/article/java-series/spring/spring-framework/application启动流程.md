
## 前提

BeanDefinitionRegistry 规定了注册接口
  registerBeanDefinition(String, BeanDefinition)
  removeBeanDefinition(String)
  getBeanDefinition(String)
  containsBeanDefinition(String)
  getBeanDefinitionNames()
  getBeanDefinitionCount()
  isBeanNameInUse(String)

BeanFactory 规定了Bean的管理接口

ApplicationContext 接口集成了环境接口，其他 BeanFactory 接口 等其他接口
ApplicationContext extends EnvironmentCapable, ListableBeanFactory, HierarchicalBeanFactory,
		MessageSource, ApplicationEventPublisher, ResourcePatternResolver  

GenericApplicationContext 类间接继承了 ApplicationContext，还实现了 BeanDefinitionRegistry  
GenericApplicationContext extends AbstractApplicationContext implements BeanDefinitionRegistry  

## 加载（CMD)过程和自动加载

为什么我写成是加载 ConfigurationMetaData ，而不是类  
容器启动时，会通过某种途径加载 ConfigurationMetaData 。我认为一定是扫描了所有已经加载的类？
BeanDefinitionReader 负责分析、解析 ConfigurationMetaData，生成 BeanDefinition ，注册到 BeanDefinitionRegistry。  

下面是一个 Debug 快照，可以帮你快速找到扫描实现的具体位置， ClassPathBeanDefinitionScanner  

```{}
ClassPathBeanDefinitionScanner(ClassPathScanningCandidateComponentProvider).scanCandidateComponents(String) line: 424	
ClassPathBeanDefinitionScanner(ClassPathScanningCandidateComponentProvider).findCandidateComponents(String) line: 316	
ClassPathBeanDefinitionScanner.doScan(String...) line: 275	
ComponentScanAnnotationParser.parse(AnnotationAttributes, String) line: 132	
ConfigurationClassParser.doProcessConfigurationClass(ConfigurationClass, ConfigurationClassParser$SourceClass) line: 287	
ConfigurationClassParser.processConfigurationClass(ConfigurationClass) line: 242	
ConfigurationClassParser.parse(AnnotationMetadata, String) line: 199	
ConfigurationClassParser.parse(Set<BeanDefinitionHolder>) line: 167	
ConfigurationClassPostProcessor.processConfigBeanDefinitions(BeanDefinitionRegistry) line: 315	
ConfigurationClassPostProcessor.postProcessBeanDefinitionRegistry(BeanDefinitionRegistry) line: 232	
PostProcessorRegistrationDelegate.invokeBeanDefinitionRegistryPostProcessors(Collection<BeanDefinitionRegistryPostProcessor>, BeanDefinitionRegistry) line: 275	
PostProcessorRegistrationDelegate.invokeBeanFactoryPostProcessors(ConfigurableListableBeanFactory, List<BeanFactoryPostProcessor>) line: 95	
AnnotationConfigApplicationContext(AbstractApplicationContext).invokeBeanFactoryPostProcessors(ConfigurableListableBeanFactory) line: 705	
AnnotationConfigApplicationContext(AbstractApplicationContext).refresh() line: 531	
SpringApplication.refresh(ApplicationContext) line: 775	
SpringApplication.refreshContext(ConfigurableApplicationContext) line: 397	
```

### AutoConfigure

从名字上我们就知道这个和类加载，还有点不一样，所以一定是在 CMD 加载之后完成的。  

https://yq.aliyun.com/articles/617718?spm=a2c4e.11153940.0.0.3a03488eaNXlck&type=2  深入理解SpringBoot的过滤条件--AutoConfigure

对于自动加载的，通过 `AutoConfigurationImportSelector.selectImports(AnnotationMetadata annotationMetadata)` 来实现，且委派给 `AutoConfigurationMetadataLoader.loadMetadata(ClassLoader classLoader)` 方法执行。    

```{}
public class AutoConfigurationImportSelector
		implements DeferredImportSelector, BeanClassLoaderAware, ResourceLoaderAware,
		BeanFactoryAware, EnvironmentAware, Ordered {
		}
```

TODO 这里还有前提细节就是， AutoConfigurationImportSelector 是怎么被 ConfigurationClassParser 发现的呢？  

## 实例化

getBean 时进行实例化，否则一开始就完全实例化，会影响程序的启动速度。  

## 扩展点

### BeanFactoryPostProcessor

BeanFactoryPostProcessor 允许我们在容器实例化相应对象之前，对注册到容器的 BeanDefinition 所保存的信息做一些额外的操作，比如修改bean定义的某些属性或者增加其他信息等。
容器中可能有多个 BeanFactoryPostProcessor ，可能还需要实现 org.springframework.core.Ordered 接口，以保证 BeanFactoryPostProcessor 按照顺序执行。Spring 提供了为数不多的 BeanFactoryPostProcessor 实现，我们以 PropertyPlaceholderConfigurer 来说明其大致的工作流程。  

与之相似的，还有 BeanPostProcessor ，其存在于对象实例化阶段 ，它会处理容器内所有符合条件并且已经实例化后的对象。简单的对比，BeanFactoryPostProcessor 处理bean的定义，而 BeanPostProcessor 则处理bean完成实例化后的对象。 BeanPostProcessor 定义了两个方法：

```{}
BeanPostProcessor
  .postProcessBeforeInitialization(Object, String)
  .postProcessAfterInitialization(Object, String)
```

bean的整个生命周期参考下图：

![图示](https://mmbiz.qpic.cn/mmbiz_png/b0eIqZY2SUBlaTKh5cSTw5CicsmEUlW8p2oedDajvouFasiaRdJVfNRasXrZMQ5AXWgQ5OGbYLN5nG9LoYick0zrw/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)  
备注：图摘自 Spring揭秘。  

postProcessBeforeInitialization() 方法与 postProcessAfterInitialization() 分别对应图中前置处理和后置处理两个步骤将执行的方法。  
这两个方法中都传入了bean对象实例的引用，为扩展容器的对象实例化过程提供了很大便利，在这儿几乎可以对传入的实例执行任何操作。注解、AOP等功能的实现均大量使用了 BeanPostProcessor。  

来看一个更常见的例子，在Spring中经常能够看到各种各样的Aware接口，其作用就是在对象实例化完成以后将 Aware 接口定义中规定的依赖注入到当前实例中。比如最常见的 ApplicationContextAware接口，实现了这个接口的类都可以获取到一个 ApplicationContext 对象。当容器中每个对象的实例化过程走到BeanPostProcessor 前置处理这一步时，容器会检测到之前注册到容器的 ApplicationContextAwareProcessor ，然后就会调用其postProcessBeforeInitialization() 方法，检查并设置Aware相关依赖。看看代码吧，是不是很简单：

```{}
	@Override
	@Nullable
	public Object postProcessBeforeInitialization(final Object bean, String beanName) throws BeansException {
		AccessControlContext acc = null;

		if (System.getSecurityManager() != null &&
				(bean instanceof EnvironmentAware || bean instanceof EmbeddedValueResolverAware ||
						bean instanceof ResourceLoaderAware || bean instanceof ApplicationEventPublisherAware ||
						bean instanceof MessageSourceAware || bean instanceof ApplicationContextAware)) {
			acc = this.applicationContext.getBeanFactory().getAccessControlContext();
		}

		if (acc != null) {
			AccessController.doPrivileged((PrivilegedAction<Object>) () -> {
				invokeAwareInterfaces(bean);
				return null;
			}, acc);
		}
		else {
			invokeAwareInterfaces(bean);
		}

		return bean;
	}

	private void invokeAwareInterfaces(Object bean) {
		if (bean instanceof Aware) {
			if (bean instanceof EnvironmentAware) {
				((EnvironmentAware) bean).setEnvironment(this.applicationContext.getEnvironment());
			}
			if (bean instanceof EmbeddedValueResolverAware) {
				((EmbeddedValueResolverAware) bean).setEmbeddedValueResolver(this.embeddedValueResolver);
			}
			if (bean instanceof ResourceLoaderAware) {
				((ResourceLoaderAware) bean).setResourceLoader(this.applicationContext);
			}
			if (bean instanceof ApplicationEventPublisherAware) {
				((ApplicationEventPublisherAware) bean).setApplicationEventPublisher(this.applicationContext);
			}
			if (bean instanceof MessageSourceAware) {
				((MessageSourceAware) bean).setMessageSource(this.applicationContext);
			}
			if (bean instanceof ApplicationContextAware) {
				((ApplicationContextAware) bean).setApplicationContext(this.applicationContext);
			}
		}
	}
```

## 参考

https://mp.weixin.qq.com/s?__biz=MzI4NDY5Mjc1Mg==&mid=2247485736&idx=1&sn=2b153c843ad2a0f90b621a8739470331&chksm=ebf6d157dc8158410970c0da63ad61d653b8fee4736c86ee6e8716bb87d6c049a077280387a0&scene=27#wechat_redirect  一份详细的 Spring Boot 知识清单，Spring boot 概览

https://www.jianshu.com/p/1ed18eebb299 SpringBoot AutoConfigure原理  
https://yq.aliyun.com/articles/617718?spm=a2c4e.11153940.0.0.3a03488eaNXlck&type=2 深入理解SpringBoot的过滤条件--AutoConfigure  
https://hacpai.com/article/1534608851208  SpringBoot 中的 spring-boot-autoconfigure 模块学习