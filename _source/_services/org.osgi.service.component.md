---
title: org.osgi.service.component
layout: service
version: 1.3
summary: An extender for Declarative Services components 
---

![Declarative Services Collaboration Diagram](/img/services/org.osgi.service.component.overview.png)


The OSGi Framework contains a procedural service model which provides a publish/find/bind mod- el for using services. This model is elegant and powerful, it enables the building of applications out of bundles that communicate and collaborate using these services.
This specification addresses some of the complications that arise when the OSGi service model is used for larger systems and wider deployments, such as:

* Startup Time – The procedural service model requires a bundle to actively register and acquire its services. This is normally done at startup time, requiring all present bundles to be initial- ized with a Bundle Activator. In larger systems, this quickly results in unacceptably long startup times.
* Memory Footprint – A service registered with the Framework implies that the implementation, and related classes and objects, are loaded in memory. If the service is never used, this memory is unnecessarily occupied. The creation of a class loader may therefore cause significant overhead.
* Complexity – Service can come and go at any time. This dynamic behavior makes the service pro- gramming model more complex than more traditional models. This complexity negatively influ- ences the adoption of the OSGi service model as well as the robustness and reliability of applica- tions because these applications do not always handle the dynamicity correctly.

The service component model uses a declarative model for publishing, finding and binding to OSGi services. This model simplifies the task of authoring OSGi services by performing the work of reg- istering the service and handling service dependencies. This minimizes the amount of code a pro- grammer has to write; it also allows service components to be loaded only when they are needed. As a result, bundles need not provide a BundleActivator class to collaborate with others through the service registry.
From a system perspective, the service component model means reduced startup time and potential- ly a reduction of the memory footprint. From a programmer’s point of view the service component model provides a simplified programming model.
The Service Component model makes use of concepts described in [1] Automating Service Dependency Management in a Service-Oriented Component Model.