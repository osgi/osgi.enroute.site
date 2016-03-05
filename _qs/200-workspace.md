---
title: The Workspace
layout: tutorial
lprev: 100-prerequisites.html
lnext: 300-application.html
summary: Setup a bnd workspace
---

## What you will learn in this section
We will setup a bnd(tools) workspace for OSGi enRoute so we can build an application in the next section.

Before you start this section, make sure you've checked the [prerequisites](100-prerequisites.html) for OSGi enRoute on your platform. 

{% include workspace.md %}

### File System

Since we made changes to your file system, a short summary of where we placed what.

The Eclipse workspace was placed in a special place for Eclipse workspaces, the `~/eclipse` directory. We named this workspace `com.acme.prime`, which is a good name. The bnd workspace was placed also in your home directory, in the `~/git` directory, also under the name `com.acme.prime`; using the same name for both the Eclipse and bnd workspaces is a good practice.

## Next

In the next section of this quick start tutorial we will create a sample application. 
