---
title: Best Practices for Exporting Packages
summary:  An overview of the best practices in exporting packages
---

Ideally, the only exported packages should be ones that contain pure
APIs, i.e. nothing but pure interfaces and perhaps some `Exception`
classes. Exporting packages that contain implementation classes means
that the specific implementation becomes part of the contract between
bundles, which is much harder to evolve and maintain in the future. For
example, pure APIs change much more slowly than implementation classes,
because the latter need to be changed every time a tiny bug is found. It
is also easier to use automatic tools to detect compatible vs
incompatible changes in APIs and generate appropriate versions (see also
[Semantic Versioning](Semantic Versioning "wikilink")).

These APIs should be in dedicated API bundles (see another best
practice, [Separate API from
Implementation](Separate API from Implementation "wikilink")). Most
other bundles should import the APIs and contain implementation classes
that consume and/or publish services. These implementation bundles
should **export nothing**.

## Avoid Bnd Wildcards

If building bundles with [bnd](bnd "wikilink") (or a bnd-derived tool
such as [Maven Bundle Plugin](Maven Bundle Plugin "wikilink") or
[Bndtools](Bndtools "wikilink")), be extremely cautious with wildcard
patterns in the [Export-Package](Export-Package "wikilink") header. In
fact, as an implication of the above best practice, wildcards should
probably be avoided entirely, in favour of explicitly stating each
exported package.

## All exported packages should be versioned

When using [Import-Package](Import-Package "wikilink"), the *only*
version that is important in resolution is the version of the [exported
package](Export-Package "wikilink"). The version of the bundle (i.e.
[Bundle-Version](Bundle-Version "wikilink")) is irrelevant in the
resolution process unless [Require-Bundle](Require-Bundle "wikilink") is
used, but see another best practice: [Use Import-Package instead of
Require-Bundle](Use Import-Package instead of Require-Bundle "wikilink").

Packages can and should be versioned independently from other packages
in the same bundle, according to the way they have changed with respect
to previous releases. If a package has not changed, do **not** bump its
version when releasing a new version of the containing bundle. See also
[Semantic Versioning](Semantic Versioning "wikilink").

If it sounds like a lot of work to maintain versions of packages
independently, then this is another argument for [exporting as little as
possible](Export Only APIs "wikilink")... remember that only *exported*
packages need to be versioned.

<Category:Best_Practices>

