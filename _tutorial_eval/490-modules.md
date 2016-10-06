---
title: Modules
layout: tutorial
summary: Turning the parent pom into a module pom
lprev: 480-testing
lnext: 600-ci
---

## What you will learn in this section

So far we've treated each project as standalone. By running Maven manually we
were responsible for building the different projects in the right order. This
clearly does not scale well; even for small projects you often find that you
compiled against a previous incarnation. 

In this section we will make our parent pom also a _module_ pom. This is a pom
that contains all our modules and will automatically build the projects in the
right order. 

Make sure you are in the top directory:

	$ cd ~/workspaces/osgi.enroute.examples.eval
{: .shell }

## The Module POM

Maven projects can inherit from a _parent pom_. Though it is theoretically
possible to have a different parent pom than a module pom, there seems to be a number
of problems when they are not the same. For this reason, we setup the 
module project as the parent pom.  

## Adjusting Module Pom

In the default directory (`~/osgi.enroute.examples.eval/`) we create a `pom.xml`
file. It has the following content.

	osgi.enroute.examples.eval $ vi pom.xml
	// Add the module section after the `<packaging/>` element.
{: .shell } 

The `modules` element must fall directly under the `project` element.
	
		<modules>
				<module>api</module>
				<module>simple.provider</module>
				<module>parsii.provider</module>
				<module>command</module>
				<module>application</module>
				<module>bndrun</module>
				<module>test</module>
				<module>integration-test</module>
		</modules>


## Verify

After you created the pom.xml file you should verify that it all is ok.

	osgi.enroute.examples.eval $ mvn install
	[INFO] Scanning for projects...
	...
	Test parsii.bndrun
	Tests run  : 1
	Passed     : 1
	Errors     : 0
	Failures   : 0
	[INFO] 
	[INFO] --- maven-install-plugin:2.4:install (default-install) @ osgi.enroute.examples.eval.integration-test ---
	[INFO] Installing /Ws/enroute/osgi.enroute.examples.eval/integration-test/pom.xml to /Users/aqute/.m2/repository/org/osgi/osgi.enroute.examples.eval.integration-test/1.0.0-SNAPSHOT/osgi.enroute.examples.eval.integration-test-1.0.0-SNAPSHOT.pom
	[INFO] ------------------------------------------------------------------------
	[INFO] Reactor Summary:
	[INFO] 
	[INFO] osgi.enroute.examples.eval ......................... SUCCESS [  0.252 s]
	[INFO] osgi.enroute.examples.eval.api ..................... SUCCESS [  0.808 s]
	[INFO] osgi.enroute.examples.eval.simple.provider ......... SUCCESS [  0.484 s]
	[INFO] osgi.enroute.examples.eval.command ................. SUCCESS [  0.044 s]
	[INFO] osgi.enroute.examples.eval.parsii.provider ......... SUCCESS [  0.204 s]
	[INFO] osgi.enroute.examples.eval.application ............. SUCCESS [  0.086 s]
	[INFO] osgi.enroute.examples.eval.bndrun .................. SUCCESS [  5.412 s]
	[INFO] osgi.enroute.examples.eval.test .................... SUCCESS [  0.041 s]
	[INFO] osgi.enroute.examples.eval.integration-test ........ SUCCESS [  3.019 s]
	[INFO] ------------------------------------------------------------------------
	[INFO] BUILD SUCCESS
	[INFO] ------------------------------------------------------------------------
	...
{: .shell }

Since the output of mvn is quite, lets say, verbose, we will only show relevant parts in the
following sections. Any skipped parts will be indicated with `...`.

## What You've Learned

In this section we made the parent pom also a _module_ pom. By adding a `modules` 
section with the projects we created we can now build all the projects in the right
order with a single command. 
 