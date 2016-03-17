---
title: Bundle-NativeCode
summary: Specifies the native code properties embedded in this bundle
---

The `Bundle-NativeCode` contains information about native libraries that
should be loaded by this bundle. The native libraries can be restricted
by `osname` as well as `osversion` and `processor` if needed, although a
`selection-filter` can apply any LDAP query to restrict it even further.

`Bundle-NativeCode:`  
` lib/foo32.dll;osname=WindowsNT;osname=WindowsXP;osname=WindowsVista;processor=x86,`  
` lib/foo64.dll;osname=WindowsNT;osname=WindowsXP;osname=WindowsVista;processor=x86_64`

[NativeCode](Category:Manifest Header "wikilink")

