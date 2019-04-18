# 概述

authentication 你是谁  
authorization 是否允许你操作  

参考：`https://spring.io/guides/topicals/spring-security-architecture/`

## 身份验证和访问控制

### 身份验证

#### AuthenticationManager  

安全策略的接口，有一个实现

```{}
public class ProviderManager implements AuthenticationManager, MessageSourceAware,
  InitializingBean {
  }
```

AuthenticationManager 有一个方法验证身份

```{}
public Authentication authenticate(Authentication authentication)
  throws AuthenticationException; 方法会做三件事
  1. 遍历所有`AuthenticationProvider`s，找到合适的`AuthenticationProvider`，通过`AuthenticationProvider.authenticate()`返回 Authentication，封装了合法的principal
  2. 抛出AuthenticationException认为principal非法
  3. 不能判定时返回null
```

一个`ProviderManager`可以通过分发到 `AuthenticationProviders`，来支持不同机制的authentication  
如果 ProviderManager 不认识 Authentication，则会被跳过。  
ProviderManager有一个可选的parent，以便在所有providers都返回null时，去咨询parent。  
如果没有parent，且返回的Authentication是null，则抛出AuthenticationException  

`AuthenticationProvider`也是一个接口，里面两个方法  
`Authentication authenticate(Authentication authentication) throws AuthenticationException;`
`boolean supports(Class<?> authentication);  查询是否支持这个类型的Authentication`

Sometimes an application has logical groups of protected resources （例如，所有匹配`/api/**`的资源），每个group可以有自己的`AuthenticationManager`.通常，每个`AuthenticationManager`都是`ProviderManager`，他们共享一个parent.The parent is then a kind of "global" resource, 充当所有`providers`的后备资源.

