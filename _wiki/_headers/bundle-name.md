---
title: Bundle-Name
summary: A human readable (and localizable) name for the bundle
---

The `Bundle-Name` is a textual identifier for the bundle. Prior to OSGi
R3, this was the identifier used to uniquely identify the bundle, but
since this could contain spaces and other characters was deemed to be
not unique enough. Generally replaced with
[Bundle-SymbolicName](Bundle-SymbolicName "wikilink") for uniqueness. If
using [Maven Bundle Plugin](Maven Bundle Plugin "wikilink") will default
to `${pom.name}`.

`Bundle-Name: Acme Bundle`

[Name](Category:Manifest Header "wikilink")

