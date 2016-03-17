---
title: Blueprint Component model
summary: A description of the Blueprint component model
---

Various **Component Models** exist for OSGi. Though they vary
significantly in their goals and implementation details, they have some
common features:

-   They ease the task of defining "components" that interact with each
    other through via OSGi [Services](Services "wikilink"). As such they
    offers means of both consuming and providing
    [Services](Services "wikilink") without writing complex code.
-   They may include the concept of lifecycle for components, distinct
    from the lifecycle of bundles.
-   Most offer a POJO programming model with no dependencies on OSGi or
    other container-specific APIs, which helps with testing.

Two component models — [Declarative
Services](Declarative Services "wikilink") and
[Blueprint](Blueprint Service "wikilink") — are defined by the OSGi
specification and have multiple implementations. Some other models are
derived from or wrap a pre-existing framework such as
[Spring-DM](Spring-DM "wikilink") (based on the Spring Framework), or
[Peaberry](Peaberry "wikilink") (based on [Google
Guice](http://code.google.com/p/google-guice/)). Others such as
[iPOJO](iPOJO "wikilink") were designed from scratch to work well in
OSGi but are not part of any specification. Finally
[ScalaModules](ScalaModules "wikilink") is a DSL in the Scala
programming language for working with the OSGi APIs.

Interoperability
----------------

Each component model reflects different design goals, choices and
compromises about features to include or omit. As such there is no
single model that is "best" for all tasks -- though naturally each model
has its evangelists and detractors.

However, a beautiful property of OSGi is that all of these component
models interoperate *perfectly* through OSGi services. Each focuses on
consuming and providing services, therefore it is possible for services
provided from a Peaberry/Guice bundle to be consumed by a bundle that
uses Spring-DM, or *vice versa*.

Therefore the choice of component model is an internal implementation
detail for a bundle, and we can in theory use many models in one
application. It is not desirable to do this arbitrarily — each new model
does carry costs, in terms of developer training and additional
supporting bundles — but we do not need to fear using third-party
components developed with other models, nor do we need to worry about
committing to a particular model and never being able to change our
minds in the future.

# Blueprint

The Blueprint Service is a way of instantiating and consuming services
provided by others by means of an external XML configuration file. It is
similar in intent to [Declarative
Services](Declarative Services "wikilink").

Configuration
-------------

The following is an example of a blueprint service, which is stored in
OSGI-INF/blueprint/\*.xml

	<components xmlns="http://www.osgi.org/xmlns/blueprint/v1.0.0">` `  
		<description>`Optional description for the blueprint defined in this file.`</description>  
		<component id="my.example.component" class="com.example.Class">  
		</component>  
	</components>

Spring
------

The Blueprint service is heavily inspired by the [Spring
Framework](http://springframework.org).

Differences with Declarative Services
-------------------------------------

A key difference between the Blueprint Service and Declarative Services
is when the instantiation of components appear. With Blueprint, the
components are created as soon as the bundle is loaded; if there are any
dependent services that are not present, there is a proxy which is bound
and defers dynamically when a service becomes available. If a service is
not present, calls to the proxy will hang until one is available.

Declarative Services, on the other hand, will not create a component
until all of its dependent services are available.

References
----------

-   [Building OSGi applications with
    Blueprint](http://www.ibm.com/developerworks/opensource/library/os-osgiblueprint/)

<Category:Service>

