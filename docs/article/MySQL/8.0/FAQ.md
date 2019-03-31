# 概述

版本升级总是会带来接口上的不兼容，或者原理层的优化。

## Eclipse

- Unknown system variable 'query_cache_size'  jdbc驱动不对  
- mysql8连接需要注意的问题  
  serverTimeZone Asia/Shanghai  
  zeroDateTimeBehavior ROUND  

## MySQL 安装升级

- 从mysql 5.7升级到8的时候  
  数据文件不匹配导致无法启动  
- windows10+mysql8.0.zip安装
  https://www.cnblogs.com/nuomin/p/8916257.html

## Mybatis

## JDBC

- Authentication plugin 'caching_sha2_password' cannot be loaded  
  https://www.cnblogs.com/chuancheng/p/8964385.html  
  ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '你的新密码'
- MySQL 8.0 Public Key Retrieval is not allowed 错误的解决方法  
  You should add client option to your mysql-connector allowPublicKeyRetrieval=true  
  https://mysql-net.github.io/MySqlConnector/connection-options/
  could help also adding useSSL=false
- vendor.MySqlValidConnectionChecker.`<init>`(MySqlValidConnectionChecker.java:53)Cannot resolve com.mys
druid并不支持mysql8

## MySQL 窗口函数

https://zhidao.baidu.com/question/498460029.html 终止当前的SQL
https://blog.csdn.net/lf_525/article/details/50835342 设置最大深度

