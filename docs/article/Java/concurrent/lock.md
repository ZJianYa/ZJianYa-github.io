# 概述

## 锁的机制

- CAS

- 掌握 synchronized、ReentrantLock 底层实现  
- 理解锁膨胀、降级  
- 理解偏斜锁、自旋锁、轻量级锁、重量级锁等概念  
- 掌握并发包中 java.util.concurrent.lock 各种不同实现和案例分析  

## volatile

## ReentrantLock

```{}
/** Condition for waiting takes */
private final Condition notEmpty;

/** Condition for waiting puts */
private final Condition notFull;

public ArrayBlockingQueue(int capacity, boolean fair) {
  if (capacity <= 0)
      throw new IllegalArgumentException();
  this.items = new Object[capacity];
  lock = new ReentrantLock(fair);
  notEmpty = lock.newCondition();
  notFull =  lock.newCondition();
}
```

ArrayBlockingQueue 到底怎么用，why

