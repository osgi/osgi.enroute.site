---
title: Quick Start
layout: book
summary: A quick-start guide to get engaged with OSGi enRoute. It shows how to quickly use the complete toolchain.
---

Since bnd(tools) is the central toolchain for OSGi enRoute starting with enRoute means starting with bndtools. The enRoute project maintains a Github repository with an archetypical workspace. This workspace is setup to contain:

* A properly configured bnd workspace
* A configuration that uses JPM as the remote repository (which contains Maven Central).
* A gradle build
* Prepared for building on Travis.
 
In this quick start we develop a little project that, suprise, prints out "hello world". Now, just keep one thing in mind, this setup takes a few shortcuts to make things simpler but that are not advised for an actual development. So try this at home, but not at work. We'll get back to this in the last chapter.

## Prerequisites

* [Java 8][2], probably already got it? If not, this is a good time to get started!
* [git][6], unlikely that you do not have it installed yet?
* [Eclipse Luna][3], if you do not know which variant, pick the _Eclipse Standard_ variant.
* Bndtools 2.4M1 or later, either from the [Eclipse Market Place][4] (available under Eclipse's Help for some reason) or you can be more adventurous and try out the latest and greatest at [cloudbees][1], you can install it also from the Eclipse `Help/Install New Software` menu.

This quick start is about learning to use OSGi enRoute, not about learning Java nor Eclipse. It is assumed that you have experience with both tools.

## Creating a Workspace

We are going to use the OSGi enRoute archetype workspace, which is a [Github repository][8]. In this case we clone the archetype repository and disconnect it. We need to use a good name for your workspace, make it a short path, and don't use spaces in the path. In this example we assume *nix and the path `/Ws/com.acme.prime` but you can use other paths, just mentally replace it when we use this path. Assuming that name, we can do the following steps:

	$ mkdir /Ws
	$ cd /Ws
	$ git clone git@github.com:osgi/osgi.enroute.archetype.git com.acme.prime
	Cloning into 'com.acme.prime'...
	...
	Checking connectivity... done.

We can now fire up Eclipse and select the `/Ws/com.acme.prime` as the Eclipse workspace. First, we must open the bndtools perspective. You can select an Eclipse perspective with `Window/Open Perspective/Bndtools`. Whenever you see a text like (`File/Open`) we intend to convey a menu path. 

If there is no `Bndtools` entry, select `Other ...` and then select Bndtools. If there is still no entry, then you have [not installed bndtools yet][9]. 

Select `File/Import/General/Existing Projects into Workspace`. As the root directory we select `/Ws/com.acme.prime`. This will allow us to import the `cnf` project. A bnd workspace requires a `cnf` project. This project configures bndtools and contains information shared between all the projects in the bnd workspace. You can look upon the bnd workspace as a kind of module that imports and exports bundles, in that view, the `cnf` project contains is private information. 
 
## Creating a Project

Let's make the archetypical `Hello world` (and in the dynamic OSGi world also `Goodbye World!`). So do (`File/New/Bndtools OSGi Project`). This will open a wizard that asks lots of questions. There are two things important.

* For the name fill in `com.acme.prime.hello.provider`. bndtools will use the extension to select a project that creates a bundle that provides an implementation for an API.
* In the next page, select the enRoute template.
* And then finish the wizard.

## Changing the Source Code

To see something happening, we add the `Hello` and `Goodbye` to the `com.acme.prime.hello.provider.HelloImpl` class. You can add the following methods to the component:

	@Activate void activate() { System.out.println("Hello World"); }
	@Deactivate void deactivate() { System.out.println("Goodbye World"); }

If you resolve the annotations, please select the OSGi annotations and the bnd variants.

TODO: remove the bnd annotations from the profile.

## Create a run Descriptor

We now have a project. This project cannot run yet, we need to add a run specification. So select `File/New/Run Descriptor`. In this wizard. Call it `hello`, this will later be the name of our application. Then select the `OSGi enRoute Base Launcher` template. This will open the Resolve tab:

![Resolve tab](/img/book/qs/resolve.jpg)

The `hello` run specification must be told to include the `com.acme.prime.hello.provider` bundle for it is this bundle we want to see if it tells us hello. So we can add this by dragging it from the left side to the right side.

## Resolving

A bundle is a social animal and usually needs some other bundles before it wants to perform. So we must ask bndtools to resolve the dependencies, fortunately, the Resolve tab has a big `Resolve` button. If we hit it, we get a list of bundles that is the minimal closure to make our initial requirement runnable.

![Resolve tab](/img/book/qs/resolve-result.jpg)

## Launching the project


## Adding a Dependency

## Creating an Application

## Continuous Integration




   

	
	

Fire up bndtools and create a new workspace. 
  
Select the bndtools perspective (`Window/Open Perspective/Other .../Bndtools`). So (`File/Open`) means goto the File menu and select Open.


You can create this 

* Use git to clone this repository somewhere on your file system. Make sure the path to the repository does not contain spaces, especially on windows.
* Open Eclipse and select this folder as a workspace, then do `Import/Existing Projects` from this folder, which will only be the cnf project.
* You now have a working bndtools workspace. 
* You can follow the tutorials at [enroute.osgi.org][7]

Make sure you always create projects in the bnd workspace. A bnd workspace is always flat and the projects must therefore reside in the same folder as the cnf project.


[1]: https://bndtools.ci.cloudbees.com/job/bndtools.master/lastSuccessfulBuild/artifact/build/generated/p2/
[2]: http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html
[3]: https://www.eclipse.org/downloads/
[4]: http://marketplace.eclipse.org/
[5]: http://jpm4j.org/#!/md/install
[6]: http://git-scm.com/book/en/Getting-Started-Installing-Git
[7]: http://enroute.osgi.org
[8]: https://github.com/osgi/osgi.enroute.archetype
[9]: http://bndtools.org/installation.html