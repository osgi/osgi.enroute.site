---
title: Dynamic References 
summary: The code can depend on other code but this is not detected by the analysis
layout: tutorial
lnext: 250-resources
lprev: 230-extra-packages
---

## Dynamic References

Bnd discovers package dependencies in a bundle by scanning the bytecode
of the compiled Java files. This process finds all of the static
dependencies of the Java code, but it does not discover dynamic
dependencies, for example those arising from the use of
`Class.forName()`. There is no generic way for Bnd to calculate all
dynamic dependencies. However there are certain well-known configuration
formats that result in dynamic dependencies, and Bnd can analyse these
formats through the use of plugins.

For example, some bundles use the Spring Framework for dependency
injection. Spring uses XML files that refer to fully qualified Java
class names:

    <bean id="myBean" class="org.example.beans.MyBean">
    </bean>

Here the `org.example.beans` package is a dependency of the bundle that
should be added to `Import-Package`. Bnd can discover this dependency by
adding a Spring analyser plugin via a declaration in the descriptor
file:

    -plugin: aQute.lib.spring.SpringComponent

Similar plugins exist for JPA and Hibernate, and custom plugins can be
written to support other configuration formats or scripting languages.

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