---
title: Overview
layout: book
summary: An overview of OSGi enRoute
---
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

## jpm4j

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


