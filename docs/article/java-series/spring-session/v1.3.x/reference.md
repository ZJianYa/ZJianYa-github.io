https://docs.spring.io/spring-session/docs/1.3.x/reference/html5/  

# Spring Session
Spring Session provides an API and implementations for managing a user’s session information.  
Spring Session提供了一个管理用户会话信息的API和实现。

## Spring Security Integration
Spring Session provides integration with Spring Security.  
Spring Session提供了与Spring Security的集成。

### Spring Security Remember-Me Support
Spring Session provides integration with [Spring Security’s Remember-Me Authentication](https://docs.spring.io/spring-security/site/docs/4.2.x/reference/htmlsingle/#remember-me). The support will:

Spring Session提供了与Spring Security的记住我身份验证的集成。 支持：

- Change the session expiration length  
更改会话过期长度

- Ensure the session cookie expires at Integer.MAX_VALUE. The cookie expiration is set to the largest possible value because the cookie is only set when the session is created. If it were set to the same value as the session expiration, then the session would get renewed when the user used it but the cookie expiration would not be updated causing the expiration to be fixed.  
确保会话的cookie在Integer.MAX_VALUE处过期。 Cookie过期尽可能设置为最大值，因为只有在创建会话时才设置Cookie。 如果它(Cookie)被设置为与会话过期相同的值，那么当用户使用它（session）的时候session会被更新，但是cookie过期不会被更新，从而导致(session)过期时间被修改。

To configure Spring Session with Spring Security in Java Configuration use the following as a guide:  
在Java配置中使用Spring Security配置Spring Session，请使用以下内容作为指导：
```
@Override
protected void configure(HttpSecurity http) throws Exception {
    http
        // ... additional configuration ...
        .rememberMe()
            .rememberMeServices(rememberMeServices());
}

@Bean
RememberMeServices rememberMeServices() {
    SpringSessionRememberMeServices rememberMeServices =
            new SpringSessionRememberMeServices();
    // optionally customize
    rememberMeServices.setAlwaysRemember(true);
    return rememberMeServices;
}
```  

An XML based configuration would look something like this:   
基于XML的配置看起来像这样：

```
<security:http>
    <!-- ... -->
    <security:form-login />
    <security:remember-me services-ref="rememberMeServices"/>
</security:http>

<bean id="rememberMeServices"
    class="org.springframework.session.security.web.authentication.SpringSessionRememberMeServices"
    p:alwaysRemember="true"/>
```

### Spring Security Concurrent Session Control

Spring Session provides integration with Spring Security to support its concurrent session control. This allows limiting the number of active sessions that a single user can have concurrently, but unlike the default Spring Security support this will also work in a clustered environment. This is done by providing a custom implementation of Spring Security’s SessionRegistry interface.

When using Spring Security’s Java config DSL, you can configure the custom SessionRegistry through the SessionManagementConfigurer like this:

Spring Session提供了与Spring Security的集成，以支持其并发会话控制。 这允许限制单个用户可以同时进行的活动会话的数量，但与默认的Spring Security支持不同，这也可以在集群环境中使用。 这是通过提供Spring Security的SessionRegistry接口的自定义实现来完成的。

在使用Spring Security的Java配置DSL时，可以通过SessionManagementConfigurer配置自定义SessionRegistry，如下所示：
```
@Configuration
public class SecurityConfiguration extends WebSecurityConfigurerAdapter {

        @Autowired
        FindByIndexNameSessionRepository<ExpiringSession> sessionRepository;

        @Override
        protected void configure(HttpSecurity http) throws Exception {
                http
                        // other config goes here...
                        .sessionManagement()
                                .maximumSessions(2)
                                .sessionRegistry(sessionRegistry());
        }

        @Bean
        SpringSessionBackedSessionRegistry sessionRegistry() {
                return new SpringSessionBackedSessionRegistry(this.sessionRepository);
        }
}
```

This assumes that you’ve also configured Spring Session to provide a `FindByIndexNameSessionRepository` that returns ExpiringSession instances.

这假定你还配置了Spring Session来提供一个返回ExpiringSession实例的FindByIndexNameSessionRepository。

When using XML configuration, it would look something like this:

```{xml}
<security:http>
    <!-- other config goes here... -->
    <security:session-management>
        <security:concurrency-control max-sessions="2" session-registry-ref="sessionRegistry"/>
    </security:session-management>
</security:http>

<bean id="sessionRegistry"
      class="org.springframework.session.security.SpringSessionBackedSessionRegistry">
    <constructor-arg ref="sessionRepository"/>
</bean>
```

This assumes that your Spring Session SessionRegistry bean is called sessionRegistry, which is the name used by all SpringHttpSessionConfiguration subclasses except for the one for MongoDB: there it’s called mongoSessionRepository.

这假定你的Spring Session SessionRegistry bean被称为sessionRegistry，它是所有SpringHttpSessionConfiguration子类使用的名称，除了MongoDB的子类外：它被称为mongoSessionRepository。

### Limitations
Spring Session’s implementation of Spring Security’s SessionRegistry interface does not support the getAllPrincipals method, as this information cannot be retrieved using Spring Session. This method is never called by Spring Security, so this only affects applications that access the SessionRegistry themselves.

Spring Session的SessionRegistry接口的实现不支持getAllPrincipals方法，因为无法使用Spring Session检索这些信息。 这个方法永远不会被Spring Security调用，所以这只会在访问SessionRegistry的应用程序中产生影响。

## API Documentation

## Spring Session Community