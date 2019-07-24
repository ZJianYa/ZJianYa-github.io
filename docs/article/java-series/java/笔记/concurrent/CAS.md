
## 原理

依赖硬件支持 CAS 指令，往往结合自旋使用，且一定会避开 BAB 问题。  
大致逻辑如下：

```{}
class Adder{
  volatile int count;
  add(int offset) {
    do {
      newValue = count + 1
    } while (!cas(version,expectValue,newValue))
  }
}
```

## 应用案例

- 原子类
  - 基本数据类型  
    AtomicBoolean  AtomicInteger AtomicLong  
  - 引用对象类型  
    AtomicReference AtomicStampedReference AtomicMarkableReference
  - 原子化数组
    AtomicIntegerArray  AtomicLongArray  AtomicReferenceArray
  - 对象属性更新器  
    AtomicIntegerFieldUpdater AtomicLongFieldUpdater AtomicReferenceFieldUpdater  
  - 累加器  
    DoubleAccumulator  
    DoubleAdder  
    LongAccumulator  

## FAQ

- 自旋锁  
  通过 CAS 来替代锁，并通过循环来最终实现对资源的访问，和锁其实没啥关系。  
- ABA
  
## TODO

- 原子化的引用对象类型，CAS 的版本号在哪里，以及 API  怎么用
