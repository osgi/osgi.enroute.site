---
title: Exporting an Application
layout: tutorial
prev: 600-testing.html
next: 800-ci.html
summary: Creating a sample application and deploying it.
---

## What You Will Learn in This Section

How To export and application so that the whole framework can be run as an executable jar.
 
## Exporting

This was fun, ok, at least not bad. But how do we deploy this? How do we get this running on our target environment? Well, we can make this into an application, an executable JAR file. 

We start by double clicking the `com.acme.prime.eval.bndrun` file and selecting the `Run` tab. Remember where we found the `Debug OSGi` button, on the right top of the `bndrun` `Run` tab. A little bit more to the right you find an `Export` button. 

![Application bndrun](/img/tutorial_base/deploy-bndrun-2.png)

Clicking the `Export` button shows you a dialog that asks you where to store the exeecutable JAR on the file system:

![Application bndrun](/img/tutorial_base/deploy-export-1.png)

Select the `Executable JAR`, and save this on your desktop under the name `com.acme.prime.jar`. 

![Application bndrun](/img/tutorial_base/deploy-export-2.png)

This JAR is quite wondrous: it has no external dependencies. To execute it, you should open a shell on your desktop:

	$ java -version
	java version "1.8.0"
	Java(TM) SE Runtime Environment (build 1.8.0-xxx)
	Java HotSpot(TM) 64-Bit Server VM (build xxxx, mixed mode)
	
	$ java -jar com.acme.prime.jar
	____________________________
	Welcome to Apache Felix Gogo	
	g! eval:eval 3+4+5+6+7+8+9
	42.0
{: .shell }

Isn't there more in the universe? It does makes you wonder that so many sums have this answer?

Anyway, when you had enough math you can quit this app by hitting control-c.

## How Does it Work?

`bndrun` files define the requirements on a desired runtime. When the `Resolve` button is hit, the bnd _resolver_ looks at the initial requirements and will try to find resources in the repositories that together match those requirements and the requirements from the introduced resources. The resulting set of bundles defines a runtime, these bundles are set in the `-runbundles` instruction.

A runtime environment can then executed to verify it, potentially resulting in some modifications. If the result is ok, then the export function of bnd is used.

The bnd export goes through a plugin; this is the same plugin that manages the launching. In this case this is the default `aQute.launch` plugin. The plugin takes the runtime environment and creates a JAR that contains all the dependencies, including itself and any properties; creating a JAR that is completely self contained.
