# 概述

The Date-Time API offers a rich set of methods within a rich set of classes. The method names are made consistent between classes wherever possible. For example, many of the classes offer a now method that captures the date or time values of the current moment that are relevant to that class. There are from methods that allow conversion from one class to another.

`Date-Time API`在一组丰富的 classes 中提供了一组丰富的方法。尽可能在类之间保持方法名一致。例如很多 classes 提供一个 now 方法，返回相对于那个 classes 上的当前时刻。 from 方法运行把一个类转为另一个。

There is also standardization regarding the method name prefixes. Because most of the classes in the Date-Time API are immutable, the API does not include set methods. (After its creation, the value of an immutable object cannot be changed. The immutable equivalent of a set method is with.) The following table lists the commonly used prefixes:

关于方法名称前缀也有标准化。由于Date-Time API中的大多数类都是不可变的，因此API不包含set方法。（其创建之后，一个不可变的对象的值不能被改变的所述的不可变的等效集方法是用。）下表列出了常用的前缀：

| Prefix | Method Type    | Use                                                                                                           |
| ------ | -------------- | ------------------------------------------------------------------------------------------------------------- |
| of     | static factory | 创建一个实例，其中工厂主要验证输入参数，而不是转换它们。                                                      |
| from   | static factory | 将输入参数转换为目标类的实例，这可能从输入中丢失信息。                                                        |
| parse  | static factory | 解析输入字符串以生成目标类的实例。                                                                            |
| format | instance       | 使用指定的格式化程序格式化 temporal 对象中的值以生成字符串。                                                  |
| get    | instance       | 返回目标对象状态的一部分。比如当前时间中的天                                                                  |
| is     | instance       | 查询目标对象的状态。                                                                                          |
| with   | instance       | 返回目标对象的副本，其中一个元素已更改; 这是JavaBean上set方法的不可变等价物。 简明的说就是相当于做了set设置。 |
| plus   | instance       | 返回目标对象的副本，并添加一定量的时间。                                                                      |
| minus  | instance       | 返回目标对象的副本，减去时间量。                                                                              |
| to     | instance       | 将此对象转换为另一种类型。                                                                                    |
| at     | instance       | 将此对象与另一个对象组合。                                                                                    |
