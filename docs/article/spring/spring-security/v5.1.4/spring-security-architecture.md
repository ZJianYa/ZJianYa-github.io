# 概述  

参考：`https://spring.io/guides/topicals/spring-security-architecture/`

This guide is a primer for Spring Security, offering insight into the design and basic building blocks of the framework. We only cover the very basics of application security but in doing so we can clear up some of the confusion experienced by developers using Spring Security. To do this we take a look at the way security is applied in web applications using filters and more generally using method annotations. Use this guide when you need to understand at a high level how a secure application works, and how it can be customized, or if you just need to learn how to think about application security.

本指南是Spring Security的入门读物，可深入了解框架的设计和基本构建块。我们只介绍应用程序安全性的基础知识，但这样做可以消除使用Spring Security的开发人员所遇到的一些困惑。为此，我们将介绍使用过滤器在Web应用程序中应用安全性的方式，更常见的是使用方法注解。当你需要从一个高层次的角度理解 a secure application 是如何工作的，可以怎么自定义，或者你只是要学习如何考虑应用程序安全性时，你可以使用这个指南。

This guide is not intended as a manual or recipe for solving more than the most basic problems (there are other sources for those), but it could be useful for beginners and experts alike. Spring Boot is also referred to a lot because it provides some default behaviour for a secure application and it can be useful to understand how that fits in with the overall architecture. All of the principles apply equally well to applications that do not use Spring Boot.

本指南不是作为解决超过最基本问题的手册或秘诀（还有其他来源），但它对初学者和专家都很有用。Spring Boot也引用了很多，因为它为安全应用程序提供了一些默认行为，了解它如何适应整体架构非常有用。所有原则同样适用于不使用Spring Boot的应用程序。

## 身份验证和访问控制

Application security boils down to two more or less independent problems: authentication (who are you?) and authorization (what are you allowed to do?). Sometimes people say "access control" instead of "authorization" which can get confusing, but it can be helpful to think of it that way because "authorization" is overloaded in other places. Spring Security has an architecture that is designed to separate authentication from authorization, and has strategies and extension points for both.

应用程序安全性可归结为两个或多或少独立的问题：身份验证（您是谁？）和授权（您可以做什么？）。有时人们会说“访问控制”而不是“授权”，这可能会让人感到困惑，但以这种方式来思考是有帮助的，因为“授权”会在其他地方超载。Spring Security的架构旨在将身份验证与授权分开，并为两者提供策略和扩展点。

### 身份验证

The main strategy interface for authentication is AuthenticationManager which only has one method:  
用于身份认证的安全策略的接口 `AuthenticationManager` 有一个实现类，只有一个方法

```{}
public class ProviderManager implements AuthenticationManager, MessageSourceAware,
  InitializingBean {
  }
```

An AuthenticationManager can do one of 3 things in its authenticate() method:  
AuthenticationManager 有一个方法验证身份，可以有3种结果中的一个：  

```{}
public Authentication authenticate(Authentication authentication)
  throws AuthenticationException; 方法会做三件事
  1. return an Authentication (normally with authenticated=true) if it can verify that the input represents a valid principal.
    遍历所有`AuthenticationProvider`s，找到合适的`AuthenticationProvider`，通过`AuthenticationProvider.authenticate()`返回 Authentication（封装了合法的principal）
  2. 抛出 AuthenticationException 认为 principal 非法
  3. 不能判定时返回null
```

`AuthenticationException` is a runtime exception. It is usually handled by an application in a generic way, depending on the style or purpose of the application. In other words user code is not normally expected to catch and handle it. For example, a web UI will render a page that says that the authentication failed, and a backend HTTP service will send a 401 response, with or without a `WWW-Authenticate` header depending on the context.

AuthenticationException 是一个运行时异常，由应用的处理风格、目的来决定处理方式。换而言之，用户会自己处理。例如 PC web类的应用会提供一个页面，而 http 服务则会提供401。

