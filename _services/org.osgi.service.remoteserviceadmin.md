---
title: org.osgi.service.remoteserviceadmin
layout: service
version: 1.1
summary:  A service for a topology manager to orchestrate the services between OSGi frameworks.
---

Details of *Remote Services* and *Remote Service Administration* specification can be found in Release 4 Version 4.2 of [OSGi Service Platform Enterprise Specification](http://www.osgi.org/Download/File?url=/download/r4v42/r4.enterprise.pdf)

These specifications together provide the discovery and service
re-moting foundations necessary for building *adaptive* distributed OSGi
based service oriented systems. The architecture defined by these
specifications allowing (implementation dependent):

-   Remote Service to come and go; so addressing 1 & 5 of Peter Deutsch
    Fallacies; see [The Eight Fallacies of Distributed
    Computing](http://blogs.oracle.com/jag/resource/Fallacies.html)
-   A framework to support multiple distribution providers
-   A framework to support multiple discovery providers
-   The ability to dynamically added and remove providers from a running
    environment.

Local Services
--------------

As a reminder, OSGi services within a single JVM are represented as
follows:

![centre|Local Services](RSA-3.png "centre|Local Services")

Remote Services
---------------

In remote services, a distribution provider detects services in the
local JVM (*framework1*) and publishes them to network endpoints. On the
consumer side (*framework 2*), the distribution provider detects the
network endpoints and creates proxy services for them. The consumer sees
an ordinary service, and need not be aware that the actual service
implementation is remote.

![centre|Remote Services](RSA-4.png "centre|Remote Services")

Anatomy of a RSA Provider
-------------------------

1.  *Service E* has a service property `service.exported.interfaces`
    set.
2.  Local *Topology Manager* is informed of *Service E*.
3.  Based on policy, the *Topology Manager* informs registered *Remote
    Service Admin* services.
4.  If a *Remote Service Admin* can support *Service E* it creates a
    *Service E* endpoint.
5.  The framework wires the service endpoint to service.
6.  The *Remote Service Admin* also creates an *Endpoint Description*
    and passes this to registered *Discovery Providers*.
7.  Each *Discovery Provider* encapsulates the *Endpoint Description* in
    the appropriate manner and issues an implementation specific
    advertisement.

NOTE: multiple concurrent discovery providers can be supported. 

![ centre | Provider](RSA-1.png " centre | Provider")

Anatomy of an RSA Consumer
--------------------------

1.  *Discovery Provider X* receives a remote-advertisement from*Service
    E*.
2.  *Service E's* endpoint description is unpacked and sent to the local
    *Topology Manager*.
3.  The *Topology Manager* is aware that *Service B* has a reference to
    *Service E*, hence the *Topology Manager* sends the *Endpoint
    Description* to the appropriate *Remote Service Admin*.
4.  The *Remote Service Admin* creates a local proxy for *Service E*.
5.  The framework wires *Service E* proxy to *Service B*.

![ centre | Consumer](RSA-2.png " centre | Consumer")

Implementations
===============

For a list of available Remote Services Admin implementations, see [https://en.wikipedia.org/wiki/OSGi_Specification_Implementations](https://en.wikipedia.org/wiki/OSGi_Specification_Implementations)
