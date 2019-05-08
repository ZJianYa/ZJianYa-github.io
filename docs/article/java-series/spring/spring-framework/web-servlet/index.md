# 概述

This part of the documentation covers support for Servlet stack, web applications built on the Servlet API and deployed to Servlet containers. Individual chapters include Spring MVC, View Technologies, CORS Support, and WebSocket Support. For reactive stack, web applications, go to Web on Reactive Stack.

## 1. Spring Web MVC

### 1.1. Introduction

Spring Web MVC is the original web framework built on the Servlet API and included in the Spring Framework from the very beginning. The formal name "Spring Web MVC" comes from the name of its source module spring-webmvc but it is more commonly known as "Spring MVC".

Parallel to Spring Web MVC, Spring Framework 5.0 introduced a reactive stack, web framework whose name Spring WebFlux is also based on its source module spring-webflux. This section covers Spring Web MVC. The next section covers Spring WebFlux.

For baseline information and compatibility with Servlet container and Java EE version ranges please visit the Spring Framework Wiki.

### 1.2. DispatcherServlet

Spring MVC, like many other web frameworks, is designed around the front controller pattern where a central Servlet, the DispatcherServlet, provides a shared algorithm for request processing while actual work is performed by configurable, delegate components. This model is flexible and supports diverse workflows.

实际工作交给 configurable，delegate components 执行。该模型非常灵活，支持多种 workflows。

The DispatcherServlet, as any Servlet, needs to be declared and mapped according to the Servlet specification using Java configuration or in web.xml. In turn the DispatcherServlet uses Spring configuration to discover the delegate components it needs for request mapping, view resolution, exception handling, and more.

DispatcherServlet 根据配置发现 `delegate components` 用于 `request mapping, view resolution, exception handling` 等等。

Below is an example of the Java configuration that registers and initializes the DispatcherServlet. This class is auto-detected by the Servlet container (see Servlet Config):

下面是一个配置示例

```{}
public class MyWebApplicationInitializer implements WebApplicationInitializer {

    @Override
    public void onStartup(ServletContext servletCxt) {

        // Load Spring web application configuration
        AnnotationConfigWebApplicationContext ac = new AnnotationConfigWebApplicationContext();
        ac.register(AppConfig.class);
        ac.refresh();

        // Create and register the DispatcherServlet
        DispatcherServlet servlet = new DispatcherServlet(ac);
        ServletRegistration.Dynamic registration = servletCxt.addServlet("app", servlet);
        registration.setLoadOnStartup(1);
        registration.addMapping("/app/*");
    }
}
```

> In addition to using the ServletContext API directly, you can also extend AbstractAnnotationConfigDispatcherServletInitializer and override specific methods (see example under Context Hierarchy).

>除了直接使用ServletContext API之外，您还可以扩展 AbstractAnnotationConfigDispatcherServletInitializer和覆盖特定方法（请参阅Context Hierarchy下的示例）。

Below is an example of web.xml configuration to register and initialize the DispatcherServlet:

```{}
...
```

