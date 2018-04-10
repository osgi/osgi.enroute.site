---
title: API Design
layout: toc-guide-page
lprev: 420--dtos.html 
lnext: 500-gogo.html 
summary: General best practises  
author: enRoute@paremus.com
sponsor: OSGi™ Alliance 
---

Good API design is critical in any software system, and OSGi is no different. In fact the tools available to you in OSGi make it easier to write clean, loosely coupled APIs.

* Use the service registry to share implementations, not API factory classes
* Use DTOs for data transfer when calling services
* There should be no statics and no state in the API
* Avoid unnecessary uses constraints

## OSGi Services and Interface Based Design

It is widely accepted that using interfaces in your API is a good thing. Using interfaces prevents your code from coupling to the implementation details of other modules and components in the system. The issue with purely interface-based APIs is that they leave us with a bootstrapping problem - how do we obtain an instance when all we have is an interface?

In standard Java a common pattern is to define an API factory class, however this has many limitations

* The API is now coupled to the implementation, as it has to instantiate it
* The client, not the provider, now dictates the lifecycle of the implementation object
* Replacing the API involves updating the factory

The `ServiceLoader` was introduced into Java to improve this model, but it still has many of the same limitations. In OSGi, however, we have the Service Registry! The OSGi Service Registry allows us to share instances between bundles transparently, without the need for any factories. 

In enRoute we do this using Declarative Services, for example:

    @Component
    public class MyImpl implements MyService {
        ...
    }

    @Component
    public class MyClient {
    
        @Reference
        private MyService;
    
        ...
    }

## Passing Data

Almost all useful methods operate on and return data. Where possible it's a good idea to use DTOs to represent this data. The main reason for this is that DTOs provide an easily convertible, transformable data model. When you call a service you don't actually know whether the implementation is local, remote, or even written in another language. Using DTOs gives implementors the maximum flexibility when providing an implementation of your API

## State in the API

An API should not contain any state or static fields. Including state in the API creates huge lifecycle issues, for example:

* Who is responsible for cleaning up the state? Failing to do so causes memory leaks.
* How do clients of the API get notified when the state changes?
* What happens when multiple implementations want to set the same field to different values?

The simplest way to avoid this is to not have any state in the API at all. This is not to say that implementations of an API cannot be stateful, however this should also be approached carefully.

By default services in the service registry are registered as singletons, and may be called concurrently by many different modules. Stateful services must therefore be thread-safe, and able to support concurrent use by different clients. 

Another option, however, is to make your service prototype scoped. Prototype scope services allow clients to get their own instances, meaning that each object is only used by a single client.


    @Component(scope = PROTOTYPE)
    public class MyImpl implements MyService {
        ...
    }

    @Component
    public class MyClient {
    
        @Reference
        private MyService;
    
        ...
    }

## Uses constraints

A uses constraint occurs whenever one API package directly exposes another API package. This may be:

* Through inheritance - one or more API types extend or implement types from another package
* Receiving method parameters with types from another package
* Returning types from another package

It is relatively common to have some uses constraints in your API, however you should be careful to minimise them, and to understand the effect that they can have. Typically, if the used packages are defined as part of the same API then there isn't a problem. For example, the `javax.servlet.http` package uses the `javax.servlet` package. If, however, the used packages are from a different bundle, or from a different separable API then this is not a good thing

### Why are uses constraints a problem

When you have a uses constraint in your API it forces all clients to also import that API, and crucially they must use *exactly the same* API package that you do. This places limitations on the way that the client can be implemented.

To use an example from the real world, the JClouds API has a uses constraint for Guava collections. This means that all JClouds clients must use the same version of Guava as JClouds does. If they don't, then the system cannot resolve. This means that clients aren't able to take advantage of newer features from Guava, simply so that JClouds can use `ImmutableSet` rather than `Set` in their API.
