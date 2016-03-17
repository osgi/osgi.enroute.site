---
title: Provide-Capability
summary: Specifies the capabilities this bundle provides 
---

The `Provide-Capability` denotes that this bundle provides the given
capability, which is similar in concept to
[Export-Package](Export-Package "wikilink") although it is not limited
to package consumption. In addition, it does not require a package
wiring between bundles, which permits a bundle to provide a [Declarative
Services](Declarative Services "wikilink") capability to be consumed by
others.

For example, a bundle could state that it provides a screen display of
1024 by 768 pixels:

`Provide-Capability: screen.size; width=1024; height=768`

Capabilities are consumed with
[Require-Capability](Require-Capability "wikilink").

This header was introduced in OSGi [Release 4.3](Release 4.3 "wikilink")
and will be ignored by frameworks that comply with earlier releases.

**Note** The OSGi specification (4.3 Core) incorrectly lists the header
in 3.2.1.26 as "Provided-Capability".

[Category:Manifest Header](Category:Manifest Header "wikilink")

