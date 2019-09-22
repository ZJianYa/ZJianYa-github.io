# Thread Objects

Each thread is associated with an instance of the class Thread. There are two basic strategies for using Thread objects to create a concurrent application.

To directly control thread creation and management, simply instantiate Thread each time the application needs to initiate an asynchronous task.

To abstract thread management from the rest of your application, pass the application's tasks to an executor.
This section documents the use of Thread objects. Executors are discussed with other high-level concurrency objects.

## Defining and Starting a Thread

## Pausing Execution with Sleep

## Interrupts

### Supporting Interruption

### The Interrupt Status Flag

## Joins

## The SimpleThreads Example