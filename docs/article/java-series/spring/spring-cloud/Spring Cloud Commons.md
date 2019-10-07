
## Spring Cloud Commons: Common Abstractions

Patterns such as service discovery, load balancing, and circuit breakers lend themselves to a common abstraction layer that can be consumed by all Spring Cloud clients, independent of the implementation (for example, discovery with Eureka or Consul).  
服务发现，负载平衡和电路断路器等模式将它们带到一个通用的抽象层，可以由所有Spring Cloud客户端使用，而与实现无关（例如，使用Eureka或Consul进行发现）。  

### @EnableDiscoveryClient

Spring Cloud Commons provides the @EnableDiscoveryClient annotation. This looks for implementations of the DiscoveryClient interface with META-INF/spring.factories. Implementations of the Discovery Client add a configuration class to spring.factories under the org.springframework.cloud.client.discovery.EnableDiscoveryClient key. Examples of DiscoveryClient implementations include Spring Cloud Netflix Eureka, Spring Cloud Consul Discovery, and Spring Cloud Zookeeper Discovery.  
Spring Cloud Commons提供了@EnableDiscoveryClient注释。这将查找具有的DiscoveryClient接口的实现META-INF/spring.factories。Discovery Client的实现将一个配置类添加到 spring.factories该org.springframework.cloud.client.discovery.EnableDiscoveryClient 键下。 DiscoveryClient 实现示例包括 [Spring Cloud Netflix Eureka](https://cloud.spring.io/spring-cloud-netflix/) ，[Spring Cloud Consul Discovery](https://cloud.spring.io/spring-cloud-consul/)和Spring Cloud Zookeeper Discovery。

By default, implementations of DiscoveryClient auto-register the local Spring Boot server with the remote discovery server. This behavior can be disabled by setting autoRegister=false in @EnableDiscoveryClient.  
默认情况下，DiscoveryClient 将本地 Spring Boot 服务器自动注册到远程发现服务器的实现。可以通过 autoRegister=false 在中设置禁用此行为 @EnableDiscoveryClient。

>@EnableDiscoveryClient is no longer required. You can put a DiscoveryClient implementation on the classpath to cause the Spring Boot application to register with the service discovery server.
>不再需要 @EnableDiscoveryClient 。您可以将 DiscoveryClient 实现放在类路径上，以使 Spring Boot 应用程序向服务发现服务器注册。

### Health Indicator

Commons creates a Spring Boot HealthIndicator that DiscoveryClient implementations can participate in by implementing DiscoveryHealthIndicator. To disable the composite HealthIndicator, set spring.cloud.discovery.client.composite-indicator.enabled=false. A generic HealthIndicator based on DiscoveryClient is auto-configured (DiscoveryClientHealthIndicator). To disable it, set spring.cloud.discovery.client.health-indicator.enabled=false. To disable the description field of the DiscoveryClientHealthIndicator, set spring.cloud.discovery.client.health-indicator.include-description=false. Otherwise, it can bubble up as the description of the rolled up HealthIndicator.  
Commons 创建了一个 Spring Boot HealthIndicator，DiscoveryClient 实现可以通过实现来参与 DiscoveryHealthIndicator 。要禁用复合 HealthIndicator ，请设置spring.cloud.discovery.client.composite-indicator.enabled=false 。自动配置了通用HealthIndicator依据。要禁用它，请设置。要禁用的描述字段，请设置。否则，它可以冒泡作为的卷起。  
DiscoveryClientDiscoveryClientHealthIndicatorspring.cloud.discovery.client.health-indicator.enabled=falseDiscoveryClientHealthIndicatorspring.cloud.discovery.client.health-indicator.include-description=falsedescriptionHealthIndicator

### Ordering DiscoveryClient instances

DiscoveryClient interface extends Ordered. This is useful when using multiple discovery clients, as it allows you to define the order of the returned discovery clients, similar to how you can order the beans loaded by a Spring application. By default, the order of any DiscoveryClient is set to 0. If you want to set a different order for your custom DiscoveryClient implementations, you just need to override the getOrder() method so that it returns the value that is suitable for your setup. Apart from this, you can use properties to set the order of the DiscoveryClient implementations provided by Spring Cloud, among others ConsulDiscoveryClient, EurekaDiscoveryClient and ZookeeperDiscoveryClient. In order to do it, you just need to set the spring.cloud.{clientIdentifier}.discovery.order (or eureka.client.order for Eureka) property to the desired value.  

DiscoveryClient 接口扩展 Ordered。当使用多个发现客户端时，这很有用，因为它允许您定义返回的发现客户端的顺序，类似于如何订购Spring应用程序加载的bean。默认情况下，any的顺序DiscoveryClient设置为 0。如果要为自定义DiscoveryClient实现设置不同的顺序，则只需要重写该getOrder()方法，以便它返回适合您的设置的值。除了这个，你可以使用属性来设置的顺序DiscoveryClient 由Spring提供的云计算等等的实现ConsulDiscoveryClient，EurekaDiscoveryClient和 ZookeeperDiscoveryClient。为此，您只需将 spring.cloud.{clientIdentifier}.discovery.order（或eureka.client.orderEureka）属性设置为所需值。

### ServiceRegistry

Commons now provides a ServiceRegistry interface that provides methods such as register(Registration) and deregister(Registration), which let you provide custom registered services. Registration is a marker interface.

The following example shows the ServiceRegistry in use:

```
@Configuration
@EnableDiscoveryClient(autoRegister=false)
public class MyConfiguration {
    private ServiceRegistry registry;

    public MyConfiguration(ServiceRegistry registry) {
        this.registry = registry;
    }

    // called through some external process, such as an event or a custom actuator endpoint
    public void register() {
        Registration registration = constructRegistration();
        this.registry.register(registration);
    }
}
```

Each ServiceRegistry implementation has its own Registry implementation.

* ZookeeperRegistration used with ZookeeperServiceRegistry

* EurekaRegistration used with EurekaServiceRegistry

* ConsulRegistration used with ConsulServiceRegistry

If you are using the ServiceRegistry interface, you are going to need to pass the correct Registry implementation for the ServiceRegistry implementation you are using.

### ServiceRegistry Auto-Registration

By default, the ServiceRegistry implementation auto-registers the running service. To disable that behavior, you can set: * @EnableDiscoveryClient(autoRegister=false) to permanently disable auto-registration. * spring.cloud.service-registry.auto-registration.enabled=false to disable the behavior through configuration.

### ServiceRegistry Auto-Registration Events

There are two events that will be fired when a service auto-registers. The first event, called InstancePreRegisteredEvent, is fired before the service is registered. The second event, called InstanceRegisteredEvent, is fired after the service is registered. You can register an ApplicationListener(s) to listen to and react to these events.

>These events will not be fired if spring.cloud.service-registry.auto-registration.enabled is set to false.

### Service Registry Actuator Endpoint

Spring Cloud Commons provides a /service-registry actuator endpoint. This endpoint relies on a Registration bean in the Spring Application Context. Calling /service-registry with GET returns the status of the Registration. Using POST to the same endpoint with a JSON body changes the status of the current Registration to the new value. The JSON body has to include the status field with the preferred value. Please see the documentation of the ServiceRegistry implementation you use for the allowed values when updating the status and the values returned for the status. For instance, Eureka’s supported statuses are UP, DOWN, OUT_OF_SERVICE, and UNKNOWN.

### Spring RestTemplate as a Load Balancer Client

RestTemplate can be automatically configured to use a Load-balancer client under the hood. To create a load-balanced RestTemplate, create a RestTemplate @Bean and use the @LoadBalanced qualifier, as shown in the following example:
```
@Configuration
public class MyConfiguration {

    @LoadBalanced
    @Bean
    RestTemplate restTemplate() {
        return new RestTemplate();
    }
}

public class MyClass {
    @Autowired
    private RestTemplate restTemplate;

    public String doOtherStuff() {
        String results = restTemplate.getForObject("http://stores/stores", String.class);
        return results;
    }
}
```

A RestTemplate bean is no longer created through auto-configuration. Individual applications must create it.

The URI needs to use a virtual host name (that is, a service name, not a host name). The Ribbon client is used to create a full physical address. See RibbonAutoConfiguration for details of how the RestTemplate is set up.

>In order to use a load-balanced RestTemplate, you need to have a load-balancer implementation in your classpath. The recommended implementation is BlockingLoadBalancerClient - add org.springframework.cloud:spring-cloud-loadbalancer in order to use it. The RibbonLoadBalancerClient also can be used, but it’s now under maintenance and we do not recommend adding it to new projects.

>	If you want to use BlockingLoadBalancerClient, make sure you do not have RibbonLoadBalancerClient in the project classpath, as for backward compatibility reasons, it will be used by default.

### Spring WebClient as a Load Balancer Client

WebClient can be automatically configured to use a load-balancer client. To create a load-balanced WebClient, create a WebClient.Builder @Bean and use the @LoadBalanced qualifier, as shown in the following example:

```
@Configuration
public class MyConfiguration {

	@Bean
	@LoadBalanced
	public WebClient.Builder loadBalancedWebClientBuilder() {
		return WebClient.builder();
	}
}

public class MyClass {
    @Autowired
    private WebClient.Builder webClientBuilder;

    public Mono<String> doOtherStuff() {
        return webClientBuilder.build().get().uri("http://stores/stores")
        				.retrieve().bodyToMono(String.class);
    }
}
```

The URI needs to use a virtual host name (that is, a service name, not a host name). The Ribbon client is used to create a full physical address.

>If you want to use a @LoadBalanced WebClient.Builder, you need to have a loadbalancer implementation in the classpath. It is recommended that you add the org.springframework.cloud:spring-cloud-loadbalancer dependency to your project. Then, ReactiveLoadBalancer will be used underneath. Alternatively, this functionality will also work with spring-cloud-starter-netflix-ribbon, but the request will be handled by a non-reactive LoadBalancerClient under the hood. Additionally, spring-cloud-starter-netflix-ribbon is already in maintenance mode, so we do not recommned adding it to new projects.

>	The ReactorLoadBalancer used underneath supports caching. If cacheManager is detected, cached version of ServiceInstanceSupplier will be used. If not, we will retrieve instances from discovery service without caching them. We recommend enabling caching in your project if you use ReactiveLoadBalancer.

### Retrying Failed Requests

A load-balanced RestTemplate can be configured to retry failed requests. By default, this logic is disabled. You can enable it by adding Spring Retry to your application’s classpath. The load-balanced RestTemplate honors some of the Ribbon configuration values related to retrying failed requests. You can use client.ribbon.MaxAutoRetries, client.ribbon.MaxAutoRetriesNextServer, and client.ribbon.OkToRetryOnAllOperations properties. If you would like to disable the retry logic with Spring Retry on the classpath, you can set spring.cloud.loadbalancer.retry.enabled=false. See the Ribbon documentation for a description of what these properties do.

If you would like to implement a BackOffPolicy in your retries, you need to create a bean of type LoadBalancedRetryFactory and override the createBackOffPolicy method:

```
@Configuration
public class MyConfiguration {
    @Bean
    LoadBalancedRetryFactory retryFactory() {
        return new LoadBalancedRetryFactory() {
            @Override
            public BackOffPolicy createBackOffPolicy(String service) {
        		return new ExponentialBackOffPolicy();
        	}
        };
    }
}
```

>client in the preceding examples should be replaced with your Ribbon client’s name.

If you want to add one or more RetryListener implementations to your retry functionality, you need to create a bean of type LoadBalancedRetryListenerFactory and return the RetryListener array you would like to use for a given service, as shown in the following example:

```
@Configuration
public class MyConfiguration {
    @Bean
    LoadBalancedRetryListenerFactory retryListenerFactory() {
        return new LoadBalancedRetryListenerFactory() {
            @Override
            public RetryListener[] createRetryListeners(String service) {
                return new RetryListener[]{new RetryListener() {
                    @Override
                    public <T, E extends Throwable> boolean open(RetryContext context, RetryCallback<T, E> callback) {
                        //TODO Do you business...
                        return true;
                    }

                    @Override
                     public <T, E extends Throwable> void close(RetryContext context, RetryCallback<T, E> callback, Throwable throwable) {
                        //TODO Do you business...
                    }

                    @Override
                    public <T, E extends Throwable> void onError(RetryContext context, RetryCallback<T, E> callback, Throwable throwable) {
                        //TODO Do you business...
                    }
                }};
            }
        };
    }
}
```

### Multiple RestTemplate objects

If you want a RestTemplate that is not load-balanced, create a RestTemplate bean and inject it. To access the load-balanced RestTemplate, use the @LoadBalanced qualifier when you create your @Bean, as shown in the following example:\

```
@Configuration
public class MyConfiguration {

    @LoadBalanced
    @Bean
    RestTemplate loadBalanced() {
        return new RestTemplate();
    }

    @Primary
    @Bean
    RestTemplate restTemplate() {
        return new RestTemplate();
    }
}

public class MyClass {
    @Autowired
    private RestTemplate restTemplate;

    @Autowired
    @LoadBalanced
    private RestTemplate loadBalanced;

    public String doOtherStuff() {
        return loadBalanced.getForObject("http://stores/stores", String.class);
    }

    public String doStuff() {
        return restTemplate.getForObject("http://example.com", String.class);
    }
}
```

>Notice the use of the @Primary annotation on the plain RestTemplate declaration in the preceding example to disambiguate the unqualified @Autowired injection.

>	If you see errors such as java.lang.IllegalArgumentException: Can not set org.springframework.web.client.RestTemplate field com.my.app.Foo.restTemplate to com.sun.proxy.$Proxy89, try injecting RestOperations or setting spring.aop.proxyTargetClass=true.

### Spring WebFlux WebClient as a Load Balancer Client

#### Spring WebFlux WebClient with Reactive Load Balancer

WebClient can be configured to use the ReactiveLoadBalancer. If you add org.springframework.cloud:spring-cloud-loadbalancer to your project, ReactorLoadBalancerExchangeFilterFunction is auto-configured if spring-webflux is on the classpath. The following example shows how to configure a WebClient to use reactive load balancer under the hood:

```
public class MyClass {
    @Autowired
    private ReactorLoadBalancerExchangeFilterFunction lbFunction;

    public Mono<String> doOtherStuff() {
        return WebClient.builder().baseUrl("http://stores")
            .filter(lbFunction)
            .build()
            .get()
            .uri("/stores")
            .retrieve()
            .bodyToMono(String.class);
    }
}
```

The URI needs to use a virtual host name (that is, a service name, not a host name). The ReactorLoadBalancerClient is used to create a full physical address.

#### Spring WebFlux WebClient with non-reactive Load Balancer Client

If you you don’t have org.springframework.cloud:spring-cloud-loadbalancer in your project, but you do have spring-cloud-starter-netflix-ribbon, you can still use WebClient with LoadBalancerClient. LoadBalancerExchangeFilterFunction will be auto-configured if spring-webflux is on the classpath. Please note, however, that this is uses a non-reactive client under the hood. The following example shows how to configure a WebClient to use load balancer:

```
public class MyClass {
    @Autowired
    private LoadBalancerExchangeFilterFunction lbFunction;

    public Mono<String> doOtherStuff() {
        return WebClient.builder().baseUrl("http://stores")
            .filter(lbFunction)
            .build()
            .get()
            .uri("/stores")
            .retrieve()
            .bodyToMono(String.class);
    }
}
```

The URI needs to use a virtual host name (that is, a service name, not a host name). The LoadBalancerClient is used to create a full physical address.

WARN: This approach is now deprecated. We suggest you use WebFlux with reactive Load-Balancer instead.

#### Passing your own Load-Balancer Client configuration

You can also use the @LoadBalancerClient annotation to pass your own load-balancer client configuration, passing the name of the load-balancer client and the configuration class, like so:

```
@Configuration
@LoadBalancerClient(value = "stores", configuration = StoresLoadBalancerClientConfiguration.class)
public class MyConfiguration {

	@Bean
	@LoadBalanced
	public WebClient.Builder loadBalancedWebClientBuilder() {
		return WebClient.builder();
	}
}
```

It is also possible to pass together multiple configurations (for more than one load-balancer client) via the @LoadBalancerClients annotation, as shown below:

```
@Configuration
@LoadBalancerClients({@LoadBalancerClient(value = "stores", configuration = StoresLoadBalancerClientConfiguration.class), @LoadBalancerClient(value = "customers", configuration = CustomersLoadBalancerClientConfiguration.class)})
public class MyConfiguration {

	@Bean
	@LoadBalanced
	public WebClient.Builder loadBalancedWebClientBuilder() {
		return WebClient.builder();
	}
}
```

### Ignore Network Interfaces

Sometimes, it is useful to ignore certain named network interfaces so that they can be excluded from Service Discovery registration (for example, when running in a Docker container). A list of regular expressions can be set to cause the desired network interfaces to be ignored. The following configuration ignores the docker0 interface and all interfaces that start with veth:

**application.yml**

```
spring:
  cloud:
    inetutils:
      ignoredInterfaces:
        - docker0
        - veth.*
```

You can also force the use of only specified network addresses by using a list of regular expressions, as shown in the following example:

**bootstrap.yml**

```
spring:
  cloud:
    inetutils:
      preferredNetworks:
        - 192.168
        - 10.0
```
You can also force the use of only site-local addresses, as shown in the following example: .application.yml
```
spring:
  cloud:
    inetutils:
      useOnlySiteLocalInterfaces: true
```
See Inet4Address.html.isSiteLocalAddress() for more details about what constitutes a site-local address.

### HTTP Client Factories

Spring Cloud Commons provides beans for creating both Apache HTTP clients (ApacheHttpClientFactory) and OK HTTP clients (OkHttpClientFactory). The OkHttpClientFactory bean is created only if the OK HTTP jar is on the classpath. In addition, Spring Cloud Commons provides beans for creating the connection managers used by both clients: ApacheHttpClientConnectionManagerFactory for the Apache HTTP client and OkHttpClientConnectionPoolFactory for the OK HTTP client. If you would like to customize how the HTTP clients are created in downstream projects, you can provide your own implementation of these beans. In addition, if you provide a bean of type HttpClientBuilder or OkHttpClient.Builder, the default factories use these builders as the basis for the builders returned to downstream projects. You can also disable the creation of these beans by setting spring.cloud.httpclientfactories.apache.enabled or spring.cloud.httpclientfactories.ok.enabled to false.

### Enabled Features

Spring Cloud Commons provides a `/features` actuator endpoint. This endpoint returns features available on the classpath and whether they are enabled. The information returned includes the feature type, name, version, and vendor.

#### Feature types

There are two types of 'features': abstract and named.

Abstract features are features where an interface or abstract class is defined and that an implementation the creates, such as DiscoveryClient, LoadBalancerClient, or LockService. The abstract class or interface is used to find a bean of that type in the context. The version displayed is bean.getClass().getPackage().getImplementationVersion().

Named features are features that do not have a particular class they implement, such as "Circuit Breaker", "API Gateway", "Spring Cloud Bus", and others. These features require a name and a bean type.

#### Declaring features

Any module can declare any number of HasFeature beans, as shown in the following examples:

```
@Bean
public HasFeatures commonsFeatures() {
  return HasFeatures.abstractFeatures(DiscoveryClient.class, LoadBalancerClient.class);
}

@Bean
public HasFeatures consulFeatures() {
  return HasFeatures.namedFeatures(
    new NamedFeature("Spring Cloud Bus", ConsulBusAutoConfiguration.class),
    new NamedFeature("Circuit Breaker", HystrixCommandAspect.class));
}

@Bean
HasFeatures localFeatures() {
  return HasFeatures.builder()
      .abstractFeature(Foo.class)
      .namedFeature(new NamedFeature("Bar Feature", Bar.class))
      .abstractFeature(Baz.class)
      .build();
}
```

Each of these beans should go in an appropriately guarded @Configuration.

### Spring Cloud Compatibility Verification

Due to the fact that some users have problem with setting up Spring Cloud application, we’ve decided to add a compatibility verification mechanism. It will break if your current setup is not compatible with Spring Cloud requirements, together with a report, showing what exactly went wrong.

At the moment we verify which version of Spring Boot is added to your classpath.

Example of a report

```
***************************
APPLICATION FAILED TO START
***************************

Description:

Your project setup is incompatible with our requirements due to following reasons:

- Spring Boot [2.1.0.RELEASE] is not compatible with this Spring Cloud release train


Action:

Consider applying the following actions:

- Change Spring Boot version to one of the following versions [1.2.x, 1.3.x] .
You can find the latest Spring Boot versions here [https://spring.io/projects/spring-boot#learn].
If you want to learn more about the Spring Cloud Release train compatibility, you can visit this page [https://spring.io/projects/spring-cloud#overview] and check the [Release Trains] section.
```

In order to disable this feature, set spring.cloud.compatibility-verifier.enabled to false. If you want to override the compatible Spring Boot versions, just set the spring.cloud.compatibility-verifier.compatible-boot-versions property with a comma separated list of compatible Spring Boot versions.