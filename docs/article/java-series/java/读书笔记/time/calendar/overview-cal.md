# Overview

There are two basic ways to represent time. One way represents time in human terms, referred to as human time, such as year, month, day, hour, minute and second. The other way, machine time, measures time continuously along a timeline from an origin, called the epoch, in nanosecond resolution. The Date-Time package provides a rich array of classes for representing date and time. Some classes in the Date-Time API are intended to represent machine time, and others are more suited to representing human time.

表示时间有两种基本方法。  
一种方式代表人类的时间，称为人类时间，例如年，月，日，小时，分钟和秒。  
另一种方式，机器时间，沿着来自原点的时间线连续测量时间，称为 epoch ，以纳秒分辨率。  
Date-Time包提供了丰富的类数组，用于表示日期和时间。  
Date-Time API中的某些类用于表示机器时间，而其他类更适合表示人工时间。  

First determine what aspects of date and time you require, and then select the class, or classes, that fulfill those needs. When choosing a temporal-based class, you first decide whether you need to represent human time or machine time. You then identify what aspects of time you need to represent. Do you need a time zone? Date and time? Date only? If you need a date, do you need month, day, and year, or a subset?

首先确定您需要的日期和时间的哪些方面，然后选择满足这些需求的类或类。  
选择基于时间的 class 时，首先要确定是否需要表示人工时间或机器时间。  
然后，您可以确定需要表示的时间方面。你需要一个时区吗？日期和时间？仅限日期？  
如果你需要一个日期，你需要月，日和年，或者一个子集？  

> Terminology: The classes in the Date-Time API that capture and work with date or time values, such as Instant, LocalDateTime, and ZonedDateTime, are referred to as temporal-based classes (or types) throughout this tutorial. Supporting types, such as the TemporalAdjuster interface or the DayOfWeek enum, are not included in this definition.

> 术语：在本教程 中，Date-Time API中捕获和使用日期或时间值的类（如Instant，LocalDateTime和ZonedDateTime）在本教程中称为 temporal-based 的类（或类型）。 Supporting types ，如 TemporalAdjuster 接口或 DayOfWeek 枚举 不包含在此定义中。

For example, you might use a LocalDate object to represent a birth date, because most people observe their birthday on the same day, whether they are in their birth city or across the globe on the other side of the international date line. If you are tracking astrological time, then you might want to use a LocalDateTime object to represent the date and time of birth, or a ZonedDateTime, which also includes the time zone. If you are creating a time-stamp, then you will most likely want to use an Instant, which allows you to compare one instantaneous point on the timeline to another.

例如，您可以使用`LocalDate`对象来表示出生日期，因为大多数人在同一天观察他们的生日，无论他们是在出生城市还是在国际日期行的另一侧。  
如果您正在跟踪占星时间，那么您可能希望使用`LocalDateTime`对象来表示出生日期和时间，或者使用`ZonedDateTime`（也包括时区）。  
如果您正在创建时间戳，那么您很可能希望使用`Instant`，它允许您将时间线上的一个瞬时点与另一个瞬时点进行比较。  

The following table summarizes the temporal-based classes in the java.time package that store date and/or time information, or that can be used to measure an amount of time. A check mark in a column indicates that the class uses that particular type of data and the toString Output column shows an instance printed using the toString method. The Where Discussed column links you to the relevant page in the tutorial.

下表总结了存储日期和/或时间信息的`java.time`包中基于时间的类，或者可用于测量时间量的类。  
列中的复选标记表示该类使用该特定类型的数据，而toString Output列显示使用toString方法打印的实例。`Where Discussed`列链接你到相关页面的教程。

| Class or Enum  | Year | Month | Day | Hours | Minutes | Seconds* | Zone Offset | Zone ID | toString Output                           | Where Discussed              |
| -------------- | ---- | ----- | --- | ----- | ------- | -------- | ----------- | ------- | ----------------------------------------- | ---------------------------- |
| Instant        |      |       |     |       |         | √        |             |         | 2013-08-20T15:16:26.355Z                  | Instant Class                |
| LocalDate      | √    | √     | √   |       |         |          |             |         | 2013-08-20                                | Date Classes                 |
| LocalDateTime  | √    | √     | √   | √     | √       | √        |             |         | 2013-08-20T08:16:26.937                   | Date and Time Classes        |
| ZonedDateTime  | √    | √     | √   | √     | √       | √        | √           | √       | 2013-08-21T00:16:26.941+09:00[Asia/Tokyo] | Time Zone and Offset Classes |
| LocalTime      |      |       |     | √     | √       | √        |             |         | 08:16:26.943                              | Date and Time Classes        |
| MonthDay       |      | √     | √   |       |         |          |             |         | --08-20                                   | Date Classes                 |
| Year           | √    |       |     |       |         |          |             |         | 2013                                      | Date Classes                 |
| YearMonth      | √    | √     |     |       |         |          |             |         | 2013-08                                   | Date Classes                 |
| Month          |      | √     |     |       |         |          |             |         | AUGUST                                    | DayOfWeek and Month Enums    |
| OffsetDateTime | √    | √     | √   | √     | √       | √        | √           |         | 2013-08-20T08:16:26.954-07:00             | Time Zone and Offset Classes |
| OffsetTime     |      |       |     | √     | √       | √        | √           |         | 08:16:26.957-07:00                        | Time Zone and Offset Classes |
| Duration       |      |       | **  | **    | **      | √        |             |         | PT20H (20 hours)                          | Period and Duration          |
| Period         | √    | √     | √   |       |         |          | ***         | ***     | P10D (10 days)                            | Period and Duration          |

*	Seconds are captured to nanosecond precision.  
  秒数被捕获到纳秒级精度。  
**	This class does not store this information, but has methods to provide time in these units.  
  此类不存储此信息，但具有在这些单元中提供时间的方法。
***	When a Period is added to a ZonedDateTime, daylight saving time or other local time differences are observed.  
  将 Period 添加到 ZonedDateTime 时，会观察夏令时或其他本地时差。

