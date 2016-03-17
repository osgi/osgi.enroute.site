---
title: Main-Class
summary: Specifies a main class (non-OSGi)
---

The `Main-Class` entry in a [Manifest](Manifest "wikilink") which is
used to represent the name of a class with a
`public static void main(String[] args)` method. This header is part of
the Java JAR File specification rather than the OSGi specification, and
is typically not used by OSGi applications, which use other means of
running code at start-up such as
[Bundle-Activator](Bundle-Activator "wikilink") or
[Service-Component](Service-Component "wikilink") instead.

Note that OSGi frameworks, such as [Equinox](Equinox "wikilink") and
[Felix](Felix "wikilink") typically use a `Main-Class` to permit the JAR
to be launched via a command line, with `java -jar jarname.jar`.

[Category:Manifest Header](Category:Manifest Header "wikilink")

