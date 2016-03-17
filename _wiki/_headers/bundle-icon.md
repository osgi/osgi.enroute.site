---
title: Bundle-Icon
summary: Specify one or more different sized icons for the bundle
---

The `Bundle-Icon` is a list of URLs which contain icons to be used as
the bundle's representation. If they are relative URLs then they refer
to content within the bundle itself; but absolute URLs (i.e. those that
refer to a URL with a protocol such as <http://>) are also permitted.

It is assumed that the icon is square, although no assumptions are made
about the supported image formats. However, it is recommended that all
frameworks support decoding PNG images so these should be preferred.
Multiple sizes of the same icon can be provided, with an optional size
attribute to denote the different (horizontal) sizes.

`Bundle-Icon: /local/icon.png`  
`Bundle-Icon: /local/icon64.png;size=64,/local/icon32.png:size=32,http://www.example.com/icon:size=512`

[Icon](Category:Manifest Header "wikilink")

