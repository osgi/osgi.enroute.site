---
title: Concurrency
summary: OSGi is multi-threaded and service calls will happen on different threads. This App note discusses the concurrency issues and provides a number of standard patterns that work well in OSGi (and outside).
---

In OSGi you will write code that runs in a multi-threaded environment. There are 
no safe guards, no hand-rails, and no warning  signs. When you register a service 
anybody can call you at any moment in time. In multi-core CPUs (are there any others?) 
your code can execute multiple times in any given instant. There will be dragons
here.

Except for a few sissy Java EE App servers, this is the standard way of working for Java.
Get over it, accept it. You must consider the concurrency issues of your code.

There are some excellent books out there that explain the issues. The most famous
one being Brian Goetz book [Java Concurrency in Practice][1], the bullet train book.

This App note attempts to handle some of the important issues when you write OSGi
applications. However, being an app note it of course remains on the surface.

## Time

Today's multi-core CPUs are amazing pieces of technology that use every trick in the
book to get the awesome performance we see today. To achieve this power CPU designers
could not maintain some invariants that software developers were accustomed to.

For a software developer it is horror to think that writing a variable does not mean
that after that write all executing code can see the new content. The following
code looks like it should stop but it might not on a multi-core machine.

	boolean stop;
	
	@Activate
	void activate() {
		new Thread( () -> {
			while (!stop) 
				;
		} ).start();
	}
	
	@Deactivate
	void deactivate() {
		stop = true;
	}

The reason is that the background loop could run on its own core. This core has a 
cached copy of main memory because it is too slow to always go to the main memory.
So when the `deactivate` method writes a `true` in the `stop` variable, the background
thread remains oblivious of this.

Sometimes the code actually works as one would expect. Strangely enough, if you 
run this code in the debugger with a breakpoint in the loop then it will work as expected.
This is not a [Heisenbug] but is caused because the debugger inadvertently causes the
caches to be synchronized with main memory. As the debugger demonstrates, this is 
a non-deterministic effect and any good developer hates this kind of indeterministic 
effects.

That is why Java has a _memory model_. 

The following picture shows some key aspects of this memory model:
 
![Write/Read Barriers](img/concurrency/conc-barriers.png)

The model allows each core to execute independently from each other core using its own
cached main memory. Though data may become invisible haphazardly, two constructs 
force the situation to become deterministic.

The first construct is the `volatile` keyword. When a volatile variable is written
then the VM _must_ ensure that the cache is finished writing all prior updates to main
memory. When a volatile variable is read the value must be the same as in main memory.
These are called the _write barrier_ and the _read barrier_.

What happens between read and write barriers is left to the implementation. Compilers
and cores are free to reorder reads and writes for any reason they see fit. (Usually
to make your code run faster.) However, if you can _prove_ that variable is written
before a volatile write then that variable _must_ be visible for anybody that has done
a volatile read. For example,

	int a, b, c;
	volatile int v;
	
	void foo() {
		a = 1;
		b = a + 1;
		c = b * a;
		v = c * c;
	}

Another thread may see the assignment of `c` before the assignment of `a` but 
after it reads `v`, the other variables must have their proper values assigned.

To write proper code it is paramount to understand this _before/after_ relation.
Fortunately, the OSGi specifications make it very clear what the order of 
certain operations is. Once the order is defined, you have a proper before/after
relation and you're guaranteed to see anything that was written before you were 
called.

As a note, a before/after relation is always between two threads although it is 
transitive between threads. In the following picture the colors of the thread
bars show that though thread B makes lots of modifications, these modifications 
are only defined to be visible by thread A after thread B had a write barrier
and thread A a read barrier. That is, established a firm before-after
relation.

![Write/Read Barriers](img/concurrency/conc-before-after.png)

A bit of warning here. The tricky part is that most code that calls out to 
other libraries tends to go through lots of read/write barriers and works 
as intended. However, there is no guarantee until you can prove there is
a proper before-after relation. That is, your code works fine in the debugger
but fails in runtime. That is, the fact that something works for you is not an
indication that you've done your work properly. 

## Guarantees from DS

In many aspects DS is a dependency injection (DI) engine similar to Spring, Guice, or
today CDI. However, in contrast with these DI engines DS components have a life cycle.
This adds the dimension of _time_ to the component, something that is utterly lacking in
any other DI engine. DS components are dynamic.

Though this extra dimension provides tremendous power it clearly comes with the
burden that things do not only get initialized, it is also possible that things go
away.

DS goes out of its way to hide that complexity. The way DS achieves this is through
very strong guarantees. DS sucks up a tremendous amount of complexity so that you
don't have to worry about it. However, many a developer writes their code defensive
and overly locks/synchronizes parts.

  

## Atomic 

Volatile variables are not atomic. For example:

	volatile int v;
	
	void foo() { v++; }

In this example it is possible to miss an increment because thread A can read the 
variable in a register, increment it and store it. However, when we're unlucky
another thread reads the same value, increments it and stores it as well. This
will lose one of the updates.

How do we protect against this?

Java knows the construct of a _synchronized_ block. A synchronized block takes a 
_lock_ object. When the synchronized block is entered it attempts to get the lock
on that object for the current thread. 

Once it has the lock, it will perform a read barrier, ensuring the cache and the
main memory are synchronized. This brings us in the wonderful position that
we are the only thread that owns the locked object. 

We can now read, make a decision on the value, and
write without having to worry that other threads interfere. At the end of the synchronized
block the VM will create a write barrier, waiting until all writes so far are flushed
to main memory. Only then will it release the lock.

Therefore the following code would properly count the number of calls to `foo`.

	int v;
	
	void foo() { 
		synchronized(this) {
			v++;
		} 
	}

Since the synchronized block does a read barrier just after it gets the lock
and a write barrier just before it returns the lock we're guaranteed the following:

* Only one thread can update `v`
* Any thread in the block can see the changes of another thread that was in that block before

Therefore synchronized blocks are crucu




 


   


 

[1]: https://www.amazon.com/Java-Concurrency-Practice-Brian-Goetz/dp/0321349601
[Heisenbug]: https://en.wikipedia.org/wiki/Heisenbug
