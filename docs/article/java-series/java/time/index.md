# 概述

The Date-Time APIs, introduced in JDK 8, are a set of packages that model the most important aspects of date and time. The core classes in the java.time package use the calendar system defined in ISO-8601 (based on the Gregorian calendar system) as the default calendar. Other non-ISO calendar systems can be represented using the java.time.chrono package and several predefined chronologies, such as Hijrah and Thai Buddhist are provided.

JDK 8中引入的 Date-Time API 是一组模拟日期和时间的包。`java.time`包中的核心类使用`ISO-8601`中定义的日历系统（基于公历系统）作为默认日历。其他非ISO日历系统可以使用`java.time.chrono`包表示，并提供了几个预定义的年表，例如`Hijrah`和`Thai Buddhist`。

## API Specification

- java.time - Classes for date, time, date and time combined, time zones, instants, duration, and clocks.
  日期，时间，日期时间组合，时区，时刻，时间段，时钟
- java.time.chrono - API for representing calendar systems other than ISO-8601. Several predefined chronologies are provided and you can also define your own chronology.
  表示ISO-8601以外的日历系统的API。提供了几个预定义的年表，您还可以定义自己的年表。  
- java.time.format - Classes for formatting and parsing dates and time.
  用于格式化和解析日期和时间的类。  
- java.time.temporal - Extended API, primarily for framework and library writers, allowing interoperations between the date and time classes, querying, and adjustment. Fields and units are defined in this package.
  扩展API，主要用于框架和库编写器，允许日期和时间类之间的互操作，查询和调整。`Fields and units`单位在此包中定义。  
- java.time.zone - Classes that support time zones, offsets from time zones, and time zone rules.  
  支持时区，时区偏移和时区规则的类。
- JSR 310: Date and Time API

## Tutorials and Programmer's Guides

- The Date-Time API trail in The Java Tutorial shows how to write code that manipulates date and time values.  

## 目录

### Date-Time Overview

### Standard Calendar

#### DayOfWeek and Month Enums

#### Date Classes

#### Date and Time Classes

#### Time Zone and Offset Classes

#### Instant Class

#### Parsing and Formatting

#### The Temporal Package

##### Temporal Adjuster

##### Temporal Query

#### Period and Duration

#### Clock

#### Non-ISO Date Conversion

#### Legacy Date-Time Code

### Summary

### Questions and Exercises
