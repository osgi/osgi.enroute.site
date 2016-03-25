---
title: Adding Source Code 
summary: OSGi Bundles can contain the source code in OSGI-OPT/src, this is recognized by IDEs during debugging  
layout: tutorial
lnext: 270-private-references
lprev: 250-resources
---

One of the nifty features of bundles is that they can carry their own sources. This feature is recognized by the better IDEs on the market. Having the source code in the IDE makes debugging a lot more friendly. However, in the Maven world (where most JPM4J dependencies come from) sources are in a separate JAR. We can ask JPM4J to create a combined JAR.

If you go to the Bndtools Repository view and select the `org.jvnet.hudson.dom4j__dom4j` entry for version is `1.6.1.hudson-3` then you can call up a menu on that entry. The menu contains an entry to `Add Sources` if the repository has source code for that artifact. This can take a few seconds because the sources must be downloaded.

Once a bundle has source code, bnd will automatically also copy that source code when it copies a package. you can disable the source code with:

	-sources: false

This can be useful for proprietary code. Otherwise, always try to include the source code because it is a small overhead on disk and it is wonderful when you need it and it is already there.

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