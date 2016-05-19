---
title: Designing Service Oriented Systems
summary: How to design with services
layout: tutorial
lprev: 215-sos.html
lnext: 217-ds.html
---

How does one design a (µ)service based system? Well, design is a skill one obtains over the years and there is no easy way to convey that knowledge. However, successful service based designs follow a number of best practices. These practices are described in this chapter.

## Design by Contract

In a service based design the goal is to let all interactions between modules flow through contracts, a.k.a. services. A contract is not an interface, a contract describes a collaboration between different parties. Some of these parties have the obligation to implement an interface, others are more anonymous.

At first sight a contract seems an additional burden to take care off that is often deemed in the way for simple problems. Even the author of this text is sometimes tempted to skip the contract but so far have always regretted such short-cuts after a surprisingly short time.

The understanding of why the additional layer is actually a simplification in almost all cases is related to why the modularity works so well. Complexity grows exponentially with the number of moving parts, which means that 2 simple service APIs would when combined become a complex service API. With Export-Package and Import-Package we minimize the number of types that are visible to other bundles and with the services we can minimize the concepts that the different bundles must be aware of.

One frequently observed reason why people balk at making service APIs is that it is seen as very hard work. Though creating a formally specified service as done by the OSGi Alliance's Expert Groups is a lot of work, this does not mean that internal service APIs amount to the same amount of work. The do not have the longevity requirement that formal specifications have.

Internally used service APIs can often be designed purely on the current needs, which is generally much smaller than what popular open source libraries offer.

For example, an internal application needs a message queue. There is of course JMS and there are many proprietary libraries. Trying to evaluate all of them can be daunting. Selecting any one of them offers way more functionality than is generally needed. This seems harmless but it has two bad consequences. Large APIs are harder to understand and after using a large API it becomes entangled in your code in a way that is almost impossible to untangle.

The better approach is to analyze what the minimum need is from the application's perspective. This is in our experience often surprisingly small. Then define the service contract based on these needs. Since you own the service you can always extend it later. The power of OSGi is that its strong dependency management and semantic versioning allows you to break APIs when necessary in a controlled way. You're not forced to be backward compatible forever.

With our simple API we now created a shared meeting point. On one side the application and on the other side an implementation. The smaller the API, the easier it will be to choose any of the available options. Most of the time it is not hard to find an open source implementation that matches your needs. However, these implementations choices remain hidden behind the simple API that the Application sees.

Over time the application will require more and more functionality from the API. This will often result in heated discussions among the developers to just use the underlying implementation library and get rid of the abstraction. Though at a certain point this may be the best choice it looks remarkably similar to removing the watertight compartments in a ship. Safes some fuel in the short run ...

 Contracts between modules significantly reduce overall system complexity. 

