## The Workspace

OSGi enRoute requires that you group a number of projects in a _bnd workspace_. A bnd workspace is basically a directory with a `cnf` directory. We start with a template workspace by getting it from git.


This is the BETA tutorial for OSGi enRoute 2.0.0. To use the right workspace template, 
go to Bndtools preferences and select `Workspace Templates`.  You should edit the
OSGi enRoute template and select the `next` branch.
{: .warning } 

This tutorial requires Bndtools 3.3.0 or later, the workspace templates were added in 3.2.0
{: .note}

We generally advise you to place things in your home directory (~). However, Eclipse does not recognize the tile (`~`) as a reference to your home directory so different paths are shown in the pictures.
{: .note}

## Two Workspaces???

First get some confusing stuff out of the way. We will have two (2) workspaces:

* _Eclipse_ – The Eclipse workspace. An Eclipse workspace is a directory with a `.metadata` directory. In OSGi enRoute tutorials we **never** place any projects in this directory. This directory will never be stored in Git or another SCM, it should therefore only contain your local preferences and information. To make it easy to switch between Eclipse workspaces, it is suggested to place all Eclipse workspaces in one easy to access directory. For example `/Ws/eclipse`.
* _bnd_ –  All _projects_ will reside in a single _bnd workspace directory_. The bnd workspace is stored in Git or an alternative SCM. It must therefore never contain any personal stuff. A bnd workspace is _flat_, the `cnf` directory and **all** project directories must reside in exactly the same parent directory, which is the _workspace directory_. Sorry, no exceptions. The bnd workspaces could be grouped in a directory for Git. Eclipse recommends `~/git`.

The structure is depicted in the following illustration:

![Eclipse & bnd workspace](/img/workspace/workspaces-layout.png)

## Opening Eclipse (Or Switching Workspace)

If you start Eclipse you will have to open the Eclipse workspace, see the previous issues. At the start of Eclipse (or when you do `File/Switch Workspace`) you will see the following dialog:

![Switch Workspace](/img/qs/qs-switch-0.png)

After filling in the proper path and then closing the dialog by clicking `OK`, we get an Eclipse restart. After Eclipse is done, we should finally get:

![Start Screen](/img/qs/qs-switch-1.png)

## Creating the bnd Workspace

To create a new bnd Workspace we use the `New/Other/Bndtools/Bnd OSGi Workspace` menu:

![Select New Workspace Wizard](/img/workspace/workspace-select.png)

Select `Bnd OSGi Workspace` and click `Next`. This will bring you to a dialog that allows you to specify the location of the bnd workspace. Here we must select the `Create in` radio button because it is bad practice to use the same directory for the bnd workspace as the Eclipse workspace as explained before.

![bnd workspace location](/img/workspace/location.png)

Clicking on `Next` will bring us to the window that selects the template that we will use. In this case we will obviously choose the OSGi enRoute template.

![Select OSGi enRoute Template](/img/workspace/select-enroute.png)

After you selected the template and clicked `Next` then Bndtools will show you proposed new content of the workspace in a list. If you would update an existing workspace you could control any conflicts.

![Content list](/img/workspace/empty-bnd-workspace.png)

In our case we just click `Finish` and we're done! Our Eclipse should look like:

![Empty IDE with just cnf](/img/workspace/bnd-empty-workspace.png)
