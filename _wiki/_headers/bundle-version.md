---
title: Bundle-Version
summary: Specifies the bundle's version
---

The `Bundle-Version` specifies the version of this bundle, in
<i>major</i>.<i>minor</i>.<i>micro</i>.<i>qualifier</i> format. The
default, if not specified, is assumed to be 0.0.0. Major, minor and
micro are numeric fields (and sorted as such) whilst the qualifier can
be any string, sorted lexicographically. Unlike Maven, the empty
qualifier is considered the lowest possible value (Maven considers a
missing qualifier to be the highest possible value).

`Bundle-Version: 1.2.3.four`

[Version](Category:Manifest Header "wikilink")

