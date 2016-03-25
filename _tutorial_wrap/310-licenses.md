---
title: Licenses 
summary: Wrapping creates a copy of other peoples work, we need to take a look at how to attribute their work.  
layout: tutorial
lnext: 320-readme
lprev: 300-serviceloader
---

We've copied someone else's byte codes ... This puts an obligation on you to obey their license(s).We should add a `Bundle-License` header to the manifest. 

The primary license is of course DOM4J. This took some effort but they use a [BSD style license]. 
The following licenses were found:

* `dom4j` – A [BSD style license]
* `relaxng` – A BSD license with an exception for the `org.relaxng.datatype.helpers.DatatypeLibraryLoader`
* `pull-parser` – [Indiana University License](http://www.extreme.indiana.edu/xgws/xsoap/xpp/download/PullParser2/LICENSE.txt)

The format of the Bundle-License header is:

	Bundle-License ::= '<<EXTERNAL>>' | ( license ( ',' license ) * ) 
	license        ::= name ( ';' license-attr ) *
	license-attr   ::= description | link
	description    ::= 'description' '=' string
	link           ::= 'link' '=' <url> 


We therefore should add a license like:

	Bundle-License: \
		https://opensource.org/licenses/BSD-2-Clause; \
			description='For DOM4J and relax NG'; \
			link='', \
		http://www.extreme.indiana.edu/xgws/xsoap/xpp/download/PullParser2/LICENSE.txt; \
			description='Pull Parser'; \
			link='http://www.extreme.indiana.edu/xgws/xsoap/xpp/download/PullParser2/LICENSE.txt', \
		'Thai Open Software Center'; \
			description='Exception for relaxng'; \
			link='tosc-license.txt'
			
Since we refer to the local file `tosc-license.txt` we need to copy this on the file system and then include it in the bundle:

	-includeresource: \
		@pull-parser__pull-parser-2.1.10.jar!/PullParser*_VERSION, \
		@pull-parser__pull-parser-2.1.10.jar!/META-INF/services/*, \
		tosc-license.txt

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