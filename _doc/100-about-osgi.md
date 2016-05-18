---
title: A Quick Introduction to OSGi
summary: A quick introduction into OSGi
layout: tutorial
lprev: /book/doc.html
lnext: 210-overview.html
---

## Software Complexity

The problem that OSGi solves is the key problem of software engineering: How to keep the complexity of large systems under control. Every developer knows the dreaded feeling if an unchecked software system becomes a bloating monster. OSGi addresses this problem with _modularity_ combined with the magic sauce of _services_.

Software complexity grows exponentially with the number of _links_ inside the code base. (Where a link is a line of code calling a method or using a field.) Modularization reduces complexity because it reduces the number of links by enforcing a _private_ and a _public_ world for each module. Any line of code can now only refer to its own (private) space and the public world. Without modularity, the developers could also link to anywhere in the code base. (And they will.) Since complexity grows exponential, even a small reduction of links has significant impact on the complexity of large systems.

The [seminal paper][parnas] from Parnas that first mentioned software modularity was called "On the Criteria To Be Used in Decomposing Systems into Modules". The paper's insight was that there was a tremendous difference in flexibility based on _how_ the system was decomposed into modules. Some decompositions required major changes for even small new requirements, other decompositions could incorporate new requirements with minimal change. 

An important concept in Parnas' paper is the concept of _change_. Large software systems evolve over time at an often surprising rate. It is therefore paramount that we're not only minimizing the number of links, but that we also make those links between modules as resilient as possible to change. The relevant concept here is _cohesion_. Things that are closely related should be close together in the private space of the module. Things that are not cohesive should be in separate modules. 
   
Within a private space private things are unknown to the rest of the world. Removing that private thing cannot affect anybody but the local residents. For example, removing a private class from a package is invisible to any external module. Anything that is not public can be changed at will. This clearly implies that by minimizing the public parts we keep our options open for the inevitable changes.     

So far this view of modularity is widely shared in our industry. However, this view ignores the _quality_ of the link. not all links are created equal. Some links cause a long train of transitive dependencies, other links link are to very volatile constructs. These types of links might still make it very hard to evolve a large software system because small new requirements still introduce system wide changes.

The ideal link allows modules to collaborate but it does not constrain any one of them. All participants in the collaboration are free to seek their own implementations and private choices. So the holy grail of modularity is to turn you gigantic trees of code links into tiny little toothpicks. Meet OSGi.
   
## Meet OSGi

The OSGi technology is a set of specifications that define a dynamic component system for Java. These specifications enable a development model where applications are (dynamically) composed of many different (reusable) components. The OSGi specifications enable components to hide their implementations from other components while communicating through services, which are objects that are specifically shared between components. This surprisingly simple model has far reaching effects for almost any aspect of the software development process.

Though components have been on the horizon for a long time, so far they failed to make good on their promises. OSGi is the first technology that actually succeeded with a component system that is solving many real problems in software development. Adopters of OSGi technology see significantly reduced complexity in almost all aspects of development. Code is easier to write and test, reuse is increased, build systems become significantly simpler, deployment is more manageable, bugs are detected early, and the runtime provides an enormous insight into what is running. Most important, it works as is testified by the wide adoption and use in popular applications like Eclipse and Spring.

We developed the OSGi technology to create a collaborative software environment. We were not looking for the possibility to run multiple applications in a single VM. Application servers do that already (though they were not yet around when we started in 1998). No, our problem was harder. We wanted an application to emerge from putting together different reusable components that had no a-priori knowledge of each other. Even harder, we wanted that application to emerge from dynamically assembling a set of components. For example, you have a home server that is capable of managing your lights and appliances. A component could allow you to turn on and off the light over a web page. Another component could allow you to control the appliances via a mobile text message. The goal was to allow these other functions to be added without requiring that the developers had intricate knowledge of each other and let these components be added independently.

## Layering

The OSGi has a layered model that is depicted in the following figure.

![layering-osgi](img/layering-osgi.png)

The following list contains a short definition of the terms:

- Bundles – Bundles are the OSGi components made by the developers.
- Services – The services layer connects bundles in a dynamic way by offering a publish-find-bind model for plain old Java objects.
- Life-Cycle – The API to install, start, stop, update, and uninstall bundles.
- Modules – The layer that defines how a bundle can import and export code.
- Security – The layer that handles the security aspects.
- Execution Environment – Defines what methods and classes are available in a specific platform.

These concepts are more extensively explained in the following sections.

## Modules

The fundamental concept that enables such a system is modularity. Modularity, simplistically said, is about assuming less. Modularity is about keeping things local and not sharing. It is hard to be wrong about things you have no knowledge of and make no assumptions about them. Therefore, modularity is at the core of the OSGi specifications and embodied in the bundle concept. In Java terms, a bundle is a plain old JAR file. However, where in standard Java everything in a JAR is completely visible to all other JARs, OSGi hides everything in that JAR unless explicitly exported. A bundle that wants to use another JAR must explicitly import the parts it needs. By default, there is no sharing.

Though the code hiding and explicit sharing provides many benefits (for example, allowing multiple versions of the same library being used in a single VM), the code sharing was only there to support OSGi services model. The services model is about bundles that collaborate. the service model is about turing the giant trees into tooth picks.

## Services

