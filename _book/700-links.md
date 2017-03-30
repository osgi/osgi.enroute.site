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
* [OSGi Alliance](https://www.osgi.org) – Where would we be without this seminal standard? Ok, don't ask.
* [Travis](https://travis-ci.org) – Travis is an eye-opener for everybody that thinks continuous integration should be reserved for real men only. It shows how amazingly simple things can be when they are designed properly.


### Projects

Projects providing implementations of OSGi specifications can be found on the following wikipedia page: [https://en.wikipedia.org/wiki/OSGi_Specification_Implementations](https://en.wikipedia.org/wiki/OSGi_Specification_Implementations)


[enroute-doc]: https://github.com/osgi/osgi.enroute.site
[enroute]: https://github.com/osgi/osgi.enroute
[template]: https://github.com/osgi/osgi.enroute.template
[examples]: https://github.com/osgi/osgi.enroute.examples
[workspace]: https://github.com/osgi/workspace
[bndtools]: https://github.com/bndtools
[gradle]: http://www.gradle.org/
[cloudbees]: https://bndtools.ci.cloudbees.com/job/bndtools.master/lastSuccessfulBuild/artifact/build/generated/p2/
