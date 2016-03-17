---
title: Class Loader Hacks
summary: Class loader hacks is a general term for a collection of erroneous patterns that arise from interacting with class loaders without taking account of modularity.
---

"Class loader hacks" is a general term for a collection of erroneous
patterns that arise from interacting with class loaders without taking
account of modularity.

Most libraries and applications should never deal directly with Java
class loaders. It is generally only necessary to use class loaders in
libraries that can be extended with user-written or 3rd-party code, and
in OSGi such patterns are better replaced with
services.

Example Problem
---------------

For example, suppose a web framework requires the application to supply
an object that is capable of rendering pages. It may do this by defining
an interface `IPageRenderer`, reading the name of a class from a
configuration file supplied by the application, instantiating that class
and and finally invoking the new object. For example:


	Properties props = new Properties();  
	props.load(configFile);  
	String className = props.get("rendererClassName");  
	Class<?> rendererClass = Class.forName(className);  
	IPageRenderer renderer = rendererClass.newInstance();  
	renderer.renderPage(inputData);

Aside from its complete lack of error handling, this example code
exhibits a number of bad features, as listed below.

### Assumption of Global Class Visibility

The above example code uses `Class.forName()`, which works by asking the
classloader of the *calling class* to lookup the request class name. In
a classpath-based Java runtime this works (so long as the provider of
the class is actually present on the classpath), since classes are
arranged in a single flat list, and any class can be seen by any other
class (assuming it has not been shadowed by another class with the same
name earlier in the list, and it is the correct version, etc).

In **any** modular system -- including but **not limited to OSGi** --
global visibility can no longer be assumed. The identity of a class
consists of both its fully qualified name **and** its owning module.
Therefore, code which tries to find a class by name alone will
necessarily fail: in this case a `ClassNotFoundException` will probably
be thrown.

### Caching Problems with Class.forName()

TODO

Solutions
---------

### OSGi Services

By far the best solution to the problem posed by the example code is to
use an OSGi service. Treat `IPageRenderer` as a service contract and
allow renderer providers to register instances as services. The web
framework can then used dependency injection (with the help of a
[Component Model]) to obtain
instances. The framework now requires no visibility of concrete renderer
classes, and providers can keep their internals completely hidden.

In applications where OSGi is not used, consider using
[PojoSR] to provide the same service-oriented
functionality.

### Specifying the Object, Class or Classloader

Unfortunately many libraries are required to work in both OSGi and
non-OSGi environments, where even the availability of
[PojoSR] cannot be relied upon. In such cases we
could change the API in one of the following ways:

-   Allow clients to pass an instance of `IPageRenderer` directly into
    the framework via a method parameter.
-   Allow clients to pass a `Class` object, via a method parameter, to
    avoid the need to lookup the class by name.
-   Allow clients to pass a `ClassLoader` that the framework should use
    when it performs its lookup by name.

The third of these solutions is usually the "lightest" in terms of
changes to the original code, and it allows OSGi-based clients to pass
in their own classloader that presumably has visibility of the desired
class.

Other Options
-------------

In cases where the framework code assumes global class visibility and
cannot be changed in any of the ways suggested above (e.g. because it is
a closed-source 3rd party dependency) then further workarounds do exist.

DynamicImport-Package is sometimes added to the manifest header of the offending framework bundle. However this is extremely loose and may lead to unintended side-effects.

It is also possible to use a [Fragment](Fragments "wikilink") to add to
the set of imported packages of the offending bundle.

[PojoSR]: http://repo1.maven.org/maven2/com/googlecode/pojosr/de.kalpatec.pojosr.framework/
[Component Model]: component-models.html