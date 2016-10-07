---
title: About enRoute
summary: An overview of OSGi enRoute
layout: tutorial
lprev: 100-about-osgi.html
lnext: 215-sos.html
---

OSGi enRoute is about helping you crossing the chasm between building typical Java (Enterprise) Systems (JES) and Service Oriented Systems (SOS). This is a paradigm shift because either side is seriously puzzled about what on earth the other side is thinking. Since the JESsers are today in the majority, we're going to assume you wonder what the heck SOS even is. So let's start with providing some background.

## Service Oriented Systems

Our industry went through several paradigm shifts already where the major shifts were to structured programming and later to object oriented programming. Both shifts included the previous best practices but provided another way of thinking about problems. Both shifts took an amazingly large time because software practitioners tend to dislike it when their baby's are called ugly. Now in general we're a pretty clever bunch in our industry, at least we're convinced we are. However, a paradigm shift happens when you can _understand_ a new mechanism but you do not _feel_ it. 

In the minds of OSGi practitioners, OSGi services are _primitive_. If we see a problem, services pop up anywhere from our brains because they capture a very complex multi-dimensional concept with a single chunk. So be aware, _feeling_ services will require an effort, but be assured, once you feel them they are a wonderful design primitive. But let's first try to make you understand the mechanism.

### µService Broker

An OSGi service is an object that is offered to the _service registry_. A component that needs a specific service requests the service registry for one. It can specify the type, how many, and it can provide only services whose properties match a given filter. This is the broker pattern and it in OSGi is fully dynamic. Offers and requests can come at any time, but for many surprisingly, withdrawals and returning services can also happen at any time. This is usually the place where the first developers give up in disgust: too complex! However, it turns out that it is absolutely not. The OSGi Declarative Service standard is as easy to use as the best Dependency Injection (DI) framework (with annotations, so no XML required) but it can create components that live quite well in this dynamic world without any conscious effort.

### Why Dynamics?

However, even if though it is as easy as classic DI, why would we need these dynamics? 

The reason is that we now have a new primitive design concept that allows us to model an enormous amount of real world problems.  For example, Distributed OSGi registers a local service in a remote framework. Since the communication between the frameworks is in the real world, failures will happen which will make the remote service registration invalid. To handle this in JES you need highly specialized listeners and other special code that usually intricately ties you to an implementation. In distributed OSGi there is no such need. The user of the remoted service will be _uninjected_ when the service can no longer be supported. The only dependency of the user is the API used by the remoted service.

### API Simplifications 

There are many more such use cases. Experience shows that we can significantly simplify JES APIs because we do not have to concern ourselves with life cycle issues. Life cycle issues are embedded in the OSGi service concept, they do not require explicit API. Many timing and dependency problems translate very naturally to µservices. Since OSGi provides such a powerful DI framework that makes it trivial to work in such a dynamic environment we have just gotten rid of a tremendous amount of accidental complexity! We also got rid of those evil global variables that are sometimes called _statics_ (OSGi is static free).

In practice, it is possible to design an API for JES and SOS where the SOS design is a fraction of the JES design. In turns out that providing implementations for these so much simpler service APIs is often quite easy because there are already existing implementations in open source that only need a small facade, or do them from scratch. Though the starting from scratch sounds scary, it turns out that since these implementations are OSGi components themselves they can leverage the built services like Configuration Admin, the web server, Event Admin, etc. that in most larger open source implementations are custom built.

## OSGi enRoute's Mission

The first cars developed in the late 19th century looked remarkably like horse drawn carriages. That was because the designers had not made the paradigm shift to what it means to have an engine instead of a horse. This does not only happen to car designers (Hi Tesla), could it also happen to software developers. Looking at the early OSGi Enterprise specifications then that was a resounding yes.

### Profiles

Since it is impossible to compete successfully with the original we would be better off to provide APIs that take advantage of OSGi. Most compendium APIs already do so but we need services and extenders that satisfy the needs of most (enterprise) developers.   

### Tool Chain

So one of the primary goals is to get a _profile_ out that contains the _base_ service APIs. However, JES is not only successful because it provided usable APIs. The fact that the industry came together caused a flurry of activity in development tools. For a long time OSGi tooling did not get the fraction of funding that JES got. Over time tools like bnd(tools) and the maven bundle plugin provided the parts of the tool chain. However, if you come out of the blue getting started requires you to be an early adopter. The vision of OSGi enRoute is therefore to create a tool chain that makes it trivial to get started building true SOS applications.

