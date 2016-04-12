---
title: Releasing to Nexus
layout: tutorial
lprev: 310-central
lnext: 330-
summary: Setup a workspace to release to Nexus
---

In this section we're going to setup releasing snapshots to Nexus.

## Setting up Nexus

We are not going to explain how to setup a Nexus repository because you probably already have a Nexus running or you can [install it according to its instructions](https://books.sonatype.com/nexus-book/reference/install.html).

In the following sections we assume that:

* There is a default Nexus running on http://localhost:8081 . This Nexus should have a snapshot and release repository setup:
	* http://localhost:8081/nexus/content/repositories/snapshots/
	* http://localhost:8081/nexus/content/repositories/releases/
* It has an account setup called `admin` with the password `admin123`. (Default account.)

You should translate these settings to your local setup.

## Communications

The [-connection-settings] instruction defines the communication settings to the Nexus repository. By default, bnd looks in the `~/.bnd/settings.xml` and then `~/.m2/settings.xml`. The bnd settings are compatible with the Maven settings. However, it is also possible to override the location of the settings in the `build.bnd` file, which we do here.

	-connection-settings: ${.}/settings.txt

And in `./cnf/settings.xml`:

 	<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
		xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
		xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0
	                          http://maven.apache.org/xsd/settings-1.0.0.xsd">
		<servers>
			<server>
				<id>http://localhost:8081</id>
				<username>admin</username>
				<password>admin123</password>
			</server>
		</servers>
	</settings>

In bnd, the id is not the name of the repository but it mustt matches the scheme, host, and port number.

You can copy the settings file in the example project to your `~/.bnd/settings.xml` file if you need to modify it with private credentials. (In general, it is a pretty bad idea to place credentials in a bnd workspace.)

## Snapshot URL

We now need to link the Release repository to the Nexus repository, so we need to modify the Release repository plugin by adding a snapshot URL:

	-plugin.9.Release: \
	\
        aQute.bnd.repository.maven.provider.MavenBndRepository; \
        	snapshotUrl			=   http://localhost:8081/nexus/content/repositories/snapshots/ ; \
			name				=	Release



