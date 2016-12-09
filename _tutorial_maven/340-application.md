---
title: Assembling an Application in Bndtools
layout: tutorial
lprev: 330-maven-project
lnext: 350-nexus
summary: Assemble an application, with the resolver, that includes the Maven Eval provider project
---

The goal of this section is to create a `bndrun` file for an application that depends on the Maven Eval provider project. We want to assemble this application with the _resolver_. This requires that our Maven Bnd Repository is also an OSGi repository. We need to set this up because this is not automatically the case.

## Application

As application, let's create a minimal Gogo command that calls the Eval service.

For this, create the `osgi.enroute.examples.eval.application` project. The template turns this into a full blown web application so you can throw away the following directories:

	static
	web
	configuration
	
This generates some errors in the `bnd.bnd` file, just get rid of the `-includeresource` instruction that included those directories.

You can add the following source code:

	package osgi.enroute.examples.eval.gogo;
	
	import org.osgi.service.component.annotations.Component;
	import org.osgi.service.component.annotations.Reference;
	
	import osgi.enroute.debug.api.Debug;
	import osgi.enroute.examples.eval.api.Eval;
	
	/**
	 * This is the implementation. It registers the Gogo interface and calls it
	 * through a Gogo command.
	 * 
	 */
	@Component(service=EvalCommand.class, property = { Debug.COMMAND_SCOPE + "=eval",
			Debug.COMMAND_FUNCTION + "=expr" }, name="osgi.enroute.examples.eval.gogo")
	public class EvalCommand {
		
		@Reference
		private Eval target;
	
		public Object expr(String message) throws Exception {
			return target.eval(message);
		}
	
	}

This implements the `eval:expr` command.

##  Assembly

We now have to create a runtime environment where we have the following parts:

* The Gogo command/application bundle (In the Workspace)
* Gogo (In the OSGi enRoute Distro repository)
* The provider we created in the Maven project

The first entries are in our repositories but the last entry is so far invisible to us. Since this project is only locally available we need to make it available in the Local repository. We do this by editing the `./cnf/local.mvn` file. We add the coordinates of the Maven project:

	osgi.enroute.examples:osgi.enroute.examples.eval.provider:1.0.0-SNAPSHOT

This will make it available in the Repositories view.

## Resolving

We can now double click on the `osgi.enroute.examples.eval.bndrun` file in the `osgi.enroute.examples.eval.application` project. We can now drag the requirements from the repositories to the `Run Requirements` list in the usual fashion. Make sure the application is added to the initial requirements. You should also add the Gogo shell `(osgi.identity=org.apache.felix.gogo.shell)`. Although the application project provides a Gogo command, it does not have a dependency on Gogo.

If you resolve then you get the following bundles (or similar):

	-runbundles \
		org.apache.felix.configadmin;version='[1.8.6,1.8.7)',\
		org.apache.felix.gogo.runtime;version='[0.16.2,0.16.3)',\
		org.apache.felix.log;version='[1.0.1,1.0.2)',\
		org.apache.felix.scr;version='[2.0.0,2.0.1)',\
		org.eclipse.equinox.metatype;version='[1.4.100,1.4.101)',\
		org.osgi.service.metatype;version='[1.3.0,1.3.1)',\
		osgi.enroute.examples.eval.application;version=snapshot,\
		osgi.enroute.examples.eval.provider;version='[1.0.0,1.0.1)',\
		org.apache.felix.gogo.shell;version='[1.0.0,1.0.1)'

We can now run the command by clicking on the `Debug` icon at the top right:

	.
	             ____
	   ___ _ __ |  _ \ ___  _   _| |_ ___ 
	  / _ \ '_ \| |_) / _ \| | | | __/ _ \
	 |  __/ | | |  _ < (_) | |_| | |_  __/
	  \___|_| |_|_| \_\___/ \__,_|\__\___|
	              http://enroute.osgi.org/
	              
	G! eval:expr "1 + sqrt(4)"
	3.0



 

