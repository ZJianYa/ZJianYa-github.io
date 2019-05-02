https://docs.spring.io/spring-session/docs/current/reference/html5/guides/java-redis.html  

# Spring Session - HttpSession (Quick Start)  

## 1. Updating Dependencies
```
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

## 2. Spring Java Configuration
After adding the required dependencies, we can create our Spring configuration. The Spring configuration is responsible for creating a Servlet Filter that replaces the HttpSession implementation with an implementation backed by Spring Session. Add the following Spring Configuration:  
****
```
@EnableRedisHttpSession
public class Config {

	@Bean
	public LettuceConnectionFactory connectionFactory() {
		return new LettuceConnectionFactory();
	}
}
```
1. 	The `@EnableRedisHttpSession` annotation creates a Spring Bean with the name of springSessionRepositoryFilter that implements Filter. The filter is what is in charge of replacing the HttpSession implementation to be backed by Spring Session. In this instance Spring Session is backed by Redis.   
`@EnableRedisHttpSession` 创建了一个Filter.这个filter替换了HttpSession的实现。这个例子中，Spring Session是由Redis做后台的。  

2. We create a RedisConnectionFactory that connects Spring Session to the Redis Server. We configure the connection to connect to localhost on the default port (6379) For more information on configuring Spring Data Redis, refer to the [reference documentation](https://docs.spring.io/spring-data/data-redis/docs/2.0.4.RELEASE/reference/html/).  
我们创建一个RedisConnectionFactory，连接Spring Session和Redis Server.   

## 3. Java Servlet Container Initialization
Our Spring Configuration created a Spring Bean named springSessionRepositoryFilter that implements Filter. The springSessionRepositoryFilter bean is responsible for replacing the HttpSession with a custom implementation that is backed by Spring Session.  
我们的Spring配置创建了一个叫springSessionRepositoryFilter的Filter。springSessionRepositoryFilter负责用自定义的Session替换用HttpSession。  

In order for our Filter to do its magic, Spring needs to load our Config class. Last we need to ensure that our Servlet Container (i.e. Tomcat) uses our springSessionRepositoryFilter for every request. Fortunately, Spring Session provides a utility class named AbstractHttpSessionApplicationInitializer both of these steps extremely easy. You can find an example below:  
为了使我们的Filter具有这种能力，Spring需要加载我们的Config类。我们需要确保我们的Servlet容器使用我们的springSessionRepositoryFilter处理每一个请求。Spring Session提供了一个叫AbstractHttpSessionApplicationInitializer工具类。这些步骤都非常简单，你可以在下面的例子中找到：  
src/main/java/sample/Initializer.java   
```
public class Initializer extends AbstractHttpSessionApplicationInitializer {

	public Initializer() {
		super(Config.class);
	}
	
}
```
The name of our class (Initializer) does not matter. What is important is that we extend AbstractHttpSessionApplicationInitializer.  
1. The first step is to extend AbstractHttpSessionApplicationInitializer. This ensures that the Spring Bean by the name springSessionRepositoryFilter is registered with our Servlet Container for every request.  
第一步是继承AbstractHttpSessionApplicationInitializer，可以确保springSessionRepositoryFilter注册到容器内。
2.  AbstractHttpSessionApplicationInitializer also provides a mechanism to easily ensure Spring loads our Config.  
springSessionRepositoryFilter也提供了一个机制确保Spring加载我们自己的Config。  

## 简而言之
1. 写配置注解 @EnableRedisHttpSession，返回LettuceConnectionFactory
2. 用AbstractHttpSessionApplicationInitializer加载配置文件

## 4. httpsession Sample Application
.








.