The most commonly used implementation of AuthenticationManager is ProviderManager, which delegates to a chain of AuthenticationProvider instances. An AuthenticationProvider is a bit like an AuthenticationManager but it has an extra method to allow the caller to query if it supports a given Authentication type:

```{}
public interface AuthenticationProvider {

  Authentication authenticate(Authentication authentication)
    throws AuthenticationException;

  boolean supports(Class<?> authentication);

}
```

The `Class<?>` argument in the supports() method is really Class<? extends Authentication> (it will only ever be asked if it supports something that will be passed into the authenticate() method). A ProviderManager can support multiple different authentication mechanisms in the same application by delegating to a chain of AuthenticationProviders. If a ProviderManager doesn’t recognise a particular Authentication instance type it will be skipped.

`ProviderManager`可以支持不同的`authentication`机制，通过分发到`AuthenticationProviders`链上。如果 ProviderManager 不认识 `Authentication`，则会被跳过。  

A ProviderManager has an optional parent, which it can consult if all providers return null. If the parent is not available then a null Authentication results in an AuthenticationException.

ProviderManager有一个可选的parent，以便在所有providers都返回null时，去咨询parent。如果没有parent，且返回的Authentication是null，则抛出 `AuthenticationException`  

Sometimes an application has logical groups of protected resources (e.g. all web resources that match a path pattern /api/**), and each group can have its own dedicated AuthenticationManager. Often, each of those is a ProviderManager, and they share a parent. The parent is then a kind of "global" resource, acting as a fallback for all providers.

有时候应用的逻辑组（如用户组）享有受保护的资源 （例如，所有匹配`/api/**`的资源），每个group可以有自己的`AuthenticationManager`.通常，每个`AuthenticationManager`都是`ProviderManager`，他们共享一个parent.The parent is then a kind of "global" resource, 充当所有`providers`的后备资源.

![如图](https://github.com/spring-guides/top-spring-security-architecture/raw/master/images/authentication.png)

Figure 1. An `AuthenticationManager` hierarchy using `ProviderManager`  

#### 自定义 Authentication Managers

Spring Security provides some configuration helpers to quickly get common authentication manager features set up in your application. The most commonly used helper is the AuthenticationManagerBuilder which is great for setting up in-memory, JDBC or LDAP user details, or for adding a custom UserDetailsService. Here’s an example of an application configuring the global (parent) AuthenticationManager:

Spring Security 提供了 configuration helpers ，可以快速设置的常见身份验证管理器功能。常用的helper是`AuthenticationManagerBuilder`,很适合创建`in-memory`,`JDBC`或者`LDAP` user details，或者拥有增加一个自定义`UserDetailsService`。下面是一个配置全局（父）`AuthenticationManager`的例子:

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

This example relates to a web application, but the usage of AuthenticationManagerBuilder is more widely applicable (see below for more detail on how web application security is implemented). Note that the AuthenticationManagerBuilder is @Autowired into a method in a @Bean - that is what makes it build the global (parent) AuthenticationManager. In contrast if we had done it this way:

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

(using an @Override of a method in the configurer) then the AuthenticationManagerBuilder is only used to build a "local" AuthenticationManager, which is a child of the global one. In a Spring Boot application you can @Autowired the global one into another bean, but you can’t do that with the local one unless you explicitly expose it yourself.

`AuthenticationManagerBuilder` 将仅仅用于构建一个local的`AuthenticationManager`。在Springboot中，你可以用`@Autowired`把全局`AuthenticationManager`注入到另一个bean中，but you can’t do that with the local one unless you explicitly expose it yourself.

Spring Boot provides a default global AuthenticationManager (with just one user) unless you pre-empt it by providing your own bean of type AuthenticationManager. The default is secure enough on its own for you not to have to worry about it much, unless you actively need a custom global AuthenticationManager. If you do any configuration that builds an AuthenticationManager you can often do it locally to the resources that you are protecting and not worry about the global default.

SpringBoot提供了一个默认的全局`AuthenticationManager`除非你提供自己的bean类型来抢占。除非您主动需要自定义全局，否则默认设置足够安全，你不需顾虑太多。  
如果你用任何配置构建了`AuthenticationManager`,you can often do it locally to the resources that you are protecting and not worry about the global default.

## 授权

Once authentication is successful, we can move on to authorization, and the core strategy here is `AccessDecisionManager`. There are three implementations provided by the framework and all three delegate to a chain of AccessDecisionVoter, a bit like the ProviderManager delegates to AuthenticationProviders.

一旦验证身份之后，我们可以继续判断授权，核心策略是`AccessDecisionManager`。  
框架提供了3个实现，并且都委托给一个`AccessDecisionVoter`链，有点像`ProviderManager`委托给`AuthenticationProviders`。  

An AccessDecisionVoter considers an Authentication (representing a principal) and a secure Object which as been decorated with ConfigAttributes:

一个`AccessDecisionVoter`考虑两个因素：`Authentication`(代表principal)和一个secure `Object`（被`ConfigAttributes`装饰）：  

```{}
boolean supports(ConfigAttribute attribute);

boolean supports(Class<?> clazz);

int vote(Authentication authentication, S object,
        Collection<ConfigAttribute> attributes);
```

The Object is completely generic in the signatures of the AccessDecisionManager and AccessDecisionVoter - it represents anything that a user might want to access (a web resource or a method in a Java class are the two most common cases). The ConfigAttributes are also fairly generic, representing a decoration of the secure Object with some metadata that determine the level of permission required to access it. ConfigAttribute is an interface but it only has one method which is quite generic and returns a String, so these strings encode in some way the intention of the owner of the resource, expressing rules about who is allowed to access it. A typical ConfigAttribute is the name of a user role (like ROLE_ADMIN or ROLE_AUDIT), and they often have special formats (like the ROLE_ prefix) or represent expressions that need to be evaluated.

那个`Object`在AccessDecisionManager和AccessDecisionVoter的签名中是通用的 - 代表了用户想要访问的任何事务，比如任何资源或者某个Java类的某个方法。`ConfigAttributes`是通用的，代表了那个`Object`的装饰，决定了访问它需要什么级别的权限。  
`ConfigAttribute`是一个接口，只有一个返回String的方法，这些以某种方式编码的strings，代表了允许谁去访问的规则。  
一个典型的`ConfigAttribute`是一个用户的例如角色名称，他们通常有固定的格式或者是一个可被计算的表达式。  

Most people just use the default AccessDecisionManager which is AffirmativeBased (if no voters decline then access is granted). Any customization tends to happen in the voters, either adding new ones, or modifying the way that the existing ones work.

大多数人仅仅使用默认的`AccessDecisionManager`。任何定制都倾向于在 voters 发生，或者增加新的voters，或者修改存在的voters工作方式。  

It is very common to use ConfigAttributes that are Spring Expression Language (SpEL) expressions, for example isFullyAuthenticated() && hasRole('FOO'). This is supported by an AccessDecisionVoter that can handle the expressions and create a context for them. To extend the range of expressions that can be handled requires a custom implementation of SecurityExpressionRoot and sometimes also SecurityExpressionHandler.

常见的用法是使用`ConfigAttributes`用的是SpEL表达式,`isFullyAuthenticated() && hasRole('FOO')`。需要`AccessDecisionVoter`能够处理表达式，并为之创建上下文，支持`ConfigAttributes`。  
要扩展可以处理的表达式范围，需要自定义实现， SecurityExpressionRoot 有时也需要 SecurityExpressionHandler 。  

## Web Security

Spring Security in the web tier是基于Filters的，所以看看下图吧：

![示意图](https://github.com/spring-guides/top-spring-security-architecture/raw/master/images/filters.png)

The client sends a request to the app, and the container decides which filters and which servlet apply to it based on the path of the request URI. At most one servlet can handle a single request, but filters form a chain, so they are ordered, and in fact a filter can veto the rest of the chain if it wants to handle the request itself. A filter can also modify the request and/or the response used in the downstream filters and servlet. The order of the filter chain is very important, and Spring Boot manages it through 2 mechanisms: one is that @Beans of type Filter can have an @Order or implement Ordered, and the other is that they can be part of a FilterRegistrationBean that itself has an order as part of its API. Some off-the-shelf filters define their own constants to help signal what order they like to be in relative to each other (e.g. the SessionRepositoryFilter from Spring Session has a DEFAULT_ORDER of Integer.MIN_VALUE + 50, which tells us it likes to be early in the chain, but it doesn’t rule out other filters coming before it).

客户端发送一个请求到服务器，容器决定用哪个过滤器。大多数情况下 Servlet 可以处理一个 request，但是过滤链上的Filter是有序的，前面的Filter可以决定是否调用后面的Filter。  
过滤链的顺序是非常重要的，Springboot通过两个机制管理：@Beans类型的Filter可以有@Order，其他Filter是`FilterRegistrationBean`  
的一部分，has an order as part of its API。一些开箱即用的Filter定义了自己的常量，标记出自己的相对位置（例如 SessionRepositoryFilter 默认order 是 Integer.MIN_VALUE + 50，告诉我们 他要出现在过滤链的前部，但是并不排除其前的其他过滤器）。  

Spring Security is installed as a single Filter in the chain, and its concerete type is FilterChainProxy, for reasons that will become apparent soon. In a Spring Boot app the security filter is a @Bean in the ApplicationContext, and it is installed by default so that it is applied to every request. It is installed at a position defined by SecurityProperties.DEFAULT_FILTER_ORDER, which in turn is anchored by FilterRegistrationBean.REQUEST_WRAPPER_FILTER_MAX_ORDER (the maximum order that a Spring Boot app expects filters to have if they wrap the request, modifying its behaviour). There’s more to it than that though: from the point of view of the container Spring Security is a single filter, but inside it there are additional filters, each playing a special role. Here’s a picture:

Spring Security 作为一个单一的Filter安装在过滤链中，他的概念类型是 `FilterChainProxy`， for reasons that will become apparent soon. 在SpringBoot应用中，FilterChainProxy 在 ApplicationContext 中是一个 @Bean，被默认安装，可以处理所有每个请求。它的位置是  SecurityProperties.DEFAULT_FILTER_ORDER ，依次是 FilterRegistrationBean.REQUEST_WRAPPER_FILTER_MAX_ORDER (the maximum order that a Spring Boot app expects filters to have if they wrap the request, modifying its behaviour). 除此之外还有更多：从容器的角度来看，Spring Security是一个单独的过滤器，但在其中有一些额外的过滤器，每个过滤器都扮演着特殊的角色。这是一张图片：

![示意图](https://github.com/spring-guides/top-spring-security-architecture/raw/master/images/security-filters.png)

Figure 2. Spring Security is a single physical Filter but delegates processing to a chain of internal filters

In fact there is even one more layer of indirection in the security filter: it is usually installed in the container as a DelegatingFilterProxy, which does not have to be a Spring @Bean. The proxy delegates to a FilterChainProxy which is always a @Bean, usually with a fixed name of springSecurityFilterChain. It is the FilterChainProxy which contains all the security logic arranged internally as a chain (or chains) of filters. All the filters have the same API (they all implement the Filter interface from the Servlet Spec) and they all have the opportunity to veto the rest of the chain.

实际上， 在 the security filter 中还有一层： the security filter  通常被安装到容器里作为`DelegatingFilterProxy`,不一定非得是一个Spring的@Bean。  
The proxy delegates to a FilterChainProxy which is always a @Bean, usually with a fixed name of springSecurityFilterChain.  

There can be multiple filter chains all managed by Spring Security in the same top level FilterChainProxy and all unknown to the container. The Spring Security filter contains a list of filter chains, and dispatches a request to the first chain that matches it. The picture below shows the dispatch happening based on matching the request path (/foo/** matches before /**). This is very common but not the only way to match a request. The most important feature of this dispatch process is that only one chain ever handles a request.

The Spring Security filter 包含了一个 filter chains 的list，把请求分发给匹配到的第一个链。
下图中展示了分发过程(/foo/** matches before /**). This is very common but not the only way to match a request. The most important feature of this dispatch process is that only one chain ever handles a request.

![示意图](https://github.com/spring-guides/top-spring-security-architecture/raw/master/images/security-filters-dispatch.png)  

Figure 3. The Spring Security FilterChainProxy dispatches requests to the first chain that matches.

A vanilla Spring Boot application with no custom security configuration has a several (call it n) filter chains, where usually n=6. The first (n-1) chains are there just to ignore static resource patterns, like `/css/**` and `/images/**`, and the error view /error (the paths can be controlled by the user with security.ignored from the SecurityProperties configuration bean). The last chain matches the catch all path `/**` and is more active, containing logic for authentication, authorization, exception handling, session handling, header writing, etc. There are a total of 11 filters in this chain by default, but normally it is not necessary for users to concern themselves with which filters are used and when.

SpringBoot通常默认有n（通常n=6）条链，前(n-1)条直接忽略静态资源和`/error`（等被 `security.ignored`控制的路径）。最后一个链匹配`/**`,包含用于身份验证，授权，异常处理，会话处理，标题写入等的逻辑。默认情况下，此链中总共有11个过滤器，但通常没有必要让用户关注使用哪些过滤器以及何时使用过滤器。

> 注意  
Spring Security内部的所有过滤器都不为容器所知，这一点很重要，尤其是在Spring Boot应用程序中，默认情况下，所有@Beans类型Filter的容器都会自动注册到容器中。  
因此，如果要将自定义过滤器添加到Spring的安全链，则需要将其不设置为@Bean或将封装为`FilterRegistrationBean`明确禁用容器注册的过程中。

### 创建自定义过滤链

The default fallback filter chain in a Spring Boot app (the one with the /** request matcher) has a predefined order of SecurityProperties.BASIC_AUTH_ORDER. You can switch it off completely by setting security.basic.enabled=false, or you can use it as a fallback and just define other rules with a lower order. To do that just add a @Bean of type WebSecurityConfigurerAdapter (or WebSecurityConfigurer) and decorate the class with @Order. Example:

默认的 fallback filter chain(the one with the /** request matcher) 有一个预定义的顺序：`SecurityProperties.BASIC_AUTH_ORDER`。你可以关闭它，通过设置`security.basic.enabled=false`,或者你可以定义一个顺序更靠前的Filter。To do that just add a @Bean of type WebSecurityConfigurerAdapter (or WebSecurityConfigurer) and decorate the class with @Order. Example:

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

Many applications have completely different access rules for one set of resources compared to another. For example an application that hosts a UI and a backing API might support cookie-based authentication with a redirect to a login page for the UI parts, and token-based authentication with a 401 response to unauthenticated requests for the API parts. Each set of resources has its own WebSecurityConfigurerAdapter with a unique order and a its own request matcher. If the matching rules overlap the earliest ordered filter chain will win.

许多应用可能对同一组资源有不同的访问规则，那么规则靠前的Filter链会起作用。

### 请求匹配和授权

Request Matching for Dispatch and Authorization

A security filter chain (or equivalently a WebSecurityConfigurerAdapter) has a request matcher that is used for deciding whether to apply it to an HTTP request. Once the decision is made to apply a particular filter chain, no others are applied. But within a filter chain you can have more fine grained control of authorization by setting additional matchers in the HttpSecurity configurer. Example:

安全过滤器链（或等效于 一个`WebSecurityConfigurerAdapter`）具有请求匹配器，用于决定是否将其应用于HTTP请求。一旦决定应用特定过滤器链，则不应用其他过滤器链。但是在过滤器链中，您可以通过在HttpSecurity配置器中设置其他匹配器来对授权进行更精细的控制。例：

```{}
@Configuration
@Order(SecurityProperties.BASIC_AUTH_ORDER - 10)
public class ApplicationConfigurerAdapter extends WebSecurityConfigurerAdapter {
  @Override
  protected void configure(HttpSecurity http) throws Exception {
    http.antMatcher("/foo/**")
      .authorizeRequests()
        .antMatchers("/foo/bar").hasRole("BAR")
        .antMatchers("/foo/spam").hasRole("SPAM")
        .anyRequest().isAuthenticated();
  }
}
```

One of the easiest mistakes to make with configuring Spring Security is to forget that these matchers apply to different processes, one is a request matcher for the whole filter chain, and the other is only to choose the access rule to apply.

配置`Spring Security`最容易犯的错误之一就是忘记这些 matchers 要应用于不同的 processes，一个匹配整个过滤链，另一个只匹配符合访问规则。

### Combining Application Security Rules with Actuator Rules

If you are using the Spring Boot Actuator for management endpoints, you probably want them to be secure, and by default they will be. In fact as soon as you add the Actuator to a secure application you get an additional filter chain that applies only to the actuator endpoints. It is defined with a request matcher that matches only actuator endpoints and it has an order of ManagementServerProperties.BASIC_AUTH_ORDER which is 5 fewer than the default SecurityProperties fallback filter, so it is consulted before the fallback.

如果您将Spring Boot Actuator用于管理端点，您可能希望它们是安全的，并且默认情况下它们将是安全的。实际上，只要将Actuator添加到安全应用程序中，您就会获得仅适用于执行器端点的附加过滤器链。它由一个仅匹配执行器端点的请求匹配器定义，并且其顺序ManagementServerProperties.BASIC_AUTH_ORDER比默认的SecurityProperties回退过滤器少5个，因此在回退之前会查询它。

If you want your application security rules to apply to the actuator endpoints you can add a filter chain ordered earlier than the actuator one and with a request matcher that includes all actuator endpoints. If you prefer the default security settings for the actuator endpoints, then the easiest thing is to add your own filter later than the actuator one, but earlier than the fallback (e.g. ManagementServerProperties.BASIC_AUTH_ORDER + 1). Example:

如果您希望将应用程序安全规则应用于执行器端点，则可以添加比执行器端点更早排序的过滤器链以及包含所有执行器端点的请求匹配器。如果您更喜欢执行器端点的默认安全设置，那么最简单的方法是在执行器端点之后添加自己的过滤器，但比回退更早（例如ManagementServerProperties.BASIC_AUTH_ORDER + 1）。例：

```{}
@Configuration
@Order(ManagementServerProperties.BASIC_AUTH_ORDER + 1)
public class ApplicationConfigurerAdapter extends WebSecurityConfigurerAdapter {
  @Override
  protected void configure(HttpSecurity http) throws Exception {
    http.antMatcher("/foo/**")
     ...;
  }
}
```

> Spring Security in the web tier is currently tied to the Servlet API, so it is only really applicable when running an app in a servlet container, either embedded or otherwise. It is not, however, tied to Spring MVC or the rest of the Spring web stack, so it can be used in any servlet application, for instance one using JAX-RS.  
Web层中的Spring Security目前与Servlet API相关联，因此它仅在嵌入式或其他方式在servlet容器中运行应用程序时才真正适用。但是，它不依赖于Spring MVC或Spring Web堆栈的其余部分，因此可以在任何servlet应用程序中使用，例如使用JAX-RS的应用程序。

## Method Security

As well as support for securing web applications, Spring Security offers support for applying access rules to Java method executions. For Spring Security this is just a different type of "protected resource". For users it means the access rules are declared using the same format of ConfigAttribute strings (e.g. roles or expressions), but in a different place in your code. The first step is to enable method security, for example in the top level configuration for our app:

除了支持保护Web应用程序外，Spring Security还支持将访问规则应用于Java方法执行。对于Spring Security，这只是一种不同类型的“受保护资源”。对于用户来说，这意味着使用相同格式的`ConfigAttribute`字符串（例如角色或表达式）声明访问规则，但是在代码中的不同位置。第一步是启用方法安全性，例如在我们的应用程序的顶级配置中：

```{}
@SpringBootApplication
@EnableGlobalMethodSecurity(securedEnabled = true)
public class SampleSecureApplication {
}
```{}

然后我们可以直接装饰方法资源，例如

```{}
@Service
public class MyService {

  @Secured("ROLE_USER")
  public String secure() {
    return "Hello Security";
  }

}
```

此示例是具有安全方法的服务。如果Spring创建了@Bean这种类型，那么它将被代理，并且调用者必须在实际执行该方法之前通过安全拦截器。如果访问被拒绝，则调用者将获得AccessDeniedException而不是实际的方法结果。

There are other annotations that can be used on methods to enforce security constraints, notably @PreAuthorize and @PostAuthorize, which allow you to write expressions containing references to method parameters and return values respectively.  
有可以在方法中使用以执行安全性约束，特别是其他注解`@PreAuthorize`和@`PostAuthorize`，它允许你写含有以分别方法参数和返回值引用的表达式。

>It is not uncommon to combine Web security and method security. The filter chain provides the user experience features, like authentication and redirect to login pages etc, and the method security provides protection at a more granular level.  
将Web安全性和方法安全性结合起来并不罕见。过滤器链提供用户体验功能，如身份验证和重定向到登录页面等，方法安全性可在更细粒度的级别提供保护。

## Working with Threads

Spring Security is fundamentally thread bound because it needs to make the current authenticated principal available to a wide variety of downstream consumers. The basic building block is the SecurityContext which may contain an Authentication (and when a user is logged in it will be an Authentication that is explicitly authenticated). You can always access and manipulate the SecurityContext via static convenience methods in SecurityContextHolder which in turn simply manipulate a TheadLocal, e.g.

```{}
SecurityContext context = SecurityContextHolder.getContext();
Authentication authentication = context.getAuthentication();
assert(authentication.isAuthenticated);
```

It is not common for user application code to do this, but it can be useful if you, for instance, need to write a custom authentication filter (although even then there are base classes in Spring Security that can be used where you would avoid needing to use the SecurityContextHolder).

If you need access to the currently authenticated user in a web endpoint, you can use a method parameter in a @RequestMapping. E.g.

@RequestMapping("/foo")
public String foo(@AuthenticationPrincipal User user) {
  ... // do stuff with user
}

This annotation pulls the current Authentication out of the SecurityContext and calls the getPrincipal() method on it to yield the method parameter. The type of the Principal in an Authentication is dependent on the AuthenticationManager used to validate the authentication, so this can be a useful little trick to get a type safe reference to your user data.

If Spring Security is in use the Principal from the HttpServletRequest will be of type Authentication, so you can also use that directly:

@RequestMapping("/foo")
public String foo(Principal principal) {
  Authentication authentication = (Authentication) principal;
  User = (User) authentication.getPrincipal();
  ... // do stuff with user
}

This can sometimes be useful if you need to write code that works when Spring Security is not in use (you would need to be more defensive about loading the Authentication class).

### Processing Secure Methods Asynchronously

Since the SecurityContext is thread bound, if you want to do any background processing that calls secure methods, e.g. with @Async, you need to ensure that the context is propagated. This boils down to wrapping the SecurityContext up with the task (Runnable, Callable etc.) that is executed in the background. Spring Security provides some helpers to make this easier, such as wrappers for Runnable and Callable. To propagate the SecurityContext to @Async methods you need to supply an AsyncConfigurer and ensure the Executor is of the correct type:

@Configuration
public class ApplicationConfiguration extends AsyncConfigurerSupport {

  @Override
  public Executor getAsyncExecutor() {
    return new DelegatingSecurityContextExecutorService(Executors.newFixedThreadPool(5));
  }

}
