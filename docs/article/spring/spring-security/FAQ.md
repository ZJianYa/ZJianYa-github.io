# 其他

- 没有使用@EnableWebSecurity，也会开启Spring Security  
  引入JAR包，就会自动的开启一个权限校验  
  默认用户名密码：user/控制台生成密码  

- 使用了`InMemoryUserDetailsManager`，在login的时候不管用  

- 没搞明白 global AuthenticationManager 和 local AuthenticationManager

- 采用CA认证 稍后考虑