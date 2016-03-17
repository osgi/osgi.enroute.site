---
title: Declarative Services (DS)
summary: The OSGi Component System
---

**Declarative Services** (DS) is a [component
model](:Category:Component_Models "wikilink") that simplifies the
creation of components that publish and/or reference OSGi
[Services](Service "wikilink"). It was first defined in OSGi [Release
4.0](Release 4.0 "wikilink") and is inspired by an earlier model known
as *service binder* by Richard Hall and Humberto Cervantes.

Features
--------

[Declarative](#Declaration_Format "wikilink")  
no need to write explicit code to
[publish](#Providing_Services "wikilink") or
[consume](#Referencing_Services "wikilink") services.

[Lazy](#Laziness "wikilink")  
components that publish services are *delayed*, meaning that the service
implementation class is not loaded or instantiated until the service is
actually requested by a client.

[Lifecycle](#Lifecycle "wikilink")  
components have their own lifecycle (i.e. activation and deactivation),
bounded by the lifecycle of the bundle in which they are defined.

[Configuration](#Configuration "wikilink")  
components can automatically receive configuration data from
[Configuration Admin](Configuration Admin "wikilink").

Declaration Format
------------------

The declarations defined by the specification are in XML format, for
example:

``  
`<component name="mycomponent">`  
`    <implementation class="org.example.MyComponent"/>`  
`    <service>`  
`        <provide interface="org.example.api.MyService"/>`  
`    </service>`  
`</component>`

Tools have taken diverging approaches to the creation of this file, in a
[similar fashion](Tooling_Approaches "wikilink") to the creation of the
OSGi manifest itself: some tools (e.g. Eclipse [PDE](PDE "wikilink"))
encourage direct editing of the XML, with GUI assistance, whereas other
tools (e.g. [bnd](bnd "wikilink"), [Bndtools](Bndtools "wikilink"),
[Maven SCR Plugin](Maven SCR Plugin "wikilink")) generate this file from
Java annotations in the component source code.

A minimal component is a simple POJO such as the following:

``  
`package org.example.ds;`  
``  
`public class HelloComponent {`  
`}`

This can be declared as a component using the following XML:

``  
`<component>`  
`    <implementation class="org.example.ds.HelloComponent"/>`  
`</component>`

... which must be referenced as follows from `META-INF/MANIFEST.MF`
(assuming that the above XML is contained in the bundle as
`OSGI-INF/hellocomponent.xml`):

``  
`Service-Component: OSGI-INF/hellocomponent.xml`

Alternatively using [bnd](bnd "wikilink") annotations we can write the
class as follows:

``  
`package org.example.ds;`  
``  
`import aQute.bnd.annotation.component.*;`  
``  
`@Component`  
`public class HelloComponent {`  
`}`

... and include the following instruction in our bnd descriptor:
`Service-Component: *`. This will cause bnd to discover all classes
declared as components (using the `@Component` annotation) and generate
XML descriptors for them when building the bundle.

Providing Services
------------------

A component provides a service by implementing its interface:

``  
`public class HelloComponent implements org.example.api.MyService {`  
`}`

Then the `service` element must be added to the XML descriptor:

``  
`<component name="mycomponent">`  
`    <implementation class="org.example.ds.HelloComponent"/>`  
`    <service>`  
`        <provide interface="org.example.api.MyService"/>`  
`    </service>`  
`</component>`

If using bnd annotations, there is no need to explicitly declare the
services: a component will be published under all of the interfaces it
directly implements (though this is a default that may be overridden).

Laziness
--------

When a component provides a service, as in the previous section, the
activation of the component instance is *delayed*. This means that the
service entry is published in the service registry, and visibile to
potential consumers, **but** the component itself is not created or
activated until a consumer actually tries to consume the service. The
OSGi framework can even avoid loading any classes or creating a class
loader for the bundle that contains the component.

This is a very important optimisation in applications that contain many
bundles, since it avoids loading classes and allocating resources that
are not actually needed.

However, the declarative services runtime only considers bundles that
are ACTIVE or STARTING; therefore our bundle must be started for it to
be used. If our bundle contained a
[Bundle-Activator](Bundle-Activator "wikilink") then this would normally
force the OSGi framework to create a class loader to load and invoke the
activator.

The simplest solution is therefore to avoid using a
[Bundle-Activator](Bundle-Activator "wikilink") in any bundle that uses
Declarative Services. This is not a great loss since a Declarative
Services component can do anything that a
[Bundle-Activator](Bundle-Activator "wikilink") can do.

In situations where a [Bundle-Activator](Bundle-Activator "wikilink")
cannot be avoided — for example as a result of legacy migration issues —
then the lazy [Bundle Activation
Policy](Bundle Activation Policy "wikilink") can be used.

Referencing Services
--------------------

Lifecycle
---------

### Service Factories

Using services with the basic OSGi API supports creating a customized
service per bundle. In such a case, one should register a Service
Factory object. This feature is also supported in DS but works
differently. Instead of mucking implementing the OSGi ServiceFactory
interface (and making your code a no-POJO) DS will just instantiate the
component instance for each time the service is gotten by a bundle. That
is, DS registers a Service Factory and you do not have to worry about
it. The only thing you have to do is to set the servicefactory=true in
the XML or in the Component annotation. For example, the following
component will print out the bundle that got that Xyz Service:

`@Component(servicefactory=true) `  
`public class MyServiceFactory implements XyzService {`  
``  
`   ...`  
`   @Activate`  
`   void activate(ComponentContext ctx) {`  
`      System.out.println("Using bundle: " + ctx.getUsingBundle());`  
`   }`  
`}`

The advantage of the servicefactory feature is that your instance is
automatically cleaned up when a bundle that uses your code is stopped or
ungets your service. The instance can therefore minimize its worries
about cleanup as instances are not shared between bundles. As there can
be several instances for this component there is often a need to
establish communications between the different instances. Unfortunately,
this often requires use of statics. This is ok but make sure that the
classes of these classes with statics are not exported or you might end
up in problems since then other parties could create instances in
different frameworks.

An example project can be found at
[<https://github.com/bnd/aQute/tree/master/aQute.servicefactory>](https://github.com/bnd/aQute/tree/master/aQute.servicefactory).

Configuration
-------------

Runtime
-------

DS is supported by a runtime bundle known as the Service Component
Runtime (SCR). The SCR is an example of the [Extender
Pattern](Extender Pattern "wikilink"). Note that:

-   A DS-based bundle will usually do nothing at all if there is no
    active SCR bundle.
-   It is generally an error to have more than one SCR bundle active.

Implementations of SCR exist for all of the major OSGi framework
implementations, and each can usually be used across other OSGi
implementations (e.g., the [Felix](Felix "wikilink") SCR can run on
[Equinox](Equinox "wikilink")).

Component Factories
-------------------

there are few patterns for DS - based component factories;

-   [Configuration Admin](Configuration Admin "wikilink") driven, with
    persistence
-   [Component Factory](Component Factory "wikilink") driven

### ConfigurationAdmin - Driven

with this approach, you control DS component life cycle via
[Configuration
Admin](http://www.osgi.org/javadoc/r4v42/org/osgi/service/cm/ConfigurationAdmin.html)
configuration entries management;

additionally, please note that all component properties are persisted
and will be available to the component even after framework restart;

3 distinct DS component life cycles are available:

-   singleton - updatable
-   singleton - complete
-   multiton

#### Singleton - Updatable

here your DS component has life independent of config admin entry, and
config entry can be used to inject new component properties;

first, you declare a "normal" DS component, and treat it as a
[singleton](http://en.wikipedia.org/wiki/Singleton_pattern)

  

``  
`@Component(name = SingletonComponent1.NAME) `  
`public class SingletonComponent1 implements ServiceABC {`  
`   public final static String NAME = "SINGLE-ONE";`  
`   @Activate`  
`   void activate(ComponentContext ctx) {}`  
`   @Modified`  
`   void modified(ComponentContext ctx) {}`  
`   @Deactivate`  
`   void deactivate(ComponentContext ctx) {}`  
`}`  
` `

and then receive [@Modified](@Modified "wikilink") invocation on config
entry
[update](http://www.osgi.org/javadoc/r4v42/org/osgi/service/cm/Configuration.html#update(java.util.Dictionary))

``  
``  
`   // note that "component.name" means "service.pid"`  
`   String instancePid = SingletonComponent1.NAME;`  
``  
`   configAdmin.getConfiguration(instancePid).update(properties);`  
``  
` `

#### Singleton - Complete

in this case, DS
[singleton](http://en.wikipedia.org/wiki/Singleton_pattern) and config
admin entry life cycle are tied one-to-one via
[ConfigurationPolicy](ConfigurationPolicy "wikilink") attribute:

``  
`@Component(name = SingletonComponent2.NAME, configurationPolicy = ConfigurationPolicy.REQUIRE) `  
`public class SingletonComponent2 implements ServiceABC {`  
`   public final static String NAME = "SINGLE-TWO";`  
`   @Activate`  
`   void activate(ComponentContext ctx) {}`  
`   @Modified`  
`   void modified(ComponentContext ctx) {}`  
`   @Deactivate`  
`   void deactivate(ComponentContext ctx) {}`  
`}`  
` `

and then control complete DS component life cycle via corresponding
config admin entry:

``  
``  
`   // note that "component.name" means "service.pid"`  
`   String instancePid = SingletonComponent2.NAME;`  
``  
`   // first update() invocation will make a new component instance and invoke @Activate`  
`   configAdmin.getConfiguration(instancePid).update(properties);`  
``  
`   // following update() invocations will find existing instance and invoke @Modified`  
`   configAdmin.getConfiguration(instancePid).update(properties);`  
``  
`   // finally, delete() will invoke @Deactivate and then destroy your component`  
`   configAdmin.getConfiguration(instancePid).delete();`  
``  
` `

#### Multiton

pay attention: similar syntax results in totally different semantics;

in this case, DS
[multiton](http://en.wikipedia.org/wiki/Multiton_pattern) and config
admin entry life cycle are tied one-to-one via
[ConfigurationPolicy](ConfigurationPolicy "wikilink") attribute,

``  
`@Component(name = MultitonComponent.NAME, configurationPolicy = ConfigurationPolicy.REQUIRE) `  
`public class SingletonComponent2 implements ServiceABC {`  
`   public final static String NAME = "MULTIPLE";`  
`   @Activate`  
`   void activate(ComponentContext ctx) {}`  
`   @Modified`  
`   void modified(ComponentContext ctx) {}`  
`   @Deactivate`  
`   void deactivate(ComponentContext ctx) {}`  
`}`  
` `

but now you control creation of multiple instances (
[multitons](http://en.wikipedia.org/wiki/Multiton_pattern) ):

``  
``  
`   // note that "component.name" now means "factory.pid"`  
`   String factoryPid = MultitonComponent.NAME;`  
``  
`   // first, create () invocation will make a new component instance and invoke @Activate`  
`   String instancePid = configAdmin.createFactoryConfiguration(factoryPid, null).getPid();`  
``  
`   // following update() invocations will find existing instance and invoke @Modified`  
`   configAdmin.getConfiguration(instancePid).update(properties);`  
``  
`   // finally, delete() will invoke @Deactivate and then destroy your component`  
`   configAdmin.getConfiguration(instancePid).delete();`  
``  
` `

### ComponentFactory - Driven

with this approach, you control DS component life cycle via [Component
Factory](http://www.osgi.org/javadoc/r4v42/org/osgi/service/component/ComponentFactory.html)
instance management

only 1 life cycles are available:

#### Life Cycle

TODO ![](ds.png "fig:ds.png")

#### Examples

The following simple HelloWorld DS example
(https://github.com/paremus/examples/tree/master/helloworld) demonstrate
the use of DS with the OSGi ConfigAdmin Service is with Nimble and
Paremus Service Fabric: the example also contains a BluePrint variant.

Newly made DS component instances are created synchronously, but you
still need to collect and manage and use them somehow. The following
examples may help explain these capabilities. [example
project](https://github.com/carrot-garden/carrot-osgi/tree/master/carrot-osgi-scr-factory-ds)

[Declarative Service with
Karaf](http://sully6768.blogspot.com/2012/09/scr-components-with-karaf.html)
is a multi-part series regarding annotated Declarative Service starting
with basic examples moving all the way to Component Factories.

[Category:Component Models](Category:Component Models "wikilink")
<Category:Service>

