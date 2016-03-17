---
title: Bundle-Activator
summary: Specify code to run when bundle is activated
---

`Bundle-Activator` is a [Manifest Header](Manifest Header "wikilink")
which specifies a class, implementing the
`org.osgi.framework.BundleActivator` interface, which will be called at
bundle activation time and deactivation time.

`Bundle-Activator: com.example.MyActivator`

`package com.example;`  
`public class MyActivator implements org.osgi.framework.BundleActivator {`  
`  public void start(org.osgi.framework.BundleContext context) throws Exception {`  
`    // do something at startup`  
`  }`  
`  public void stop(org.osgi.framework.BundleContext context) throws Exception {`  
`  }`  
`}`

Often, the start method is the only way to get hold of an instance of
`org.osgi.framework.BundleContext`, which is then used to find other
services (and thus interact with the remainder of the framework).

Notes
-----

-   The Bundle Activator was part of the original design. However it is
    a bit flawed that there is only one per bundle, it does not take any
    dependencies into account, and it couples you to OSGi API. It is
    usually better to use [Declarative
    Services](Declarative Services "wikilink") or any of the other
    [Component Models](Component Models Overview "wikilink") to activate
    a component. This makes it easier to refactor bundles as the Bundle
    Activator has the tendency to couple different parts inside the
    bundle together.

[Activator](Category:Manifest Header "wikilink")

