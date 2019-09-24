# 概述

TreeMap 是基于红黑树的  
HashMap 的put/get复杂度是多少？  

## HashMap

### 内部实现

- 桶 Node链表
- 扩容

  ```{}
    if (++size > threshold)
      resize();  
  ```

- 哈希表中的位置
  i = (n - 1) & hash  
  仔细观察哈希值的源头，我们会发现，它并不是 key 本身的 hashCode，而是来自于 HashMap 内部的另外一个 hash 方法。注意，为什么这里需要将高位数据移位到低位进行异或运算呢？  
  这是因为有些数据计算出的哈希值差异主要在高位，而 HashMap 里的哈希寻址是忽略容量以上的高位的，那么这种处理就可以有效避免类似情况下的哈希碰撞。

```{}
static final int hash(Object kye) {
    int h;
    return (key == null) ? 0 : (h = key.hashCode()) ^ (h >>>16;
}
```

- 初始化，扩容，树化

### 扩容，树化

TODO 看源码