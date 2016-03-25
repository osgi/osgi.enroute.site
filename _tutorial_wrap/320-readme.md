---
title: README 
summary: Be a good citizen and add  a README to your bundle so other people don't have to guess  
layout: tutorial
lnext: 400-conclusion
lprev: 310-licenses
---

We know, documenting is a pita ... However, you do appreciate it yourself when you don't have to guess yourself what a bundle does so why no spend 5 mins providing some proper documentation?

In each OSGi enRoute project you will find a `readme.md` file. It is strongly suggested that you edit this file and include it in the `-includeresource` instruction. An option of this instruction allows you to process any bnd macros. So lets add the following description in `readme.md`:

	# OSGI ENROUTE EXAMPLES WRAPPING DOM4J ADAPTER
	
	${Bundle-Description}

	This bundle was constructed from the following JARs:
	
		${-buildpath}
		
	Exports are: ${exports}
	
	You can find this project on https://github.com/osgi/osgi.enroute.examples/${p}
	
	This bundle is version ${versionmask;===;${Bundle-Version}} and was build on ${tstamp}
	
	

To pre-process this file for macros, add curly braces ('{' and '}') around the resource.

	-includeresource: \
		@pull-parser__pull-parser-2.1.10.jar!/PullParser*_VERSION, \
		@pull-parser__pull-parser-2.1.10.jar!/META-INF/services/*, \
		tosc-license.txt, \
		{readme.md}


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