# Executor

In all of the previous examples, there's a close connection between the task being done by a new thread, as defined by its Runnable object, and the thread itself, as defined by a Thread object. This works well for small applications, but in large-scale applications, it makes sense to separate thread management and creation from the rest of the application. Objects that encapsulate these functions are known as executors. The following subsections describe executors in detail.

前面的例子中，在任务和线程之间有一个紧密的联系，如 Runnable 对象中所定义。对于小应用来讲这没问题，但是在大规模的应用中，将线程管理和创建与应用程序的其余部分分开是有意义的。封装这些函数的对象称为 executors 。以下小节详细描述了 executors 。

- [Executor Interfaces](https://docs.oracle.com/javase/tutorial/essential/concurrency/exinter.html) define the three executor object types.  
Executor Interfaces定义三个 executor object 类型。
- Thread Pools are the most common kind of executor implementation.  
线程池是最常见的 executor 实现类型。  
- Fork/Join is a framework (new in JDK 7) for taking advantage of multiple processors.  
是一个利用多个处理器的框架（JDK 7中的新增功能）。  

## Executor Interfaces

The java.util.concurrent package defines three executor interfaces:

- Executor, a simple interface that supports launching new tasks.  
- ExecutorService, a subinterface of Executor, which adds features that help manage the lifecycle, both of the individual tasks and of the executor itself.  
ExecutorService 是 Executor 的一个子接口，增加了很多管理生命周期的功能，包括单个任务和 executor 本身。
- ScheduledExecutorService, a subinterface of ScheduledExecutorService, supports future and/or periodic execution of tasks.  
ScheduledExecutorService，一个 ScheduledExecutorService 的子接口，支持  future 和/或 定期执行任务。

Typically, variables that refer to executor objects are declared as one of these three interface types, not with an executor class type.  
通常，引用executor对象的变量被声明为这三种接口类型之一，而不是执行器类类型。  

### The Executor Interface

The Executor interface provides a single method, execute, designed to be a drop-in replacement for a common thread-creation idiom . If `r` is a Runnable object, and `e` is an Executor object you can replace.  
该 Executor接口提供了一种方法，execute 被设计为常见线程创建习惯语法的替代品。如果 r 是 Runnable 对象，e 则是可以替换为 Executor 的对象  

```{}
(new Thread(r)).start();
```

with

```{}
e.execute(r);
```

However, the definition of execute is less specific. The low-level idiom creates a new thread and launches it immediately. Depending on the Executor implementation, execute may do the same thing, but is more likely to use an existing worker thread to run r, or to place r in a queue to wait for a worker thread to become available. (We'll describe worker threads in the section on Thread Pools.)  
但是，execute 的定义不太具体。低级习语创建一个新线程并立即启动它。根据Executor实现，execute可能会执行相同的操作，但更有可能使用现有的工作线程来运行r，或者放入r队列以等待工作线程变为可用。（我们将在线程池的部分中描述工作线程。）

The executor implementations in java.util.concurrent are designed to make full use of the more advanced `ExecutorService` and `ScheduledExecutorService` interfaces, although they also work with the base Executor interface.  
executor 的实现 java.util.concurrent 旨在充分利用更高级 ExecutorService 和 ScheduledExecutorService 接口，尽管它们也可以与基本Executor接口一起使用。

### The ExecutorService Interface

The ExecutorService interface supplements execute with a similar, but more versatile submit method. Like execute, submit accepts Runnable objects, but also accepts Callable objects, which allow the task to return a value. The submit method returns a Future object, which is used to retrieve the Callable return value and to manage the status of both Callable and Runnable tasks.
ExecutorService接口补充 execute 具有相似的，但更通用的submit方法。和 execute 类似，submit 接受 Runnable 对象，但也接受 Callable 允许任务返回值的对象。该 submit 方法返回一个 Future 对象，该对象用于检索 Callable 返回值并管理两者Callable和Runnable任务的状态。  

ExecutorService also provides methods for submitting large collections of Callable objects. Finally, ExecutorService provides a number of methods for managing the shutdown of the executor. To support immediate shutdown, tasks should handle interrupts correctly.  

ExecutorService还提供了提交大量Callable对象的方法。最后，ExecutorService提供了许多用于管理执行程序关闭的方法。为了支持立即关闭，任务应该正确处理中断。

### The ScheduledExecutorService Interface

The ScheduledExecutorService interface supplements the methods of its parent ExecutorService with schedule, which executes a Runnable or Callable task after a specified delay. In addition, the interface defines `scheduleAtFixedRate` and `scheduleWithFixedDelay`, which executes specified tasks repeatedly, at defined intervals.

`ScheduledExecutorService` 接口补充其父 ExecutorService 的 schedule 方法，其执行Runnable或Callable在指定的延迟后的任务。此外，接口定义 scheduleAtFixedRate 并 scheduleWithFixedDelay 以规定的间隔重复执行指定的任务。

## Thread Pools

Most of the executor implementations in java.util.concurrent use thread pools, which consist of worker threads. This kind of thread exists separately from the Runnable and Callable tasks it executes and is often used to execute multiple tasks.  
大多数执行程序实现都在java.util.concurrent使用线程池，它由工作线程组成。这种线程 Runnable 与 Callable 它执行的任务分开存在，通常用于执行多个任务。

Using worker threads minimizes the overhead due to thread creation. Thread objects use a significant amount of memory, and in a large-scale application, allocating and deallocating many thread objects creates a significant memory management overhead.  
使用工作线程可以最大限度地减少由于线程创建而产生 线程对象使用大量内存，而在大型应用程序中，分配和释放许多线程对象会产生大量的内存管理开销。

One common type of thread pool is the fixed thread pool. This type of pool always has a specified number of threads running; if a thread is somehow terminated while it is still in use, it is automatically replaced with a new thread. Tasks are submitted to the pool via an internal queue, which holds extra tasks whenever there are more active tasks than threads.  
一种常见类型的线程池是固定线程池。这种类型的池始终具有指定数量的线程运行; 如果某个线程在仍在使用时以某种方式终止，它将自动替换为新线程。任务通过内部队列提交到池中，只要有多个活动任务而不是线程，该队列就会保存额外的任务。

An important advantage of the fixed thread pool is that applications using it degrade gracefully. To understand this, consider a web server application where each HTTP request is handled by a separate thread. If the application simply creates a new thread for every new HTTP request, and the system receives more requests than it can handle immediately, the application will suddenly stop responding to all requests when the overhead of all those threads exceed the capacity of the system. With a limit on the number of the threads that can be created, the application will not be servicing HTTP requests as quickly as they come in, but it will be servicing them as quickly as the system can sustain.  
固定线程池的一个重要优点是使用它的应用程序可以优雅地降级。要理解这一点，请考虑一个Web服务器应用程序，其中每个HTTP请求都由一个单独的线程处理。如果应用程序只是为每个新的HTTP请求创建一个新线程，并且系统接收的请求数超过它可以立即处理的数量，那么当所有这些线程的开销超过系统容量时，应用程序将突然停止响应所有请求。由于可以创建的线程数量有限制，应用程序不会像它们进入时那样快速地为HTTP请求提供服务，但它将在系统可以维持的时间内尽快为它们提供服务。

A simple way to create an executor that uses a fixed thread pool is to invoke the newFixedThreadPool factory method in `java.util.concurrent.Executors` This class also provides the following factory methods:

创建使用固定线程池的执行程序的一种简单方法是调用 newFixedThreadPool 工厂方法。 java.util.concurrent.Executors此类还提供以下工厂方法：

- The `newCachedThreadPool` method creates an executor with an expandable thread pool. This executor is suitable for applications that launch many short-lived tasks.
- The `newSingleThreadExecutor` method creates an executor that executes a single task at a time.
- Several factory methods are `ScheduledExecutorService` versions of the above executors.

If none of the executors provided by the above factory methods meet your needs, constructing instances of java.util.concurrent.ThreadPoolExecutor or java.util.concurrent.ScheduledThreadPoolExecutor will give you additional options.

如果上面的都还不能满足你，构建 ThreadPoolExecutor 或者 ScheduledThreadPoolExecutor 实例可以给你额外的选择。

## Fork/Join

The fork/join framework is an implementation of the ExecutorService interface that helps you take advantage of multiple processors. It is designed for work that can be broken into smaller pieces recursively. The goal is to use all the available processing power to enhance the performance of your application.

fork / join框架是ExecutorService接口的实现，可帮助您利用多个处理器。它专为可以递归分解成小块的工作而设计。目标是使用所有可用的处理能力来提高应用程序的性能。  

As with any ExecutorService implementation, the fork/join framework distributes tasks to worker threads in a thread pool. The fork/join framework is distinct because it uses a work-stealing algorithm. Worker threads that run out of things to do can steal tasks from other threads that are still busy.  

与任何 ExecutorService 实现一样，fork / join 框架将任务分配给线程池中的工作线程。fork / join 框架是不同的，因为它使用了工作窃取算法。做完事情的工作线程可以从仍然忙碌的其他线程中窃取任务。

The center of the fork/join framework is the ForkJoinPool class, an extension of the AbstractExecutorService class. ForkJoinPool implements the core work-stealing algorithm and can execute ForkJoinTask processes.

fork / join 框架的中心是 ForkJoinPool 类，是`AbstractExecutorService`类的扩展。`ForkJoinPool`实现核心工作窃取算法并可以执行 ForkJoinTask 进程。

### Basic Use

The first step for using the fork/join framework is to write code that performs a segment of the work. Your code should look similar to the following pseudocode:  
使用fork / join框架的第一步是编写执行工作的代码片段。您的代码应类似于以下伪代码：

```{}
if (my portion of the work is small enough)
  do the work directly
else
  split my work into two pieces
  invoke the two pieces and wait for the results
```

Wrap this code in a ForkJoinTask subclass, typically using one of its more specialized types, either RecursiveTask (which can return a result) or RecursiveAction.  
将此代码包装在`ForkJoinTask`子类中，通常使用其中一种更专业的类型 `RecursiveTask`（可以返回结果）或 `RecursiveAction`。

After your ForkJoinTask subclass is ready, create the object that represents all the work to be done and pass it to the invoke() method of a ForkJoinPool instance.  
在您的`ForkJoinTask`子类是准备之后，创建一个表示要完成所有的工作对象，把它传递给`invoke()`一个方法`ForkJoinPool`实例。

### Blurring for Clarity

To help you understand how the fork/join framework works, consider the following example. Suppose that you want to blur an image. The original source image is represented by an array of integers, where each integer contains the color values for a single pixel. The blurred destination image is also represented by an integer array with the same size as the source.  
为了帮助您了解`fork / join`框架的工作原理，请考虑以下示例。  
假设您想模糊图像。原始源图像由整数数组表示，其中每个整数包含单个像素的颜色值。  
模糊的目标图像也由与源相同大小的整数数组表示。

Performing the blur is accomplished by working through the source array one pixel at a time. Each pixel is averaged with its surrounding pixels (the red, green, and blue components are averaged), and the result is placed in the destination array. Since an image is a large array, this process can take a long time. You can take advantage of concurrent processing on multiprocessor systems by implementing the algorithm using the fork/join framework. Here is one possible implementation:  
通过一次一个像素地处理源阵列来完成模糊。  
每个像素的平均周围像素（红色，绿色和蓝色分量被平均），结果放在目标数组中。  
由于图像是大型数组，因此此过程可能需要很长时间。  
通过使用fork / join框架实现算法，您可以利用多处理器系统上的并发处理。  
这是一个可能的实现：

```{}
public class ForkBlur extends RecursiveAction {
  ...
}
```

Now you implement the abstract compute() method, which either performs the blur directly or splits it into two smaller tasks. A simple array length threshold helps determine whether the work is performed or split.  
现在你可以实现抽象的 `compute()` 方法，或者直接执行模糊操作或者分成两个小任务。  
简单的数组长度阈值有助于确定是执行还是拆分工作。  

```{}

protected static int sThreshold = 100000;

protected void compute() {
    if (mLength < sThreshold) {
        computeDirectly();
        return;
    }
    
    int split = mLength / 2;
    
    invokeAll(new ForkBlur(mSource, mStart, split, mDestination),
              new ForkBlur(mSource, mStart + split, mLength - split,
                           mDestination));
}

```

If the previous methods are in a subclass of the RecursiveAction class, then setting up the task to run in a ForkJoinPool is straightforward, and involves the following steps:  
如果上面的方法在子类 RecursiveAction 中，那么将任务设置为在 `ForkJoinPool` 中直接运行很简单，并包含以下步骤：  

1. Create a task that represents all of the work to be done.

// source image pixels are in src
// destination image pixels are in dst
ForkBlur fb = new ForkBlur(src, 0, src.length, dst);

2. Create the ForkJoinPool that will run the task.

ForkJoinPool pool = new ForkJoinPool();

3. Run the task.

pool.invoke(fb);

For the full source code, including some extra code that creates the destination image file, see the ForkBlur example.

### Standard Implementations

Besides using the fork/join framework to implement custom algorithms for tasks to be performed concurrently on a multiprocessor system (such as the ForkBlur.java example in the previous section), there are some generally useful features in Java SE which are already implemented using the fork/join framework. One such implementation, introduced in Java SE 8, is used by the java.util.Arrays class for its parallelSort() methods. These methods are similar to sort(), but leverage concurrency via the fork/join framework. Parallel sorting of large arrays is faster than sequential sorting when run on multiprocessor systems. However, how exactly the fork/join framework is leveraged by these methods is outside the scope of the Java Tutorials. For this information, see the Java API documentation.  
除了使用`fork / join`框架来实现在多处理器系统上同时执行的任务的自定义算法（例如ForkBlur.java上一节中的示例）之外，Java SE中还有一些通常有用的功能，它们已经使用fork / join实现了框架。在Java SE 8中引入的一种这样的实现被 java.util.Arrays类用于其`parallelSort()`方法。这些方法类似于`sort()`，但通过fork / join框架利用并发性。在多处理器系统上运行时，大型数组的并行排序比顺序排序更快。但是，这些方法如何利用 fork / join 框架超出了Java Tutorials的范围。有关此信息，请参阅Java API文档。

Another implementation of the fork/join framework is used by methods in the java.util.streams package, which is part of Project Lambda scheduled for the Java SE 8 release. For more information, see the Lambda Expressions section.    
fork / join框架的另一个实现由java.util.streams包中的方法使用，该方法是为Java SE 8发布而安排的[Project Lambda](http://openjdk.java.net/projects/lambda/)的一部分 。有关更多信息，请参阅 [Lambda 表达式](https://docs.oracle.com/javase/tutorial/java/javaOO/lambdaexpressions.html)部分。