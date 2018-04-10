---
title: Prerequisites 
layout: toc-guide-page
lprev: 032-tutorial_microservice-jpa.html 
lnext: 017-enRoute-ArcheTypes.html 
summary: Prerequistes & configurations required for running these Tutorials.
author: enRoute@paremus.com
sponsor: OSGi™ Alliance 
---

Before you start any of the tutorials you must prepare your environment so that the right tools are installed. This page helps you to achieve this. 

## Required tools

We need to run the following tools on your computer - without them you won't get very far at all.

* [Java][java8], probably already got it? If not, this is a good time to get started! enRoute projects target Java 8 by default, so make sure your Java is at least that version
* [Maven][Maven], a popular build tool for Java applications with an enormous repository behind it. Make sure that you're on at least 3.3.9

## Useful tools

These tools aren't strictly required but we think that they'll improve your experience of using the tutorials, and that they'll help you in starting your own projects.

* [Eclipse][mars], A powerful, flexible IDE for Java if you do not know which variant you want then pick the _Eclipse Standard_ variant. Make sure that you use version _Mars_ or higher
* [Bndtools][bndtools] A plugin for Eclipse that adds IDE support for OSGi development. This includes automatically building your projects and nice editors for bnd metadata. Make sure that you have 4.0.0 as enRoute makes use of lots of new OSGi features!
* [Git][git], Eclipse does include git support through EGit, but when it comes to git nothing really beats the good old command line.


### Installing bndtools

You can't install bndtools 4.0.0 from the Eclipse market place yet as it hasn't been formally released, but you can install the bndtools development snapshot directly from an update site using the instructions at:

        http://bndtools.org/installation.html#nonstandard_versions

## Conventions

Whenever you see a text like `File/Open` we hope you treat it as a menu path. That is, go to the menu bar, click on `File`, then select `Open`. If the menu path starts with @/ then it is from the context menu on the selected object, which has then been clearly defined in the previous sentence.

## OS Specific Issues

Since this part is rather sensitive to the operating system you're using, we have split it in different sections for each of the major operating systems.

* [Windows](#windows)
* [MacOS](#macos)
* [*nix](#unix)

### Windows

In the enRoute tutorials file paths are always indicated using the forward slash or solidus ('/') as is customary on *nix like systems. The reason is that bnd, since its files are portable, always uses relative addressing from the workspace and adopted the forward slash. For most developers mapping these paths to Windows should be straightforward.

The only addressing outside the workspace is to the user's home directory, the user's home directory is indicated by a path that starts with a tilde and a slash ('~/'). This maps to the path indicated in Java's `user.home` System property.

Make sure you have a good command line shell available. If you're familiar with one, keep it. If command lines are uncomfortable for you, you might want to use [Git for Windows][gitforwindows] which includes a bash like shell. Though virtually all work in OSGi enRoute can be done through an IDE, the tutorials use a *shell first* approach so that you can choose the IDE you want to use.

### MacOS

If you start using enRoute you will likely create a number of workspaces. There is a very handy utility plugin for Eclipse on MacOS that shows you which workspace is which icon in the task bar:

> [http://njbartlett.name/2011/10/09/workspace-mac-badge.html](http://njbartlett.name/2011/10/09/workspace-mac-badge.html)

There is also multi-workspace launcher plugin from Torkild U. Resheim that incorporates Neil Bartlett's task bar badge (above).

> [OS X Eclipse Launcher Utility](http://marketplace.eclipse.org/content/osx-eclipse-launcher)

### Unix

We aren't currently aware of any challenges on Unix systems. Please let us know if you have any!

[java8]: http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html
[Maven]: https://maven.apache.org
[mars]: https://www.eclipse.org/downloads/
[bndtools]: http://bndtools.org
[git]: http://git-scm.com/book/en/Getting-Started-Installing-Git
[gitforwindows]: http://msysgit.github.io

