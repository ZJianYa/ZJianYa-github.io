
https://docs.oracle.com/javase/tutorial/sound/SPI-intro.html  
https://www.baeldung.com/java-spi  
https://github.com/eugenp/tutorials/tree/master/java-spi  


## 1. Overview

## 2. Terms and Definitions of Java SPI

Java SPI 定义了4个主要组件。  

### 2.1. Service

A well-known set of programming interfaces and classes that provide access to some specific application functionality or feature.

一组程序，提供了访问某些应用程序功能和特性的接口。

### 2.2. Service Provider Interface

An interface or abstract class that acts as a proxy or an endpoint to the service.  
If the service is one interface, then it is the same as a service provider interface.  
Service and SPI together are well-known in the Java Ecosystem as API.

一个作为 service 的 proxy 或者 endpoint 的接口或者抽象类。  
如果服务是一个接口，则它与服务提供者接口相同。  
服务和SPI一起在Java Ecosystem中作为API。  

### 2.3. Service Provider

A specific implementation of the SPI. The Service Provider contains one or more concrete classes that implement or extends the service type.  

SPI的具体实现。服务提供者包含一个或多个实现或扩展服务类型的具体类。  

A Service Provider is configured and identified through a provider configuration file which we put in the resource directory META-INF/services. The file name is the fully-qualified name of the SPI and his content is the fully-qualified name of the SPI implementation.

通过我们放在资源目录 META-INF/services 中的配置文件来配置和识别 SP。  
文件名是 SPI 的完全限定名称，其内容是 SPI 实现的完全限定名称。  

服务提供者以扩展的形式安装，我们放置在应用程序类路径中的jar文件，java扩展类路径或用户定义的类路径。  

### 2.4. ServiceLoader

SPI的核心是ServiceLoader类。这具有懒惰地发现和加载实现的作用。它使用上下文类路径来定位提供程序实现并将它们放在内部缓存中。

## 3. SPI Samples in Java Ecosystem

Java提供了许多SPI，以下是服务提供者接口的一些示例及其提供的服务：

* CurrencyNameProvider：为 Currency类提供本地化的货币符号。
* LocaleNameProvider：为 Locale类提供本地化名称。
* TimeZoneNameProvider：为 TimeZone类提供本地化的时区名称。
* DateFormatProvider：提供指定区域设置的日期和时间格式。
* NumberFormatProvider：为 NumberFormat类提供货币，整数和百分比值。
* 驱动程序：从4.0版开始，JDBC API支持SPI模式。旧版本使用 Class.forName（）方法加载驱动程序。
* PersistenceProvider：提供JPA API的实现。
* JsonProvider：提供JSON处理对象。
* JsonbProvider：提供JSON绑定对象。
* 扩展：为CDI容器提供扩展。
* ConfigSourceProvider：提供检索配置属性的源。

## 4. Showcase: a Currency Exchange Rates Application

