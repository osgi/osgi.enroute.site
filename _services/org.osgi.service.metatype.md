---
title: org.osgi.service.metatype
layout: service
version: 1.1
summary:  A standard to describe data structures with the intent to create user interfaces from.
---

![Metatype Collaboration Diagram](/img/services/org.osgi.service.metatype.overview.png)

The Metatype specification defines interfaces that allow bundle developers to describe attribute types in a computer readable form using so-called metadata.

The purpose of this specification is to allow services to specify the type information of data that they can use as arguments. The data is based on attributes, which are key/value pairs like properties.

A designer in a type-safe language like Java is often confronted with the choice of using the lan- guage constructs to exchange data or using a technique based on attributes/properties that are based on key/value pairs. Attributes provide an escape from the rigid type-safety requirements of modern programming languages.

Type-safety works very well for software development environments in which multiple program- mers work together on large applications or systems, but often lacks the flexibility needed to receive structured data from the outside world.
The attribute paradigm has several characteristics that make this approach suitable when data needs to be communicated between different entities which “speak” different languages. Attributes are uncomplicated, resilient to change, and allow the receiver to dynamically adapt to different types of data.

As an example, the OSGi framework Specifications define several attribute types which are used in a Framework implementation, but which are also used and referenced by other OSGi specifications such as the Configuration Admin Service Specification on page 85. A Configuration Admin service im- plementation deploys attributes (key/value pairs) as configuration properties.

The Meta Type Service provides a unified access point to the Meta Type information that is associat- ed with bundles. This Meta Type information can be defined by an XML resource in a bundle (OSGI- INF/metatype directories must be scanned for any XML resources), it can come from the Meta Type Provider service, or it can be obtained from Managed Service or Managed Service Factory services.
