---
title: Service Loader Services Integration 
summary: ADVANCED. The Java Service Loader uses a file in META-INF/services to load an implementation by its implemented interface. This requires some extra work in OSGi.  
layout: tutorial
lnext: 310-licenses
lprev: 290-contracts
---

This is an advanced subject.
{: .note }

Several bundles support the Java VM's _Service Loader_ services. These services have a magic file in `META-INF/services` with the name of an interface. If the Service Loader wants to load a service for an interface it looks in the magic directory for files with the interface's name. It then reads the contents and loads the class with the name in that file. For example, `pull-parser__pull-parser-2.1.10.jar` contains the file `META-INF/services/org.gjt.xpp.XmlPullParserFactory`. The contents of this file is `org.gjt.xpp.impl.PullParserFactoryFullImpl`. Using the Service Loader to get a class that implements the `org.gjt.xpp.XmlPullParserFactory` interface will get you the  `org.gjt.xpp.impl.PullParserFactoryFullImpl` class.

So let's first add this Service Loader services file to the bundle:


	-includeresource: \
		@pull-parser__pull-parser-2.1.10.jar!/PullParser*_VERSION, \
		@pull-parser__pull-parser-2.1.10.jar!/META-INF/services/*

In OSGi the Service Loader does not work because the class loader has no visibility inside your bundle. (That is the whole idea behind modularity!) However, in [133 Service Loader Mediator Specification] the OSGi specifies a service that can register these Service Loader services as ordinary OSGi services. 

There are different options, read the specification to see what you can do. According to the specification we must _advertise_ the Service Loader service and then require the `osgi.serviceloader.registrar` extender. Again, it is useful to read the [133 Service Loader Mediator Specification] or the specification.

	Provide-Capability: \
		osgi.serviceloader; \
            osgi.serviceloader=org.gjt.xpp.XmlPullParserFactory

This will make the Service Loader service available to Service Loader _consumers_ but it will not do anything unless there is a _registrar_ present. So we need to add a requirement for the OSGi extender `osgi.serviceloader.registrar`:

	Require-Capability: \
		osgi.extender; \
        filter:="(&(osgi.extender=osgi.serviceloader.registrar)"



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