---
title: Fragment-Host
summary: Specifies the parent this fragment can attach to
---


Declares this bundle to be a [Fragment](Fragment "wikilink"), and
specifies which parent bundle to attach to:

`Fragment-Host: the.parent.bundle`

May also have an optional version constraint:

`Fragment-Host: the.parent.bundle;bundle-version=1.2.3`

A Bundle <em>fragment</em>, or simply a <em>fragment</em>, is a bundle
whose contents are made available to another bundle (the <em>fragment
host</em>). Importantly, fragments share the classloader of their parent
bundle. One notable difference is that fragments do not participate in
the lifecycle of the bundle, and therefore cannot have an
[Bundle-Activator](Bundle-Activator "wikilink").

A fragment is identified by the use of the
[Fragment-Host](Fragment-Host "wikilink") header:

` Fragment-Host: a.nother.bundle;bundle-version=1.2.3`

If the [Bundle-ClassPath](Bundle-ClassPath "wikilink") header is used in
the fragment's host, then it will apply to the contents in the fragment
as well. Typically the default . will therefore pick up all classes in
both the host and the fragment. Sometimes, fragments are used to 'patch'
existing bundles:

` Bundle-SymbolicName: the.host`  
` Bundle-ClassPath: patch.jar,.`

` Bundle-SymbolicName: the.host.fragment`  
` Fragment-Host: the.host`

In this scenario, the `patch.jar` is not available in the host bundle
itself, but may be supplied by the fragment. Since it is ahead of '.' it
will allow classes to be preferentially loaded from the fragment instead
of the host.


[Category:Manifest Header](Category:Manifest Header "wikilink")

