---
title: The Workspace
layout: tutorial
prev: 100-prerequisites.html
next: 300-api.html
summary: Create and manage a bnd workspace
---

## What you will learn in this section

In this section you will learn what a bnd workspace is and how it relates to the Git and Eclipse workspaces. We will address naming and how to use a ready made enRoute workspace template from github to get all the settings we need in one go. At the end of this section you will have a new workspace.

Optionally, you can learn how Eclipse, Git, enRoute, and bnd workspaces relate to each other.

Before you start this section, make sure you've checked the [prerequisites](100-prerequisites.html) for enRoute on your platform. 

## The Workspace

Since bnd(tools) is the central toolchain for OSGi enRoute starting with enRoute means starting with bnd(tools), the bnd based tools. A crucial concept in bnd is the _workspace_. The workspace contains a number of _projects_, that can each create multiple _bundles_. The workspace also has a `cnf` directory that contains shared information that can be referenced and used in the projects. 

The enRoute project maintains a Github repository with [an archetypical workspace for bnd][workspace]. enRoute will maintain this repository with new release. This workspace is setup to contain:

* A properly configured bnd workspace
* A configuration that uses JPM as the remote repository (which contains Maven Central) for external dependencies.
* A gradle build
* Travis CI YAML file to built it on travis-ci.com

### Naming 

First we must decided on a name (very important!). Best practice is to use a directory with all your workspaces that has a short path since it is likely you use it a lot in a shell, for example `/Ws`. Then use reverse domain names for the workspace name, based on your domain name and the topic of the workspace, for example `com.acme.prime`. To prevent yourself from unnecessary misery, do not use spaces in the path. Yes, spaces do work. Yes, you will regret using spaces in path names. 

In this chapter we use `/Ws/com.acme.prime` as the user's Eclipse workspace location (which is not going to be the bnd workspace!).

### Start bndtools

So fire up Eclipse and select `/Ws/com.acme.prime` as the Eclipse workspace. You'll get the start screen, just close it and select the bndtools perspective. You can select an Eclipse perspective with `Window/Open Perspective/Bndtools`. If there is no `Bndtools` entry, select `Other ...` and then select Bndtools. If there is still no entry, then you have [not installed bndtools yet][bndtools-install]. 

### Import the Archetype Workspace

We are going to use the OSGi enRoute archetype workspace, which is a [Github repository][workspace]. We need to import this archetype so select `File/Import`. 

![Import archetype](/img/tutorial_base/workspace-import-0.png)

Then select the `Projects from Git`. 

![Select Projects from Git](/img/tutorial_base/workspace-import-1.png)

And `Clone URI`. 

![Select Clone URI](/img/tutorial_base/workspace-import-2.png)

You should then enter the URI; the URI that we should use is

> `https://github.com/osgi/workspace.git`

So fill in the base URL, which should then give you:

![Fill in the base URL](/img/tutorial_base/workspace-import-3.png)

On the next `Next` you must select the branch. The default is `master` and that is what we want.

![Select Clone URI](/img/tutorial_base/workspace-import-4.png)

If you then click `Next` you should see the page that allows you to specify the destination of your Git (and bnd) workspace. By default Git places the projects in a sub directory `git` of your home directory (`~/git/...`). (This is an Eclipse preference.) We will follow this rather sane convention since this separation makes a lot more sense than you probably think. So we follow the default but we rename the workspace directory from 'workspace' to a name that matches our Eclipse workspace: `com.acme.prime`.

![Select Clone URI](/img/tutorial_base/workspace-import-5.png)

On the `Next` page we must define how to import the projects. A bnd workspace contains potentially many projects so the default option is ok, `Import existing projects`.

![Import Projects](/img/tutorial_base/workspace-import-6.png)

You now see the projects that will be imported from this new workspace., so you can click `Next`. The mini Package Explorer shows a single project `cnf`. 

![Import cnf and Finish](/img/tutorial_base/workspace-import-7.png)

Since this is all what we want imported, we can cick `Finish` then this project will be imported.
 
Congratulations, you've created your first enRoute workspace!

### About the Workspace

An bnd workspace requires a `cnf` project. This project configures bndtools and contains information shared between all the projects in the bnd workspace. You can look upon the bnd workspace as a kind of next order module that imports and exports bundles, in that view, the `cnf` project contains workspace private information. 

So, we now have the following file layout for the _Eclipse workspace_:

	/Ws                      workspaces
	  com.acme.prime         Eclipse Workspace
	    .metadata            The Eclipse metadata


The bnd and Git workspace have the following layout:

	~/                       User's home directory
	  git/                   Default Eclipse's git workspace directory
	    com.acme.prime       The Git repository/ bnd workspace
	      .git               The git control folder
	      cnf                The bnd control folder 
	      ....               Build files

Fortunately, from Eclipse it looks very simple:

![Import cnf and Finish](/img/tutorial_base/workspace-final-0.png)

You now have to restart Eclipse to make sure bndtools picks up the proper location. After you have restarted Eclipse, make sure you select the _bndtools perspective_. On the top right corner of the Eclipse workspace window you find a workspace icon with a '+', this is a button that pops up a list of perspectives. You can also do `Window/Open Perspective/Other ...`. Select `Bndtools`.

![Import cnf and Finish](/img/tutorial_base/workspace-perspective-0.png)

## How Does it Work?

It helps to understand how the workspace are layed out. An Eclipse workspace is a directory where Eclipse stores its metadata, e.g. the plugins persistent storage or the history. Though it can be used to also store the actual projects, it is in general not a good idea, especially if you use a source control system. EGit can actually become quite slow when you include the Git workspace.

Therefore, the best way to work with projects in Eclipse is to not store them in the Eclipse workspace folder but import them from another directory.

For bnd, a workspace is a directory with a `cnf` folder and a number of projects. This is a flat space; hated by many but it works quite well because it is very simple and hard to get wrong. Don't count on it changing so do not try to work around it, you're regret it. The `cnf` folder contains a `build.bnd` file and a `ext` directory which together define the workspace properties.

A bnd workspace is like a module; it imports bundles (and JARs) from a repository and it exports bundles to the same or another repository. On the inside we have projects that are private to the workspace. The projects should be cohesive so that they can share information via the `cnf` project.

The Git workspace is a directory that has a `.git` sub directory. When used with bnd, the Git workspace and the bnd workspace overlap. That is, the bnd workspace is one Git workspace, projects do not have their own repositories. 


[workspace]: https://github.com/osgi/workspace
[bndtools-install]: http://bndtools.org/installation.html
