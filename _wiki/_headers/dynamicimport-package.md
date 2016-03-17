---
title: DynamicImport-Package
summary: Last resort to import unknown packages
---

`DynamicImport-Package` is not widely used. Its purpose is to allow a
bundle to be wired up to packages that may not be known about in
advance. When a class is requested, if it cannot be solved via the
bundle's existing imports, the `Dynamic-ImportPackage` allows other
bundles to be considered for a wiring import to be added.

The dynamic import package is typically considered to be a backwards
compatibility hook for those JARs which use many dynamic class accesses,
such as Hibernate.

`DynamicImport-Package: *`

Notes
-----

-   Though DynamicImport-Package can be a life saver in certain
    circumstances it does revert the OSGi Framework to a very expensive
    class path for the packages involved. With DynamicImport-Package the
    OSGi Framework must revert to searching the public exported packages
    to find a match instead of the careful normal calculation.
    Especially using the wildcard is very harmful. The need for
    DynamicImport-Package usually is a symptom of a non-modular design.

[Category:Manifest Header](Category:Manifest Header "wikilink")

