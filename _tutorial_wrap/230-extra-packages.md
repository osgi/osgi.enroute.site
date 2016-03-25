---
title: Adding Extra Packages 
summary: Since the analysis is done by code not all packages that are required are found.
layout: tutorial
lnext: 240-dynamic-references
lprev: 225-ignoring-dependencies
---

The `-conditionalpackage` instruction has given us a nice way to ensure that we've covered all package dependencies that _are discoverable by code inspection_. However, in certain cases there are resources that must be included. Unfortunately, bnd has no knowledge of those references. It is therefore necessary to copy those resources. 

For example, when we inspect the list of included packages (you can see them with the JAR Editor) we find that for the   `pull-parser__pull-parser-2.1.10.jar` we only drag in one package `org.gjt.xpp`:

	...
	org/dom4j/xpp
	  ProxyXmlStartTag.class
	org/gjt
	org/gjt/xpp
	  XmlEndTag.class
	  XmlFormatter.class
	  XmlNode.class
	  XmlPullNode.class
	  XmlPullParser.class
	  XmlPullParserBufferControl.class
	  XmlPullParserEventPosition.class
	  XmlPullParserException.class
	  XmlPullParserFactory.class
	  XmlRecorder.class
	  XmlStartTag.class
	  XmlTag.class
	  XmlWritable.class
	org/relaxng
	org/relaxng/datatype
	...

This implies we do not carry the implementation, this is just the API. So we can add the implementation using the following instruction:

	Private-Package: org.gjt.xpp.*

If we now look in our bundle then we see:

	...
	org/dom4j/xpp
	  ProxyXmlStartTag.class
	org/gjt
	org/gjt/xpp
	  XmlEndTag.class
	  XmlFormatter.class
	  XmlNode.class
	  XmlPullNode.class
	  XmlPullParser.class
	  XmlPullParserBufferControl.class
	  XmlPullParserEventPosition.class
	  XmlPullParserException.class
	  XmlPullParserFactory.class
	  XmlRecorder.class
	  XmlStartTag.class
	  XmlTag.class
	  XmlWritable.class
	org/gjt/xpp/impl
	  PullParserFactoryFullImpl.class
	org/gjt/xpp/impl/format
	  Formatter.class
	  Recorder.class
	org/gjt/xpp/impl/node
	  EmptyEnumerator.class
	  Node.class
	  OneChildEnumerator.class
	org/gjt/xpp/impl/pullnode
	  PullNode.class
	  PullNodeEnumerator.class
	org/gjt/xpp/impl/pullparser
	  ElementContent.class
	  PullParser.class
	org/gjt/xpp/impl/tag
	  Attribute.class
	  EndTag.class
	  PullParserRuntimeException.class
	  StartTag.class
	  Tag.class
	org/gjt/xpp/impl/tokenizer
	  Tokenizer.class
	  TokenizerBufferOverflowException.class
	  TokenizerException.class
	org/relaxng
	org/relaxng/datatype
	...

It should be clear that this could add additional imports so we should verify the `Contents` tab. Fortunately in this case we add a few additional packages form the external dependency `jaxen` bundle, no problem here.

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