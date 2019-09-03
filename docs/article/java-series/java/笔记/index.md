# 概述

首先我们有很多设想：  
* 我们的 app 可能是 native 的，可能是 personal 的 ，也可能是 intent 的  
* meta data 包含了日期、作者、文件名

## 功能清单

- 文件管理
  - 上传/导入  
    速率控制，文件大小控制，权限控制  
    类型校验，不是后缀名而是真正的格式校验  
  - 下载/导出
  - 公共静态资源管理
  https://blog.coding.net/blog/spring-static-resource-process 静态资源处理的深入理解
  /static/css/static/img/background-login.ddb2ae9.png
  /static/img/logo.ae18ffb.png  
  - 路径问题  
  http://tomcat.apache.org/tomcat-5.5-doc/servletapi/index.html getRealpath  
- （格式化的）数据管理
  - 存储
  - 检索
  - 流处理/批处理
  - IO 网络
  - 视图
- 定时调度
  https://www.jianshu.com/p/7e755698d58a  美团调度，Quartz应用与集群原理分析  
  http://www.quartz-scheduler.org/documentation/quartz-2.x/tutorials/crontrigger.html  cron表达式  
  1. 动态的调整任务周期，调整之后从下次开始执行新的周期  
  2. 停止之后重启调整任务周期，相当于关闭旧任务，开启新任务  
  3. 执行指定次数之后结束任务，或者指定时间之后结束任务  
- 权限管理
  - 临时授权
  - 中央集权
  - 传递授权
  - 登录/登出  
  https://www.infoq.cn/article/LZE*ob52bASspjYu4c6Z 不就是个短信验证嘛，还真挺复杂的
- 使用手册（帮助文档）
  - 
- 技术文档
- 恶意攻击
- 用户审计
- 安全

## 算法

https://www.cnblogs.com/chanshuyi/p/9197164.html  算法、正则、CPU  
https://github.com/algorithm-visualizer  算法可视化 

- 存储引擎
- 检索引擎
- 消息引擎
- 流处理引擎
