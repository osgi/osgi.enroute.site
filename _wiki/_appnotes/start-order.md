---
title: Start Ordering
summary: Although an depending on start order is an anti pattern, the OSGi start ordering has its use cases.
---
  
A "start order dependency" is any requirement to start a bundle (or
bundles) before some other bundle(s).

For example, in naïve [Services](Services "wikilink") usage, a bundle
*B* may attempt to invoke a service from the `start` method of its
[Bundle-Activator](Bundle-Activator "wikilink"), where that service is
published by bundle *A*. The developer of *B* therefore states "bundle
*A* must be started before bundle *B*", to ensure the service is
available when *B* starts. This kind of requirement very quickly leads
to a fragile and unmaintainable system. It is also common for cycles to
appear, i.e. *A* must start before *B* **and** *B* must start before *A*
(though usually the cycle involves a chain of many bundles rather than
just two). As soon as such a cycle appears the system cannot be started,
and an alternative approach must be found.

Ideally in OSGi we should be able to start bundles in **any order**. To
achieve this, bundles must be designed correctly. In the above example,
bundle *B* should not assume the service is available immediately; if it
is unavailable then *B* should enter a waiting state until the service
*becomes* available.

Developing bundles in such a manner is challenging when using the lowest
level OSGi APIs. However, using a [Service
Tracker](Service Tracker "wikilink") or any of the higher level
[Component Models](Component Models Overview "wikilink") make it easy to
develop bundles in the proper way.

When Start Order Cannot be Avoided
----------------------------------

While avoiding start order dependencies is strongly advised as a best
practice, it is not always possible to achieve, perhaps because of
legacy code. In these cases, the [Start Level
API](Start Level API "wikilink") can be used to control the start
ordering.

Service Hooks
-------------

[Service Hooks](Service Hooks "wikilink") are used to intercept and
filter service lookups, for example to implement service proxies.
Unfortunately, a bundle using a service hook may not get a chance to
filter out a service if it starts after other bundles.

In this situation the hook provider should **stop and restart** any
bundle that already obtained the service instance it wishes to filter
out; by doing this we avoid introducing a start order dependency.
However the solution is not optimal in terms of performance, so start
levels can be used to ensure the hook provider starts first. Used in
this way, start levels can be seen as an **optimisation** rather than
something we rely on in order for our system to work correctly.

[Category:Best Practices](Category:Best Practices "wikilink")