The reason we needed the service model is because Java shows how hard it is to write collaborative with only class sharing. The standard solution in Java is to use factories that use dynamic class loading and statics. For example, if you want a `DocumentBuilderFactory`, you call the static factory method `DocumentBuilderFactory.newInstance()`. Behind that façade, the `newInstance` methods tries every class loader trick in the book (and some that aren’t) to create an instance of an implementation subclass of the `DocumentBuilderFactory` class. Trying to influence what implementation is used is non-trivial (services loader model, properties, conventions in class name), and usually global for the VM. Also it is a passive model. The implementation code can not do anything to advertise its availability, nor can the user list the possible implementations and pick the most suitable implementation. It is also not dynamic. Once an implementation hands out an instance, it can not withdraw that object, ever. Worst of all, the factory mechanism is a convention used in hundreds of places in the VM where each factory has its own unique API and configuration mechanisms. There is no centralized overview of the implementations to which your code is bound. In other words, a nightmare.

The solution to all these issues is simply the OSGi service registry. A bundle can create an object and register it with the OSGi service registry under one or more interfaces. Other bundles can go to the registry and list all objects that are registered under a specific interfaces or class. For example, a bundle provides an implementation of the `DocumentBuilder`. When it gets started, it creates an instance of its `DocumentBuilderFactoryImpl` class and registers it with the registry under the `DocumentBuilderFactory` class. A bundle that needs a `DocumentBuilderFactory` can go to the registry and ask for all available services with the `DocumentBuilderFactory` class. Even better, a bundle can wait for a specific service to appear and then get a call back.

A bundle can therefore register a service, it can get a service, and it can listen for a service to appear or disappear. Any number of bundles can register the same service type, and any number of bundles can get the same service. This is depicted in the following figure.

![Services](img/services.png)

This in general called a broker.

What happens when multiple bundles register objects under the same interface or class? How can these be distinguished? First, in many cases it is not important to distinguish between individuals. Otherwise, the answer is properties. Each service registration has a set of standard and custom properties. A expressive filter language is available to select only the services in which you are interested. Properties can be used to find the proper service or can play other roles at the application level.

Services are dynamic. This means that a bundle can decide to withdraw its service from the registry while other bundles are still using this service. Bundles using such a service must then ensure that they no longer use the service object and drop any references. We know, this sounds like a significant complexity but it turns out that helper classes like the Service Tracker and frameworks like Declarative Services can remove the pain while the advantages are quite large. The service dynamics were added so we could install and uninstall bundles on the fly while the other bundles could adapt. That is, a bundle could still provide functionality even if the Http Service went away. 

We found that the real world is actually dynamic and many problems are a lot easier to model with dynamic services than static factories. For example, a Device service could represent a device on the local network. If the device goes away, the service representing it is unregistered. This way, the availability of the service models the availability of a real world entity. This works out very well in, for example, the distributed OSGi model where a service can be withdrawn if the connection to the remote machine dies. It also turns out that the dynamics solve the initialization problem. OSGi applications do not require a specific start ordering in their bundles.

_We found that the service registry significantly simplified application code because it handle so many common patterns_.
 
The effect of the service registry has been that many specialized APIs can be much modeled with the service registry. Not only does this simplify the overall application, it also means that standard tools can be used to debug and see how the system is wired up.

## Standard Services

Though the service registry accepts any object as a service, the best way to achieve reuse is to register these objects under (standard) interfaces to decouple the implementer from the client code. This is the reason the OSGi Alliance publishes the Compendium specifications. These specification define a large number of standard services, from a Log Service to a Measurement and State specification. All these standardized services are described in great detail.

That said, the approach to decouple the API from the implementation pays off in even the smallest of problems. It is our experience that even trivial problems tend to grow over time. Separating the API from the implementation makes almost every aspect of the software development process simpler. It is our recommendation that inside companies the responsibilities of organization wide APIs are carefully managed.

## Declarative Services & Configuration

Two of those standardized services in the OSGi are the Configuration Admin service and the Declarative Services. Though these service are just a few of the many compendium services they have a special role. These services provide functionality that is very hard to evaluate from the outside because they have no counterpart in in other systems. (A case could be made that they should probably have been part of the framework.)

Declarative Services makes writing a service implementation as simple as writing a POJO with a few annotations. Though there are other systems that do similar injections as Declarative Services, these other systems ignore time and dependencies. By handling time and (dynamic) dependencies without any code overhead OSGi provides a toolbox that is as innovative as objects were in the nineties.

In a similar vein, Configuration Admin can be used to not only configure service implementations, it can also control the life cycle. 

The pair of DS and Configuration Admin make it possible to create components that are completely configured through Configuration Admin (not requiring a confguration API), including their life cycle. 

Again, this is a feature that has no counterpart in other environments but the value of this is hard to over estimate.

## Deployment

Bundles are deployed on an OSGi framework, the bundle runtime environment. This is not a container like Java Application Servers. It is a collaborative environment. Bundles run in the same VM and can actually share code. The framework uses the explicit imports and exports to wire up the bundles so they do not have to concern themselves with class loading. Another contrast with the application servers is that the management of the framework is standardized. A simple API allows bundles to install, start, stop, and update other bundles, as well as enumerating the bundles and their service usage. This API has been used by many management agents to control OSGi frameworks. Management agents are as diverse as the Knopflerfish desktop and the Prosyst management system.

## Implementations

The OSGi specification process requires a reference implementation for each specification. However, since the first specifications there have always been commercial companies that have implemented the specifications as well as open source implementations. Currently, there are 4 open source implementations of the framework and too many to count implementations of the OSGi services. The open software industry has discovered OSGi technology and more and more projects deliver their artifacts as bundles.

## Conclusion

The OSGi specifications provide a mature and comprehensive component model with a very effective (and small) API. Converting monolithic or home grown plugin based systems to OSGi almost always provides great improvements in the whole process of developing software.

[parnas]: https://www.cs.umd.edu/class/spring2003/cmsc838p/Design/criteria.pdf
