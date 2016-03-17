---
title: Boot Delegation Loading
summary: Issues around importing packages from the VM
---

In an ideal world, bundles would load all packages by importing them
from other bundles (i.e. using the
Import-Package header) or from their own
private contents. However there is a security restriction in Java that
states any class name starting with "`java.`" *must* be loaded from the
boot class loader. For example this includes `java.lang.Object`,
`java.lang.String`, `java.util.List` etc. Therefore OSGi always
delegates `java.*` class loading requests to the boot class loader.

All other packages should be imported with
Import-Package if they are used by a
bundle. This includes packages that are normally distributed with the
JRE, such as `javax.swing`, `javax.xml`, `org.w3c.com`, `org.ietf.jgss`
and so on. In order for those imports of JRE packages to be resolved,
the [System Bundle] exports them; this is the
case for all OSGi frameworks, including both
[Equinox] (the framework normally used to run
Eclipse) and [Felix]. The list of system bundle
exports can be extended with the
`org.osgi.framework.system.packages.extra` property.

However, there is an override mechanism called [Boot
Delegation](Boot Delegation "wikilink"), which makes all (or a subset)
of packages automatically delegated to the boot class loader before
attempting to load from imported packages or a bundle's own contents.
Specifying `org.osgi.framework.bootdelegation=*` means that OSGi
attempts to load all packages from the boot class loader. The list of
packages can also be specified as a comma-separated list. Note that
using this property is **strongly discouraged** because it leads to many
class loading errors.

For historic reasons, Equinox runs with a boot delegation set to `*`
when running as Eclipse. However, the out-of-the-box experience of
"standalone" Equinox is that same as that of Felix, in which this is not
set. So bundles running in Eclipse may gain access to `javax.swing`
where a bundle running in either Equinox or Felix OSGi runtimes would
not wire the dependencies up.

In summary: a bundle should always import the `javax.swing` package if
it uses that package; then it will work correctly on any OSGi framework.
It is bad practice to assume global visibility of any package other than
those in the `java.*` namespace.


[Felix]: http://felix.apache.org
[System Bundle]: framework.html