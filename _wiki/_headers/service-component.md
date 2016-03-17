---
title: Service-Component
summary: Points to where the Declarative Services component XML is stored in the bundle
---

`Service-Component` is a header used in [Declarative
Services](Declarative Services "wikilink") to define many individual XML
files (or patterns) which can be used to declare components. The default
value is empty, though typically it points to `OSGI-INF/*.xml`, to
permit any files in the bundle (or any of its
[fragments](Fragment "wikilink")) to supply additional information for
Declarative Services to process.

`Service-Component: OSGI-INF/*.xml`

[Category:Manifest Header](Category:Manifest Header "wikilink")

