

A synchronization aid that allows a set of threads to all wait for each other to reach a common barrier point. CyclicBarriers are useful in programs involving a fixed sized party of threads that must occasionally wait for each other. The barrier is called cyclic because it can be re-used after the waiting threads are released.   

一种同步辅助工具，允许一组线程全部等待彼此到达公共障碍点。  
CyclicBarriers 在涉及固定大小的线程数量的程序中很有用，这些线程必须偶尔等待彼此。  
屏障称为 cyclic ，因为它可以在等待中的线程释放后重新使用。

A CyclicBarrier supports an optional Runnable command that is run once per barrier point, after the last thread in the party arrives, but before any threads are released. This barrier action is useful for updating shared-state before any of the parties continue.   

CyclicBarrier 支持可选的Runnable命令，该命令在每个障碍点运行一次，在 party 中的最后一个线程到达之后，但在释放任何线程之前。  
在任何一方继续之前，此屏障操作对于更新共享状态非常有用。  


Here, each worker thread processes a row of the matrix then waits at the barrier until all rows have been processed. When all rows are processed the supplied Runnable barrier action is executed and merges the rows. If the merger determines that a solution has been found then done() will return true and each worker will terminate. 
If the barrier action does not rely on the parties being suspended when it is executed, then any of the threads in the party could execute that action when it is released. To facilitate this, each invocation of await returns the arrival index of that thread at the barrier. You can then choose which thread should execute the barrier action, for example: 

这个子例子中，每个工作线程处理一行矩阵，然后在屏障处等待，直到所有行都被处理完毕。  
处理完所有行后，将执行提供的 `Runnable` 屏障操作并合并行。  
如果合并确定已找到解决方案，则 done() 将返回 true 并且每个工作程序将终止。  
如果屏障操作在执行时不依赖于 parties 被暂停，那么该 party 中的任何线程都可以在 released 时执行该操作。  
为了促进这一点，每次调用 await 都会在屏障处返回该线程的到达索引。然后，您可以选择应执行屏障操作的线程，例如：

 if (barrier.await() == 0) {
   // log the completion of this iteration
 }}

The CyclicBarrier uses an all-or-none breakage model for failed synchronization attempts: If a thread leaves a barrier point prematurely because of interruption, failure, or timeout, all other threads waiting at that barrier point will also leave abnormally via BrokenBarrierException (or InterruptedException if they too were interrupted at about the same time). 

CyclicBarrier 使用一个 all-or-none breakage model 为同步失败做尝试：如果一个线程因为 interruption, failure, or timeout 而过早的离开了 barrier，在该障碍点等待的所有其他线程也会通过 BrokenBarrierException （或InterruptedException 如果他们也在大约同一时间被打断了） 离开 barrier。

Memory consistency effects: Actions in a thread prior to calling await() happen-before actions that are part of the barrier action, which in turn happen-before actions following a successful return from the corresponding await() in other threads.

内存一致性影响：调用await（）之前的线程中的操作发生在作为屏障操作一部分的操作之前，而这些操作又发生在从其他线程中相应的await（）成功返回之后的操作之前。
