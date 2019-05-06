# 概述

https://docs.spring.io/spring-boot/docs/current/reference/html/howto-hotswapping.html

https://docs.spring.io/spring-boot/docs/current/reference/html/  
https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/  

## TOC

### I. Spring Boot Documentation  

#### 5. Learning about Spring Boot Features  Y

### II. Getting Started  

#### 8. Introducing Spring Boot

#### 9. System Requirements  

##### 9.1. Servlet Containers

#### 10. Installing Spring Boot

#### 11. Developing Your First Spring Boot Application

#### 12. What to Read Next

### III. Using Spring Boot  

#### 13. Build Systems

#### 14. Structuring Your Code

#### 15. Configuration Classes  Y

#### 16. Auto-configuration Y

#### 17. Spring Beans and Dependency Injection Y

#### 18. Using the @SpringBootApplication Annotation

#### 19. Running Your Application

#### 20. Developer Tools

#### 21. Packaging Your Application for Production

### IV. Spring Boot features Y

#### 23. SpringApplication

#### 24. Externalized Configuration

#### 25. Profiles

#### 26. Logging

#### 27. Internationalization

#### 28. JSON

#### 29. Developing Web Applications

#### 30. Security

#### 31. Working with SQL Databases

#### 32. Working with NoSQL Technologies

#### 33. Caching

#### 34. Messaging

#### 35. Calling REST Services with RestTemplate Y

#### 36. Calling REST Services with WebClient Y

#### 37. Validation

#### 38. Sending Email

#### 39. Distributed Transactions with JTA

#### 40. Hazelcast

#### 41. Quartz Scheduler

#### 42. Task Execution and Scheduling

#### 43. Spring Integration

#### 44. Spring Session

#### 45. Monitoring and Management over JMX

#### 46. Testing

#### 47. WebSockets

#### 48. Web Services

#### 49. Creating Your Own Auto-configuration

#### 50. Kotlin support

#### 51. What to Read Next

### V. Spring Boot Actuator: Production-ready features  NN

#### 52. Enabling Production-ready Features

#### 53. Endpoints

#### 54. Monitoring and Management over HTTP

##### 54.1. Customizing the Management Endpoint Paths

##### 54.2. Customizing the Management Server Port

##### 54.3. Configuring Management-specific SSL

##### 54.4. Customizing the Management Server Address

##### 54.5. Disabling HTTP Endpoints

##### 55. Monitoring and Management over JMX

##### 56. Loggers

##### 57. Metrics

##### 58. Auditing

##### 59. HTTP Tracing

##### 60. Process Monitoring

##### 61. Cloud Foundry Support

##### 62. What to Read Next

### VI. Deploying Spring Boot Applications

#### 63. Deploying to the Cloud

#### 64. Installing Spring Boot Applications

#### 65. What to Read Next

### VII. Spring Boot CLI

### VIII. Build tool plugins  

#### 71. Spring Boot Maven Plugin

#### 72. Spring Boot Gradle Plugin

#### 73. Spring Boot AntLib Module

#### 74. Supporting Other Build Systems

### IX. ‘How-to’ guides

### X. Appendices

#### A. Common application properties  NN

#### B. Configuration Metadata

#### C. Auto-configuration classes

#### D. Test auto-configuration annotations

#### E. The Executable Jar Format

#### F. Dependency versions

## autowired

Spring 已经在侵入代码，通过注解的方式  
舍弃免侵入，取得便捷性  

## @EnableAutoConfiguration

查看都是启用了哪些 AutoConfiguration

## FAQ

1. Springboot1.0 升级到 2.0的问题 jdbcUrl is required with driverClassName.  
  https://blog.csdn.net/weixin_40085570/article/details/80968099

2. 日期转换  
  通常我们不会做日期转换
