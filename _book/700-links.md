---
title: Where to Find Stuff
layout: book
---

## Where to Find Stuff 

This page provides you with a map for the components that we use and love to depend on.

### OSGi enRoute Repositories

We have organized the work around a number of Github repositories. All these repositories are either Apache Software License version 2.0, or EPL 1.0 unless indicated otherwise. To make this all work, there are actually a rather large number of repositories involved, which tends to get confusing. Therefore an illustration how it all hangs together:

![Repositories in use and their relations](/img/repositories-overview.png)

* [`osgi.enroute.site`][enroute-doc] – This website! Don't whine about this website, clone it, change it, and create a pull-request. All contributions welcome.   
* [`osgi.enroute`][enroute] – The OSGi enRoute Profile and Distro repository. This repository is the source for the OSGi enRoute  profiles. You will find the definition here as well as the sources for the service contracts that are not (yet?) part of the OSGi standards.
* [`workspace`][workspace] – The OSGi enRoute template for a bnd workspace. This template creates a bnd environment that is all setup to go. It also contains the OSGi enRoute default distro at the latest revision. 
* [`osgi.enroute.bundles`](https://github.com/osgi/osgi.enroute.bundles) – Some of the services in the OSGi enRoute Base Profile are new and do not have open source implementations (yet!). This repository provides default, and mostly rather simple, implementations for these services. We're actively pushing these projects into one of the major open source projects.
* [`osgi.enroute.template`][template] – This repository is an OSGi enRoute workspace for project templates in bndtools. It is a normal workspace but it uses weird names so these names can be replaced when the template is expanded. The template must currently manually be imported in the bndtools build.
* [`osgi.enroute.examples`][examples] – The OSGi enRoute service catalog demonstrates the use of the OSGi API with small examples. These examples can be found in this repository. 

### Tools

In sorted order:

* [bnd(tools)](http://bndtools.org) – The bnd(tools) project provides the underlying engine for the OSGi enRoute tool chain as well as the Eclipse bndtools plugin. You can find their repositories at [Github][bndtools]. For the moment, please install the latest release from [Cloudbees][cloudbees].
* [Eclipse](http://eclipse.org)  – The Eclipse Foundation provides the unsurpassed IDE that forms the basis of the ease of use 
* [Git & Github](https://github.com) – Git provides the unsurpassed source control management system. 
* [Gradle][gradle] - The command line based build tool used in the continuous build on Travis.
of the OSGi enRoute project.
* [Java](https://www.java.com) – The not so sexy 20 year old, but oh man, it is the work horse of our industry.
* [jpm4j](https://jpm4j.org) – Since OSGi has some extra needs on top of Maven Central, we use jpm4j.org to provide an OSGi perspective. 
* [OSGi Alliance](https://osgi.org) – Where would we be without this seminal standard? Ok, don't ask.
* [Travis](https://travis-ci.org) – Travis is an eye-opener for everybody that thinks continuous integration should be reserved for real man only. It shows how amazingly simple things can be when they are designed properly.


### Open Source Projects

In sorted order:

* [Apache Felix](http://felix.apache.org) – Apache Felix provides numerous bundles to the OSGi enRoute distro; taking great care to make them run on all frameworks. Richard Hall, the initiator of this project is an OSGi Fellow and invited researcher of the OSGi Alliance. An active contributor is [Adobe](http://adobe.com) who is an OSGi Strategic Member and part of the OSGi Alliance board.
* [bndtools](http://bndtools.org) – bndtools is not only the provider of the underlying bnd engine, it also has the [`bndtools.rt`](https://github.com/bndtools/bndtools.rt) repository. Several bundles of this repository made it into the OSGi distro. bndtools is primarily shepherded by [Paremus Inc](https://www.paremus.com), an OSGi Strategic member and part of the board. [IBM](http://ibm.com) and [Luminis](http://luminus.nl) are active committers.
* [Eclipse](http://eclipse.org) – Eclipse is the open source foundation sheperding this incredible tool the Eclipse IDE. However, they also provides one of the popular OSGi framework Equinox (which is also the basis for the OSGi Alliance RI) and have implemented almost all OSGi compendium specifications. They therefore provide a number of OSGi enRoute distro bundles. The Eclipse Foundation is a Contributing Associate member of the OSGi Alliance.
* [Knopflerfish](http://www.knopflerfish.org/) – Knopflerfish is an open source distro of the OSGi specifications, they have implementations for almost all specifications. Several bundles in the OSGi enRoute distro are coming from Knopflerfish. The guardian company of Knopflerfish is [Makewave](http://www.makewave.com), who is a Principal member of the OSGi Alliance, tracing their membership back to the early beginnings.


[enroute-doc]: https://github.com/osgi/osgi.enroute.site
[enroute]: https://github.com/osgi/osgi.enroute
[template]: https://github.com/osgi/osgi.enroute.template
[examples]: https://github.com/osgi/osgi.enroute.examples
[workspace]: https://github.com/osgi/workspace
[bndtools]: https://github.com/bndtools
[gradle]: http://www.gradle.org/
[cloudbees]: https://bndtools.ci.cloudbees.com/job/bndtools.master/lastSuccessfulBuild/artifact/build/generated/p2/
