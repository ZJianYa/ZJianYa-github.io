
## web

-Resource 源码分析
  可以解决：如何使用相对路径，绝对路径等等
- WebMvcConfigurationSupport 是Spring MVC里用来辅助配置的，而WebMvcAutoConfiguration是Spring Boot用来做WebMVC的自动配置的

- 路径中有小数点
  https://blog.csdn.net/fay462298322/article/details/53106486  javaconfig
  https://blog.csdn.net/oschina_40730821/article/details/83310342 正则
  https://blog.csdn.net/u012410733/article/details/71791673 虽然啰嗦，但是提供了别样的解决方法
  为什么不允许路径中有小数点

- 全局异常  

  https://stackoverflow.com/questions/23580509/how-to-write-a-proper-global-error-handler-with-spring-mvc-spring-boot  
  https://spring.io/blog/2013/11/01/exception-handling-in-spring-mvc  
  对于SQL错误要尽量统一处理掉  

- 全局日期格式化（输入/输出）也许是没有必要的，但是  
  binder  
  参考:https://docs.spring.io/spring/docs/4.2.x/spring-framework-reference/htmlsingle/#mvc-ann-webdatabinder  
  format  
  https://docs.spring.io/spring/docs/4.2.x/spring-framework-reference/htmlsingle/#format-configuring-formatting-globaldatetimeformat  

- 上传下载，size和type的限定，多条件校验

- dispatcherServlet vs contextListener  

- Springboot 和 @EnableWebMvc  
  https://blog.csdn.net/testcs_dn/article/details/80249894
- WebMvcConfigurerAdapter 已经废弃  

- HttpMessageConverter
  org.springframework.web.servlet.config.annotation.WebMvcConfigurationSupport.configureMessageConverters(List<HttpMessageConverter<?>>)   
  这个方法要慎重使用，应该是不会做覆盖HttpMessageConverter的
  FormattingConversionService 是用来做格式化用，不是用来做序列化用
  org.springframework.web.servlet.config.annotation.WebMvcConfigurationSupport.addFormatters 也同样可能不是做覆盖
