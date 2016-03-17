---
title: Import Packges versus Require Bundle
summary: Trade offs between Import Packages & Require Bundle
---

In general, it's much better to express dependencies using
[Import-Package](Import-Package "wikilink") rather than
[Require-Bundle](Require-Bundle "wikilink"). The reason for this is that
of substitutionality in which you can replace a bundle with another
providing the same API. It also allows you to refactor a bundle's
content to move elsewhere, instead of having to update a list of
specific statements.

Even packages like `org.eclipse.swt` can be substituted for different
implementations, for example, RAP provides an SWT widget set that
renders via HTML remotely. Packages that
`Require-Bundle: org.eclipse.swt` will not be portable to RAP, but those
that use `Import-Package: org.eclipse.swt` will be.

In addition, packages may be independently versioned and ranges provided
(e.g. `Import-Package: org.osgi.framework;version:=[1.3,2.0)`). This
avoids the need to express a dependency on a bundle (which will often
have a collection of packages) and instead provide a specific dependency
on a versioned package, even if other packages on bundles have
incompatible changes.

[Category:Best Practices](Category:Best Practices "wikilink")

