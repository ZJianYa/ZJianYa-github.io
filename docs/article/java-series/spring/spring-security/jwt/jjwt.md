# 概述

翻译： https://github.com/jwtk/jjwt

JJWT aims to be the easiest to use and understand library for creating and verifying JSON Web Tokens (JWTs) on the JVM and Android.

JJWT是一个纯Java实现，完全基于JWT， JWS，JWE， JWK和JWA RFC规范以及Apache 2.0许可条款下的开源。

The library was created by Okta's Senior Architect, Les Hazlewood and is supported and maintained by a community of contributors.

Okta是一个面向开发人员的完整身份验证和用户管理的API。

我们还添加了一些不属于规范的便利扩展，例如JWT压缩和强制claim。

## 特性

## What is a JSON Web Token?

## 安装

### JDK Projects

#### Maven

```{}
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-api</artifactId>
    <version>0.10.5</version>
</dependency>
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-impl</artifactId>
    <version>0.10.5</version>
    <scope>runtime</scope>
</dependency>
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-jackson</artifactId>
    <version>0.10.5</version>
    <scope>runtime</scope>
</dependency>
<!-- Uncomment this next dependency if you want to use RSASSA-PSS (PS256, PS384, PS512) algorithms:
<dependency>
    <groupId>org.bouncycastle</groupId>
    <artifactId>bcprov-jdk15on</artifactId>
    <version>1.60</version>
    <scope>runtime</scope>
</dependency>
-->
```

#### Gradle

### Android Projects

## Understanding JJWT Dependencies

请注意，上面的依赖声明都只有一个编译时依赖项，其余的声明为运行时依赖项。

因为JJWT设计为了让你仅需要依赖APIs，所有其他内部实现细节（可以在没有警告的情况下更改） - 降级为仅运行时依赖项。如果您想确保稳定的JJWT使用和升级，这一点非常重要：

JJWT保证所有`artifacts`语义上的版本兼容，除`jjwt-impl.jar`之外。对`jjwt-impl.jar`和内部更改没有这样的保证。永远不要将jjwt-impl.jar 添加 到带有compile范围的项目中- 始终使用runtime范围声明它。

这样做是为了您好：精心管理`jjwt-api.jar`并确保它包含您需要的内容并尽可能保持向后兼容，以便您可以安全地在编译范围依赖。 运行时`jjwt-impl.jar`策略为JJWT开发人员提供了随时随地更改内部包和实现的灵活性。这有助于我们更快，更有效地实现功能，修复错误并向您发送新版本。

## 快速开始

大多数复杂性隐藏在方便且可读的基于构建器的流畅界面背后，非常适合依靠IDE自动完成来快速编写代码。这是一个例子：

```{}
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import java.security.Key;

// We need a signing key, so we'll create one just for this example. Usually
// the key would be read from your application configuration instead.
Key key = Keys.secretKeyFor(SignatureAlgorithm.HS256);

String jws = Jwts.builder().setSubject("Joe").signWith(key).compact();
```

在这个例子中，我们实现了：

1. 构建一个带有`registered claim sub (subject) set to Joe`的JWT，
2. 使用适合HMAC-SHA-256算法的密钥对JWT进行签名，
3. 其压缩成最终String形式。签名的JWT称为“JWS”。

生成的jws字符串看起来像这样：

```{}
eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJKb2UifQ.1KP0SsvENi7Uz1oQc07aXTL7kpQG5jBNIybqr60AlD4
```

现在让我们验证JWT（你应该总是丢弃与预期签名不匹配的JWT）：

```{}
assert Jwts.parser().setSigningKey(key).parseClaimsJws(jws).getBody().getSubject().equals("Joe");
```

一定要调用`parseClaimsJws`方法，因为有很多相似的方法，如果你用错了方法，你会得到一个`UnsupportedJwtException`

这里有两件事。key之前的from用于验证JWT的签名。如果它无法验证JWT，则抛出SignatureException（从中延伸JwtException）。如果JWT已经过验证，我们会解析声明并断言该主题设置为Joe。

但是如果解析或签名验证失败怎么办？您可以相应地捕捉JwtException并做处理：

```{}
try {

    Jwts.parser().setSigningKey(key).parseClaimsJws(compactJws);

    //OK, we can trust this JWT

} catch (JwtException e) {

    //don't trust the JWT!
}
```

## Signed JWTs

### Signature Algorithms Keys

### Creating a JWS

### Reading a JWS

## Compression

## JSON Support

## Base64 Support

## Learn More

## Author

## License