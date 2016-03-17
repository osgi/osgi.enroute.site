---
title: Bundle_RequiredExecutionEnvironment
summary: Specify the library dependency on the runtime
---

Although OSGi bundles mark what packages they consume with the
[Import-Package](Import-Package "wikilink") directive, this is not
necessary for packages with the `java.` package namespace. However, not
all versions of Java are the same - for example, Java 1.1 was very
different in the core package from the Java 6 release.

As a result, there are different *execution environments* which denote a
specific set of `java.` packages. These can then be referred to, either
from the
[Bundle-RequiredExecutionEnvironment](Bundle-RequiredExecutionEnvironment "wikilink")
or (for OSGi R4.3 and above) the more generic
[Require-Capability](Require-Capability "wikilink") form.

The list of execution environments may change over time, and not all
OSGi runtimes will support all execution environments. The [OSGi
specification reference](http://www.osgi.org/Specifications/Reference)
lists a number of non-normative examples:

-   `J2SE-1.2` - Java 1.2
-   `J2SE-1.3` - Java 1.3
-   `J2SE-1.4` - Java 1.4
-   `J2SE-1.5` - Java 1.5
-   `JavaSE-1.6` - Java 6
-   `JavaSE-1.7` - Java 7
-   `OSGi/Minimum-1.1` - the minimum required for OSGi to run
-   `CDC-1.1/Foundation-1.1` - the J2ME foundation profile
-   `CDC-1.1/PersonalBasis-1.1` - the J2ME personal basis profile
-   `CDC-1.1/PersonalJava-1.1` - the J2ME personal basis profile

These may not only include which packages are in which environments, but
also what methods are available (e.g. `String.split()` appeared in Java
1.5)

`Bundle-RequiredExecutionEnvironment: OSGi/Minimum-1.1,J2SE-1.2`