![如图](https://github.com/spring-guides/top-spring-security-architecture/raw/master/images/authentication.png)

Figure 1. An `AuthenticationManager` hierarchy using `ProviderManager`  

#### 自定义 AuthenticationManager

Spring Security 提供了 configuration helpers，可以快速设置的常见身份验证管理器功能。常用的helper是`AuthenticationManagerBuilder`,很适合创建`in-memory`,`JDBC`或者`LDAP` user details，或者拥有增加一个自定义`UserDetailsService`。下面是一个配置全局（父）`AuthenticationManager`的例子:

```{}
@Configuration
public class ApplicationSecurity extends WebSecurityConfigurerAdapter {

   ... // web stuff here

  @Autowired
  public initialize(AuthenticationManagerBuilder builder, DataSource dataSource) {
    builder.jdbcAuthentication().dataSource(dataSource).withUser("dave")
      .password("secret").roles("USER");
  }

}
```

上面只是一个web应用的例子，`AuthenticationManagerBuilder`的实际拥有更广泛。注意`AuthenticationManagerBuilder`使用`@Autowired`注入到一个方法里，这样才构建了配置全局（父）`AuthenticationManager`。相反，如果我们这样：

```{}
@Configuration
public class ApplicationSecurity extends WebSecurityConfigurerAdapter {

  @Autowired
  DataSource dataSource;

   ... // web stuff here

  @Override
  public configure(AuthenticationManagerBuilder builder) {
    builder.jdbcAuthentication().dataSource(dataSource).withUser("dave")
      .password("secret").roles("USER");
  }

}
```

`AuthenticationManagerBuilder` 将仅仅用于构建一个local的`AuthenticationManager`。在Springboot中，你可以用`@Autowired`把全局`AuthenticationManager`注入到两个bean中，but you can’t do that with the local one unless you explicitly expose it yourself.

SpringBoot提供了一个默认的全局`AuthenticationManager`除非你提供自己的bean类型来抢占它`AuthenticationManager`。除非您主动需要自定义全局，否则默认设置足够安全，你不需顾虑太多。  
如果你用任何配置构建了`AuthenticationManager`,you can often do it locally to the resources that you are protecting and not worry about the global default.

## 授权

一旦验证身份之后，我们可以继续判断授权，核心策略是`AccessDecisionManager`。  
框架提供了3个实现，并且都委托给一个`AccessDecisionVoter`链，有点像`ProviderManager`委托给`AuthenticationProviders`。  

一个`AccessDecisionVoter`考虑两个因素：`Authentication`(代表principal)和一个secure `Object`（被`ConfigAttributes`装饰）：  

```{}
boolean supports(ConfigAttribute attribute);

boolean supports(Class<?> clazz);

int vote(Authentication authentication, S object,
        Collection<ConfigAttribute> attributes);
```

那个`Object`在AccessDecisionManager和AccessDecisionVoter的签名中是通用的 - 代表了用户想要访问的任何事务，比如任何资源或者某个Java类的某个方法。`ConfigAttributes`是通用的，代表了那个`Object`的装饰，决定了访问它需要什么级别的权限。  
`ConfigAttribute`是一个接口，只有一个返回String的方法，这些以某种方式编码的strings，代表了允许谁去访问的规则。  
一个典型的`ConfigAttribute`是一个用户的例如角色名称，他们通常有固定的格式或者是一个可被计算的表达式。  

大多数人仅仅使用默认的`AccessDecisionManager`。任何自定义都需要voters，或者增加新的voters，或者修改存在的voters工作方式。  

常见的用法是使用`ConfigAttributes`用的是SpEL表达式,`isFullyAuthenticated() && hasRole('FOO')`。需要`AccessDecisionVoter`能够处理表达式，并为之创建上下文，支持`ConfigAttributes`。  
要扩展可以处理的表达式范围，需要自定义实现，SecurityExpressionRoot有时也需要SecurityExpressionHandler。  

## Web Security

Spring Security in the web tier是基于Filters的，所以看看下图吧：

![示意图](https://github.com/spring-guides/top-spring-security-architecture/raw/master/images/filters.png)

客户端发生一个请求到服务器，容器决定用哪个过滤器。  
过滤链的顺序是非常重要的，Springboot通过两个机制管理：@Beans类型的Filter可以有@Order，其他Filter是`FilterRegistrationBean`  
的一部分，有API来order。一些开箱即用的Filter定义了自己的常量，标记出自己的相对位置。

Spring Security 作为一个单一的Filter安装在过滤链中，他的概念类型是FilterChainProxy， for reasons that will become apparent soon. 在SpringBoot应用中，security filter is a @Bean in the ApplicationContext，被默认安装，拦截所有请求。  

![示意图](https://github.com/spring-guides/top-spring-security-architecture/raw/master/images/security-filters.png)

Figure 2. Spring Security is a single physical Filter but delegates processing to a chain of internal filters

实际上， security filter通常被安装到容器里作为`DelegatingFilterProxy`,不一定非得是一个Spring的@Bean。  
The proxy delegates to a FilterChainProxy which is always a @Bean, usually with a fixed name of springSecurityFilterChain.  

下图中展示了分发过程(/foo/** matches before /**). This is very common but not the only way to match a request. The most important feature of this dispatch process is that only one chain ever handles a request.

![示意图](https://github.com/spring-guides/top-spring-security-architecture/raw/master/images/security-filters-dispatch.png)  

Figure 3. The Spring Security FilterChainProxy dispatches requests to the first chain that matches.

SpringBoot通常默认有n（通常n=6）条链，前(n-1)条直接忽略静态资源和`/error`（等被security.ignored控制的路径）。最后一个链匹配`/**`,包含用于身份验证，授权，异常处理，会话处理，标题写入等的逻辑。默认情况下，此链中总共有11个过滤器，但通常没有必要让用户关注使用哪些过滤器以及何时使用过滤器。

> 注意  
Spring Security内部的所有过滤器都不为容器所知，这一点很重要，尤其是在Spring Boot应用程序中，默认情况下，所有@Beans类型Filter的容器都会自动注册到容器中。  
因此，如果要将自定义过滤器添加到Spring的安全链，则需要将其不设置为@Bean或将封装为`FilterRegistrationBean`明确禁用容器注册的过程中。

## 创建自定义过滤链

默认的fallback filter chain(the one with the /** request matcher)有一个预定义的顺序：`SecurityProperties.BASIC_AUTH_ORDER`。你可以关闭它，通过设置`security.basic.enabled=false`,或者你可以定义一个顺序更靠前的Filter。To do that just add a @Bean of type WebSecurityConfigurerAdapter (or WebSecurityConfigurer) and decorate the class with @Order. Example:

```{}
@Configuration
@Order(SecurityProperties.BASIC_AUTH_ORDER - 10)
public class ApplicationConfigurerAdapter extends WebSecurityConfigurerAdapter {
  @Override
  protected void configure(HttpSecurity http) throws Exception {
    http.antMatcher("/foo/**")
     ...;
  }
}
```

This bean will cause Spring Security to add a new filter chain and order it before the fallback.

许多应用可能对同一组资源有不同的访问规则，那么规则靠前的Filter链会起作用。
