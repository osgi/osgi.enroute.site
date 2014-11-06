---
title: org.osgi.service.cm
layout: service
version: 1.5
summary: Provides a push and pull model to configure components. 
---
The Configuration Admin service is an important aspect of the deployment of an OSGi framework. It allows an Operator to configure deployed bundles. Configuring is the process of defining the con- figuration data for bundles and assuring that those bundles receive that data when they are active in the OSGi framework.

This specification is based on the concept of a Configuration Admin service that manages the con- figuration of an OSGi framework. It maintains a database of Configuration objects, locally or re- motely. This service monitors the service registry and provides configuration information to ser- vices that are registered with a service.pid property, the Persistent IDentity (PID), and implement one of the following interfaces:

* Managed Service – A service registered with this interface receives its configuration dictionary from the database or receives null when no such configuration exists.
* Managed Service Factory – Services registered with this interface can receive several configuration dictionaries when registered. The database contains zero or more configuration dictionaries for this service. Each configuration dictionary is given sequentially to the service.

The database can be manipulated either by the Management Agent or bundles that configure them- selves. Other parties can provide Configuration Plugin services. Such services participate in the con- figuration process. They can inspect the configuration dictionary and modify it before it reaches the target service.