>Spring Boot follows a different initialization sequence. Rather than hooking into the lifecycle of the Servlet container, Spring Boot uses Spring configuration to bootstrap itself and the embedded Servlet container. `Filter` and `Servlet` declarations are detected in Spring configuration and registered with the Servlet container. For more details check the [Spring Boot docs](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#boot-features-embedded-container).

>Spring Boot遵循不同的初始化顺序。Spring Boot使用Spring配置来引导自身和嵌入式Servlet容器，而不是挂钩到Servlet容器的生命周期。Filter和Servlet声明在Spring配置中检测到并在Servlet容器中注册。有关更多详细信息，请查看 Spring Boot文档。

#### 1.2.1. Context Hierarchy

DispatcherServlet expects a WebApplicationContext, an extension of a plain ApplicationContext, for its own configuration. WebApplicationContext has a link to the ServletContext and Servlet it is associated with. It is also bound to the ServletContext such that applications can use static methods on RequestContextUtils to look up the WebApplicationContext if they need access to it.

DispatcherServlet 需要一个 WebApplicationContext，一个普通的扩展 ApplicationContext，用于它自己的配置。WebApplicationContext 和 ServletContext 关联 ，ServletContext和Servlet关联。它也绑定于 `ServletContext` 应用程序可以使用静态方法 RequestContextUtils 来查找 WebApplicationContext 如果它们需要访问它。

For many applications having a single WebApplicationContext is simple and sufficient. It is also possible to have a context hierarchy where one root WebApplicationContext is shared across multiple DispatcherServlet (or other Servlet) instances, each with its own child WebApplicationContext configuration. See Additional Capabilities of the ApplicationContext for more on the context hierarchy feature.

对于许多单一应用有一个简单的 WebApplicationContext 就够了。也可以有一个 context hierarchy : 一个 WebApplicationContext 被多个 DispatcherServlet 共享，每一个（DispatcherServlet）都有自己的子 WebApplicationContext 配置。有关 上下文层次结构功能的更多信息，请参阅[ApplicationContext](https://docs.spring.io/spring/docs/5.0.x/spring-framework-reference/core.html#context-introduction)的其他功能。

The root WebApplicationContext typically contains infrastructure beans such as data repositories and business services that need to be shared across multiple Servlet instances. Those beans are effectively inherited and could be overridden (i.e. re-declared) in the Servlet-specific, child WebApplicationContext which typically contains beans local to the given Servlet:

根 `WebApplicationContext` 通常包含基础架构 bean，例如需要跨多个Servlet实例共享的 data repositories 和 business services 。这些 bean 是有效继承的，可以在 Servlet-specific 的子代 `WebApplicationContext` 中重写（即重新声明），该子代通常包含本地bean：

![图例](https://docs.spring.io/spring/docs/5.0.x/spring-framework-reference/images/mvc-context-hierarchy.png)

Below is example configuration with a WebApplicationContext hierarchy:

```{}
public class MyWebAppInitializer extends AbstractAnnotationConfigDispatcherServletInitializer {

    @Override
    protected Class<?>[] getRootConfigClasses() {
        return new Class<?>[] { RootConfig.class };
    }

    @Override
    protected Class<?>[] getServletConfigClasses() {
        return new Class<?>[] { App1Config.class };
    }

    @Override
    protected String[] getServletMappings() {
        return new String[] { "/app1/*" };
    }
}
```

> If an application context hierarchy is not required, applications may return all configuration via getRootConfigClasses() and null from getServletConfigClasses().

> 如果不需要应用程序上下文层次结构，则应用程序可以通过getRootConfigClasses()和null从中返回所有配置getServletConfigClasses()。

而web.xml相当于：

```{}
...
```

#### 1.2.2. Special Bean Types

The DispatcherServlet delegates to special beans to process requests and render the appropriate responses. By "special beans" we mean Spring-managed, Object instances that implement framework contracts. Those usually come with built-in contracts but you can customize their properties, extend or replace them.

"special beans" 我们意思是被 Spring 管理的，实现了 framework contracts 的对象实例。 那些内置的 contracts 你可以自定义它们的属性，或者扩展或者替代它们。  

The table below lists the special beans detected by the DispatcherServlet:

| Bean type                             | Explanation                                                                                                                                                                                                                            |
| ------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| HandlerMapping                        | Map a request to a handler along with a list of interceptors for pre- and post-processing. The mapping is based on some criteria the details of which vary by HandlerMapping implementation.                                           |
| &nbsp;                                | The two main HandlerMapping implementations are RequestMappingHandlerMapping (which supports @RequestMapping annotated methods) and SimpleUrlHandlerMapping (which maintains explicit registrations of URI path patterns to handlers). |
| HandlerAdapter                        | 帮助 DispatcherServlet 调用一个 handler 映射到一个 request 上，忽略 the handler 实际是怎么执行的。主要目的是为 DispatcherServlet 屏蔽这些细节                                                                                          |
| HandlerExceptionResolver              | Strategy to resolve exceptions, possibly mapping them to handlers, to HTML error views, or other targets. See Exceptions.                                                                                                              |
| ViewResolver                          | Resolve logical String-based view names returned from a handler to an actual View with which to render to the response. See View Resolution and View Technologies.                                                                     |
| LocaleResolver, LocaleContextResolver |                                                                                              |
| ThemeResolver                         |                                                                                             |
| MultipartResolver                     |                                                                                            |
| FlashMapManager                       |                                                                                           |