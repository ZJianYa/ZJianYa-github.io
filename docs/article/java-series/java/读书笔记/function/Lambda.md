# 概述

https://en.wikipedia.org/wiki/Currying 柯力化  
[https://docs.oracle.com/javase/tutorial/java/javaOO/lambdaexpressions.html](https://docs.oracle.com/javase/tutorial/java/javaOO/lambdaexpressions.html)

可以替代匿名函数，把函数作为参数传入给函数。

## 语法

```{.java}
(a,b,c) -> {
  ;
}
```

- 括号中用逗号分隔的形式参数列表  
  注意：您可以省略lambda表达式中参数的数据类型。此外，如果只有一个参数，则可以省略括号。例如，以下lambda表达式也是有效的：  

```{.java}
  p  - > p.getGender（）== Person.Sex.MALE  
    && p.getAge（）> = 18  
    && p.getAge（）<= 25  
```

- 箭头标记， ->  
- 一个主体  
  由单个表达式或语句块组成。此示例使用以下表达式：  

```{.java}
  p.getGender（）== Person.Sex.MALE  
    && p.getAge（）> = 18  
    && p.getAge（）<= 25  
```

如果指定单个表达式，则Java运行时将计算表达式，然后返回其值。或者，您可以使用return语句：  

```{}
  p  - > {  
    return p.getGender（）== Person.Sex.MALE  
        && p.getAge（）> = 18  
        && p.getAge（）<= 25;  
  }
```

return语句不是表达式; 在lambda表达式中，必须用大括号（{}）括起语句。但是，您不必在大括号中包含void方法调用。例如，以下是有效的lambda表达式：

```{}
email -> System.out.println(email)
```

这个lambda表达式看起来很像方法声明.你可以把lambda表达式看做匿名方法.

下面的例子,`Calculator`,是一个接受多个参数的`lambda`表达式

方法`operateBinary`对两个整数操作数执行数学运算。操作本身由`IntegerMath`实例指定。例子中用`lambda`表达式定义了两个操作，`addition` 和 `subtraction`。该示例打印以下内容：

```{}
40 + 2 = 42
20 - 10 = 10
```

## 访问`Enclosing Scope`的local变量

像内部类一样,`lambda`表达式可以捕获变量;它们对封闭范围的局部变量具有相同的访问权限。但是，与内部类\匿名类不同，`lambda`表达式没有任何`shadowing issues`问题。`Lambda`表达式是词法范围的。这意味着它们不会从超类型继承任何名称或引入新级别的范围。`lambda`表达式中的声明与封闭环境中的声明一样被解释。以下示例 `LambdaScopeTest` 演示了这一点：

```{}
``