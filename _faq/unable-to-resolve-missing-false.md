---
title: Unable to resolve org.example.foo.api version=1.0.0.201603042130 missing requirement false
summary: When the resolver fails to resolve and says the missing requirement is false.
---

The resolve error indicates that the only exporter is the API project but that this project says it should not resolve because in enRoute we highly recommend to include the API package in the provider so a resolution does not just consist of APIs without implementations. If you look in your bnd.bnd file in the org.example.foo.api project then you'll see the following lines:

Require-Capability: \
compile-only

This is a requirement that cannot be resolved. Adding the package to the provider will then make the provider the preferred exporter.

This model (exporting the API from the provider) is explained extensively in the [Base Tutorial][1]. For a more information you can also look in the [bnd manual about versioning][2].

You should there have some org.example.foo.provider bundle that provides the implementation and this should export the API. Exporting it is simple, just drag the package and drop it on the Contents Export list of the provider's `bnd.bnd` file. See the Base tutorial for details.

That said, in the OSGi we now have implementation capabilities and the next OSGi enRoute setup will use those. It is slightly cleaner but also a bit less practical. For now, just export the API from the provider it is the last amount of trouble.


[1]: /tutorial_base/300-api.html
[2]: http://bnd.bndtools.org/chapters/170-versioning.html
