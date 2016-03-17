---
title: Property Files in OSGi
summary: OSGi provides the COnfiguration Admin that is much better suited for configuring your code then property files.
---

In classic Java programs,
[properties](http://download.oracle.com/javase/6/docs/api/java/util/Properties.html)
files are a common solution for storing and maintaining configuration
data. This has some downsides in an OSGi environment:

1.  Generally, property files are stored at a pre-defined location on a
    file system. In OSGi no assumption can be made about the presence of
    a file system, let alone the availability of a specific file system
    layout.
2.  Property files need to be explicitly read and watched for changes to
    see whether configuration changes occur in real time. In practice
    this means that property files are normally read once and
    configuration changes at run-time are disregarded.

In practice the first issue is generally worked around by including the
property file in the [ bundle](Bundle "wikilink") or a [
fragment](Fragment "wikilink") attached to the bundle. This however
requires a new (version of) a bundle to be installed in the [
framework](Framework "wikilink") when the configuration changes.
Furthermore, it doesn't solve the second issue (which cannot be solved
given the properties solution).

Therefore, consider using the [ configuration
admin](Configuration_Admin "wikilink") service for configuration
purposes. Reasonable defaults can still be provided via property files
in the absence of a configuration admin service in the framework.

[Category:Best Practices](Category:Best Practices "wikilink")

