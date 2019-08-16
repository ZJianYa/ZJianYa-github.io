# 概述

https://www.baeldung.com/spring-value-annotation

用于给 `field` 注入值，可用于 `field or constructor/method parameter` 级别。  

## 详述

### 配置常量

基本没用

### 读取配置文件（简单）

* 在 上使用 @PropertySource 指明要读取的配置文件，例如：

  ``

* 编写 .properties 文件,例如

```  
```  

* 在属性上填写 @Value 注解

* 设置默认值

### 读取系统变量

If the same property is defined as a system property and in the properties file, then the system property would be applied.

Suppose we had a property priority defined as a system property with the value “System property” and defined as something else in the properties file. In the following code the value would be “System property”:

```{}
@Value("${priority}")
private String prioritySystemProperty;
```

### 读取配置文件（复杂）

#### Array

Sometimes we need to inject a bunch of values. It would be convenient to define them as comma-separated values for the single property in the properties file or as a system property and to inject into an array. In the first section, we defined comma-separated values in the listOfValues of the properties file, so in the following example the array values would be [“A”, “B”, “C”]:

@Value("${listOfValues}")
private String[] valuesArray;

#### SpEL

#### map

We can also use the @Value annotation to inject a Map property.

First, we’ll need to define the property in the {key: ‘value’ } form in our properties file:

valuesMap={key1: '1', key2: '2', key3: '3'}

**Note that the values in the Map must be in single quotes.**

Now we can inject this value from the property file as a Map:

```{}
@Value("#{${valuesMap}}")
private Map<String, Integer> valuesMap;
```

### 编码问题
