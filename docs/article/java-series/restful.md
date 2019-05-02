# 概述

关于命名方式和规范,是一个没有办法精确比较的话题.

## 参考

http://www.ruanyifeng.com/blog/2011/09/restful.html 理解RESTful架构
http://www.ruanyifeng.com/blog/2014/05/restful_api.html 设计指南
http://www.ruanyifeng.com/blog/2018/10/restful-api-best-practices.html  RESTful API 最佳实践
wiki  

## 详述

### 概念

Representational State Transfer

Resources 资源
URI  统一资源定位符

#### Representation

Representation 我们把"资源"具体呈现出来的形式，叫做它的"表现层"（Representation）
比如，文本可以用txt格式表现，也可以用HTML格式、XML格式、JSON格式表现，甚至可以采用二进制格式；图片可以用JPG格式表现，也可以用PNG格式表现。  
URI只代表资源的实体，不代表它的形式。严格地说，有些网址最后的".html"后缀名是不必要的，因为这个后缀名表示格式，属于"表现层"范畴，而URI应该只代表"资源"的位置。它的具体表现形式，应该在HTTP请求的头信息中用Accept和Content-Type字段指定，这两个字段才是对"表现层"的描述。  

#### Architectural constraints

- Client–server architecture
- Statelessness  
  这个是Token流行的原因吗？可这还是要缓存principal的信息的啊，Client ≠ Principal？  
- Cacheability
- Layered system
- Code on demand (optional)
- Uniform interface  
  意思是URL一样，但是metadata不一样吗？

其实，我还是那句话：不在意任何名称，我们更想知道名称背后的含义，即本质。  
那么 Restful 和其他HTTP请求有和区别？  
我们之前都用了哪些糟糕的格式，举例说明带来了哪些灾难性的后果。  

## 实践

参考  
https://blog.mwaysolutions.com/2014/06/05/10-best-practices-for-better-restful-api/  

- 简单增删改 /cars/711
- 关联查询 GET /cars/711/drivers/4
- 资源格式 serialization formats  
  Content-Type defines the request format.  
  Accept defines a list of acceptable response formats.  
- Filtering
- Sorting
- Field selection
- Paging
- Version your API
- Handle Errors with HTTP status codes
- Allow overriding HTTP method