The OSGi tool chain is based on Eclipse, bnd(tools), Git, Gradle, Github, and Travis. Through tutorials we make it really easy to get started with a working, albeit simple, application.

### Documentation & Tutorials

Which brings us to the third leg of OSGi enRoute: Documentation. The OSGi Alliance takes great pride in the quality of the specifications; few software specifications are as thoroughly documented (lots of pictures!) as the OSGi Core and Compendium specifications. We often met the absurd claim that OSGi is so complex because it has thousands of pages of documentation, a nice way to tell the expert groups to document as little as possible!

The specifications focus on the implementers of the specifications and thereby we've achieved fantastic portability between different implementations but that left the users, especially the uninitiated, largely out in the cold. 

Therefore the OSGi enRoute project spends a significant amount of time to provide documentation and tutorials. This can happen on this web site or it can happen by supporting a project with documentation.

### Community

At the core of OSGi we find a component system that our industry has pursued for so long. The basic premise of a component system is reuse and a market place. With OSGi we are temptingly close to this grail but a market place won't happen until there is a community.

Therefore the last leg on which OSGi enRoute stands is promoting a community. It engages the very active Apache Karaf, Eclipse, Liferay, Amdatu, Knopflerfish, Apache Felix and other communities to establish this market place of ideas and components. Everybody that wants to participate actively to work in this direction is more than welcome.

## Conclusion

OSGi enRoute is a very ambitious project. At the time of writing of this conclusion everything is still very much in beta and under construction. However, the vision is clear.















<!--

TBD

## Why OSGi?

 ... Hello world is not a benchmark
 
![Workflow](/img/book/ov/babel.jpg)

![Workflow](/img/book/ov/devchain-weight.jpg)

![Workflow](/img/book/ov/devchain-java.jpg)

* µService Oriented Programming
* To reduce system complexity
* Dependency Management 
* To reduce errors in development & operations
* Tooling
* To reduce time to market
* Documentation & Training
* To reduce confusion with developers

![Workflow](/img/book/ov/workflow.jpg)

## Community

## Tutorials

## bnd, the little engine that built 

![Workflow](/img/book/ov/bnd-arch.jpg)

![Workflow](/img/book/ov/bnd-workspace.jpg)

## Profiles

A profile is specific catalog of specifications that vendors can provide in a distribution.
An OSGi Profile consists of

* µServices — Specifications of either OSGi Alliance or external µservices.
* Extenders — An extender provides support functionality to OSGi bundles.
* Capabilities — A capability describes a feature/function/resource of the underlying system in abstract format.

Each OSGi enRoute Profile is represented by a clean signed JAR library that can be used to build bundles against.  This is a specification only library, it can not introduce unwanted dependencies, or let developers accidentally use proprietary features of a vendor.

* java 1.8 — All profiles are based on Java 1.8
* base — A minimum profile, mostly as common base and for demonstrations. It provides support for the best practices in our industry.
* base.debug — Supports developing and debugging
* web — Web application development optimized for single page web apps.
* web.debug — Supports developing and debugging web apps.
persistence — Provides support for JPA on OSGi


## bndtools

## Service Oriented Programming

![Workflow](/img/book/ov/services.jpg)

## Components 

![Workflow](/img/book/ov/components.jpg)

## Bundles 

![Workflow](/img/book/ov/bundles.jpg)

![Workflow](/img/book/ov/bundles-closed.jpg)

## Assembling

![Workflow](/img/book/ov/assembly.jpg)

## Distros

A distro provides the runtime environment for one or more profiles The OSGi enRoute project will deliver a reference distribution for all profiles based on open source and OSGi provided bundles. Members and other companies can provide other, competing, interoperable, distributions (And are actively encouraged to do so).

How do we prevent vendor lock-in?

## Capability Maturity Model

![Workflow](/img/book/ov/cap-req-1.jpg)

![Workflow](/img/book/ov/cap-req-2.jpg)

## Semantic Versioning

* major – Breaking change for consumers
* minor – Breaking change for providers
* micro – Invisible change

## Baselining

## Command Line Building

## Source Control Management

## Continuous Integration


-->