---
title: Tutorials
layout: book
---

This section is an entry to the hopefully growing collection of tutorials that OSGi enRoute provides. If you want to develop an additional tutorial, please submit a PR.

## Quick Start

![Thumbnail for Quick start Tutorial](/img/qs/app-0.png)
{: .thumb200-l }

In this quick start we develop a little project that, creates a single page web-application. This tutorial is light on the explanations because it focuses on introducing the overall architecture of enRoute, not the details.  We will cover the whole chain, from creating a workspace all the way to continuous integration.

A disclaimer. This quick start is about learning to use OSGi enRoute, not about learning Java, Git, nor Eclipse. It is assumed that you have basic experience with these tools.

[Go to the Quick  Start tutorial](/qs/050-start.html)

{: style='clear:both;' }

## Base Tutorial

![Thumbnail for Base Tutorial](/img/tutorial_base/debug-xray-1.png)
{: .thumb200-l }

The Base Tutorial is a very extensive tutorial that takes you to all the principles. It starts from scratch and it brings you all the way to a release cycle with continuous integration. It is absolutely worth the effort to go through this tutorial to really learn OSGi.

[Go to the Base Tutorial](/tutorial_base/050-start.html)

{: style='clear:both;' }

## A Maven ONLY Tutorial for an Eval Service

![Thumbnail for Maven Tutorial](/tutorial_eval/img/tutorial_eval.png)
{: .thumb200-l } 

THIS IS IN BETA FOR NOW

This tutorial mirrors the base tutorial but uses Maven instead of Bndtools. It
takes you to the process of creating a small web application with an expression
evaluator with nothing but mvn and vi. It shows how to do API based design,
it creates 2 providers, a Gogo command, and a web app. It also shows how to
do integration testing with maven.

[Go to the Maven Eval Service Tutorial](/tutorial_eval/050-start.html)

{: style='clear:both;' }

## IoT Tutorial

![Thumbnail for IoT Tutorial](/img/tutorial_iot/exploring-led-breadboard-1.png)
{: .thumb200-l }

The Internet of Things ... a concept that has as many definitions as there are things you can connect to the Internet. However, most definitions place an emphasis on the _edge devices_ and the _gateways_, which is of course right in the realm that was the raison d'être of OSGi already so long ago.

This tutorial uses OSGi enRoute to develop an application for a [Raspberry Pi][pi]. The Raspberry Pi is a formidable machine that would put many laptops to shame a few years ago. The OS is Linux and it has lots of inputs and outputs. For OSGi enRoute, we've developed a number of bundles that allow you to play with the Raspberry. This tutorial will explain how to get started with the Raspberry Pi and then show how to do interesting things.

[Go to the IoT Tutorial](/tutorial_iot/050-start.html)

{: style='clear:both;' }

## Distributed OSGi with Zookeeper

![Thumbnail for IoT Tutorial](/img/tutorial_rsa/rsa-service-0.png)
{: .thumb200-l }

This tutorial takes you through the steps to build a trivial Chat application using distributed OSGi. We first build a service API for a Chat client and use this API in an implementation. Then we add a command to test the implementation. After this works, we run a Zookeeper server from Bndtools. This Zookeeper server is used by the Amdatu Distributed OSGi implementation to distribute the Chat services. To finish it off, we create a client in the browser. 

[Go to the Distributed OSGi with Zookeeper Tutorial](/tutorial_rsa/050-start.html)

{: style='clear:both;' }

## Maven Bnd Repository

![Thumbnail for Maven Tutorial](/tutorial_maven/img/maven.gif)
{: .thumb200-l }
The Maven Bnd Repository Plugin provides full bi-drectional access to the local Maven repository, remote repositories like Maven Central, and company wide repositories like Nexus and Artifactory. In this tutorial we take the plugin for a ride. We first use the plugin to get access to Maven Central resources. Then we setup the build that all JARs end up in the local Maven repository so that they can be used by any Maven project. We then show how to link in Maven projects. Last but not least we demonstrate how to release snapshots and releases to Maven Central.


[Go to the Maven Tutorial](/tutorial_maven/050-start.html)

{: style='clear:both;' }
  




[pi]: https://www.raspberrypi.org/


