---
title: The Local Repository
layout: tutorial
lprev: 310-central
lnext: 330-maven-project
summary: Install bnd JARs in the Maven local repository after a build
---

Maven's local repository is a _cache_ but it is also used to share revisions between projects that run on the same machine. In Maven, you can _install_ a revision in the local repository, and then the other project can depend on it. This model is also supported by the Bnd Maven Repository.

## Local Repository

For this, we want to have a _local repository_. In OSGi enRoute we've already have a local repository:

	-plugin.6.Local: \
	   aQute.bnd.deployer.repository.LocalIndexedRepo; \
	      name     =    Local ; \
	      pretty   =    true ; \
	      local    =    ${build}/local

This is an indexed repository but we can override it with a Maven Bnd Repository in the `./cnf/build.bnd` file:

	-plugin.6.Local: \
      aQute.bnd.repository.maven.provider.MavenBndRepository; \
	        name   =    Local

This instruction defines a _local only_ Maven repository. This means that we're only using it to put bundles in the local Maven repository in `~/.m2/repository`.

## Build Repository

The most convenient way to use this repository is to automatically push any build JAR in Bndtools directly to this Local repository. You can set the [-buildrepo] instruction to a _build repository_. This will instruct bnd to put any build JAR immediately in the given repositories. If the build repository is a Maven Bnd Repository then it will be stored in the local Maven repository.  

	-buildrepo: Local


## The POM

This raises the interesting question of how is the POM created for the resulting revision? This magic is provied by the [-pom] instruction. In bnd there is a function that will create a POM inside the JAR at a Maven defined location. Just specifying `true` is sufficient to get this POM in your JAR. bnd will attempt to use the Manifest headers to create sensible defaults. However, we can get better results by specifying some of its options.

In this case we want to release our projects as _snapshots_. We therefore have to add the following to the `./cnf/build.bnd` file:

	-pom: \
		groupid	=	osgi.enroute.examples,\
		version =	${versionmask;===;${@version}}-SNAPSHOT

We can set this instruction in the `./cnf/build.bnd` file so the same mask is used for all JARs. Notice that the `${@version}` is automatically set to the Bundle's version; you can also use `${@bsn}`. See the [-pom] instruction for the details.

Though this is a general useful function, the Maven Bnd Repository plugin will require the POM file inside the JAR to find out what to do.

## Projects

We've prepared an example project that shows how to have an Eclipse workspace with a Maven project together with a Bndtools workspace. In this tutorial we'll build this example step by step.

Now we don't have any projects yet, so create a simple API project, in here we'll call it: `osgi.enroute.examples.eval.api`. You can of course name it differently. Let the single source file be:

	package osgi.enroute.examples.eval.api;

	public interface Eval {
		double eval(String expression) throws Exception;
	}

If you used the standard OSGi enRoute template you should already have the package and it is also already exported.

Since we already set up the [-buildrepo] and [-pom] instructions, we should have added the project's bundle to the Maven local repository. You can find it at `~/.m2/repository/osgi/enroute/examples/osgi.enroute.examples.eval.api/1.0.0-SNAPSHOT/osgi.enroute.examples.eval.api/1.0.0-SNAPSHOT.jar`.

If you look inside this JAR you find the following POM at `META-INF/maven/osgi.enroute.examples/osgi.enroute.examples.eval.api`:

	<?xml version="1.0" encoding="UTF-8"?>
	<project xmlns="http://maven.apache.org/POM/4.0.0"
		xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
		xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
	  <modelVersion>4.0.0</modelVersion>
	  <groupId>osgi.enroute.examples</groupId>
	  <artifactId>osgi.enroute.examples.eval.api</artifactId>
	  <version>1.0.0-SNAPSHOT</version>
	  <description>This is OSGI ENROUTE EXAMPLES EVAL API project. An API project should in general not contain any implementation code.</description>
	  <name>osgi.enroute.examples.eval.api</name>
	</project>

(If you have no nice viewer installed on your system for JAR files, just drop the JAR file in a Bndtools project and double click on it.)

## Versions

It is important to realize that we've now used 2 different versions. The OSGi version is set to `1.0.0.201604081640` (where the qualifier is of course a time-stamp so it will change for you). The Maven version is `1.0.0-SNAPSHOT`. Maven versions are free text that must be entered literally but OSGi versions have a formally defined syntax. That is, in Maven 1.0.0 and 1.0 are different versions, in OSGi, they would be the same.

The `-SNAPSHOT` suffix is quite important for Maven. There are lots of rules in Maven for snapshot revisions.  

## Headers

To demonstrate that we can just use OSGi headers, add a bundle license header to the `bnd.bnd` file in the project:

	Bundle-License: \
		https://opensource.org/licenses/Apache-2.0; \
		link=http://www.apache.org/licenses/LICENSE-2.0; \
		description="Apache Software License 2.0"

 Double click on the `generated/osgi.enroute.examples.eval.api.jar` file and you can see that the POM file now looks like:

	<?xml version="1.0" encoding="UTF-8"?>
	<project xmlns="http://maven.apache.org/POM/4.0.0"
		xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
		xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
	  <modelVersion>4.0.0</modelVersion>
	  <groupId>osgi.enroute.examples</groupId>
	  <artifactId>osgi.enroute.examples.eval.api</artifactId>
	  <version>1.0.0-SNAPSHOT</version>
	  <description>This is OSGI ENROUTE EXAMPLES EVAL API project. An API project should in general not contain any implementation code.</description>
	  <name>osgi.enroute.examples.eval.api</name>
	  <licenses>
	    <license>
	      <name>https://opensource.org/licenses/Apache-2.0</name>
	      <url>http://www.apache.org/licenses/LICENSE-2.0</url>
	      <distribution>repo</distribution>
	      <comments>Apache Software License 2.0</comments>
	    </license>
	  </licenses>
	</project>

Not a bad result for a day's work?

{% include links.md %}
