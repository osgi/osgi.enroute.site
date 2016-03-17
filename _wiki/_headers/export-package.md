---
title: Export-Package
summary: List of packages to be used by other bundles
---

Bundles may export zero or more packages from the JAR to be consumable
by other bundles. The export list is a comma-separated list of
fully-qualified packages, often with a version attribute. If not
specified, the version defaults so 0.0.0.

`Export-Package: com.example.acme, com.example.other;version="1.0"`

[Category:Manifest Header](Category:Manifest Header "wikilink")

