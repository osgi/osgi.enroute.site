---
title: Conclusion 
summary: Show the final bnd.bnd file  
layout: tutorial
lnext: 050-start
lprev: 320-readme
---

You can look at the [osgi.enroute.examples.wrapping.dom4j.adapter] project for the final result. As a summary, this is the resulting bnd file:

	#
	# OSGI ENROUTE EXAMPLES WRAPPING DOM4J ADAPTER BUNDLE 
	#
	
	version-dom4j = 1.6.1
	version-relaxng = 1.0.0
	version-gjt = 2.1.10
	
	Bundle-Version:			1.6.1.${tstamp}
	Bundle-Description:		Wraps DOM4J for OSGi, including the primary dependencies
	Bundle-Copyright:		OSGi enRoute
	Bundle-Vendor:			OSGi Alliance
	
	
	Export-Package: \
				org.dom4j.*;version=${version-dom4j}, \
				org.relaxng.datatype;version=${version-relaxng}, \
				org.gjt.xpp;version=${version-gjt}
	
	Private-Package: \
		org.gjt.xpp.*
	
	Provide-Capability: \
		  osgi.contract; \
		    osgi.contract=DOM4J; \
		    uses:="${exports}"; \
		    version:List<Version>="1.0"
	
	Import-Package: \
		  com.sun.msv.datatype.*; resolution:=optional, \
		  !org.xmlpull.*, \
		  *
	
		
	-includeresource: \
			@pull-parser__pull-parser-2.1.10.jar!/PullParser*_VERSION, \
			tosc-license.txt, \
			{readme.md}
	
	-conditionalpackage: \
		  !javax.*, \
		  !org.xml.*, \
		  !org.w3c.*, \
		  !org.ietf.jgss, \
		  !org.omg.*, \
		  !com.sun.*, \
		  !org.jaxen.*, \
		  !org.xmlpull.*, '\
		  *
		
	-buildpath: \
		org.jvnet.hudson.dom4j__dom4j;version=1.6.1.hudson-3,\
		xmlpull__xmlpull;version=1.1.3.4d_b4_min,\
		pull-parser__pull-parser;version=2.1.10,\
		jaxen;version=1.1.6, \
		net.java.dev.msv.core;version=2013.6.1,\
		net.java.dev.msv.xsdlib;version=2013.6.1,\
		relaxngDatatype__relaxngDatatype;version=20020414.0
		
	-testpath: \
		osgi.enroute.junit.wrapper;version=4.12

With OSGi enRoute, you automatically get the Gradle build. However, notice that this file can easily be used in a Maven build with a few adaptations.  

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
