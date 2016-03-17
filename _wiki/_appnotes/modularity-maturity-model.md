---
title: Modulariy Maturiy Model (MMM)
summary: he <em>Modularity Maturity Model</em> was proposed by Dr Graham Charters at the OSGi Community Event 2011, as a way of describing how far down the modularity path an organisation or project is.
---

The <em>Modularity Maturity Model</em> was proposed by Dr Graham
Charters at the OSGi Community Event 2011, as a way of describing how
far down the modularity path an organisation or project is. It is named
for the [Capability Maturity
Model](http://en.wikipedia.org/wiki/Capability_Maturity_Model), which
allows organisations or projects to measure their improvements on a
software development process.

As a work in progress, these levels may change over time. Once it has
reached stability this paragraph will be removed and a link to the
normative specification will be added.

Note that these terms are largely OSGi agnostic and that it can be
applied to any modularity model. It is also intended as a guide rather
than prescriptive.

Level 1: Ad Hoc
---------------

At the Ad-hoc level, there isn't any formal modularity. A flat class
path issued with a bunch of classes with no, or limited, structure.

They may use 'library JARs' to access functionality but typically
results in a monolithic application.

### Benefits

The main benefit of this is the low cost and low barrier to entry.

Level 2: Modules
----------------

Modules are explicitly versioned and have formal module identities,
instead of merely classes (or JARs of classes). In particular, and a key
point of this, is that dependencies are done against the module identity
(including version) rather than the units themselves.

Maven, Ivy, RPM and OSGi are all examples of where dependencies are
managed at the versioned identity level instead of at the JAR level.

### Benefits

-   Decouple module from artefact
-   Clearer view of module assembly
-   Enables version awareness through build, development and operations
-   Enables module categories

Level 3: Modularity
-------------------

Module identity is not the same as modularity.

`"(Desirable) property of a system, such that individual components an be examined, `  
`modified and maintained independently of the remainder of the system. `  
`Objective is that changes in one part of a system should not lead to unexpected behaviour in other parts" `  
`- www.maths.bath.ac.uk/~jap/MATH0015/glossary.html (correct link unknown, may be a reference to Jianjun Hu PhD 2004`

Modules are declared via module contracts, not via artefacts. The
requirements can take the general form of the capabilities and
requirements, but could be a specific realisation (e.g. a particular
package). The private parts of the modules are an implementation detail.

In this level, dependency resolution comes first and module identity is
of lesser importance.

### Benefits

-   Fine-grained impact awareness (for bug fixes, implementation or
    client breaking changes)
-   System structure awareness
-   Client/provider independence
-   Requirement-based dependency checking

Level 4: Loose coupling
-----------------------

There is a separation of interface from implementation; they are not
acquired via factories or use constructors to access the
implementations. This provides a services-based module collaboration
(seen in OSGi, but also present in some other frameworks like Spring or
JNDI to hide the construction of the services from the user of those
services).

In addition, the dependencies must be semantically versioned.

### Benefits

-   Implements a client/provider independence

Level 5: Devolution
-------------------

At the devolved level, artefact ownerships are devolved to
modularity-aware repositories. They may support collaboration or
governance for accessing the assets by relation to the services and
capabilities required.

### Benefits

-   Greater awareness of existing modules
-   Reduced duplication and increased quality
-   Collaboration and empowerment
-   Quality and operational control

Level 6: Dynamism
-----------------

Provides a dynamic module life-cycle, which allows modules to
participate in the life cycle events (or initiate them). Will have
operational support for module addition/removal/replacement.

### Benefits

-   No brittle ordering dependencies
-   Ability to dynamically update
-   Can allow fixes to be hot-deployed and to extend capabilities
    without needing to restart the system

