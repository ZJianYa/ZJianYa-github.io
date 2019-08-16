
# ContextLoaderListener vs DispatcherServlet

这里并没有详细介绍从入口方法到完全加载的整个流程。  

https://howtodoinjava.com/spring-mvc/contextloaderlistener-vs-dispatcherservlet/

Before reading further, please understand that –

Spring can have multiple contexts at a time. One of them will be root context, and all other contexts will be child contexts.
All child contexts can access the beans defined in root context; but opposite is not true. Root context cannot access child contexts beans.

## DispatcherServlet – Child application contexts  

DispatcherServlet is essentially a Servlet (it extends HttpServlet) whose primary purpose is to handle incoming web requests matching the configured URL pattern. It take an incoming URI and find the right combination of controller and view. So it is the front controller.  

DispatcherServlet 主要功能是处理 web 请求（比如处理 url 匹配和找到合适的 view )，是一个前置控制器。  

When you define a DispatcherServlet in spring configuration, you provide an XML file with entries of controller classes, views mappings etc. using contextConfigLocation attribute.  

```
<servlet>
    <servlet-name>employee-services</servlet-name>
    <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
    <init-param>
        <param-name>contextConfigLocation</param-name>
        <param-value>classpath:employee-services-servlet.xml</param-value>
    </init-param>
    <load-on-startup>1</load-on-startup>
</servlet>
```

If you do not provide configuration file then it will load its own configuration file using [servlet_name]-servlet.xml. Web applications can define any number of DispatcherServlet entries. Each servlet will operate in its own namespace, loading its own application context with mappings, handlers, etc.  

如果不提供配置文件（即`<init-param>`参数)，会自动加载 [servlet_name]-servlet.xml 。可以定义多个 DispatcherServlet 。每一个 servlet 在自己的命名空间工作。  

## ContextLoaderListener – Root application context

ContextLoaderListener creates the root application context and will be shared with child contexts created by all DispatcherServlet contexts. You can have only one entry of this in web.xml.

ContextLoaderListener 是根上下文，所以只能配置一个。  

```
<listener>
  <listener-class>
    org.springframework.web.context.ContextLoaderListener
  </listener-class>
</listener>
  
<context-param>
  <param-name>contextConfigLocation</param-name>
  <param-value>/WEB-INF/spring/applicationContext.xml</param-value>
</context-param>
```

The context of ContextLoaderListener contains beans that globally visible, like services, repositories, infrastructure beans, etc. After the root application context is created, it’s stored in ServletContext as an attribute, the name is:  

ContextLoaderListener 包含的 beans 是全局可见的。并且（ ContextLoaderListener ）被作为属性存入了 ServletContext 。

```
//org/springframework/web/context/ContextLoader.java
servletContext.setAttribute(WebApplicationContext.ROOT_WEB_APPLICATION_CONTEXT_ATTRIBUTE, this.context);
 
//Where attibute is defined in /org/springframework/web/context/WebApplicationContext.java as
 
WebApplicationContext.ROOT_WEB_APPLICATION_CONTEXT_ATTRIBUTE = WebApplicationContext.class.getName() + ".ROOT";
```

你可以使用 WebApplicationContextUtils （在 Controller 中） 获得根 ApplicationContext 如下：

```
//Controller.java
@Autowired
ServletContext context;
 
ApplicationContext ac = WebApplicationContextUtils.getWebApplicationContext(context);
 
if(ac == null){
    return "root application context is null";
}    
```

* ContextLoaderListener creates root application context.
* DispatcherServlet entries create one child application context per servlet entry.
* Child contexts can access beans defined in root context.
* Beans in root context cannot access beans in child contexts (directly).
* All contexts are added to ServletContext.
* You can access root context using WebApplicationContextUtils class.

## 延伸

- 在 SpringBoot 中，已经没有显式的区分两者，那么它是合为一体了，还是做了自动的甄别和处理呢？又是怎么实现这两者的呢？  