
1.  NoSuchMethodError
 https://www.cnblogs.com/hjwublog/p/5749929.html  
 实际问题是Spring 4.2之前的版本有问题，但是网上解释为：此类问题多事spring-data-redis以及jedis版本问题，多换个版本试试，本文上面提到的版本可以使用。  


2. NoSuchBeanDefinitionException: No bean named 'springSessionRepositoryFilter'   
 `<context:annotation-config/>`和`<bean class="org.springframework.session.data.redis.config.annotation.web.http.RedisHttpSessionConfiguration"/>`需要配合使用  
 且需要在一个上下文中使用，security的xmlns也只能出现在同一个上下文中？SpringSession对SpringSecurity是有可选依赖的

3. 