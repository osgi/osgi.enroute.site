---
title: Require-Bundle
summary: Express a dependency on another bundle
---

The `Require-Bundle` header is used to express a dependency on a
bundle's exports by reference to its [symbolic
name](Bundle-SymbolicName "wikilink") instead of via specific packages.
This was introduced in OSGi R4, as a means to solve Eclipse's
dependencies, which typically used `Require-Bundle` to express
dependencies. These days, best practice suggests using
[Import-Package](Import-Package "wikilink") instead of
[Require-Bundle](Require-Bundle "wikilink").

`Require-Bundle: com.example.acme,com.example.other;bundle-version=1.0.0`

See also [Use Import-Package instead of
Require-Bundle](Use Import-Package instead of Require-Bundle "wikilink"),
which is a [Best Practice](:Category:Best Practices "wikilink").

[Category:Manifest Header](Category:Manifest Header "wikilink")

