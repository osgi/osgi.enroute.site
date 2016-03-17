---
title: Split Packages
summary: Describing the anti-pattern of split packages and what to do against them 
---

A split packages is caused where two or more bundles export the same
package name and version, usually with different contents. For example,
two JARs that each contain a subset of the classes comprising a whole
package.

Split packages are a problem for the Java Virtual Machine because the
"default" access level for a class, method or field depends on
membership of the same **runtime** package (a runtime package is a Java
package as loaded by a particular class loader). Therefore if we split a
package across multiple JARs and load those JARs in different class
loaders, the JVM can throw IllegalAccessErrors even when accessing
resources that have the same package name. The javac compiler cannot
catch such problems because it has no idea of the runtime class loading
architecture.

In OSGi, a package is the primary unit of sharing between modules, and
therefore a package must be coherent. When a package is imported by a
bundle, **exactly one** exporter of that package is chosen, so if a
package is split across multiple bundles then an importer will only ever
see a subset of the package. As a result, it is a [Best
Practice](:Category:Best Practices "wikilink") to [Avoid Split
Packages](Avoid Split Packages "wikilink").

Note that using [Require-Bundle](Require-Bundle "wikilink") does allow a
bundle to aggregate all the parts of a split package, by depending on
bundles by their bundle symbolic name rather than by their exports.
However, using Require-Bundle is *also* considered to be [against best
practice](Use Import-Package instead of Require-Bundle "wikilink") and
it does not solve any of the other major issues with split packages.

However, if you are dealing with legacy code and cannot avoid split
packages, you can use the following to "combine" the split package
together for bundles which wish to import the combined package. Bundle b
and c export portions of the split package.

`Bundle-SymbolicName: b`  
`Export-Package: com.company.util;b=split;mandatory:=b`

`Bundle-SymbolicName: c`  
`Export-Package: com.company.util;c=split;mandatory:=c`

Bundle a requires both bundles b and c which combines the package and
then exports the combined package. Other bundles which import the
package will wire to bundle a since they do not (and should not) have
the mandatory attributes on their import.

`Bundle-SymbolicName: a`  
`Require-Bundle: b, c`  
`Export-Package: com.company.util`

