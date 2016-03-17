---
title: Bundle-SymbolicName
summary: Identifies the bundle and its singleton status
---

The `Bundle-SymbolicName` header is used together with
[Bundle-Version](Bundle-Version "wikilink") to uniquely identify a
bundle in an OSGi runtime. Since OSGi [Release
4.0](Release 4.0 "wikilink"), `Bundle-SymbolicName` has been a mandatory
header, and it indeed it is the **only** mandatory header.

Since it is so important and frequently used, `Bundle-SymbolicName` is
often abbreviated in conversation and in writing as "BSN".

A BSN often takes the form of a reverse domain name. If automatically
generated via [Maven Bundle Plugin](Maven Bundle Plugin "wikilink"),
takes the form `${pom.groupId}.${pom.artifactId}`, or
`${pom.artifactId}` if it already starts with `${pom.groupId}`.

`Bundle-SymbolicName: com.example.acme`

This may have a [Directive](Directive "wikilink") to declare that this
bundle is a *singleton*, or that there should be only one bundle with
this name in the framework at once. This constraint may be violated if
the framework supports nested frameworks or similar support.

`Bundle-SymbolicName: com.example.acme;singleton:=true`

[SymbolicName](Category:Manifest Header "wikilink")

