---
title: Ant, Ivy, P2
summary: An toolchain with Ant, Ivy and P2 
--- 

This page describes an Ant/Ivy and p2 based toolchain with OSGi support
from Bundlor.

Purpose
-------

The toolchain described on this page is suitable for creating standard
OSGi Bundles. It supports both development in the Eclipse IDE as well as
command-line builds using Ant.

A project with 2 bundles is created:

-   A bundle containing a service that implements an API
-   A web bundle with a consumer of the service

Note that this description assumes some basic knowledge of what build
systems do. For more information on Ant in general see:
[1](http://ant.apache.org/). For more information on Ivy in general see:
[2](http://ant.apache.org/ivy/index.html).

This example is based on OSGi 4.2 APIs.

The example project used in this description is available [here in
github](https://github.com/cgfrost/osgi-toolchain-ant-ivy-p2-bundlor).

The Ivy p2 support is experimental and should not be used in production
-----------------------------------------------------------------------
