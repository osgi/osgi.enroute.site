---
title:  Service Contracts
summary: Discussion about the Services
---

Introduction
------------

The OSGi framework takes efforts to ensure that both the provider and
consumer of a service have compatible expectations of the service
interface.

Service consumers do not have visibility of the implementation class of
a service, however they must have visibility of the service
**interface**. This is necessary because in order to invoke the methods
of the service, the consumer normally casts the object it receives from
the service registry to the type of the service. For example if using a
Service Tracker:

``  
`public Object addingService(ServiceReference reference) {`  
`    MyService service = (MyService) context.getService(reference);`  
`    // TODO: invoke service`  
`    return service;`  
`}`

(Note that if using a [Component
Model](Component Models Overview "wikilink") such as [Declarative
Services](Declarative Services "wikilink") or
[Blueprint](Blueprint Service "wikilink") the cast may be hidden from
normal code).

The provider of a service must also have visibility of the interface so
that it can create an implementation:

``  
`public class MyServiceImpl implements MyService {`  
`    // TODO`  
`}`

**Service Compatibility** simply means that both the consumer and
provider must use the same interface. In a modular system, multiple
copies and versions of the `MyService` interface may exist, potentially
with different methods and signatures; the service model relies on the
consumer and provider agreeing on one particular version of the
interface.

Ensuring Compatibility
----------------------

When a consumer queries the service registry, the OSGi framework inserts
a compatibility check before returning any
[ServiceReferences](ServiceReference "wikilink"). The compatibility
check ensures that each bundle providing a service of the requested
interface type loads that interface from the same classloader that the
consumer loads it from. In practice, this means that both the consumer
and provider must import the service interface package from the same
bundle.

For example, suppose we wish to publish and consume services of type
`org.example.api.MyService`. Any of the following scenarios will allow
the compatibility check to succeed:

-   Provider and Consumer bundle both import package `org.example.api`
    from a third API bundle (N.B. they must both import from the
    **same** bundle).
-   Provider exports the package `org.example.api` and the Consumer
    imports from the Provider.
-   Consumer exports the package `org.example.api` and the Provider
    imports from the Consumer (though this is valid, it is rarely done).
-   Provider and Consumer are the **same** bundle, and `org.example.api`
    is an internal package of that bundle (this is an edge case, and not
    very useful).

Disabling Compatibility Checks
------------------------------

In some cases a consumer can elect to ignore compatibility, and retrieve
*all* services of a requested type, irrespective of the provider's view
of the interface. This can be done by calling
`getAllServiceReferences()` instead of `getServiceReferences()`. When
using a [ServiceTracker](ServiceTracker "wikilink"), call `open(true)`
instead of just `open()`.

Note that when compatibility checks are disabled, it is possible that
incompatible services will be returned. In this case, attempting to cast
the service instance to the interface will result in a
`ClassCastException`.

For this reason, it is generally not useful to disable compatibility
checks if our intention is to actually invoke the service. Turning off
the check may be useful if we only want to access service metadata (i.e.
the properties attached to the
[ServiceReference](ServiceReference "wikilink")), or to list all
existing services. This would be the case if we were implementing a
shell, for example.

Versioning and Services
-----------------------

Services are not explicitly versioned. However, service **interfaces**
are versioned because they belong to a versioned exported package.

If multiple versions of a service interface package exist, then both
consumers and providers may have a choice to bind to more than one
export, due to their import package ranges. However, the services are
only compatible where both consumer and provider are bound to the same
package. For example:

![](Service-compatibility.png "Service-compatibility.png")

In this figure there are two versions of the `api` package, 1.0 and 1.1,
and a service of each is exported. The consumer could import **either**
API version because it's version range is [1.0,2.0). But a bundle can
only import one version of a package at a time, and in this case the
OSGi framework has wired it to the 1.0 exporter. As a result, only
service S1 is visible to the consumer.

Note that if the consumer were to use `getAllServiceReferences` to
obtain S2 then it would see a `ClassCastException`.

If the OSGi framework instead wired the consumer to the 1.1 exporter,
then S2 would be the only visible service, and using
`getAllServiceReferences` would now see a `ClassCastException` trying to
access S1!

<Category:Tutorial>

