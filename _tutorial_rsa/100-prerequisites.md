---
title: Prerequisites
layout: tutorial
lprev: /book/510-tutorial-rsa.html
lnext: 120-introduction.html
summary: The prerequisites for the use of OSGi enRoute (Important!)
---

{% include prerequisites.md %}

## Level

In this tutorial we assume that you've followed the [quick start tutorial][qs] and are familiar with Eclipse. We will therefore not show the steps to create a project or a bndrun file in detail. That is, if you don't know whay resolving is then you will not be able to make this tutorial. So if you have not done the quickstart tutorial yet then it is highly recommended to this first.

## Setting Up bndtools

The next setup is the Eclipse works. Please follow the [quick start tutorial][qs] or if you're ambitious the [base tutorial][base]. For this tutorial, you should create a new workspace as described in the tutorials. Make sure you get the latest version workspace from github.

The git commands to create a new workspace are:

	cd  ~/git
	git init com.mycompany.chat
	cd com.mycompany.chat
	git fetch --depth=1 https://github.com/osgi/workspace master
	git checkout FETCH_HEAD -- .
{: .shell}

As advised in the [quick start tutorial][qs], you should open an Eclipse workspace in another directory, for example, `~/eclipse/com.mycompany.chat` and the import the `cnf` project from your git workspace ( `~/git/com.mycompany.chat` in the command line example).

In the tutorial we will use `osgi.enroute.examples.chat` as the workspace name. It is recommended to choose a name that is more logical for yourself.

[qs]: http://enroute.osgi.org/book/200-quick-start.html
[base]: http://enroute.osgi.org/book/220-tutorial-base.html
