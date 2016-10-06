---
title: Maven Central
layout: tutorial
lprev: 300-background
lnext: 320-local
summary: Change the plugin for Maven Central
---

The plugin for Maven Central in OSGi enRoute points to [jpm4j]. Since this repository is largely filled with Maven Central, let's override it with the Maven Bnd Repository using the same . The definition is as follows in the file `./cnf/ext/enroute.bnd`:

	-plugin.4.Central:  \
	\
	    aQute.bnd.deployer.repository.wrapper.Plugin; \
	        location  = "${build}/cache/wrapper"; \
	        reindex   = true, \
	\
	    aQute.bnd.jpm.Repository; \
	        includeStaged = true; \
	        name          = Central; \
	        location      = ~/.bnd/shacache; \
	        index         = ${build}/central.json

This repository definition defines 2 plugins. The _wrapper_ and the _jpm repository_. The jpm repository communicates with the central server. The function of the [Wrapper Plugin] is to provide OSGi metadata for the downloaded archives.

We only need 1 wrapper for all possible Maven Bnd Repository plugins. Make sure you only define the wrapper once.

## Configuring the Plugin for Maven Central

The `ext` bnd files are read before the `./cnf/build.bnd` is read, we can therefore reliably override the configuration, just use the same property name: `-plugin.4.Central`. Therefore we override the configuration as follows in `./cnf/build.bnd`:

	-plugin.4.Central = \
	   aQute.bnd.repository.maven.provider.MavenBndRepository; \
	      releaseUrl = https://repo.maven.apache.org/maven2/; \
	      name       = Central

## Repositories View

After saving the `build.bnd` file, the Repositories view in Bndtools is updated, the `Central` repository is now a Maven Repository that points to Maven Central.  (It replaced the JPM repository with the same name.) You can hover your mouse over the repository name to see the details.

## Scope View

By default, this repository is empty, nothing, nada. So why is that? Well, One of the goals of bnd is to have _repeatable builds_ over very long times. If you checkout your project ten years from now then it should build the same files as it does today. Unfortunately, if your repositories change then the build results can potentially change. For this reason, we maintain the _view_ of what we want to see from Maven Central in a file.

This file should be under source control management so that anytime in the future when a previous revision is checked out, it will see exactly the same contents of the repository.

## Editing the scope

The most basic way to extend the scope is editing the corresponding file. Since we did not specify this file (the configuration property is `index`), we used the default which is the name of the `./cnf/` + repository name in lower case + `.mvn`. In this case, `./cnf/central.mvn`.  The format of the file is a _maven coordinate_ per line. For example:

	commons-math:commons-math:1.2
	dnsjava:dnsjava:2.1.1
	org.apache.felix:org.apache.felix.framework:bundle:5.4.0

Obviously manually editing this file is not such an pleasant thought. There are therefore a number of ways you edit the file in the Repositories View of Bndtools.

You can:

* Drop a URL on the repository that points to a POM file. The repository will read the POM file. (Parsing a POM file may require access to a remote repository to resolve _parent poms_ so in general the POM should come from the remote repository that this repository is connected to.)
* Drop a URL to a JPM revision, just like the JPM repository.
* Use [search.maven.org](http://search.maven.org/) and drop the link to the POM from the result on the Maven repository in the Repositories view.

Once you have a revision in the Repositories view, you can manipulate it by calling up a context menu.

* Update to a later revision
* Delete it
* Add all compile or runtime dependencies. Yes, this can be quite convenient.

All changes that are made are immediately reflected in the file. Changes in the file are reflected in the Repositories view.

## Information in the Repositories View

In the Maven Bnd Repository, each entry (repository, program, and revision) have a context menu and provide additional information when you hover over them.

Revisions and programs are identified by their corresponding Bundle Symbolic Name if they are bundles. If they're not bundles, then the Maven coordinate is displayed.

{% include links.md %}
