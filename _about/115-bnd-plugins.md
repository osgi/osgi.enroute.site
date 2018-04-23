---
title: Maven Plugins from bnd  
layout: toc-guide-page
lprev: 112-enRoute-Archetypes.html  
lnext: 120-Sponsors.html 
summary: An introduction to the maven plugins built by the bnd project and used in enRoute 
author: enRoute@paremus.com
sponsor: OSGi™ Alliance 
---

The enRoute project makes extensive use of the maven plugins from the bnd project. These are used for all sorts of different purposes.

## The bnd-maven-plugin

The bnd-maven-plugin is a key plugin when producing OSGi bundles. The bnd-maven-plugin is responsible for parsing the bytecode of the classes included in the JAR file being produced by a Maven module. Based on the discovered annotations and dependencies the bnd-maven-plugin will construct an OSGi Manifest file for the bundle, and any other required metadata (for example Declarative Services XML descriptors).

Note that the `maven-jar-plugin` must be configured to accept this externally generated manifest.
{: .note }

### enRoute customisations

OSGi enRoute further configures the `bnd-maven-plugin` to give a more friendly symbolic name for projects that use short artifact ids, to include sources in the generated bundle, and to use [OSGi Contracts (_Requirements_ & _Capabilities_)](../FAQ/200-resolving.html) when they are available

## The bnd-export-maven-plugin

The bnd-export-maven-plugin is used to export an OSGi application as a runnable JAR. The input to the bnd-export-maven-plugin is a `bndrun` file. This file declares a set of bundles and launch properties that should be used to start an OSGi framework containing the application.

## The bnd-indexer-maven-plugin
The bnd-indexer-maven-plugin is used to generate an OSGi repository index from the set of maven dependencies in your module’s pom. This repository index can be used for resolving or exporting the application.

The indexes used in OSGi enRoute are typically for intermediate or local usage, so the repository URLs in the index point at files on the local file system. Also, by default the index contains only the compile and runtime scoped dependencies, so this plugin defines a second execution for generating an index of the test scoped dependencies. This is used when running and resolving the application with debug utilities, and for use in integration testing

## The bnd-resolver-maven-plugin

The bnd-resolver-maven-plugin is not normally part of the main build, but it can be used from the command line to [resolve](../FAQ/200-resolving.html) an application or integration testing `bndrun`. This resolve operation takes a set of run requirements and uses an OSGi repository index to find the complete set of bundles that need to b deployed to satisfy the run requirements.

## The bnd-baseline-maven-plugin
The bnd-baseline-maven-plugin is used to validate the [semantic versioning](../FAQ/210-semantic_versioning.html) of a bundle’s exported API by comparing it against the last released version. This plugin will fail the build if the API version has not been increased when a change has been made, or if the version increase is insufficient to communicate the semantics of the change.

## The bnd-testing-maven-plugin

The bnd-testing-maven-plugin is used to provide bundle-level testing. The tests are written using JUnit and packaged into a tester bundle (often produced in the same build project). The bnd-testing-maven-plugin then uses one or more bndrun files to launch an OSGi framework containing the tester bundle and the bundles under test. The test cases are then run by the bnd-testing-maven-plugin.

As the test cases are run inside an OSGi framework they are able to install bundles and interact with the service registry. This allows for validation of the external behaviour of your OSGi bundles.
