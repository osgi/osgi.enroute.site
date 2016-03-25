---
title: Strategy
summary: How do we go about wrapping a bundle? What are the forces?
layout: tutorial
lnext: 200-project
lprev: 100-shouldyou
---

Though you can simply add the manifest headers to a JAR and make it an official bundle it is recommended to take a look at its dependencies. Good bundles are _cohesive_. That is, they perform one well defined function and make that available through a minimal API. 

Their dependencies are minimal and are of the _abstraction_ type. That is, a good bundle should not depend on a library like Guava because it was convenient to use a very small set of types from this library. A dependency should be a point where the outer application can provide a specific implementation that fits its requirements. Due to the abstraction points, a bundle can then live in many different contexts.  

The strategy for good bundles is therefore to hide any implementation dependencies and only import and export API packages. Obviously, this is the goal and not always achievable. It is especially hard for JARs that are not modular, the majority.

A simple strategy would be to export all packages (Export-Package: *) and let bnd do the work. Unfortunately when wrapping third-party libraries it sometimes is not sufficient to simply accept the generated `Import-Package` statement: the result may need to be fine-tuned. This is because many third-party libraries contain dependencies that are out of place, often due to errors resulting from a lack of good modular practices.

For example:

-   Classes that implement optional features are sometimes placed into a
    library’s "core" JAR. For example the Log4J library includes
    optional "appenders" for writing log messages to emails, JMS queues
    and JMX/JDMK. As a result it depends on inter alia the javax.jms
    package, and we have to include the JMS API bundle in order for
    logging to work at all!
-   In other cases a library may contain "dead code" — i.e. code that is
    not reachable from the public API — and that code may have external
    dependencies.

Bnd detects dependencies statically by inspecting all code in the library; it cannot determine which parts of the library are reachable. For example a common error is to include JUnit test cases in a library JAR, resulting in dependencies on JUnit. Unless fixed, the bundle will only be usable in a runtime environment where JUnit is also present, i.e., we will have to ship a copy of JUnit to our end users.

In this tutorial we will follow the strategy of exporting all the packages but then carefully craft the resulting bundle based on the different problems one typically encounters wrapping bundles.

That said, the actual wrapping is contrived, it is not an actual industrial ready wrapping.

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