---
title: Maven Background
layout: tutorial
lprev: 200-workspace
lnext: 310-central
summary: Change the plugin for Maven Central
---

Maven has been around for a long time and is heavily used by a very large group of people. The greatest advantage of Maven is that it is very easy to use the outputs of Maven projects through their repository model. Especially [Maven Central] has grown to be a humongous collection of JARs and other files. In April 2016 there were almost 1.2 million JARs in the repository.

The Maven repository model is largely build around a _naming_ scheme and a mapping from that naming scheme to file and URL paths. If you're familiar with Maven then please don't skip the next section where we define this scheme, we introduce some novel names to define this model a bit more formal and less ambiguous.

This naming scheme is based on:

* `groupId` – A general grouping name of _programs_.
* `artifactId` – A general name for a _program_.
* `version` – A version (free form) that identifies a _revision_.
* `extension` – An extension identifies the packaging of a file. The `pom` extension is special, it identifies the Project Object Model (POM).
* `classifier` – The classifier is used to have multiple files in a revision. There is always the _target_ of the revision and the _pom_ file, but Maven does allow archives for sources, javadoc, tests, etc. The classifier identifies these additional archives.
* `snapshots` – Maven has different workflows for _snapshots_ and final released versions. Snapshots are identified by a `-SNAPSHOT` extension of the version. Snapshots can be released multiple times while in principle an actual release can only be released once.

Maven identifies archives with a combination of these identifiers, these are known as _gavs_ or _coordinates_. There are several competing short form of the coordinates. In bnd, the following syntax is used to specify archives:

	archive = groupId ':' artifactId ( ':' extension ( ':' classifier )? )? ':' version ( '-SNAPSHOT' )?

For example, `com.google.guava:guava:jar:jdk5:19` is the coordinate for the released Guava library compiled for JDK 5.

If you're familiar with Maven you will find that the concepts of _program_, _revision_, and _archive_ are not defined by Maven. They are introduced here because they remove a lot of the ambiguity in the Maven documentation. (For example, what is an artifact?) They are defined as follows:

* `program` – This is basically the combination of the `groupId` and `artifactId`. It defines a name but this name does not identify anything concrete. A _program_ can have multiple _revisions_.
* `revisions` – A revision is named by a _program_ and a _version_ and has a collection of _archives_.
* `archive` – A file in a revision. The file with the `pom` extension contains the project information. Archives are identified by an _extension_ and a _classifier_. Extensions are closely related to _packaging_.

## The bnd Maven Repository

The bnd Maven Repository is a bnd repository that provides the following functions for bnd users:

* External dependencies with a _scoped_ view that is in source control
* Local install in the local Maven repository for direct use by Maven projects
* Releasing snapshots or final releases to a remote repository, e.g. Nexus or Artifactory, or file based Maven repository
* Automatically generating the Javadoc and sources archives
* UI support to update revisions to latest and including compile or runtime dependencies

## What You Won't Like as a Maven User

The transitive dependency model of Maven (where you drag in all the dependencies of your dependencies) is highly popular among Maven users because it really solves a problem. Still, in bnd (and indirectly OSGi) there is no support for this oh so useful feature. A lot of Maven aficionados give up on bnd for this reason before they fully understand _why_ OSGi does not full heartedly support this model. After all, it is conceptually a simpler model than the OSGi model.

The reason is identical to why Java got _interfaces_. The goal of OSGi is to create systems out of reusable components. The problem with the transitive dependency model is that it suffers from the same condition as pre-interface Object Oriented applications: [The Big Ball of Mud]. Without interfaces, your code does not only drag in the direct dependencies of the components you use, you also drag in any implementation dependencies.

In OSGi, instead of requiring another component, we require a capability. A capability is for example a specific _service_ or _package_. Using  the _resolver_ we can then assemble applications. Therefore, the mindset in the OSGi world is to care deeply about your dependencies. The actual dependency graph is a primary citizen in the architecture design and not a consequence of what projects do.

This is quite a different philosophy that does generate some pain up-front. However, the resulting systems are significantly simpler.  

So please bear with us even if it looks disgusting to you.


{% include links.md %}
