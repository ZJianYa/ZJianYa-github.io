
# Cloud Native Applications

Cloud Native is a style of application development that encourages easy adoption of best practices in the areas of continuous delivery and value-driven development. A related discipline is that of building [12-factor Applications](https://12factor.net/), in which development practices are aligned with delivery and operations goals — for instance, by using declarative programming and management and monitoring. Spring Cloud facilitates these styles of development in a number of specific ways. The starting point is a set of features to which all components in a distributed system need easy access.

Cloud Native是一种应用程序开发风格，鼓励在持续交付和价值驱动开发领域轻松采用最佳实践。一个相关的学科是建立12因素应用程序，其中开发实践与交付和运营目标保持一致 - 例如，通过使用声明性编程和管理与监控。Spring Cloud以多种特定方式促进这些开发风格。起点是一组功能，分布式系统中的所有组件都需要轻松访问。

Many of those features are covered by Spring Boot, on which Spring Cloud builds. Some more features are delivered by Spring Cloud as two libraries: Spring Cloud Context and Spring Cloud Commons. Spring Cloud Context provides utilities and special services for the ApplicationContext of a Spring Cloud application (bootstrap context, encryption, refresh scope, and environment endpoints). Spring Cloud Commons is a set of abstractions and common classes used in different Spring Cloud implementations (such as Spring Cloud Netflix and Spring Cloud Consul).

Spring Boot 构建了 Spring Boot 中的许多功能。Spring Cloud将更多功能作为两个库提供：Spring Cloud Context 和 Spring Cloud Commons 。Spring Cloud Context 为 ApplicationContext Spring Cloud 应用程序（bootstrap context, encryption, refresh scope, and environment endpoints）提供实用程序和特殊服务。Spring Cloud Commons 是一组用于不同Spring Cloud实现的抽象和公共类（例如Spring Cloud Netflix和Spring Cloud Consul）。  

If you get an exception due to "Illegal key size" and you use Sun’s JDK, you need to install the Java Cryptography Extension (JCE) Unlimited Strength Jurisdiction Policy Files. See the following links for more information:

如果由于“非法密钥大小”而导致异常并且您使用Sun的JDK，则需要安装 `Java Cryptography Extension（JCE）Unlimited Strength Jurisdiction Policy Files` 。有关更多信息，请参阅以下链接：

* Java 6 JCE

* Java 7 JCE

* Java 8 JCE

Extract the files into the JDK/jre/lib/security folder for whichever version of JRE/JDK x64/x86 you use.

> Spring Cloud is released under the non-restrictive Apache 2.0 license. If you would like to contribute to this section of the documentation or if you find an error, you can find the source code and issue trackers for the project at github.  

Spring Cloud是在非限制性Apache 2.0许可下发布的。如果您想为文档的这一部分做出贡献，或者如果发现错误，您可以在github上找到项目的源代码和问题跟踪器。

## Spring Cloud Context: Application Context Services

Spring Boot has an opinionated view of how to build an application with Spring. For instance, it has conventional locations for common configuration files and has endpoints for common management and monitoring tasks. Spring Cloud builds on top of that and adds a few features that probably all components in a system would use or occasionally need.  

Spring Boot 有一个关于如何使用Spring构建应用程序的观点。例如，它具有常见配置文件的常规位置，并具有用于常见管理和监视任务的端点。  
Spring Cloud 构建于此之上，并添加了一些功能，可能是系统中的所有组件都可能使用或偶尔需要的功能。  

### The Bootstrap Application Context

A Spring Cloud application operates by creating a “bootstrap” context, which is a parent context for the main application. It is responsible for loading configuration properties from the external sources and for decrypting properties in the local external configuration files. The two contexts share an Environment, which is the source of external properties for any Spring application. By default, bootstrap properties (not bootstrap.properties but properties that are loaded during the bootstrap phase) are added with high precedence, so they cannot be overridden by local configuration.

Spring Cloud 应用程序通过创建“引导程序”上下文来运行，该上下文是主应用程序的父上下文。它负责从外部源加载配置属性以及解密本地外部配置文件中的属性。这两个上下文共享一个Environment，它是任何Spring应用程序的外部属性的来源。默认情况下，引导属性（不是bootstrap.properties在引导阶段加载的属性）以高优先级添加，因此本地配置不能覆盖它们。  

The bootstrap context uses a different convention for locating external configuration than the main application context. Instead of application.yml (or .properties), you can use bootstrap.yml, keeping the external configuration for bootstrap and main context nicely separate. The following listing shows an example:  

引导上下文使用不同的约定来定位外部配置而不是主应用程序上下文。而不是 application.yml（或.properties），您可以使用bootstrap.yml，保持引导程序和主要上下文的外部配置很好地分开。以下清单显示了一个示例：  

**bootstrap.yml**

```
spring：
  application：
    name：foo 
  cloud：
    config：
      uri：$ {SPRING_CONFIG_URI：http：// localhost：8888}
```

If your application needs any application-specific configuration from the server, it is a good idea to set the spring.application.name (in bootstrap.yml or application.yml). In order for the property spring.application.name to be used as the application’s context ID you must set it in bootstrap.[properties | yml].  

如果您的应用程序需要来自服务器的任何特定于应用程序的配置，则最好设置 spring.application.name（in bootstrap.yml或application.yml）。  
为了将 spring.application.name 用作应用程序的上下文ID，您必须在 bootstrap.[properties | yml] 中设置他。

You can disable the bootstrap process completely by setting spring.cloud.bootstrap.enabled=false (for example, in system properties).  
您可以通过设置 spring.cloud.bootstrap.enabled=false（例如，在系统属性中）完全禁用引导过程。  

### Application Context Hierarchies

If you build an application context from SpringApplication or SpringApplicationBuilder, then the Bootstrap context is added as a parent to that context. It is a feature of Spring that child contexts inherit property sources and profiles from their parent, so the “main” application context contains additional property sources, compared to building the same context without Spring Cloud Config. The additional property sources are:  

如果你通过 SpringApplicationBuilder 构建一个 application context ，则 Bootstrap context 作为 parent 添加到这个上线文上。  
child contexts 从 parent 继承 property sources and profiles 是 Spring 的一个特性，所以 “main” application context 包含额外的属性，相对于没有 Spring Cloud Config 的 context 。  
额外的 property sources 是: 

* “bootstrap”: If any PropertySourceLocators are found in the Bootstrap context and if they have non-empty properties, an optional CompositePropertySource appears with high priority. An example would be properties from the Spring Cloud Config Server. See “Customizing the Bootstrap Property Sources” for instructions on how to customize the contents of this property source.  

* “bootstrap”：如果`PropertySourceLocators`在 Bootstrap 上下文中找到任何内容，并且它们具有非空属性，`CompositePropertySource`则会显示具有高优先级的可选项。一个例子是`Spring Cloud Config Server`的属性。有关如何自定义此属性源内容的说明，请参阅“ 自定义Bootstrap属性源 ”。  

* “applicationConfig: [classpath:bootstrap.yml]” (and related files if Spring profiles are active): If you have a bootstrap.yml (or .properties), those properties are used to configure the Bootstrap context. Then they get added to the child context when its parent is set.   
They have lower precedence than the application.yml (or .properties) and any other property sources that are added to the child as a normal part of the process of creating a Spring Boot application. See “Changing the Location of Bootstrap Properties” for instructions on how to customize the contents of these property sources.  

* “applicationConfig：[classpath：bootstrap.yml]”（以及相关文件，如果Spring配置文件处于活动状态）：如果您有bootstrap.yml（或.properties），则使用这些属性配置Bootstrap上下文。然后，在设置其父级时，它们将添加到子上下文中。它们的优先级低于 application.yml（或.properties）以及作为创建 Spring Boot 应用程序过程的正常部分添加到子级的任何其他属性源。有关如何自定义这些属性源的内容的说明，请参阅“ 更改Bootstrap属性的位置 ”。

Because of the ordering rules of property sources, the “bootstrap” entries take precedence. However, note that these do not contain any data from bootstrap.yml, which has very low precedence but can be used to set defaults.  

由于顺序规则， “bootstrap” 实体有更高的优先级。但是，注意不包含任何 bootstrap.yml 中的数据，它具有非常低的优先级，可用于设置默认值。  

You can extend the context hierarchy by setting the parent context of any ApplicationContext you create — for example, by using its own interface or with the SpringApplicationBuilder convenience methods (parent(), child() and sibling()). The bootstrap context is the parent of the most senior ancestor that you create yourself. Every context in the hierarchy has its own “bootstrap” (possibly empty) property source to avoid promoting values inadvertently from parents down to their descendants. If there is a Config Server, every context in the hierarchy can also (in principle) have a different spring.application.name and, hence, a different remote property source. Normal Spring application context behavior rules apply to property resolution: properties from a child context override those in the parent, by name and also by property source name. (If the child has a property source with the same name as the parent, the value from the parent is not included in the child).

您可以通过设置您创建的任何 ApplicationContext 的父上下文来扩展上下文层次结构 - 例如，通过使用自己的接口或 SpringApplicationBuilder 便捷方法（parent（），child（）和sibling（））。引导上下文是您自己创建的最高级祖先的父级。层次结构中的每个上下文都有自己的“引导程序”（可能是空的）属性源，以避免从父级到其后代无意中提升值。如果存在Config Server，则层次结构中的每个上下文（原则上）也可以具有不同的spring.application.name，因此具有不同的远程属性源。普通的Spring应用程序上下文行为规则适用于属性解析：来自子上下文的属性按名称和属性源名称覆盖父级中的属性。 （如果子项具有与父项具有相同名称的属性源，则父项中的值不包含在子项中）

Note that the SpringApplicationBuilder lets you share an Environment amongst the whole hierarchy, but that is not the default. Thus, sibling contexts, in particular, do not need to have the same profiles or property sources, even though they may share common values with their parent.

SpringApplicationBuilder 让你共享一个 Environment 在整个 hierarchy ，但不是默认的。 因此，同级上下文，尤其不需要具有相同的 profiles 或属性源，即使它们可能与其父级共享相同的值。

### Changing the Location of Bootstrap Properties

The bootstrap.yml (or .properties) location can be specified by setting spring.cloud.bootstrap.name (default: bootstrap) or spring.cloud.bootstrap.location (default: empty) — for example, in System properties. Those properties behave like the spring.config.* variants with the same name. In fact, they are used to set up the bootstrap ApplicationContext by setting those properties in its Environment. If there is an active profile (from spring.profiles.active or through the Environment API in the context you are building), properties in that profile get loaded as well, the same as in a regular Spring Boot app — for example, from `bootstrap-development.properties` for a development profile.

bootstrap.yml 位置可以通过设置 spring.cloud.bootstrap.name 或者 spring.cloud.bootstrap.location 来指定，在系统属性中。  
这些属性的行为类似于 spring.config.* 具有相同名称的变量。实际上，它们是通过在它的 Environment 中设置这些属性来 set up the bootstrap ApplicationContext 。  
如果有一个 active profile , 和一个普通的 Spring Boot app 一样从那个 profile 中获取 properties 。 

### Overriding the Values of Remote Properties

The property sources that are added to your application by the bootstrap context are often “remote” (from example, from Spring Cloud Config Server). By default, they cannot be overridden locally. If you want to let your applications override the remote properties with their own System properties or config files, the remote property source has to grant it permission by setting spring.cloud.config.allowOverride=true (it does not work to set this locally). Once that flag is set, two finer-grained settings control the location of the remote properties in relation to system properties and the application’s local configuration:  
属性源称之为 "remote". 默认你不可以本地覆盖. 如果你想让你的应用覆盖远程属性，配置 `spring.cloud.config.allowOverride=true`.

* spring.cloud.config.overrideNone=true: Override from any local property source.

* spring.cloud.config.overrideSystemProperties=false: Only system properties, command line arguments, and environment variables (but not the local config files) should override the remote settings.

### Customizing the Bootstrap Configuration

The bootstrap context can be set to do anything you like by adding entries to /META-INF/spring.factories under a key named org.springframework.cloud.bootstrap.BootstrapConfiguration. This holds a comma-separated list of Spring @Configuration classes that are used to create the context. Any beans that you want to be available to the main application context for autowiring can be created here. There is a special contract for @Beans of type ApplicationContextInitializer. If you want to control the startup sequence, classes can be marked with an @Order annotation (the default order is last).  

bootstrap 上下文可以设置任何你喜欢的，通过为 spring.factories 文件的 org.springframework.cloud.bootstrap.BootstrapConfiguration 增加的 entries。
它包含@Configuration用于创建上下文的Spring 类的逗号分隔列表。您可以在此处创建要用于主应用程序上下文进行自动装配的任何bean。@Beans类型的特殊合同ApplicationContextInitializer。如果要控制启动顺序，则可以用@Order注释标记类（默认顺序为last）。

>	When adding custom BootstrapConfiguration, be careful that the classes you add are not @ComponentScanned by mistake into your “main” application context, where they might not be needed. Use a separate package name for boot configuration classes and make sure that name is not already covered by your @ComponentScan or @SpringBootApplication annotated configuration classes.
> 添加 custom BootstrapConfiguration 时，请注意不要将添加的类 @ComponentScanned 错误地插入到可能不需要它们的“ 主 ”应用程序上下文中。为引导配置类使用单独的程序包名称，并确保您的名称@ComponentScan或带@SpringBootApplication注释的配置类尚未覆盖该名称。

The bootstrap process ends by injecting initializers into the main SpringApplication instance (which is the normal Spring Boot startup sequence, whether it is running as a standalone application or deployed in an application server). First, a bootstrap context is created from the classes found in spring.factories. Then, all @Beans of type ApplicationContextInitializer are added to the main SpringApplication before it is started.

引导过程结束时，将初始化程序注入到主SpringApplication实例中（这是正常的Spring Boot启动序列，无论它是作为独立应用程序运行还是在应用程序服务器中部署）。
首先，从中找到的类创建引导上下文spring.factories。然后，在启动之前将所有@Beans类型ApplicationContextInitializer添加到主体SpringApplication。

### Customizing the Bootstrap Property Sources

The default property source for external configuration added by the bootstrap process is the Spring Cloud Config Server, but you can add additional sources by adding beans of type PropertySourceLocator to the bootstrap context (through spring.factories). For instance, you can insert additional properties from a different server or from a database.

默认 property source 是 Spring Cloud Config Server，但是你可以增加额外的 PropertySourceLocator 。例如，你可以 insert 额外的属性从一个不同的 server 或者 database .

As an example, consider the following custom locator:  
例如:  

```
@Configuration
public class CustomPropertySourceLocator implements PropertySourceLocator {

    @Override
    public PropertySource<?> locate(Environment environment) {
        return new MapPropertySource("customProperty",
                Collections.<String, Object>singletonMap("property.from.sample.custom.source", "worked as intended"));
    }

}
```

The Environment that is passed in is the one for the ApplicationContext about to be created — in other words, the one for which we supply additional property sources for. It already has its normal Spring Boot-provided property sources, so you can use those to locate a property source specific to this Environment (for example, by keying it on spring.application.name, as is done in the default Spring Cloud Config Server property source locator).  
传入的 Environment ... 他已经有普通 Spring Boot 提供的属性源，所以你可以使用这些去 locate 一个属性源给这个 Environment （例如，通过将其键入spring.application.name，就像在默认的 Spring Cloud Config Server 属性源定位器中所做的那样）。

If you create a jar with this class in it and then add a META-INF/spring.factories containing the following, the customProperty PropertySource appears in any application that includes that jar on its classpath:  
如果你创建的 jar 包，那就在 spring.factories 包含下面的

`org.springframework.cloud.bootstrap.BootstrapConfiguration=sample.custom.CustomPropertySourceLocator`

### Logging Configuration

If you are going to use Spring Boot to configure log settings than you should place this configuration in `bootstrap.[yml | properties] if you would like it to apply to all events.

> For Spring Cloud to initialize logging configuration properly you cannot use a custom prefix. For example, using custom.loggin.logpath will not be recognized by Spring Cloud when initializing the logging system.  

### Environment Changes

The application listens for an EnvironmentChangeEvent and reacts to the change in a couple of standard ways (additional ApplicationListeners can be added as @Beans by the user in the normal way). When an EnvironmentChangeEvent is observed, it has a list of key values that have changed, and the application uses those to:  
应用监听 EnvironmentChangeEvent 并且通过一组标准方式作出反应。当观测到一个 EnvironmentChangeEvent , 应用程序会：

* Re-bind any @ConfigurationProperties beans in the context

* Set the logger levels for any properties in logging.level.*

Note that the Config Client does not, by default, poll for changes in the Environment. Generally, we would not recommend that approach for detecting changes (although you could set it up with a @Scheduled annotation). If you have a scaled-out client application, it is better to broadcast the EnvironmentChangeEvent to all the instances instead of having them polling for changes (for example, by using the Spring Cloud Bus).  
注意 Config Client 默认不去拉去 Environment 的变化。通常我们也不建议用这种方式探测变化。如果你有一个横向扩展的客户端应用，最好广播 EnvironmentChangeEvent 给所有实例。 

The EnvironmentChangeEvent covers a large class of refresh use cases, as long as you can actually make a change to the Environment and publish the event. Note that those APIs are public and part of core Spring). You can verify that the changes are bound to @ConfigurationProperties beans by visiting the /configprops endpoint (a normal Spring Boot Actuator feature). For instance, a DataSource can have its maxPoolSize changed at runtime (the default DataSource created by Spring Boot is an @ConfigurationProperties bean) and grow capacity dynamically. Re-binding @ConfigurationProperties does not cover another large class of use cases, where you need more control over the refresh and where you need a change to be atomic over the whole ApplicationContext. To address those concerns, we have @RefreshScope.  
EnvironmentChangeEvent 覆盖了一大类刷新用例，当 Environment 变动并发布 event 时。 这些 APIs 是公共的，是 Spring 核心的一部分。你可以通过访问 /configprops 验证绑定到 @ConfigurationProperties 的变化。例如，一个 DataSource 可以在运行时更改 maxPoolSize ，动态扩容。 重新绑定 @ConfigurationProperties 不涉及另一类大类用例，在这些用例中，您需要对刷新有更多的控制，并且需要进行更改以使整体成为原子 ApplicationContext 。 为了解决这些问题，我们有 @RefreshScope。

### Refresh Scope

When there is a configuration change, a Spring @Bean that is marked as @RefreshScope gets special treatment. This feature addresses the problem of stateful beans that only get their configuration injected when they are initialized. For instance, if a DataSource has open connections when the database URL is changed via the Environment, you probably want the holders of those connections to be able to complete what they are doing. Then, the next time something borrows a connection from the pool, it gets one with the new URL.  
当有一个配置变动时，一个标记为 @RefreshScope 的 @Bean 会被特殊对待。此功能解决了有状态 beans 的问题，只有在初始化时才会注入配置。 例如，通过 Environment 更改一个 DataSource 配置，你可能想等正在使用的链接被用完之后（再释放）。然后，下次 something 从池中获取连接时，它将获得具有新URL的连接。  

Sometimes, it might even be mandatory to apply the @RefreshScope annotation on some beans which can be only initialized once. If a bean is "immutable", you will have to either annotate the bean with @RefreshScope or specify the classname under the property key spring.cloud.refresh.extra-refreshable.  
有时，甚至可能必须将 @RefreshScope 注释应用于只能初始化一次的某些 bean 。如果 bean 是“不可变的”，则必须使用注释bean @RefreshScope 或在属性key下指定类名 spring.cloud.refresh.extra-refreshable。  

>	If you create a DataSource bean yourself and the implementation is a HikariDataSource, return the most specific type, in this case HikariDataSource. Otherwise, you will need to set spring.cloud.refresh.extra-refreshable=javax.sql.DataSource.
> 如果你创建一个 DataSource bean 并且用的是 HikariDataSource 实现，则返回最特定的类型，在这种情况下为HikariDataSource。否则你需要设置 `spring.cloud.refresh.extra-refreshable=javax.sql.DataSource` .

Refresh scope beans are lazy proxies that initialize when they are used (that is, when a method is called), and the scope acts as a cache of initialized values. To force a bean to re-initialize on the next method call, you must invalidate its cache entry.  
Refresh scope 是延迟代理，他们在被使用时被初始化，并且 scope 充当初始化值的缓存。要强制 bea n在下一个方法调用上重新初始化，必须使它的缓存条目无效。

The RefreshScope is a bean in the context and has a public refreshAll() method to refresh all beans in the scope by clearing the target cache. The /refresh endpoint exposes this functionality (over HTTP or JMX). To refresh an individual bean by name, there is also a refresh(String) method.  
RefreshScope 是一个在上线文中 bean ，有个 refreshAll() 方法刷新所有 beans 通过 clearing 目标缓存。  
`/refresh` endpoint 暴露这个功能。为了刷新一个单独的bean, 还有一个 `refresh(String)` 方法。

To expose the /refresh endpoint, you need to add following configuration to your application:  
为了暴露 `/refresh` endpoint, 你需要给 application 增加下面的配置。  

```
management:
  endpoints:
    web:
      exposure:
        include: refresh
```

> @RefreshScope works (technically) on an @Configuration class, but it might lead to surprising behavior. For example, it does not mean that all the @Beans defined in that class are themselves in @RefreshScope. Specifically, anything that depends on those beans cannot rely on them being updated when a refresh is initiated, unless it is itself in @RefreshScope. In that case, it is rebuilt on a refresh and its dependencies are re-injected. At that point, they are re-initialized from the refreshed @Configuration).  

@RefreshScope (从技术角度看) 在一个 @Configuration 上，但是可能导致令人惊讶的行为。例如，不意味着所有定义在那个类中的 @Beans 都是 @RefreshScope. 具体而言，依赖于这些 beans 的 anything 不能依赖于刷新启动时对其进行更新，除非它自己 in @RefreshScope.

### Encryption and Decryption

Spring Cloud has an Environment pre-processor for decrypting property values locally. It follows the same rules as the Config Server and has the same external configuration through encrypt.*. Thus, you can use encrypted values in the form of {cipher}* and, as long as there is a valid key, they are decrypted before the main application context gets the Environment settings. To use the encryption features in an application, you need to include Spring Security RSA in your classpath (Maven co-ordinates: "org.springframework.security:spring-security-rsa"), and you also need the full strength JCE extensions in your JVM.  
Spring Cloud 有一个在本地解密属性值的环境预处理。 它遵循与 Config Server 相同的规则，并通过进行相同的外部配置encrypt.*。因此，您可以使用{cipher}*和形式的加密值，只要有有效的密钥，就可以在主应用程序上下文获得Environment设置之前对它们进行解密。要在应用程序中使用加密功能，您需要在类路径中包含Spring Security RSA（Maven坐标：“ org.springframework.security:spring-security-rsa”），并且您还需要在其中包含完整的JCE扩展。您的JVM。

If you get an exception due to "Illegal key size" and you use Sun’s JDK, you need to install the Java Cryptography Extension (JCE) Unlimited Strength Jurisdiction Policy Files. See the following links for more information:  
如果由于“密钥大小非法”而导致异常，并且使用Sun的JDK，则需要安装Java密码学扩展（JCE）无限强度管辖权策略文件。有关更多信息，请参见以下链接：

* [Java 6 JCE](http://www.oracle.com/technetwork/java/javase/downloads/jce-6-download-429243.html)

* [Java 7 JCE](http://www.oracle.com/technetwork/java/javase/downloads/jce-7-download-432124.html)

* [Java 8 JCE](http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html)

Extract the files into the JDK/jre/lib/security folder for whichever version of JRE/JDK x64/x86 you use.  
将文件解压缩到所使用的JRE / JDK x64 / x86版本的JDK / jre / lib / security文件夹中。

### Endpoints

For a Spring Boot Actuator application, some additional management endpoints are available. You can use:

* POST to /actuator/env to update the Environment and rebind @ConfigurationProperties and log levels.

* /actuator/refresh to re-load the boot strap context and refresh the @RefreshScope beans.

* /actuator/restart to close the ApplicationContext and restart it (disabled by default).

* /actuator/pause and /actuator/resume for calling the Lifecycle methods (stop() and start() on the ApplicationContext).

>	If you disable the /actuator/restart endpoint then the /actuator/pause and /actuator/resume endpoints will also be disabled since they are just a special case of /actuator/restart.

