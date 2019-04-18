# 其他

- 没有使用@EnableWebSecurity，也会开启Spring Security  
  引入JAR包，就会自动的开启一个权限校验  
  默认用户名密码：user/控制台生成密码  

- 使用了`InMemoryUserDetailsManager`，在login的时候不管用  

1. 如何实现Tocken的形式鉴权和非Tocken形式

2. 如何通过数据库的方式进行鉴权

3. 如何处理鉴权不通过之后的跳转
  AuthenticationEntryPoint

4. 改为403和302的分别处理，个性化的定义路径 ??

5. 采用CA认证 稍后考虑

6. 登出的处理 ok  
  `http://websystique.com/spring-security/spring-security-4-logout-example/` 登出示例

7. 加密方法 ok

8. 对于自定义的，是否可以使用antmatcher来做路径匹配