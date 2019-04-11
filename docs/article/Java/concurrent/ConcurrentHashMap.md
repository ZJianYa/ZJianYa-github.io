# 概述

Vector Stack Hashtable  
Synchronized Wrapper  

线程安全和并发

Queque Deque ConcurrentHashMap CopyOnWriteArrayList

## ConcurrentHashMap

### WHY

Hashtable synchronized，增加了热点数据的争夺  

Collections 提供的 Synchronized Wrapper 和HashTable本质是一样的  

### HOW

数据存储利用 volatile 来保证可见性。