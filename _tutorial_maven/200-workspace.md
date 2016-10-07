---
title: The Workspace
layout: tutorial
lprev: 100-prerequisites
lnext: 300-background
summary: Setup a bnd workspace
---

## What you will learn in this section
We will setup a bnd(tools) workspace for OSGi enRoute so we can change it to a Maven setup in the next section. 

Before you start this section, make sure you've checked the [prerequisites](100-prerequisites) for OSGi enRoute on your platform. 

{% include workspace.md %}

## Existing Setup

The standard OSGi enRoute setup uses a Maven repository and a number of indexed repositories. You can find these definitions in `./cnf/ext/enroute.bnd` and `./cnf/ext/enroute-distro.bnd`. Look at the created plugins. In this tutorial, we will replace the Release repository and the Maven Central repository by overwriting the values for their plugin definitions.

In a company wide setup it is recommended to create a custom workspace that has this setup.

## Next

In the next section of this quick start tutorial we will create a sample application. 
