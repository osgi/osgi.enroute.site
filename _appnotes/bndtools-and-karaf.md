---
title: Integrate Apache Karaf and Bnd toolchain
summary: Shows how to leverage Bnd remote debugger to integrate Bnd and Apache Karaf
---

[Bnd remote launcher](http://bnd.bndtools.org/chapters/300-launching.html) allows debugging bundles and Bndrun files in Eclipse using a remote Apache Karaf instance as the target OSGi runtime. This is a very convenient way to combine Apache Karaf features with the power of Bndtools OSGi toolchain.

In this app note we're going to build a simple declarative service and we are going to use Apache Karaf as a remote OSGi target runtime to debug the ds from within Eclipse.

A complete working example is available at https://github.com/mrulli/com.flairbit.examples.karaf-debug.

## Set up the Karaf runtime
You can download the [latest Apache Karaf distro](http://karaf.apache.org/download.html) and you can unpack it somewhere in your filesystem. You can launch Karaf with:

```
$ apache-karaf-4.0.5/bin/karaf debug
Listening for transport dt_socket at address: 5005
        __ __                  ____      
       / //_/____ __________ _/ __/      
      / ,<  / __ `/ ___/ __ `/ /_        
     / /| |/ /_/ / /  / /_/ / __/        
    /_/ |_|\__,_/_/   \__,_/_/         

  Apache Karaf (4.0.5)

Hit '<tab>' for a list of available commands
and '[cmd] --help' for help on a specific command.
Hit '<ctrl-d>' or type 'system:shutdown' or 'logout' to shutdown Karaf.

karaf@root()> 
```
The `debug` switch opens a listening jdb port on 5005.

The bundle under development (*BUD*) that we are going to debug provides a declarative service so we need to install SCR Karaf feature too:

```
karaf@root(bundle)> feature:install scr
```

To deploy and debug our BUD we need to install the Bnd remote agent on Karaf and start it:

```
karaf@root(bundle)> install mvn:biz.aQute.bnd/biz.aQute.remote.agent/3.2.0
Bundle ID: 86
karaf@root(bundle)> start 86
Host localhost 29998
karaf@root(bundle)> 
```

The line `Host localhost 29998` means the remote agent is ready to interact with our eclipse IDE through the default Bnd agent port (29998).

Now the Karaf runtime is ready to be used for our debugging session. 

## The *bundle under development*
You can create a new Bndtools project using the *Bnd OSGi Project* project wizard in Eclipse. Select the OSGi enRoute template and create a `*.example` template project. This creates a declarative service with a simple "Hello World" API and a gogo command:

```
g! example:example yourstring
World:yourstring
```
Now we want to automatically install the BUD jars in Apache Karaf and debug them remotely from within Eclipse. 

To do that we have to edit a little bit the `debug.bndrun`: open it and substitute its content with this (let's assume your project is called `com.example.karafdbg.example`):

```
-runpath: biz.aQute.remote.launcher

-runremote: test;\
	shell   =   -1; \
	jdb     =   5005; \
	host    =   localhost; \
	agent   =   29998; \
	timeout =   10000

-runproperties: gosh.args=--noshutdown

-runtrace: true

-runbundles: \
	com.example.karafdbg.example.api,\
	com.example.karafdbg.example.command,\
	com.example.karafdbg.example.provider
```

The `debug.bndrun` now contains the remote debugger configuration, in particular it teaches the Bnd remote launcher how to contact the agent installed on Karaf: the `-runremote` directive specifies 

* how to interact with the remote OSGi shell
* the JDB debug port the remote container is listing on
* the hostname for the remote OSGi runtime
* the remote agent listing port
* connection timeout in seconds

In particular, the `shell = -1` option allows the remote launcher to play nicely with the native Karaf OSGi console. 

The details are fully explained in the [Bndtools docs](http://bnd.bndtools.org/chapters/300-launching.html).

## Launching
Right click on `debug.bndrun` file and select `Debug As -> Bnd Native Launcher`. As soon as the debug session starts, the followin message pops up in Karaf

```
karaf@root(bundle)> World:Hello
```

That means the agent received the BUD and successfully installed (and started) them on the target Karaf runtime!

You can set your breakpoints around now: note that the gogo shell and the Karaf shell are not mutually exclusive: it is possible to invoke the `SimplebundleCommand` right from the Karaf console

```
karaf@root(bundle)> example:example your-name-here
World:your-name-here
karaf@root(bundle)> 
```
gogo commands are a handy way to experiment with breakpoints.

## Stop the debug session
To terminate the debugging session and automatically clean up all the things in the target Karaf runtime, just **disconnect** the eclipse remote debugger and after that **stop** the debug session. As soon as you do that, the remote agent uninstalls all the BUDs:

```
karaf@root(bundle)> Listening for transport dt_socket at address: 5005
World:Goodbye

karaf@root(bundle)> 
```
Everything is now ready for a new debug session.
