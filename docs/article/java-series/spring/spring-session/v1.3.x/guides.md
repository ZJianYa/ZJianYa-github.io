
https://docs.spring.io/spring-session/docs/1.3.x/reference/html5/guides/httpsession-xml.html  

# Spring Session - HttpSession (Quick Start)  

This guide describes how to use Spring Session to transparently leverage Redis to back a web application’s HttpSession with XML based configuration.

这个指南讲了如何使用Spring会话透明地利用Redis以基于XML的配置来备份Web应用程序的HttpSession。

## Updating Dependencies

```{}
<dependencies>
	<!-- ... -->

	<dependency>
		<groupId>org.springframework.session</groupId>
		<artifactId>spring-session-data-redis</artifactId>
		<version>2.0.2.RELEASE</version>
		<type>pom</type>
	</dependency>
	<dependency>
		<groupId>io.lettuce</groupId>
		<artifactId>lettuce-core</artifactId>
		<version>5.0.2.RELEASE</version>
	</dependency>
	<dependency>
		<groupId>org.springframework</groupId>
		<artifactId>spring-web</artifactId>
		<version>5.0.4.RELEASE</version>
	</dependency>
</dependencies>
```  

## Spring XML Configuration

After adding the required dependencies, we can create our Spring configuration. The Spring configuration is responsible for creating a Servlet Filter that replaces the HttpSession implementation with an implementation backed by Spring Session. Add the following Spring Configuration:

添加所需的依赖关系后，我们可以创建我们的Spring配置。 Spring配置负责创建一个Servlet过滤器，用Spring Session来替换HttpSession实现。 添加下面的Spring配置：

src/main/webapp/WEB-INF/spring/session.xml  

```
<context:annotation-config/>
<bean class="org.springframework.session.data.redis.config.annotation.web.http.RedisHttpSessionConfiguration"/>


<bean class="org.springframework.data.redis.connection.lettuce.LettuceConnectionFactory"/>
```

We use the combination of `<context:annotation-config/>` and `RedisHttpSessionConfiguration` because Spring Session does not yet provide XML Namespace support (see gh-104). This creates a Spring Bean with the name of springSessionRepositoryFilter that implements Filter. The filter is what is in charge of replacing the HttpSession implementation to be backed by Spring Session. In this instance Spring Session is backed by Redis.

We create a RedisConnectionFactory that connects Spring Session to the Redis Server. We configure the connection to connect to localhost on the default port (6379) For more information on configuring Spring Data Redis, refer to the reference documentation.

我们使用`<context：annotation-config />`和`RedisHttpSessionConfiguration`的组合，因为Spring Session尚未提供对XML名称空间的支持（参见[gh-104](https://github.com/spring-projects/spring-session/issues/104)）。 这将创建一个名为springSessionRepositoryFilter的Spring Bean来实现Filter。 过滤器是负责把HttpSession实现的替换为Spring Session。 在这个例子中，Spring Session由Redis支持。

我们创建一个`RedisConnectionFactory`把Spring Session接到Redis Server上。我们将连接配置为在默认端口（6379）上连接到本地主机。有关配置Spring Data Redis的更多信息，[请参阅参考文档](https://docs.spring.io/spring-data/data-redis/docs/current/reference/html/)。  

## XML Servlet Container Initialization 
Our Spring Configuration created a Spring Bean named springSessionRepositoryFilter that implements Filter. The springSessionRepositoryFilter bean is responsible for replacing the HttpSession with a custom implementation that is backed by Spring Session.

In order for our Filter to do its magic, we need to instruct Spring to load our session.xml configuration. We do this with the following configuration:

我们(上面)的Spring配置创建了一个名为springSessionRepositoryFilter的Spring Bean，它实现了Filter。 springSessionRepositoryFilter bean负责用自定义实现的Spring Session替换HttpSession。

为了让我们的过滤器发挥它的魔法，我们需要指示Spring加载我们的session.xml配置。 我们用下面的配置来做到这一点：

src/main/webapp/WEB-INF/web.xml  

```{}
<context-param>
    <param-name>contextConfigLocation</param-name>
    <param-value>
        /WEB-INF/spring/*.xml
    </param-value>
</context-param>
<listener>
    <listener-class>
        org.springframework.web.context.ContextLoaderListener
    </listener-class>
</listener>
```

The ContextLoaderListener reads the contextConfigLocation and picks up our session.xml configuration.

Last we need to ensure that our Servlet Container (i.e. Tomcat) uses our springSessionRepositoryFilter for every request. The following snippet performs this last step for us:

ContextLoaderListener读取contextConfigLocation并获取我们的session.xml配置。

最后，我们需要确保我们的Servlet容器（即Tomcat）为每个请求使用我们的springSessionRepositoryFilter。 以下片段为我们执行了最后一步：

src/main/webapp/WEB-INF/web.xml

```{}
<filter>
    <filter-name>springSessionRepositoryFilter</filter-name>
    <filter-class>org.springframework.web.filter.DelegatingFilterProxy</filter-class>
</filter>
<filter-mapping>
    <filter-name>springSessionRepositoryFilter</filter-name>
    <url-pattern>/*</url-pattern>
    <dispatcher>REQUEST</dispatcher>
    <dispatcher>ERROR</dispatcher>
</filter-mapping>
```

The DelegatingFilterProxy will look up a Bean by the name of springSessionRepositoryFilter and cast it to a Filter. For every request that DelegatingFilterProxy is invoked, the springSessionRepositoryFilter will be invoked.

DelegatingFilterProxy将通过springSessionRepositoryFilter的名称查找Bean并将其转换为Filter。 对于调用DelegatingFilterProxy的每个请求，将调用springSessionRepositoryFilter。

## httpsession-xml Sample Application
Running the httpsession-xml Sample Application

You can run the sample by obtaining the source code and invoking the following command:

