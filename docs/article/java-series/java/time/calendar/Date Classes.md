# Date Classes

Date-Time API提供了四个专门处理日期信息的类，而不考虑时间或时区。类名建议使用这些类：LocalDate，YearMonth，MonthDay和Year。

The Date-Time API provides four classes that deal exclusively with date information, without respect to time or time zone. The use of these classes are suggested by the class names: LocalDate, YearMonth, MonthDay, and Year.

## LocalDate

一个 LOCALDATE 的代表年，月，日的ISO日历，对表示没有时间的日期是有用的。  
您可以使用LocalDate跟踪重要事件，例如出生日期或结婚日期。以下示例使用of和with方法创建LocalDate的实例：

A LocalDate represents a year-month-day in the ISO calendar and is useful for representing a date without a time. You might use a LocalDate to track a significant event, such as a birth date or wedding date. The following examples use the of and with methods to create instances of LocalDate:

```{}
LocalDate date = LocalDate.of(2000, Month.NOVEMBER, 20);
LocalDate nextWed = date.with(TemporalAdjusters.next(DayOfWeek.WEDNESDAY));
```

For more information about the TemporalAdjuster interface, see Temporal Adjuster.

In addition to the usual methods, the LocalDate class offers getter methods for obtaining information about a given date. The getDayOfWeek method returns the day of the week that a particular date falls on. For example, the following line of code returns "MONDAY":  
除了常用方法之外，LocalDate类还提供了获取有关给定日期的信息的getter方法。该 getDayOfWeek方法返回一个特定日期适逢星期。例如，以下代码行返回“MONDAY”：  

DayOfWeek dotw = LocalDate.of(2012, Month.JULY, 9).getDayOfWeek();

The following example uses a TemporalAdjuster to retrieve the first Wednesday after a specific date.  
以下示例使用`TemporalAdjuster`检索特定日期之后的第一个星期三。

LocalDate date = LocalDate.of(2000, Month.NOVEMBER, 20);
TemporalAdjuster adj = TemporalAdjusters.next(DayOfWeek.WEDNESDAY);
LocalDate nextWed = date.with(adj);
System.out.printf("For the date of %s, the next Wednesday is %s.%n",
                  date, nextWed);

Running the code produces the following:  
运行代码会产生以下结果：  

For the date of 2000-11-20, the next Wednesday is 2000-11-22.  

The `Period and Duration` section also has examples using the LocalDate class.  

## YearMonth

