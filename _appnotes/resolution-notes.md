---
title: Resolution Notes
summary: Notes regarding resolution of bundle capabilities and requirements
---

OSGi has an advanced dependency management mechanism based on matching
capabilities and requirements. When constructing a system, the resolution
mechansim matches capabilities with requirements.

OSGi developers are gaining more experience with this resolution process,
and how it integrates with development and deployment of complex systems.

The notes here are an attempt to collect some of the good practices employed
by some of the leading OSGi developers.

Definitions
---------------
"Resolving" is the process of wiring a bundle in a runtime system, as described in Chapter 3
(Module Layer) of the OSGi Core specification.

"Resolution" is the process of determining a network of resources in a system such that
the requirements and capabilities declared by the resources resolve to a solution.

Overview
---------------
As the number of resources in a system increase, the resolution problem becomes
complex [which function? exponential?]. By managing how dependencies are provided
from repositories, and by carefully crafting the declared capabilities and 
requirements of the resources, some of this complexity can be mitigated.

There is consensus in the OSGi community that repository governance is
one of the keys to success. There appears to be consensus that design-time
resolution management also contributes to success. Opinions currently 
diverge regarding the role of runtime resolution.

We discuss each of these topics below.

Repository Governance
---------------
[TBD]


Deployment Process
---------------
Resolution first happens during design time. Bndtools and EnRoute
provide a development environment that assists with resource resolution.
The tool will produce a resolution file, which can (and should) be
committed to a source code management system (git). The resolution can
also optionally be transformed into some other format, such as a
Karaf feature. 


Runtime Resolution
---------------
There are two schools of thought regarding runtime resolution (RR):
 * Don't-do-it-it's-dangerous (DDIID)
 * It-is-necessary (IIN)

In the DDIID School:

In the beginning, there was a dream of automating runtime resolutions
based on requirements and capabilities. However, with time and
practice, this no longer appears to be a practical solution. It is a
goal worth striving for, but cannot be achieved. 
The only reliable
resolution can be performed at design and build time. This resolution should be
committed to scm and propagated to the production runtime. Otherwise,
any change introduced into the runtime system creates a significant risk.

A RR should not be required, and on the contrary could be very dangerous


In the IIN School:

A production runtime may be an amalgamation of various systems, each
one having been built independently, or a system may need to run in
different environments (example: OS specific). When creating such
production system, the environment may therefore have differences
from what was crafted in the different development environments. If
you were to create a development-time "fixed" resolution for each
possible permutation, it would create a LOT of extra work. It also
helps to validate that the system is running in a compatible environment.

A runtime resolution is important and possibly necessary.

A runtime resolution should not be expected to be identical to a
build-time resolution


System Types
---------------
There are different system types that may require different ways
of approaching RR. For instance:

 * A small, contained "Application" may be run in isolation on 
    a known system. In such case, it would be better to resolve
    up-front during design time, and ensure that the RR does not
    change.

 * An "application host" server may already provide a context into
    which "applications" may be deployed. Since the applications are
    being deployed into an existing context, RR becomes important.


