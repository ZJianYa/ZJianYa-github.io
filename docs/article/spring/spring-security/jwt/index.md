# 概述

https://jwt.io/introduction/  

## WHY & WHEN

- 专注于签名令牌
- 应用场景
  - 授权 Single Sign On
  - 信息交换
    使用公钥/私钥对 - 您可以确定发件人是他们所说的人。此外，由于使用标头和有效负载计算签名，您还可以验证内容是否未被篡改。

### session ？

Session 模式的问题在于，扩展性（scaling）不好。单机当然没有问题，如果是服务器集群，或者是跨域的服务导向架构，就要求 session 数据共享，每台服务器都能够读取 session。

举例来说，A 网站和 B 网站是同一家公司的关联服务。现在要求，用户只要在其中一个网站登录，再访问另一个网站就会自动登录，请问怎么实现？

一种解决方案是 session 数据持久化，写入数据库或别的持久层。各种服务收到请求后，都向持久层请求数据。这种方案的优点是架构清晰，缺点是工程量比较大。另外，持久层万一挂了，就会单点失败。

另一种方案是服务器索性不保存 session 数据了，所有数据都保存在客户端，每次请求都发回服务器。JWT 就是这种方案的一个代表。

## JWT VS SWT VS SAML

让我们来谈谈JSON Web Tokens（JWT）与Simple Web Tokens（SWT）和Security Assertion Markup Language Tokens（SAML）相比的好处。

由于JSON比XML更简洁，因此在编码时它的大小也更小，使得JWT比SAML更紧凑。这使得JWT成为在HTML和HTTP环境中传递的不错选择。

在安全方面，SWT只能使用HMAC算法通过共享密钥对称签名。但是，JWT和SAML令牌可以使用X.509证书形式的公钥/私钥对进行签名。与签名JSON的简单性相比，使用XML数字签名对XML进行签名而不会引入模糊的安全漏洞非常困难。

JSON解析器在大多数编程语言中很常见，因为它们直接映射到对象。相反，XML没有自然的文档到对象映射。这使得使用JWT比使用SAML断言更容易。

关于使用，JWT用于互联网规模。这突出了在多个平台（尤其是移动平台）上轻松进行JSON Web令牌的客户端处理。

比较编码的JWT和编码的SAML的长度 比较编码的JWT和编码的SAML的长度

如果您想了解有关JSON Web Tokens的更多信息，甚至开始使用它们在您自己的应用程序中执行身份验证，请浏览到Auth0 上的JSON Web Token登录页面。

## How

### 格式

在紧凑的形式中，JSON Web Tokens由dot 分隔的三个部分组成，它们是：

- Header 头
- Payload 有效载荷
- 签名

因此，JWT通常如下所示。

xxxxx.yyyyy.zzzzz

让我们分解不同的部分。

#### Header  

通常由两部分组成：令牌的类型，即JWT，以及正在使用的签名算法，例如HMAC SHA256或RSA。

例如：

```{}
{
  "alg": "HS256",
  "typ": "JWT"
}
```

然后，这个JSON被编码为Base64Url，形成JWT的第一部分。

#### Payload

包含了claims。Claims 是关于实体（通常是用户）和其他数据的声明。有三种类型Claims：registered, public, and private claims。

- Registered claims: 是一组预定义的Claims，（这些Claims)不是强制性的，但是推荐使用（这组预定义claims）以提供一组有用的，可互操作的声明。  
  - iss (issuer)：签发人
  - exp (expiration time)：过期时间
  - sub (subject)：主题
  - aud (audience)：受众
  - nbf (Not Before)：生效时间
  - iat (Issued At)：签发时间
  - jti (JWT ID)：编号
  请注意，声明名称只有三个字符，因为JWT意味着紧凑。  
- Public claims: 这些可以由使用JWT的人随意定义。但为避免冲突，应在 [IANA JSON Web令牌注册表](https://www.iana.org/assignments/jwt/jwt.xhtml)中定义它们，或者将其定义为包含防冲突命名空间的URI。
- Private claims: 这些是当事人之间自定义的信息

一个payload大致是这个样子：

```{}
{
  "sub": "1234567890",
  "name": "John Doe",
  "admin": true
}
```

然后，payload经过Base64Url编码，形成JSON Web令牌的第二部分。

>请注意，对于签名令牌，此信息虽然可以防止被篡改，但任何人都可以读取。除非加密，否则不要将秘密信息放在JWT的有效负载或头元素中。

#### Signature

要创建签名部分，您必须采用`the encoded header, the encoded payload, a secret`，header中指明的算法，并对其进行签名。  
例如，如果要使用HMAC SHA256算法，将按以下方式创建签名：

```{}
HMACSHA256(
  base64UrlEncode(header) + "." +
  base64UrlEncode(payload),
  secret)
```

签名用于验证消息在此过程中未被更改，并且，在使用私钥签名的令牌的情况下，它还可以验证JWT的发件人是否是它所声称的人。

### 综述

最终的结果（JWT）是三个由点分隔的`Base64-URL`字符串，可以在HTML和HTTP环境中轻松传递，而与基于XML的标准（如SAML）相比更加紧凑。

下面显示了一个JWT，它具有先前的头和​​有效负载编码，并使用密钥签名。  

```{}
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c
```

如果您想使用JWT并将这些概念付诸实践，您可以使用[jwt.io Debugger](https://jwt.io/)来解码，验证和生成JWT。

### JSON Web令牌如何工作？

在身份验证中，当用户使用其凭据成功登录时，将返回JSON Web令牌。由于令牌是凭证，因此必须非常小心以防止出现安全问题。一般情况下，您不应该将令牌保留的时间超过要求。

每当用户想要访问受保护的路由或资源时，用户代理应该使用`payload`模式发送JWT，通常在Authorization标头中。`header`的内容应如下所示：

```{}
Authorization: Bearer <token>
```

在某些情况下，这可以是无状态授权机制。服务器的受保护路由将检查`Authorization`头中的有效JWT ，如果存在，则允许用户访问受保护资源。如果JWT包含必要的数据，则可以减少查询数据库以进行某些操作的需要，尽管可能并非总是如此。

如果在标Authorization头中发送令牌，则跨域资源共享（CORS）将不会成为问题，因为它不使用cookie。

下图显示了如何获取JWT并用于访问API或资源：

1. 应用程序或客户端向授权服务器请求授权。这是通过其中一个不同的授权流程执行的。例如，典型的OpenID Connect兼容Web应用程序将/oauth/authorize使用授权代码流通过端点。
2. 授予授权后，授权服务器会向应用程序返回访问令牌。
3. 应用程序使用访问令牌来访问受保护资源（如API）。

请注意，使用签名令牌，令牌中包含的所有信息都会向用户或其他方公开，即使他们无法更改。这意味着您不应该在令牌中放置秘密信息。

## FAQ  

- HMAC RSA  ECDSA
- Base64Url vs Base64