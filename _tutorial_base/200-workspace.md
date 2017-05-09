---
title: The Workspace
layout: tutorial
lprev: 100-prerequisites.html
lnext: 300-api.html
summary: Create and manage a bnd workspace
---

## What you will learn in this section

In this section you will learn what a bnd workspace is and how it relates to the Git and Eclipse workspaces. We will address naming and how to use a ready made enRoute workspace template from github to get all the settings we need in one go. At the end of this section you will have a new workspace.

Optionally, you can learn how Eclipse, Git, enRoute, and bnd workspaces relate to each other.

Before you start this section, make sure you've checked the [prerequisites](100-prerequisites.html) for OSGi enRoute on your platform. 

In the next section you learn how to set up a workspace. For this tutorial you must ensure you have a new workspace. If you've done the quickstart
tutorial you might already have a workspace. Delete it or use one with another name for this tutorial to not get confused.

{% include workspace.md %}

## How Does it Work?

It helps to understand how the workspace is layed out. An Eclipse workspace is a directory where Eclipse stores its metadata, e.g. the plugins persistent storage or the history. Though it can be used to also store the actual projects, it is in general not a good idea, especially if you use a source control system. EGit can actually become quite slow when you include the Git workspace.

Therefore, the best way to work with projects in Eclipse is not to store them in the Eclipse workspace folder but to import them from another directory.

For bnd, a workspace is a directory with a `cnf` folder and a number of projects. This is a flat space; hated by many but it works quite well because it is very simple and hard to get wrong. Don't count on it changing so do not try to work around it, you'll regret it. The `cnf` folder contains a `build.bnd` file and a `ext` directory which together define the workspace properties.

A bnd workspace is like a module; it imports bundles (and JARs) from a repository and it exports bundles to the same or another repository. On the inside we have projects that are private to the workspace. The projects should be cohesive so that they can share information via the `cnf` project.

The Git workspace is a directory that has a `.git` sub directory. When used with bnd, the Git workspace and the bnd workspace overlap. That is, the bnd workspace is a single Git workspace. Projects do not have their own repositories. 
