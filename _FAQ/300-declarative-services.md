---
title: Declarative Services (DS) 
layout: toc-guide-page
version: 1.3
lprev: 210-semantic_versioning.html 
lnext: 400-patterns.html 
summary: An overview of the Declarative Services DI framework 
author: enRoute@paremus.com
sponsor: OSGi™ Alliance  
---

Increasingly Declarative Services ( _abbrv_ DS) is the backbone of OSGi. While other Dependency Injection frameworks can be used with OSGi, the OSGi Alliance strongly recommend DS.

All of the enRoute [examples](../examples) are DS based, and walk you from the simplest of DS Components [quickstart](../examples/010-examples.html#the-ds-component) through DS range of capabilities.


## Background

DS (a.k.a _Service Component Runtime_  _abbrv_ SCR) is an [Extender Pattern]() that creates components from an XML resource in your bundle. Code annotations allow the toolchain to write the required XML on the fly; so no direct interaction with XML is required. The XML file defines the Bundle's dependencies, properties, and registered services; allowing DS to automatically instantiate the class, inject the dependencies, activate the component, and register the services.



## DS & Dynamism

The most significant and compelling difference between DS, and other dependency injection frameworks, is that DS has a life-cycle and handles _dynamic_ dependencies: resource can be found and resource can be lost.

The concepts of  _time_ & _change_ are utterly lacking in any other DI engines. 
{: .note }

DS deals with the complexity of potentially volatile services through the use of stronh guarantees.


### Ordering

DS provides a very strict ordering. 

* Constructor – DS will always create a new object, it will **never** reuse an existing object.
* Bind – The bind methods or field injections are called in alphabetical order when using annotations.
   (Though dynamic methods or field injections can of course be called at any time.)
* Activate – Only if all static reference methods and field injections are called is the activate method called. 
    * If this method does not throw an exception, it is guaranteed that the deactivate will be called. 
    * If an exception is thrown the following phases are not executed.
* Active – During the active phase the following methods can be called in any order from
   any thread and in parallel:
    * Any methods of the registered services
    * A modified methods that dynamically takes the modified configuration properties
    * Any of the updated reference methods if defined
* Deactivate – Clean up
    * Unbinds – And unbind methods are called
    * Release of object – DS will release the object so that no longer any references are held
    * Finalize – Java garbage collects the object

Lazy services are registered before their constructor is called. The initialization of the
DS component will take place when the service is used for the first time. However, this
should not be observable by the component itself.


## Static References

The default and simplest model of DS is to use `static` references. If a component only has
static references then it never sees any of the OSGi dynamics. This means that
with the given ordering there is no need to use volatile or other
synchronization constructs for static references. 


## Optional References

Sometimes a component can deliver its functionality even when a reference is absent. This is then an _optional_ reference. By far the simplest method to handle this is to make the reference optional by specifying the cardinality:

```java
	@Component(service=ReluctantOptionalReference.class)
	public class ReluctantOptionalReference {

		@Reference(cardinality=ReferenceCardinality.OPTIONAL)
		Foo reluctantOptionalReference;
	}
```

However, this is a _static_ reference. This implies that the component is started regardless of the presence of Foo. If Foo happens to be there then it is injected otherwise the field remains `null`. This model is called _reluctant_.

Unfortunately, this means we miss the Foo service when it is registered a few nanoseconds later. Since the static model has so many advantages there is an option to reconstruct the component when this reference finds a candidate. This is the _greedy_ mode:

```java
	@Component(service=GreedyOptionalReference.class)
	public class GreedyOptionalReference {

		@Reference(
			cardinality=ReferenceCardinality.OPTIONAL,
			policyOption=ReferencePolicyOption.GREEDY)
		Foo greedyOptionalReference;
	}
```

DS will now reconstruct the component when there is a _better_ candidate for `foo`. Clearly any candidate will beat no candidate but what means better in the case that we already have `foo`?

When multiple candidates are available DS will sort them by ranking. Services with a higher _ranking_ are deemed _better_. Service ranking is indicated by a property called `service.ranking`. It is an integer, higher is better.

One of the advantages of the static model is that in your activate method all the way to your deactivate method your visible world won't change.

The previous examples were still static because none of the references changed between the `activate` and `deactivate` phase. The greedy policy option achieved its replacement by reconstructing the component. This is acceptable in most cases but sometimes the component does not want to die for the sake of an optional reference. In that case we can handle the situation _dynamically_.

By far the easiest solution is to mark the field as _volatile_. **A volatile field will automatically get marked as `policy=DYNAMIC`**.

```java
	@Component(service=DynamicOptionalReference.class)
	public class DynamicOptionalReference {

		@Reference(cardinality=ReferenceCardinality.OPTIONAL)
		volatile Foo dynamicOptionalReference;
	}
```

This is simple but there is an obvious price. The following bad code shows a common (but horrible) pattern that people use to use `foo`:

```java
	if ( foo != null ) // BAD!
		foo.bar();
```

This innocuous looking code is actually a Null Pointer Exception in the waiting.
A better way is to do:

```java
	Foo foo = this.foo;
	if ( foo != null )
		foo.bar();
```

By using a local variable we guarantee that the check (is `foo null`?) is using the same object as the one we will call `bar()` on. This is a very cheap form of synchronization.


## What If The Service Disappears?

Your code should always be prepared to accept exceptions when you call other services. This does not mean you should catch them, on the contrary. It is much better to forward the exceptions to the caller so that they do not unnecessarily get wrapped up in wrapping exceptions and lose the
original context.

In almost all cases there is a top level function that initiated your request. It is this function that has the responsibility to make sure the overall system keeps working regardless of failures. This kind of robustness code is extremely difficult to get right and should **never** be mixed with application code.


## Tracking Multiple Services

If you use a [whiteboard pattern](../faq/420-patterns) or other listener like model then in general you want to use dynamics. 

The reason is that you have _multiple_ references and building and destroying the component at every change in the set of services we're interested in (the _tracked_ services) becomes expensive.

By far the easiest method is to use field injection of a list of services.  If you make this field `volatile` then DS will inject a new list whenever the set of tracked services changes.

```java
	@Component(service=SimpleList.class)
	public class SimpleList {

		@Reference
		volatile List<Foo>		dynamicFoos;
	}
```

However, there are scenarios where the component must interact with the bind
and unbind of the references. The most common way is then to create a bind
and unbind method.

```java
	@Component(service = DynamicBindUnbind.class)
	public class DynamicBindUnbind {

		final List<Foo> foos = new CopyOnWriteArrayList<>();

		@Reference(
			cardinality = ReferenceCardinality.MULTIPLE,
			policy = ReferencePolicy.DYNAMIC)
		void addFoo(Foo foo) {
			foos.add(foo);
		}

		void removeFoo(Foo foo) {
			foos.remove(foo);
		}
	}
```

In this example we use a `CopyOnWriteArrayList`. This is a so called _non-locking_
object. Though it is perfectly safe to use in a concurrent environment it will not
use locks and any iteration over that list is guaranteed not to fail. 

