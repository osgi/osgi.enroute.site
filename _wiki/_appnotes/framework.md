---
title: Interactions with the OSGi Framework
summary: Best practices for interacting with the OSGi Framework
---

This Application node discusses some tips and best practices in using the OSGi framework.

## System Bundle

The **system bundle** is a special bundle that represents the OSGi
framework itself, from within that framework. It has the following
roles:

-   Exports packages from the JRE
    ([excluding](Boot Delegation "wikilink") `java.*`), for example
    `javax.swing`, `org.w3c.com` etc.
-   Exports the OSGi framework packages such as `org.osgi.framework`.
-   Stopping the system bundle has the effect of shutting down the OSGi
    framework.
-   Updating the system bundle has the effect of restarting the OSGi
    framework (requires support from the launcher).

The system bundle always has a bundle id of 0 (zero), so in code we can
safely obtain a reference to it as follows:

``  
`Bundle systemBundle = context.getBundle(0);`

### Symbolic Name

The [Bundle Symbolic Name](Bundle Symbolic Name "wikilink") of the
system bundle depends on the specific framework we are running, but it
has an *alias* that is always `system.bundle`. This can be used to refer
to it from the manifest of another bundle, for example:

-   `Require-Bundle: system.bundle` imports all of the packages exported
    by the system bundle
-   `Fragment-Host: system.bundle` defines a fragment of the system
    bundle.

Using this alias is usually preferable since we can avoid depending on a
specific framework implementation.


## Return quickly** from framework callback methods

When the framework calls into your bundle, it is doing so because
another bundle changed the state of the OSGi world... for example, it
registered a service. The other bundle does *not* expect the
`registerService` method to take 10 seconds because *you* decided to
perform blocking I/O or an expensive computation!

Remember that when you are in a callback method, you are literally
borrowing somebody else's thread, and you should give it back to them as
soon as possible. This is especially true in the
`BundleActivator.start()` method. This method is often called during the
startup of the system, and if there are many bundles then the start
methods will typically be invoked serially (though it depends on the
launcher). If your `BundleActivator.start()` method takes a long time,
it will directly affect the perceived start-up time of the whole
application.

If you need to perform a slow operation from a callback, either start a
thread or submit a job to an `Executor` service.

