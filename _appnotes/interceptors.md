---
title: Interceptors in OSGi
summary: Discussion of the ins and outs of using proxies in OSGi
---

A recurring question on OSGi forums is how to use _interceptors_. The [Spring framework] made it popular to use _aspects_ of Aspect Oriented programming and obviously the desire is then there to use the same mechanisms in OSGi, because they are so enticing. 

## What is an Interceptor?

Let's say we have a function that performs some work. In the following example we need to do some "pre work", "post work", and additionally handle exceptions in similar way:

	void doWork() {
	    preWork();
		try {
		   … do work
		   postWork();
		} catch( Throwable t) {
	       exceptionWork(t);
		   throw t;
		}
	}
	
	void doOtherWork() {
	    preWork();
		try {
		   … do other work
		   postWork();
		} catch( Throwable t) {
	       exceptionWork(t);
		   throw t;
		}
	}

The problem with this approach is that it creates a lot of boiler plate code, and the actual work gets lost. How can we get rid of this noisy and distracting code? 

One possible solution is to use Interceptors. With this approach, you add an annotation and now the caller is ensuring that your annotation is correctly interpreted.

	@Work(SOME_PARAMETER)
	void doWork() {
		   … do work
	}

Voila, boiler plate gone! Problem solved. Or is it?

Well, there is the small aspect (pun intended) of the burden being shifted to the caller. (Imagine the caller introspecting the annotations?) There are two mechanisms we could use to avoid this. We could _weave_ in the bioler plate code, or we could create a _proxy_ on the target and let the proxy handle the boiler plate.

$$$ I don't understand the next sentence...$$$
Weaving has its own problems, here we focus on this is  _interceptor_ pattern. You can use this pattern for any boiler plate you want to add to a method.

Before going deeper into these possible solutions, let us first examine the problems with Interceptors in more detail.

## Problems with the Interceptor 

The reason it is absent in enRoute is because the interceptor model has a few serious disadvantages. 

* `this` **transparency** – The 'this' keyword cannot be used without care since it bypasses the interceptor proxy. I.e. the interceptor is not transparent. Generally, the target object is explicitly provided access to the proxy object and it should only call its own methods on that object. Obviously this is error prone. $$$ I am having trouble understanding this statement. Perhaps an example would help? $$$
* **debuging & testing** – It is also much harder to debug because there is 'magic' happening outside your source code.
* **inflexibility** –  Annotations can handle the boiler plate code but are quite inflexible when you need, for example, to take arguments to the call into account.
* **annotations** – Though annotations are extremely useful for configuration they have the danger to be over used as a way to create your own language on top of Java. They were not designed for that purpose and have extreme limitations.
* **strings** – The semantics of the annotations are often defined by strings. There is no way for the compiler to verify those strings.
* **dynamics** – In OSGi we've got a dynamic system. The interceptor will be a crucial dynamic dependency and this can sometimes be quite complex because these aspects tend to cross the module boundaries.
* **limitation to interfaces** – Proxies cannot operate on classes, the target MUST be defined with an interface. Since the target object is pure implementation code there is often no need to create this indirection for many of the methods. (Byte code weaving has this problem to a much more limited extent.)

## Plain Old Java

Modularity is about assuming as little as possible. In OSGi we've taken this as our mantra and combined it with a very strong focus on type safety. If you use plain old Java as it was intended to be you rarely have unexpected problems. The pain usually starts when you try to bypass the built-in safeguards or guarantees. 

The problem is that often these solutions are so incredibly enticing. Any developer that can save his co-workers a few bytes in boiler plate can count on being teated to free beer that evening in the pub, regardless what this means for the rest of the system's complexity.

When you opt for an interceptor-like model you create relatively complex machinery. So the question is, is this overall complexity worth the reduced boiler plate code? Clearly in the transaction example it was.

However, we're many years further today then when that model was introduced, and there are now better ways.

## Lambdas

Since Java 8 we now have lambdas! (About 42 years after Smalltalk.) Lambdas are interceptors turned inside out. In the transaction composition problem the interceptor had to do something before it ran our code, then ran our code, and then handle any exceptions and do some post-processing. With lambdas, we can achieve the same model by the method calling the interceptor and passing the function.

	void doWork() {
	    interceptor.doWork( () -> ... working );
	}

That is, instead of typing an annotation above the method, you just use a method with that name and pass it parameters, one of the parameters being the function you want to check.

The advantage is now that _everything_ is plain old Java. The debugger will work perfectly on that code, you can use every trick in the Java book and not just limited what the, by design, limited annotations can express.

## Transaction Control

An extremely interesting example of this is the work being done on the [Transaction Control service in OSGi][1] by Tim Ward. Something like this was originally done in OSGi enRoute but was left out when persistence was skipped. 

The underlying problem with transactions is that when you get called in a service oriented world it is not always clear how to _compose_ the transactions. I.e. join, reject if on is there, or start. This is a classical problem where you need to do something _before_ and _after_ your actual code. Therefore the transaction control service makes it look like:

       @Reference Store<Person> persons;
       @Reference TransactionController txc;

       public Person findPerson( long id) {
            return txc.required( () -> 
                 persons.find( "select * from Person where id=%s", id )
            );
       }
     
Therefore, with the same amount of code (or less) you do not need the magic interceptors.

## Service Hooks

In certain cases you really need to dynamically proxy.

There is one solution in OSGi that makes it possible to create a proxy for a service. By registering a number of [Service Hooks] you can hide certain services from selected bundles. You can then register a proxy to that original service that then performs the interceptor function.

The the mechanism itself works very reliable, it requires that you control the activation order. The interceptor bundle must be available before the target service is registered. If the interceptor is later, then the interceptor cannot hide the service adequately. 

## Conclusion

That said, the interceptor model was made very popular with Spring and its 'aspect oriented' programming. There are a number of solutions if you still want to have interceptors. Of course there are the standard byte code weaving based models, byte code weaving is very well supported by OSGi.

The best method is probably the OSGi Service Hooks. Service Hooks allow you to create a proxy (an example is in the specification) and then do your magic in the proxy. Though this works quite well it will require that your proxy bundle is available before anyone else, which you can only make work in a very controlled environment.

Best is to try to leverage Java 8 because plain old Java code is surprisingly simpler on a wide range of system level issues, especially in component based systems. 

## Discussions & Questions


[1]: https://github.com/osgi/design/blob/master/rfcs/rfc0221/rfc-0221-TransactionControl.pdf
[Spring framework]: https://en.wikipedia.org/wiki/Spring_Framework
[Service Hooks]: http://blog.osgi.org/2009/02/osgi-service-hooks.html
