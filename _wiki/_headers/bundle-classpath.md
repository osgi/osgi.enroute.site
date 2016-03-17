---
title: Bundle-ClassPath
summary: Specify jars on the class path that come from inside the bundle
---

The `Bundle-ClassPath` specifies where to load classes from from the
bundle. In an unzipped bundle this may refer to a directory (such as
`classes` or `target/classes`). It may also refer to JARs as well (such
as `lib.jar,other.jar`). For unzipped bundles, referring to classes
within a nested JAR has no performance constraints, but when accessing
nested JARs inside JARs the OSGi runtime may have to extract the JAR
into a temporary storage area, which may take additional time.

The default is '.' which allows classes to be loaded from the root of
the bundle. For OSGi bundles which are also valid JARs this makes sense
since that will be the default behaviour of other JARs.

` Bundle-ClassPath: .`

Loading from nested JARs (whether packed or unpacked):

` Bundle-ClassPath: foo.jar,other.jar,classes`

It is generally preferable to avoid nested JARs and either
unpack-and-merge all the contents or extract them to external bundles.

[ClassPath](Category:Manifest Header "wikilink")

