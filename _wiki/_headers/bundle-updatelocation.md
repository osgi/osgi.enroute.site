---
title: Bundle-UpdateLocation
summary: Specifies the bundles location for an update if different then the one installed (don't use it)
---

The `Bundle-UpdateLocation` specifies where any updates to this bundle
should be loaded from. This only makes sense for mutating bundles (e.g.
those with -SNAPSHOT) rather than milestones or other released JARs
(which are assumed to be immutable). This is typically not used in
favour of an updating agent such as [P2](P2 "wikilink") or
[OBR](OBR "wikilink"). This URL will be consulted when the user invokes
a `bundle.update()` call, such as from an interactive console. The
default value is to use the URL where the bundle was originally
installed.

`Bundle-UpdateLocation: `[`http://www.example.com/bundle.jar`](http://www.example.com/bundle.jar)

[UpdateLocation](Category:Manifest Header "wikilink")

