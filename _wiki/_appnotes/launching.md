---
title: Standard Framework Launcher
summary: Use of the standardized launcher
---

Introduction
------------

OSGi [Release 4.1](Release 4.1 "wikilink") included a standard framework
launch API, which makes it easy to write one's own launcher or embed an
OSGi framework in an application. Writing a custom launcher can be
useful when we need precise control over the initialisation properties,
bundle locations, etc. Embedding OSGi inside a larger application can be
useful for migrating legacy code to full OSGi, or running OSGi in a
legacy application server environment (e.g., J2EE).

Creating and Starting a Framework
---------------------------------

The framework launching API uses the [Java SPI](Java SPI "wikilink")
mechanism to load a "framework factory". Assuming we have an OSGi
framework on the application classpath, the following will work:

``  
`// Load a framework factory`  
`FrameworkFactory frameworkFactory = ServiceLoader.load(FrameworkFactory.class).iterator().next();`  
``  
`// Create a framework`  
`Map<String, String> config = new HashMap<String, String>();`  
`// TODO: add some config properties`  
`Framework framework = frameworkFactory.newFramework(config);`  
``  
`// Start the framework`  
`framework.start();`

We now have an OSGi framework running, but it's not very useful until we
add some bundles. Let's do that next.

Installing Bundles
------------------

The `Framework` object that was returned from `newFramework` is actually
a sub-interface of `Bundle`, from which we can get a
`[[BundleContext]]`. If you have ever written a bundle activator then
you are familiar with `BundleContext` already: it's the central point of
access to the entire OSGi API.

Let's install the Felix Shell bundles (NB these bundles work just fine
on Equinox and Knopflerfish also):

``  
`BundleContext context = framework.getBundleContext();`  
`List<Bundle> installedBundles = new LinkedList<Bundle>();`  
``  
`// Install the bundles`  
`installedBundles.add(context.installBundle("file:org.apache.felix.shell-1.4.2.jar"));`  
`installedBundles.add(context.installBundle("file:org.apache.felix.shell.tui-1.4.1.jar"));`  
``  
`// Start installed bundles`  
`for (Bundle bundle : installedBundles) {`  
`    bundle.start();`  
`}`

Note that as a general principle, when we want to install a set of
bundles we should install them all 'first' and then start them. If you
tried to install and start them individually then you would have to be
careful about ordering... much better to let the framework sort it all
out!

Also bear in mind that there is no error handling in the above code. To
improve this we should catch any exceptions on install or start, so that
we can still install/start the other bundles.

Another thing to be careful of is [fragment
bundles](fragment bundles "wikilink"). Fragments cannot be started, so
the `bundle.start()` line will throw an exception if the installed
bundle was a fragment. You may want to add the following check to avoid
those exceptions:

``  
`if (bundle.getHeaders().get(Constants.FRAGMENT_HOST) == null)`  
`    bundle.start();`

Handling Shutdown
-----------------

Once the framework is running with the bundles you want, you should just
let it run until it finishes. Usually the shutdown signal should come
from within OSGi, for example the user might type `shutdown` at the
shell. This would stop the framework, and you would normally want to do
something after this has happened.

For example, if you are writing a straightforward launcher then you
probably want to call `System.exit()` after OSGi stops. The cleanest way
to do this is as follows:

``  
`try {`  
`    framework.waitForStop(0);`  
`} finally {`  
`    System.exit(0);`  
`}`

The `waitForStop` method simply blocks the main thread until OSGi stops,
so it is the last thing we do after performing all of our initialisation
steps. We can't just allow the main thread to finish and expect the JVM
to shut down, because any of the bundles in the OSGi framework might
have started a non-daemon thread, so we need `System.exit()` in order to
actually shut down. (Note: a bundle that starts a thread 'should' stop
that thread when it stops, but our launcher cannot assume that all
bundles will be so well-behaved).

Exposing Application Packages
-----------------------------

When embedding OSGi we might want the bundles inside the OSGi framework
to have visibility of types from the parent application. The way to do
this is to expose those types as exports of the [system
bundle](system bundle "wikilink"); then the bundles that wish to see
those types can import them with `Import-Package` in the usual way.

For example suppose our parent application contains a domain model in
the package `org.example.mydomain`. This package needs to be added to
the [system bundle exports](system bundle exports "wikilink"), so go
back to the first code sample and insert the following where we had the
TODO marker:

``  
`config.put(Constants.FRAMEWORK_SYSTEMPACKAGES_EXTRA,`  
`           "org.example.mydomain;version=1.0.0");`

The bundle that uses this package should have the following in its
manifest:

``  
`Import-Package: org.example.mydomain;version="[1.0.0,2.0.0)"`

The framework will wire up this import to the export offered by the
system bundle. Note that the importing bundle doesn't care that the
package comes from the system bundle, it could just as easily import
from an ordinary bundle! This gives us the flexibility to refactor our
application. In the future we might want to do more in OSGi, so the
domain model packages would be inside an ordinary bundle in OSGi rather
than outside it.

The technique works for any package that is on the classpath of the
launcher class.

Other Configuration
-------------------

There are other configuration changes that can be made in a standard way
using the properties you pass to `newFramework`. Here are a couple of
the more useful ones:

``  
`// Control where OSGi stores its persistent data:`  
`config.put(Constants.FRAMEWORK_STORAGE, "/Users/neil/osgidata");`  
``  
`// Request OSGi to clean its storage area on startup`  
`config.put(Constants.FRAMEWORK_STORAGE_CLEAN, "true");`  
``  
`// Provide the Java 1.5 execution environment`  
`config.put(Constants.FRAMEWORK_EXECUTIONENVIRONMENT, "J2SE-1.5");`

Of course there are a few framework-specific properties as well, for
example:

``  
`// Turn on the Equinox console on port 1234 (Equinox only)`  
`config.put("osgi.console", "1234");`

Services
--------

The embedding application or launcher can both publish services and bind
to services that are published by bundles inside OSGi. For example the
following scenarios are possible:

-   When embedding OSGi inside a J2EE application server, our launcher
    code can look up EJBs from JNDI and publish them into OSGi as
    services under the appropriate "Local Home" interfaces. OSGi bundles
    can bind to those services using [Declarative
    Services](Declarative Services "wikilink"),
    [Blueprint](Blueprint "wikilink"), etc.

-   An OSGi bundle can publish a services to be consumed by the
    launcher. For example, [bnd](bnd "wikilink") uses this technique to
    execute services of type `java.lang.Runnable` using the JVM main
    thread, which is necessary for running GUI applications on Mac OS X.

When using this technique, remember that [Service
Compatibility](Service Compatibility "wikilink") demands that both the
consumer and producer load the service interface package with the same
class loader. In this scenario, either the consumer or the producer is
the system bundle, and since the system bundle cannot import packages
from ordinary bundles, all service interface APIs must be present on the
application classpath and exported from the system bundle.

[Embedding](Category:Tutorial "wikilink")

