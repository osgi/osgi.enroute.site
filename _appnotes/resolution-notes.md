---
title: Notes about Resolution
summary: Notes regarding resolving bundle capabilities and requirements
---

OSGi has an advanced dependency management mechanism based on matching
_requirements_ to _capabilities_ coming from a set of _resources_, for example bundles. When constructing a system, the resolver
can create _resolution_. A resolution is a set of resources that provide all required capabilities for that set of resources.

OSGi developers are gaining more experience with this resolution process,
and how it integrates with development and deployment of complex systems. The notes here are an attempt to collect some of the good practices employed
by some of the leading OSGi developers.

## Definitions

* _Resolving_ is the process of wiring bundles in a runtime system, as described in Chapter 3
(Module Layer) of the OSGi Core specification. 
* _Resolution_ is a set of wires that satisfies all requirements. It is the result of the resolve process.

## Overview

As the number of resources in a system increases, the resolution problem becomes
exponentially more complex. It is therefore paramount to minimize the set of resources in a resolution. 
By managing how dependencies are provided
from repositories, and by carefully crafting the declared capabilities and 
requirements of the resources, most of this complexity can be mitigated. This process is called _curation_.

There is consensus in the OSGi community that repository curation is
one of the keys to success. There appears to be consensus that design-time
resolution management also contributes to success. Opinions currently 
diverge regarding the role of runtime resolution.

We discuss each of these topics below.

## Repository Curation

Repositories can be seen as an ever growing collection of resources, like Maven Central. Once a resource is listed it can never be removed because a build using that resource will fail. This problem is worsened when the repository is used in a resolution since also newer revisions of resources can change the resolution. Resolutions are highly sensitive to changes in their input.

In Bndtools, the approach is to create a _view_ on one or more repositories and store this view in source control management system. Since this view is stored in the source control management system, the build will always see the same resources and, as long as the other inputs to the resolution process do not change, will therefore produce the same resolution in the future.

## Deployment Process

Resolution first happens during design time. Bndtools and OSGi enRoute
provide a development environment that assists with resource resolution.
The tool will produce a resolution file, which can (and should) be
committed to a source code management system (git). The resolution can
also optionally be _exported_ into some other format, such as a
Karaf feature, subsystem file, a docker image, or an executable JAR. 


## When should resolution be done

### Design time

In the beginning, there was a dream of automating runtime resolutions based on requirements and capabilities. However, with time and practice, this no longer appears to be a practical solution. It is a goal worth striving for, but cannot be achieved because of _optionality_. In many cases requirements are optional. For example, The Event Admin service implementation has an optional requirement on the Event Handler service. It should be clear that the resolution should not contain every possible provider in the repositories of the Event Handler service; the intention of the Event Admin is to act as event broker between bundles that are required for some other reason. That is, a resource being required by Event Admin is clearly **not** a reason to include it.

There is no known practical solution to this problem of optionality. It always requires a human to make a choice based on trade-offs that are not visible to the resolver. (Though it is possible to automate the choice, it should be clear that this quickly runs in a problem requiring Artificial Intelligence.)

Even without the optionality problem, runtime resolutions are not advised because a resolution is highly dependent on its inputs, which includes the resolver version, the repositories (including their ordering), the artifacts, the history of the target system, and the time of day. It should be clear that this sensitivity can easily result in different results between the Q&A test system and the production system. Though this is in general benign because the resolution does a lot of checking, it should be clear that it is all too easy for hard to diagnose errors to creep in. (i.e., it runs in Q&A but fails in production.)

Therefore, the only reliable resolution can be performed at the design time, when a user is present to solve the optionality problem. This resolution should be committed to the source control system. The resolution is then propagated to the production runtime. Otherwise, any change introduced directly into the runtime system creates a significant risk.

### Build time

Build time resolution neans that the resolve step is done in a fully automated build based on a set of repositories and requirements that are both created interactively.

The goal of build time resolution is to enable a devops style of development. So you can work with snapshot dependencies and set up a fully automated build and test pipeline. Any change in your code as well as snapshots you depend on should be built  and tested automatically. This gives an early warning when upstream projects change in possibly incompatible ways while also achieving green builds when the changes are compatible. Design time resolution can not solve this as it would regard any change in upstream projects that affect the resolution as a reason to break the build.

Compared to runtime resolution build time resolution has the advantage that once released your system is fixed and will not change in unpredicted ways. 

### Runtime

A production runtime may be an amalgamation of various systems, each
one having been built independently, or a system might be required to run in
different environments (example: OS specific). When creating such
production system, the environment may therefore have differences
from what was crafted in the different development environments. If
you were to create a development-time _fixed resolution_ for each
possible permutation, it would create a LOT of extra work. It also
helps to validate that the system is running in a compatible environment.

* A runtime resolution is important and possibly necessary.
* A runtime resolution should not be expected to be identical to a
build-time resolution.

One important reason for runtime resolution is if your artifacts are deployed on an OSGi based application server where
they have to live together with already deployed artifacts from other sources. A resolution that covers all deployed artifacts can only be determined at runtime. A big problem with this is though that the resolution can affect and break already deployed artifacts.

## System Types

There are different system types that may require different ways
of approaching runtime resolution. For instance:

 * A small, contained _Application_ may be run in isolation on 
    a known system. In such case, it would be better to resolve
    up-front during design time, and ensure that the RR does not
    change.

 * An _application host_ server may already provide a context into
    which "applications" may be deployed. Since the applications are
    being deployed into an existing context, runtime resolution becomes important.


