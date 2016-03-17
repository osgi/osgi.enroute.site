---
title: Bundle-ActivationPolicy
summary: Define how & when a bundle should be activated
---

The `Bundle-ActivationPolicy` is a marker to tell the OSGi runtime
whether this bundle should be activated (i.e. run its
[Bundle-Activator](Bundle-Activator "wikilink")). Currently, the only
supported value for this is `lazy`, which means that once the bundle is
to be started, it does not invoke the
[Bundle-Activator](Bundle-Activator "wikilink")'s `start()` method until
the first access of a class is received.

This can improve performance in a system with many bundles, where
instead of starting them they may be placed into a lazy state, and only
activated when they are actually used. It is not suitable for bundles
which need to register services programmatically in the `start()` method
of the [Bundle-Activator](Bundle-Activator "wikilink"); though if
another service is registering the components (such as [Declarative
Services](Declarative Services "wikilink") or
[Blueprint](Blueprint "wikilink")) then the lazy policy may be
beneficial.

`Bundle-ActivationPolicy: lazy`

[ActivationPolicy](Category:Manifest Header "wikilink")

