---
title: Quick Start
layout: book
summary: A quick-start guide to get engaged with OSGi enRoute. It shows how to quickly use the complete toolchain.
---

Since bnd(tools) is the central toolchain for OSGi enRoute starting with enRoute means starting with bndtools. The enRoute project maintains a Github repository with an archetypical workspace. This workspace is setup to contain:

* A properly configured bnd workspace
* A configuration that uses JPM as the remote repository (which contains Maven Central).
* A gradle build
* Ready for building on Travis.
 
In this quick start we develop a little project that, suprise, prints out "hello world". Now, just keep one thing in mind, this setup takes a few shortcuts to make things simpler but that are not advised for an actual development. So try this at home, but not at work. We'll get back to this in the last chapter.

## Prerequisites

* [Java 8][2], probably already got it? If not, this is a good time to get started!
* [git][6], unlikely that you do not have it installed yet?
* [Eclipse Luna][3], if you do not know which variant, pick the _Eclipse Standard_ variant.
* Bndtools 2.4M1 or later, either from the [Eclipse Market Place][4] (available under Eclipse's Help for some reason) or you can be more adventurous and try out the latest and greatest at [cloudbees][1], you can install it also from the Eclipse `Help/Install New Software` menu.

## Creating a Workspace

Fire up bndtools and create a new workspace. Use a good name for your workspace, make it a short path, and don't use spaces in the path. In this example we assume *nix and the path `/Ws/com.acme.prime` but you can use other paths, just mentally replace it when we use this path.
  
Select the bndtools perspective (`Window/Open Perspective/Other .../Bndtools`). Whenever you see a string like (`File/Open`) we intend to convey a menu path. So (`File/Open`) means goto the File menu and select Open.

A bnd workspace requires a `cnf` project. This project configures bndtools and contains information shared between all the projects in the bnd workspace. You can look upon the bnd workspace as a kind of module that imports and exports bundles, in that view, the cnf project contains is private information. 



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
