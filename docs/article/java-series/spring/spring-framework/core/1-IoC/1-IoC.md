# 概述

## 容器

```{}
BeanFactory
  ApplicationContext
```

### Configuration metadata

Annotation-based configuration:  
  Java-based configuration:
    @Configuration, @Bean, @Import and @DependsOn

### Instantiating a container

### Using the container

## 1.4. Dependencies

A typical enterprise application does not consist of a single object (or bean in the Spring parlance). Even the simplest application has a few objects that work together to present what the end-user sees as a coherent application. This next section explains how you go from defining a number of bean definitions that stand alone to a fully realized application where objects collaborate to achieve a goal.

### 1.4.1. Dependency Injection

Dependency injection (DI) is a process whereby objects define their dependencies, that is, the other objects they work with, only through constructor arguments, arguments to a factory method, or properties that are set on the object instance after it is constructed or returned from a factory method. The container then injects those dependencies when it creates the bean. This process is fundamentally the inverse, hence the name Inversion of Control (IoC), of the bean itself controlling the instantiation or location of its dependencies on its own by using direct construction of classes, or the Service Locator pattern.

依赖注入（DI）是一个过程，通过这个过程，对象定义它们的依赖关系，即它们使用的其他对象，只能通过构造函数参数，工厂方法的参数或在构造或返回对象实例后在对象实例上设置的属性。从工厂方法。然后容器在创建bean时注入这些依赖项。这个过程基本上是相反的，因此名称Inversion of Control（IoC），bean本身通过使用类的直接构造或服务定位器模式来控制其依赖项的实例化或位置。

Code is cleaner with the DI principle and decoupling is more effective when objects are provided with their dependencies. The object does not look up its dependencies, and does not know the location or class of the dependencies. As such, your classes become easier to test, in particular when the dependencies are on interfaces or abstract base classes, which allow for stub or mock implementations to be used in unit tests.

使用DI原理的代码更清晰，当对象提供其依赖项时，解耦更有效。该对象不查找其依赖项，也不知道依赖项的位置或类。因此，您的类变得更容易测试，特别是当依赖关系在接口或抽象基类上时，这允许在单元测试中使用存根或模拟实现。

DI exists in two major variants, Constructor-based dependency injection and Setter-based dependency injection.

DI存在两个主要变体，基于构造函数的依赖注入和基于Setter的依赖注入。

#### Constructor-based dependency injection

Constructor-based DI is accomplished by the container invoking a constructor with a number of arguments, each representing a dependency. Calling a static factory method with specific arguments to construct the bean is nearly equivalent, and this discussion treats arguments to a constructor and to a static factory method similarly. The following example shows a class that can only be dependency-injected with constructor injection. Notice that there is nothing special about this class, it is a POJO that has no dependencies on container specific interfaces, base classes or annotations.

基于构造函数的DI由容器调用具有多个参数的构造函数来完成，每个参数表示一个依赖项。 调用具有特定参数的静态工厂方法来构造bean几乎是等效的，本讨论同样处理构造函数和静态工厂方法的参数。 以下示例显示了一个只能通过构造函数注入进行依赖注入的类。 请注意，此类没有什么特别之处，它是一个POJO，它不依赖于容器特定的接口，基类或注释。

```{}
public class SimpleMovieLister {

    // the SimpleMovieLister has a dependency on a MovieFinder
    private MovieFinder movieFinder;

    // a constructor so that the Spring container can inject a MovieFinder
    public SimpleMovieLister(MovieFinder movieFinder) {
        this.movieFinder = movieFinder;
    }

    // business logic that actually uses the injected MovieFinder is omitted...
}
```

#### Constructor argument resolution

Constructor argument resolution matching occurs using the argument’s type. If no potential ambiguity exists in the constructor arguments of a bean definition, then the order in which the constructor arguments are defined in a bean definition is the order in which those arguments are supplied to the appropriate constructor when the bean is being instantiated. Consider the following class:

使用参数的类型进行构造函数参数解析匹配。 如果bean定义的构造函数参数中不存在潜在的歧义，那么在bean定义中定义构造函数参数的顺序是在实例化bean时将这些参数提供给适当的构造函数的顺序。 考虑以下课程：

```{}
package x.y;

public class Foo {

    public Foo(Bar bar, Baz baz) {
        // ...
    }
}
```

No potential ambiguity exists, assuming that Bar and Baz classes are not related by inheritance. Thus the following configuration works fine, and you do not need to specify the constructor argument indexes and/or types explicitly in the <constructor-arg/> element.

```{}
<beans>
    <bean id="foo" class="x.y.Foo">
        <constructor-arg ref="bar"/>
        <constructor-arg ref="baz"/>
    </bean>

    <bean id="bar" class="x.y.Bar"/>

    <bean id="baz" class="x.y.Baz"/>
</beans>
```

