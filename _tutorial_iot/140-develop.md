---
title: Developing
layout: tutorial
prev: 120-exploring.html
summary: Developing a Java program on the Pi
---

## Hello World

Let's start very simple with a sample `Hello` and `Goodbye` world example. In the project, create the following simple component that we will extend later to have some commands:

	package osgi.enroute.iot.domotica.command;

	import org.osgi.service.component.annotations.Activate;
	import org.osgi.service.component.annotations.Component;
	import org.osgi.service.component.annotations.Deactivate;
	
	@Component
	public class DomoticaCommand {
	
		@Activate
		void activate() {
			System.out.println("Hello World");
		}
	
		@Deactivate
		void deactivate() {
			System.out.println("Goodbye World");
		}
	}
	
Again, make sure to use your own package names.

## Setting up a bndrun File

A bndrun file defines the framework, properties, class path, and the set of bundles. When you create an application project, the OSGi enRoute template sets up two bndrun files:

* `[name of the application].bndrun` – This is the top level bndrun file. It contains the initial requirements
* `debug.bndrun` – This file includes the `[name of the application].bndrun`, it adds a number of debug bundles


