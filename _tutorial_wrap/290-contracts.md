---
title: OSGi Contracts 
summary: ADVANCED. Sometimes OSGi Contracts can alleviate the versioning problem.  
layout: tutorial
lnext: 300-serviceloader
lprev: 280-versioning
---

This is an advanced subject.
{: .note }

One possibility for the versioning problem in the previous section is to use _OSGi contracts_. An OSGi contract replaces the versions on the myriad packages with a single versioned name. This was concept was developed because the versions on servlet related packages was a disaster. This is outlined in [135.3 osgi.contract Namespace].

Providing a contract is quite straightforward, you provide a capability that enumerates the packages that belong to the contract. The users of the bundle should then have a matching requireme capability. (bnd has support then to remove the versions from the package import, read [135.3 osgi.contract Namespace] for more information.)

The capability that we provide for the contract must contain the list of packages in the `uses:` directive. Fortunately, the `${exports}` macro contains the list of all our exported packages in bnd. Saves us from maintaining this list by hand. So the capability would look like: 

	Provide-Capability: \
	  ... \
	  osgi.contract; \
	    osgi.contract=DOM4J; \
	    uses:="${exports}"; \
	    version:List<Version>=1.0.0

There is a bug in the OSGi specification, it lists `version=1.0.0` but it should be `version:List<Version>=1.0.0`.
{:.bug}

The bundles that use this DOM4J contract should now have a matching require capability like:

	Require-Capability: \
	  ... \
	  osgi.contract; \
        filter:="(&(osgi.contract=DOM4J)(version=1.0))"
	-contract: DOM4J

The `-contract` instruction tells bnd to remove the versions of all packages that are part of the contract. 


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