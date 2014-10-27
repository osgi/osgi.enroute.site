---
title: The Workspace
layout: tutorial
prev: 100-prerequisites.html
next: 300-application.html
summary: Setup a bnd(tools) workspace
---

## What you will learn in this section
We will setup a bnd(tools) workspace for enRoute so we can build an application in the next section.

Before you start this section, make sure you've checked the [prerequisites](100-prerequisites.html) for enRoute on your platform. 

## The Workspace

A workspace is a directory that has a specific layout so that bnd(tools) knows how to treat your projects. Since we will work in Eclipse we actually have 2 workspaces. The Eclipse workspace is a directory where Eclipse keeps its metadata and we keep that separated from the bnd(tools) workspace.

Since a bnd workspace for enRoute has some specific setup, we clone the workspace from a Github project, [osgi/workspace](https://github.com/osgi/workspace). 

So start an Eclipse Luna session and select a workspace. For our tutorials in OSGi enRoute we use the com.acme.prime workspace name, which is also the directory name. Let's place this test workspace in our home directory at `~/eclipse/com.acme.prime`.

Select `File/Switch Workspace/Other ...`. This gives you the following dialog:

![Switch Workspace](/img/qs/qs-switch-0.png)

After filling in the proper path and then closing the dialog by clicking `OK`, we get an Eclipse restart and should finally get:

![Start Screen](/img/qs/qs-switch-1.png)

### Import the Archetype Workspace

We can ignore the welcome screen. The next step is to link this Eclipse workspace to a bnd workspace. We therefore need to clone the [osgi/workspace](https://github.com/osgi/workspace). This process uses EGit, it is a tad cumbersome, quite a few steps.

Select `File/Import`. 

![Import archetype](/img/qs/git-import-0.png)

Then select the `Projects from Git`. 

![Import archetype](/img/qs/git-import-1.png)

If you click `Next` you should be see the following:

![Import archetype](/img/qs/git-import-2.png)

Select `Clone URI`, then `Next`, which gives us the window where we should enter the URI to the repository. 

![Import archetype](/img/qs/git-import-3.png)

You should then enter the URI; the URI that we should use is

> `https://github.com/osgi/workspace.git`

Select `Next` and then select the `master` branch.

![Import archetype](/img/qs/git-import-4.png)

Then select `Next` to go to the page where we will tell EGit to store our Git/bnd workspace in your file system.

![Import archetype](/img/qs/git-import-5.png)

By default Git places the projects in a sub directory `git` of your home directory (`~/git/...`). (This is an Eclipse preference.) We will follow this rather sane convention. However, the default name of the workspace is 'workspace' so we want to rename this to `com.acme.prime`.

So click `Next`, which will bring us to a page asking us if we should import the projects in this workspace. A resounding yes! (Even if there is only a single `cnf` project.)

![Import archetype](/img/qs/git-import-6.png)

When you click `Next` you get on a bit deja vu page but there is probably some reason we don't get.

![Import archetype](/img/qs/git-import-7.png)


So just click `Finish`. Which should give you a fresh new workspace, only beaten by the smell of freshly baked bread!

![Import archetype](/img/qs/git-import-8.png)

We've now created a workspace that will allow us to play with enRoute. Maybe a bit cumbersome with all the EGit steps but once you've mastered it is quite fast since most pages are just clicking `Next` to accept the defaults.

You have to restart Eclipse since there is a small chance that Eclipse will by default place new projects in the Eclipse workspace and not, as is absolutely required, in the Git/bnd workspace.
{: .bug}

Now, select the `Bndtools` perspective with `Window/Open Perspective .../Other ...'. This opens a selection dialog:

![Perspective Selection Dialog](/img/qs/workspace-bndtools-0.png)

Selecting `Bndtools` and clicking `OK` ensures that you are in the proper perspective. Your Eclipse should look similar to (at least after you refresh the repository view at the left bottom):

![Perspective Selection Dialog](/img/qs/workspace-bndtools-1.png)


### File System

Since we made changes to your file system, a short summary of where we placed what.

The Eclipse workspace was placed in a special place for Eclipse workspaces, the `~/eclipse` directory. We named this workspace `com.acme.prime`, which is a good name. The bnd workspace was placed also in your home directory, in the `~/git` directory, also under the name `com.acme.prime`; keeping the related Eclipse and Git/bnd workspace named identical is a a good practice.

	~/
		git/
			com.acme.prime/
				cnf/
					ext/
					build.bnd
					...
		eclipse/
			com.acme.prime/
				.metadata/
					...


## Next

In the next section of this quick start tutorial we will create a sample application. 
