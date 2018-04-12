---
title: Resolving - OSGi's Best Kept Secret?
layout: toc-guide-page
lprev: 520-bnd.html
lnext: 210-semantic_versioning.html  
summary: Resolving is one of the cornerstones of OSGi, but what actually is going on?
author: enRoute@paremus.com
sponsor: OSGi Alliance 
---

The OSGi Framework uses the Resolver to _wire_ together a given set of bundles at runtime, however what most people don't know is that the resolver can also be used to _select_ the set of required bundles that should be installed into your runtime.

## Modularity and Dependencies  

As soon as you create Modules, you create a dependency management problem.

Realising this the OSGi Alliance has evolved, through extensive experience, a generic Requirements-Capabilities [dependency management model](https://osgi.org/hudson/job/build.core/lastSuccessfulBuild/artifact/osgi.specs/generated/html/core/framework.module.html#framework.module.dependencies). 

This model consists of a small number of primitive concepts:

* **Artifact** (a.k.a _Thing_) - For OSGi the primary Artifact is the OSGi Bundle (a JAR file); but other  examples of Artefacts include software Certificates, or physical components such as a secure USB key store.

* **Environment** - The runtime Environment within which an Artefact may be installed: i.e. a physical host, a container, or an OSGi framework.

* **Resource** - A formal description of the Artifact specifying what that Artefact can contribute to the host Environment (its _Capabilities_) and what it needs from the Environment to function (its _Requirements_).

* **Namespace** Capabilities and Requirements are defined in appropriate [namespaces](https://osgi.org/specification/osgi.core/7.0.0/framework.namespaces.html); every _Requirement_ belongs to a namespace and can only require _Capabilities_ in the same namespace.

* **Capability** - Describes a feature or function of the Resource when installed in the Environment. A Capability has a _type_ (specifying namespace) and a set of key/value  _properties_. Properties are key value pairs, where the keys are strings and values can be scalars or collections of `String`, `Integer`, `Double`, and `Long`.

* **Requirement** - Specifies a Capability needed in an Environment. A Requirement consists of a type and an _OSGi filter_ expressed as an LDAP expression. A Requirement can be _mandatory_ or _optional_.

**Resolving** is then the process of constructing a complete, closed set of _Resources_ from a list of _initial Requirements_, a description of the Environment's _Capabilities_, and one or more _repositories_ with available _Resources_. Once this list of resources is known the associated artefacts can be installed. 

![image](https://user-images.githubusercontent.com/200494/31130842-cf5299d2-a858-11e7-907c-d6cb43954501.png)

### Namespaces 

The Requirements / Capabilities Namespaces currently defined are:

* [_osgi.identity_](https://osgi.org/hudson/job/build.core/lastSuccessfulBuild/artifact/osgi.specs/generated/html/core/framework.namespaces.html#i1776750) - Used to identify a resource type and  provide a unique name: e.g. for a Certificate the type could be x509 and the name could then its SHA-1 fingerprint.

* [_osgi.ee_](https://osgi.org/hudson/job/build.core/lastSuccessfulBuild/artifact/osgi.specs/generated/html/core/framework.namespaces.html#framework.namespaces.osgi.ee) - An OSGi Framework must register capabilities for all the execution environments the Java VM is known to be backward compatible with. For example, if the Java VM provides Java SE 6, then it is backward compatible with 1.2, 1.3, 1.4, 1.5, and 1.6. The osgi.ee capability defines the provided versions as a comma separated list.

* [_osgi.native_](https://osgi.org/hudson/job/build.core/lastSuccessfulBuild/artifact/osgi.specs/generated/html/core/framework.namespaces.html#framework.namespaces.osgi.native) - Used to describe the native environment in which the Framework is executing. An OSGi Framework must provide a capability in the `osgi.native` namespace that represents the native environment in which the Framework is executing.

* [_osgi.content_](https://osgi.org/hudson/job/build.cmpn/lastSuccessfulBuild/artifact/osgi.specs/generated/html/cmpn/service.repository.html#i3224340) -  Via which repositores can advertise different formats; each of those format capabilities being identified with a unique SHA-256 checksum and a URL.

* [_osgi.wiring.package_](https://osgi.org/hudson/job/build.core/lastSuccessfulBuild/artifact/osgi.specs/generated/html/core/framework.namespaces.html#i1773241) - A Requirements / Capabilities representation of the information in the Bundle manifest: i.e. Import-Package, DynamicImport-Package, and Export-Package. 

* [_osgi.wiring.bundle_](https://osgi.org/hudson/job/build.core/lastSuccessfulBuild/artifact/osgi.specs/generated/html/core/framework.namespaces.html#i1773242) - Reflects the information in the bundle headers for the purpose of requiring another bundle: i.e. a Require-Bundle header creates a wire from the requiring bundle to the required bundle. 

* [_osgi.wiring.host_](https://osgi.org/hudson/job/build.core/lastSuccessfulBuild/artifact/osgi.specs/generated/html/core/framework.namespaces.html#i1773243) - Used to allow a [Fragment](https://osgi.org/hudson/job/build.core/lastSuccessfulBuild/artifact/osgi.specs/generated/html/core/framework.wiring.html#framework.wiring-fragments) to attach itself to a host Bundle. 

Of these, the last three are concerned with low-level wire-up of the Bundle assembles and can ususally be ignored. For further information see the [Framework Namespace Specification](https://osgi.org/hudson/job/build.core/lastSuccessfulBuild/artifact/osgi.specs/generated/html/core/framework.namespaces.html#d0e16016).


## Resolving & Repositories 

A _Repository_ is a collection of _Resources_. 

Only the resources contained in the repositories provided to the resolver can be considered during the resolution process: i.e. the resolution process is _scoped_ by these repositories. 

One might consider a single large repository with all possible resources (e.g.  Maven Central), or alternatively a number of tightly scoped repositories, one per application with minimal diversity of resources. 

Each approach has its drawbacks: 
* Resolving is an NP complete problem so resolution times quickly become long when the repository becomes large
* Without appropriate tooling many small tightly scoped repositories - while in principle a good idea - can become an management burden.

Hence usually a small number of _curated_ repositories, each aligned to each Organisational business unit, is usually a good compromise.

The relationship between Repositories and the Resolution process is shown: 

![Resolving](https://user-images.githubusercontent.com/200494/31221580-73596198-a9c4-11e7-8d11-1e1fe7e37199.png)

An important variable in the resolving process is `effective` which defines the _effectiveness_ under which the resolve operation is performed. The resolver will only look at requirements that it deems _effective_. The default effectiveness is `resolve`. The effectiveness `active` is a convention commonly used for situations that do not need to be resolved by the OSGi framework but are relevant in using the resolver for assembling applications. 


## Managing Repositories

As previously explained Maven Central is far too huge for us to consider resolving against. We definitely need curated sources of bundles that we can resolve against, ideally without adding too much management overhead. 

When using Maven it turns out that a POM file is actually a pretty good source of bundles. Instead of searching the whole of Maven Central we can just search the transitive dependency graph defined by the POM file. As long as the POM is well maintained, with properly scoped dependencies, then it functions very well as the basis for a curated repository.  

This is the approach taken by OSGi enRoute. The OSGi enRoute project provides a number of "index" poms which are designed to be used both for convenience in your Maven build, and also when you want to resolve your application. You will have seen that in each of the examples there is an _Application_ module which gathers together the application bundles and exports them as a runnable JAR file. If you look a little more closely you will also see that these modules depend on the enRoute indexes, and on the other modules in the application. The reason for this is that application modules use the `bnd-indexer-maven-plugin` to generate OSGi repositories based on the dependencies listed in their poms.

Working in this way reduces the repository management overhead in maintaining the dependencies in your applications pom file. If any of the other modules in the application change their dependencies then this is automatically reflected in the OSGi repository generated by the indexer. The only time a change is needed to the application project is if a new leaf module (i.e. one that isn’t depended on by other modules in the application) is added to the application.


## Resolving in quickstart?  

When working through the quickstart tutorial the OSGi resolver was run ether in [eclipse](../tutorial/020-tutorial_qs.html#resolving-the-application), or manually via the [cli](../tutorial/020-tutorial_qs.html#resolving-the-application): if in eclipse you'll have seen the `Resolution Results` window lists the set of Bundles required.

The enRoute release artefact `app.jar` was then created with its own internal respository with contents determined by the resolution: to see this `jar xf app.jar`. 

    $ ls
    META-INF		    app.jar	    launcher.properties	    start.bat
    aQute		    jar		    start
    $ cd jar
    $ ls
    biz.aQute.launcher-4.0.0.jar
    impl-1.0-SNAPSHOT.jar
    javax.json-api-1.0.jar
    logback-classic-1.2.3.jar
    logback-core-1.2.3.jar
    org.apache.aries.javax.annotation-api-0.0.1-SNAPSHOT.jar
    org.apache.aries.javax.jax.rs-api-0.0.1-SNAPSHOT.jar
    org.apache.aries.jax.rs.whiteboard-0.0.1-SNAPSHOT.jar
    org.apache.felix.configadmin-1.9.0-SNAPSHOT.jar
    org.apache.felix.framework-5.7.0-SNAPSHOT.jar
    org.apache.felix.http.jetty-3.4.7-R7-SNAPSHOT.jar
    org.apache.felix.http.servlet-api-1.1.2.jar
    org.apache.felix.scr-2.1.0-SNAPSHOT.jar
    org.osgi.service.jaxrs-1.0.0-SNAPSHOT.jar
    org.osgi.util.function-1.1.0-SNAPSHOT.jar
    org.osgi.util.promise-1.1.0-SNAPSHOT.jar
    slf4j-api-1.7.25.jar
{: .shell }

Once the application is started the resolver in the OSGi framework runs, wiring together the Bundles in the application's local respository to create your application.

Note that enRoute supports a simple standalone Application release/run model. More sophisticatied runtime behaviours are enabled by OSGi including: 
* Dynamic Bundle updates at runtime.
* Runtime assembly influced by the runtime Environment's Capabilities.   


## Conclusion

The OSGi Resolver is responsible for assembling composite artefacts from selected sets of self-describing OSGi Bundles: so enabling substitution and re-use.

For further details concerning the OSGi Resolver & Repository consult [OSGi Core Release 7 specifications](https://osgi.org/hudson/job/build.core/lastSuccessfulBuild/artifact/osgi.specs/generated/html/core/index.html). 
