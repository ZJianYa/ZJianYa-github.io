## guide

A synchronization aid that allows one or more threads to wait until a set of operations being performed in other threads completes. 
允许一个或多个线程等待直到在其他线程中执行的一组操作完成的同步辅助。

A CountDownLatch is initialized with a given count. The await methods block until the current count reaches zero due to invocations of the countDown method, after which all waiting threads are released and any subsequent invocations of await return immediately. This is a one-shot phenomenon -- the count cannot be reset. If you need a version that resets the count, consider using a CyclicBarrier. 

用一个给定的 count 初始化 CountDownLatch。调用 countDown 方法，等待方法阻塞直到当前 count 为0，在所有的等待线程释放后任何  
这是一个一次性现象 ———— 计数无法重置。如果您需要重置计数的版本，请考虑使用CyclicBarrier。  

A CountDownLatch is a versatile synchronization tool and can be used for a number of purposes. A CountDownLatch initialized with a count of one serves as a simple on/off latch, or gate: all threads invoking await wait at the gate until it is opened by a thread invoking countDown. A CountDownLatch initialized to N can be used to make one thread wait until N threads have completed some action, or some action has been completed N times.   

CountDownLatch 是一个多功能的同步工具，可以用于很多用途。用一个 count 初始化的 CountDownLatch 可以用作一个简单的开关门栓：所有的调用 await方法的线程在门外等候知道被一个线程调用countDown打开大门。初始化为 N 的 CountDownLatch 可以被用于知道 N 个线程完成相同的操作，或者一些 action 被完成 N 次。

A useful property of a CountDownLatch is that it doesn't require that threads calling countDown wait for the count to reach zero before proceeding, it simply prevents any thread from proceeding past an await until all threads could pass.   
CountDownLatch 的一个有用属性是它不要求调用 countDown 的线程在继续之前等待计数达到零，它只是阻止任何线程继续等待直到所有线程都可以通过。

Sample usage: Here is a pair of classes in which a group of worker threads use two countdown latches: 
示例用法：这是一对类，其中一组工作线程使用两个倒计时锁存器：  

The first is a start signal that prevents any worker from proceeding until the driver is ready for them to proceed; 
The second is a completion signal that allows the driver to wait until all workers have completed.  

第一个是启动信号，阻止任何 worker 继续工作，直到 driver 准备好继续进行;  
第二个是完成信号，允许 driver 等到所有 worker 完成。  

```{}
 class Driver { // ...
   void main() throws InterruptedException {
     CountDownLatch startSignal = new CountDownLatch(1);
     CountDownLatch doneSignal = new CountDownLatch(N);

     for (int i = 0; i < N; ++i) // create and start threads
       new Thread(new Worker(startSignal, doneSignal)).start();

     doSomethingElse();            // don't let run yet
     startSignal.countDown();      // let all threads proceed
     doSomethingElse();
     doneSignal.await();           // wait for all to finish
   }
 }

 class Worker implements Runnable {
   private final CountDownLatch startSignal;
   private final CountDownLatch doneSignal;
   Worker(CountDownLatch startSignal, CountDownLatch doneSignal) {
     this.startSignal = startSignal;
     this.doneSignal = doneSignal;
   }
   public void run() {
     try {
       startSignal.await();
       doWork();
       doneSignal.countDown();
     } catch (InterruptedException ex) {} // return;
   }

   void doWork() { ... }
 }}
```

Another typical usage would be to divide a problem into N parts, describe each part with a Runnable that executes that portion and counts down on the latch, and queue all the Runnables to an Executor. When all sub-parts are complete, the coordinating thread will be able to pass through await. (When threads must repeatedly count down in this way, instead use a CyclicBarrier.)   

另一个典型的用法是将问题分成N个部分，用执行该部分的Runnable描述每个部分并对锁存器进行倒计时，并将所有Runnables排队到Executor。当所有子部件都完成后，协调线程将能够通过等待。 （当线程必须以这种方式重复倒计时时，而是使用CyclicBarrier。）

```{}
 class Driver2 { // ...
   void main() throws InterruptedException {
     CountDownLatch doneSignal = new CountDownLatch(N);
     Executor e = ...

     for (int i = 0; i < N; ++i) // create and start threads
       e.execute(new WorkerRunnable(doneSignal, i));

     doneSignal.await();           // wait for all to finish
   }
 }


 class WorkerRunnable implements Runnable {
   private final CountDownLatch doneSignal;
   private final int i;
   WorkerRunnable(CountDownLatch doneSignal, int i) {
     this.doneSignal = doneSignal;
     this.i = i;
   }
   public void run() {
     try {
       doWork(i);
       doneSignal.countDown();
     } catch (InterruptedException ex) {} // return;
   }

   void doWork() { ... }
 }}
```

Memory consistency effects: Until the count reaches zero, actions in a thread prior to calling countDown() happen-before actions following a successful return from a corresponding await() in another thread.  
内存一致性影响：在计数达到零之前，调用countDown（）之前的线程中的操作发生在从另一个线程中的相应await（）成功返回之后的操作之前。  

## API

## FAQ
