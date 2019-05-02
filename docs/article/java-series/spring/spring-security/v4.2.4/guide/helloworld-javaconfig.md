https://docs.spring.io/spring-security/site/docs/4.2.x/guides/html5/helloworld-javaconfig.html

# Hello Spring Security Java Config
......

## Setting up the sample

## Securing the application
Before securing your application, it is important to ensure that the existing application works as we did in Running the insecure application. Now that the application runs without security, we are ready to add security to our application. This section demonstrates the minimal steps to add Spring Security to our application.  

... 本节演示了将Spring Security添加到应用程序的最小步骤。

### Updating your dependencies
......

### Creating your Spring Security configuration

新建`src/main/java/org/springframework/security/samples/config/SecurityConfig.java`,如下:
```
package org.springframework.security.samples.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.configuration.*;

@EnableWebSecurity
public class SecurityConfig {

    @Autowired
    public void configureGlobal(AuthenticationManagerBuilder auth) throws Exception {
        auth
            .inMemoryAuthentication()
                .withUser("user").password("password").roles("USER");
    }
}
```

>The name of the configureGlobal method is not important. However, it is important to only configure AuthenticationManagerBuilder in a class annotated with either @EnableWebSecurity, @EnableGlobalMethodSecurity, or @EnableGlobalAuthentication. Doing otherwise has unpredictable results.

>configureGlobal 方法名不重要。重要的是要在一个带有@EnableWebSecurity, @EnableGlobalMethodSecurity, or @EnableGlobalAuthentication注解的类中配置AuthenticationManagerBuilder。否则后果难料。

The `SecurityConfig` will:
- Require authentication to requests matched against /user/**  
要求授权

- Specifies the URL to send users to for form-based login
指明了发送给users登录需要的URL

- Allow the user with the Username user and the Password password to authenticate with form based authentication
允许用户使用用户名、密码授权

- Allow the user to logout  
允许用户登出

- CSRF attack prevention  
跨站伪造防御

- Session Fixation protection
Session保护

- Security Header integration
Header加密
    - HTTP Strict Transport Security for secure requests

    - X-Content-Type-Options integration

    - Cache Control (can be overridden later by your application to allow caching of your static resources)

    - X-XSS-Protection integration

    - X-Frame-Options integration to help prevent Clickjacking

- Integrate with the following Servlet API methods

    - HttpServletRequest#getRemoteUser()

    - HttpServletRequest.html#getUserPrincipal()

    - HttpServletRequest.html#isUserInRole(java.lang.String)

    - HttpServletRequest.html#login(java.lang.String, java.lang.String)

    - HttpServletRequest.html#logout()

### Registering Spring Security with the war

### Exploring the secured application

## Conclusion

...