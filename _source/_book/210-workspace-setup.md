---
title: Workspace Setup
layout: book
summary: A discussion of how to setup the workspace.
---

In the simplistic setup we overlap the Eclipse workspace with the bnd workspace. This is ok for a quick try but has the disadvantage that the Eclipse preferences are under source control. Though you can easily prevent the Eclipse .metadata directory from being shared, it means that it becomes discardable by the source control system. That is, if you restore the git workspace with `git clean -fdx` then you delete all files that are ignored. Kind of disappointing to see all that work you spent on that fancy color scheme being nuked. It happened many times to us.

For this reason, a much better setup is to separate the Eclipse workspace from the bnd workspace. After lots of research, deep thinking coffee, and long lunches we came to the following setup as best practice:

    /<workspaces path>/                      path to all your workspaces
      com.workspace.topic/                   A workspace directory
        .metadata/                           The Eclipse workspace metadata
        scm/                                 The directory under source control
          .git/                              The scm metadata directory
          cnf/                               The bnd(tools) configuration project
          com.workspace.topic.subject.<ext>/ A project directory
            ...
                        
This setup makes it easy to throw away a temporary workspace since the bnd workspace is nested in the Eclipse workspace but it makes it impossible to nuke your Eclipse preferences and history.

There are several ways to correctly setup the Eclipse and bnd workspaces. These are discussed in the following sections.

* [Setting Up a Workspace with bndtools](#bndtoolsws)
* [Setting Up a Workspace with bnd](#bndws)
* [Setting Up a Workspace manually](#manually)

##<a name="bndtoolsws"></a> Setting Up a Workspace with Bndtools
Bndtools can setup a new workspace from git with everything initialized. This works as follows.

* Start bndtools, and create a new workspace. Eclipse will prompt you for a place to put the Eclipse workspace. It is best practice to follow these guidelines:
  * Gather all workspaces in a single directory. Believe me, you will create lots of them. 
  * Use a short path for your workspaces collection without spaces, if you use a shell it is a lot easier to get to and many tools barf on spaces in a path. Best practice is to use `/Ws` or so (this is what we assume in the following examples.
  *  Do name the workspace with a really unique name, this makes it possible to share it with others. Also make sure to take advantage of the sorting order so that long lists remain readable. The reverse domain name is quite workable for this goal. 
  
  E.g. `com.acme.prime`, the path is therefore `/Ws/com.acme.prime`.

Once you've started bndtools on the `/Ws/com.acme.prime` folder as workspace, you can import a git project. For this, select `File/Import`. This shows a dialog where you can select the Git import.

![Select Import and then Git](/img/book/qs/gitimport.jpg)

Proceeding, with `Projects from Git` gives us:

![Select the Clone URI](/img/book/qs/cloneuri.jpg)

Where we will select the `Clone URI`. The next page in the wizard allows us to specify where to clone from. The OSGi enRoute project has a nice archetype for you where everything is setup nicely:

    git@github.com:osgi/osgi.enroute.archetype.git

So we should fill this in in this dialog:

![Import the archetype](/img/book/qs/settings.jpg)

Then we need to select the master branch:

![Import the archetype](/img/book/qs/branch-selection.jpg)

If we click on `Next`, then we must provide the location of the bnd workspace, this is where the proverbial beef hits the ground, or something like that. By default, Eclipse's git will try to store this in your user home directory, in the `git` folder. However, as discussed earlier, we want it in a subfolder of our Eclipse workspace. Therefore, we place it in `/Ws/com.acme.prime/scm`.

![Select the scm folder](/img/book/qs/destination.jpg)

The next step is to import any projects from the archetype workspace. 

![Import projects](/img/book/qs/import-projects.jpg)

We can now end this tedious process and hit finish. If we then select the `Bndtools` perspective, we get something like the following views in our Eclipse:

![Final result](/img/book/qs/final.jpg)


##<a name="bndws"></a> Setting Up a Workspace with bnd

##<a name="manually"></a> Setting Up a Workspace manually



