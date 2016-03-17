---
title: Require-Capability
summary: Declare dependencies on capabilities
---


The `Require-Capability` allows a bundle to declare that it requires an
abstract "capability" provided by some other bundle. For example a
bundle may require to be run on a screen that is at least 800 wide by
600 pixels deep:

`Require-Capability: screen.size; filter:="(&(width>=800)(height>=600))"`

This bundle would then only resolve if another bundle is present that
offered the `screen.size` capability with sufficient width and height
properties (using the
[Provided-Capability](Provided-Capability "wikilink") header).

Note that `Require-Capability` can be seen as a generalisation of both
importing packages with [Import-Package](Import-Package "wikilink") and
requiring bundles with [Require-Bundle](Require-Bundle "wikilink"). That
is, both [Import-Package](Import-Package "wikilink") and
[Require-Bundle](Require-Bundle "wikilink") can be translated directly
into `Require-Capability` headers.

See also [Provided-Capability](Provided-Capability "wikilink").

**NB** This header was introduced in OSGi [Release
4.3](Release 4.3 "wikilink") and will be ignored by frameworks that
comply with earlier releases.

[Category:Manifest Header](Category:Manifest Header "wikilink")

