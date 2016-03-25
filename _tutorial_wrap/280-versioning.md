---
title: Versioning the Packages 
summary: The hard part, what versions should the exported packages have?  
layout: tutorial
lnext: 290-contracts
lprev: 270-private-references
---

So far we've ignored the nasty concept of _versions_. We were forced to export a lot of packages that are not [semanticaly versioned]. By default, bnd gives these packages the version of their bundle, which is an awful defaultbut we don't know any better. In our example, this looks like:

	Export-Package
	  org.dom4j                              {version=1.6.1, imported-as=\[1.6,2)}
	  org.dom4j.bean                         {version=1.6.1}
	  org.dom4j.datatype                     {version=1.6.1}
	  org.dom4j.dtd                          {version=1.6.1, imported-as=\[1.6,2)}
	  org.dom4j.io                           {version=1.6.1, imported-as=\[1.6,2)}
	  org.dom4j.rule                         {version=1.6.1, imported-as=\[1.6,2)}
	  org.dom4j.rule.pattern                 {version=1.6.1, imported-as=\[1.6,2)}
	  org.dom4j.swing                        {version=1.6.1}
	  org.dom4j.tree                         {version=1.6.1, imported-as=\[1.6,2)}
	  org.dom4j.util                         {version=1.6.1, imported-as=\[1.6,2)}
	  org.dom4j.xpath                        {version=1.6.1, imported-as=\[1.6,2)}
	  org.dom4j.xpp                          {version=1.6.1, imported-as=\[1.6,2)}
	  org.gjt.xpp                            {version=2.1.10, imported-as=\[2.1,3)}
	  org.relaxng.datatype                   {version=1.0.0, imported-as=\[1.0,2)}


Sadly, there is no good solution. It is one of those things where only the author can provide good semantic versions, anything someone else does will back fire one day. And this does makes sense because semantic versioning is basically a promise from the _author_ to signal the compatibility of future changes in the version number.
 
Note that version ranges cannot be added for JRE packages, e.g.
`javax.swing` or `org.xml.sax` because the Java specifications do not
define the version of any of these packages, and therefore the OSGi
framework exports them all as version 0.0.0. As an alternative, add a
`Bundle-RequiredExecutionEnvironment` header to indicate the basic Java
level required by the bundle:

    Bundle-RequiredExecutionEnvironment: J2SE-1.8

Other possible values include JavaSE-1.6, OSGi/Minimum-1.0, etc.

If we wanted to control the versions in more detail we could decorate the Export-Package header. In general you then want to use macros to specify these versions so you won't have to repeat yourself.

	version-dom4j = 1.6.1
	version-relaxng = 1.0.0
	version-gjt = 2.1.10
	Export-Package: \
			org.dom4j.*;version=${version-dom4j}, \
			org.relaxng.datatype;version=${version-relaxng}, \
			org.gjt.xpp;version=${version-gjt}

This gives us an export list of:

	Export-Package
	  org.dom4j                              {version=1.6.1, imported-as=[1.6,2)}
	  org.dom4j.bean                         {version=1.6.1}
	  org.dom4j.datatype                     {version=1.6.1}
	  org.dom4j.dtd                          {version=1.6.1, imported-as=[1.6,2)}
	  org.dom4j.io                           {version=1.6.1, imported-as=[1.6,2)}
	  org.dom4j.rule                         {version=1.6.1, imported-as=[1.6,2)}
	  org.dom4j.rule.pattern                 {version=1.6.1, imported-as=[1.6,2)}
	  org.dom4j.swing                        {version=1.6.1}
	  org.dom4j.tree                         {version=1.6.1, imported-as=[1.6,2)}
	  org.dom4j.util                         {version=1.6.1, imported-as=[1.6,2)}
	  org.dom4j.xpath                        {version=1.6.1, imported-as=[1.6,2)}
	  org.dom4j.xpp                          {version=1.6.1, imported-as=[1.6,2)}
	  org.gjt.xpp                            {version=2.1.10, imported-as=[2.1,3)}
	  org.relaxng.datatype                   {version=1.0.0, imported-as=[1.0,2)}

Whatever you do, the fact that the packages are not versioned by the author makes it a losing game. So this probably works when you use this bundle yourself but it is dangerous to publish it to the world or place it on maven central.


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