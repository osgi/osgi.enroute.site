---
title: The Manifest
summary: A short description of the manifest rules
---

A JAR's Manifest is a `META-INF/MANIFEST.MF` file, which contains
meta-information about a JAR. These have been standardised since the
beginning of Java, but there are some peculiar quirks to be aware of:

-   Max line length is 72 characters
-   Character set is ASCII
-   Whitespace at start and end of the value is trimmed
-   Continuations from previous lines start with a space

The headers form Key:Value pairs, and are grouped in *sections*. The
first is called the *main section* and it is this which typically
contains the OSGi related headers. If a JAR is signed, then there will
be one section per resource (with a Name header) and often hashes of
those contents as well.

`Manifest-Version: 1`  
`Created-By: A.n.other`  
`Main-Class: com.example.Foo`  
  
`Name: resource1`  
`SHA1-Digest: TKCqucfhw4nrtMc0dAxQOpNIlWE=`  
  
`Name: resource2`  
`SHA1-Digest: TK421VlIwN12llD5HsCqjs=`

Many more [manifest headers](:Category:Manifest Header "wikilink") can
be used

