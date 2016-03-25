---
title: Warning, Private References 
summary: Private references are references from an exported package to a private packages. Since they can cause grief, they need to be cleaned up.  
layout: tutorial
lnext: 280-versioning
lprev: 260-source-code
---

If you pay attention to warnings (and you should!) then you should have noticed that we're having a number of _private references_ warning. A private reference warning means that an exported package uses a type from a private package in its public API. The implication is that that API is not possible to use since the needed types are private. 

Unfortunately, many libraries are badly designed and the types referred are actually just part of a private API. It is one of the reasons why it is sometimes worth to not use external JARs.

However, in this case we need to export more packages than `org.dom4j.*`. The warnings in the `Problems` view in Eclipse provide you with the following information:

	Export org.dom4j.datatype,  has 1,  private references [org.relaxng.datatype]

This means that the `org.dom4j.datatype` uses types from `org.relaxng.datatype` in its **public** API. We will therefore have to export `org.relaxng.datatype` as well. Looking at the warnings we have the following private references

	org.relaxng.datatype
	org.gjt.xpp

You could investigate if they are really needed (they could be superpackages) for your purpose but let's add them to the exports.

	Export-Package: \
		org.dom4j.*, \
		org.relaxng.datatype, \
		org.gjt.xpp
 
In this case we were lucky, adding them to the export list gets rid of the private reference warnings.

[DOM4J]: http://jpm4j.org/#!/p/org.jdom/jdom
[JPM4J]: http://jpm4j.org/
[-conditionalpackage]: http://bnd.bndtools.org/instructions/conditionalpackage.html
[blog]: http://njbartlett.name/2014/05/26/static-linking.html
[133 Service Loader Mediator Specification]: http://blog.osgi.org/2013/02/javautilserviceloader-in-osgi.html
[semanticaly versioned]: http://bnd.bndtools.org/chapters/170-versioning.html 
[135.3 osgi.contract Namespace]: http://blog.osgi.org/2013/08/osgi-contracts-wonkish.html
[BSD style license]: http://dom4j.sourceforge.net/dom4j-1.6.1/license.html
[supernodes of small worlds]: https://en.wikipedia.org/wiki/Small-world_network
[OSGiSemVer]: https://www.osgi.org/wp-content/uploads/SemanticVersioning.pdf
[osgi.enroute.examples.wrapping.dom4j.adapter]: https://github.com/osgi/osgi.enroute.examples/osgi.enroute.examples.wrapping.dom4j.adapter