When another bean is referenced, the type is known, and matching can occur (as was the case with the preceding example). When a simple type is used, such as `<value>true</value>`, Spring cannot determine the type of the value, and so cannot match by type without help. Consider the following class:

```{}
package examples;

public class ExampleBean {

    // Number of years to calculate the Ultimate Answer
    private int years;

    // The Answer to Life, the Universe, and Everything
    private String ultimateAnswer;

    public ExampleBean(int years, String ultimateAnswer) {
        this.years = years;
        this.ultimateAnswer = ultimateAnswer;
    }
}
```

#### Constructor argument type matching

#### Constructor argument index

#### Constructor argument name

#### Setter-based dependency injection

#### Dependency resolution process

#### Examples of dependency injection

### 1.4.2. Dependencies and configuration in detail

#### Straight values (primitives, Strings, and so on)

#### References to other beans (collaborators)

#### Inner beans

#### Collections

#### Null and empty string values

#### XML shortcut with the p-namespace

#### XML shortcut with the c-namespace

#### Compound property names

### 1.4.3. Using depends-on

If a bean is a dependency of another that usually means that one bean is set as a property of another. Typically you accomplish this with the `<ref/>` element in XML-based configuration metadata. However, sometimes dependencies between beans are less direct; for example, a static initializer in a class needs to be triggered, such as database driver registration. The depends-on attribute can explicitly force one or more beans to be initialized before the bean using this element is initialized. The following example uses the depends-on attribute to express a dependency on a single bean:

如果一个 bean 是另一个bean的依赖,即一个bean是另一个的属性.通常，您可以使用基于XML的配置元数据中的`<ref />`元素来完成此操作。 但是，有时bean之间的依赖关系不那么直接; 例如，需要触发类中的静态初始化程序，例如数据库驱动程序注册。 在初始化使用此元素的bean之前，`depends-on` 属性可以显式强制初始化一个或多个bean。 以下示例使用 `depends-on` 属性表示对单个bean的依赖关系：

```{}
<bean id="beanOne" class="ExampleBean" depends-on="manager"/>
<bean id="manager" class="ManagerBean" />
```{}

To express a dependency on multiple beans, supply a list of bean names as the value of the depends-on attribute, with commas, whitespace and semicolons, used as valid delimiters:

```{}
<bean id="beanOne" class="ExampleBean" depends-on="manager,accountDao">
    <property name="manager" ref="manager" />
</bean>

<bean id="manager" class="ManagerBean" />
<bean id="accountDao" class="x.y.jdbc.JdbcAccountDao" />
```

The depends-on attribute in the bean definition can specify both an initialization-time dependency and, in the case of singleton beans only, a corresponding destruction-time dependency. Dependent beans that define a depends-on relationship with a given bean are destroyed first, prior to the given bean itself being destroyed. Thus depends-on can also control shutdown order.

bean定义中的depends-on属性既可以指定初始化时间依赖关系，也可以指定仅限单例bean的相应销毁时间依赖关系。 在给定的bean本身被销毁之前，首先销毁定义与给定bean的依赖关系的从属bean。 因此，依赖也可以控制关机顺序。

### 1.4.4. Lazy-initialized beans

### 1.4.5. Autowiring collaborators

### 1.4.6. Method injection

## 1.5. Bean scopes

## 1.6. Customizing the nature of a bean

### 1.6.1. Lifecycle callbacks

### 1.6.2. ApplicationContextAware and BeanNameAware

### 1.6.3. Other Aware interfaces

## 1.7. Bean definition inheritance

## 1.8. Container Extension Points

Typically, an application developer does not need to subclass ApplicationContext implementation classes. Instead, the Spring IoC container can be extended by plugging in implementations of special integration interfaces. The next few sections describe these integration interfaces.

通常，应用程序 developer 不需要实现 ApplicationContext 子类。  
IoC 容器可以通过可插拔的集成接口实现进行扩展。  
下面几个部分讲述这些集成扩展。  

### 1.8.1. Customizing beans using a BeanPostProcessor

### 1.8.2. Customizing configuration metadata with a BeanFactoryPostProcessor

### 1.8.3. Customizing instantiation logic with a FactoryBean

## 1.9. Annotation-based container configuration

## 1.10. Classpath scanning and managed components

## 1.11. Using JSR 330 Standard Annotations

## 1.12. Java-based container configuration

## 1.13. Environment abstraction

## 1.14. Registering a LoadTimeWeaver

## 1.15. Additional capabilities of the ApplicationContext

## 1.16. The BeanFactory