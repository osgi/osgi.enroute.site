---
title: org.osgi.service.http
layout: service
version: 1.2.1
summary:  An HTTP server framework
---

![Http Service Collaboration Diagram](/img/services/org.osgi.service.http.overview.png)

An OSGi framework normally provides users with access to services on the Internet and other net- works. This access allows users to remotely retrieve information from, and send control to, services in an OSGi framework using a standard web browser.
Bundle developers typically need to develop communication and user interface solutions for stan- dard technologies such as HTTP, HTML, XML, and servlets.

The Http Service supports two standard techniques for this purpose:

* Registering servlets – A servlet is a Java object which implements the Java Servlet API. Registering a servlet in the Framework gives it control over some part of the Http Service URI name-space.
* Registering resources – Registering a resource allows HTML files, image files, and other static re- sources to be made visible in the Http Service URI name-space by the requesting bundle.
Implementations of the Http Service can be based on:
  * [HTTP 1.0 Specification RFC-1945][1] 
  * [HTTP 1.1 Specification RFC-2616][2] 

Alternatively, implementations of this service can support other protocols if these protocols can conform to the semantics of the javax.servlet API. This additional support is necessary because the Http Service is closely related to [3] Java Servlet Technology. Http Service implementations must sup- port at least version 2.1 of the Java Servlet API.

[1]: HTTP 1.0 Specification RFC-1945, http://www.ietf.org/rfc/rfc1945.txt, May 1996
[2]: HTTP 1.1 Specification RFC-2616, http://www.ietf.org/rfc/rfc2616.txt, June 1999