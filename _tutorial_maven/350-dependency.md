---
title: Adding a Dependency to the Provider
layout: tutorial
lprev: 310-central
lnext: 330-
summary: Add an extra dependency on the provider's Maven Project
---

Currently, the Maven project has no external bundle dependencies because we wrap the PARSII parser. This raises the question, what happens if it had a dependency on a bundle? To make it all work, we need to find that bundle also on the Bndtools side when we resolve the application.

Therefore, this section explores the steps to add the Guava bundle to the provider using its the `factorial` function and then running the resolver on the application. 

## Adding an Additional Dependency

We need to add the following Guava dependency to our pom in `osgi.enroute.examples.eval.provider`:

		<dependency>
			<groupId>com.google.guava</groupId>
			<artifactId>guava</artifactId>
			<version>19.0</version>
		</dependency>

## Updating the Source

After you change the pom you need to update the Maven project. (Option refresh F5 on the Mac.)This will set the class path container to include the Guava dependency.

We can now change the source code and add an `activate` method that registers a new function:

		@Activate
		void activate() {
			Function fact = new Function() {
	
				@Override
				public int getNumberOfArguments() {
					return 1;
				}
	
				@Override
				public double eval(List<Expression> args) {
					double value = args.get(0).evaluate();
					return DoubleMath.factorial((int) value);
				}
	
				@Override
				public boolean isNaturalFunction() {
					return true;
				}
			};
	
			Parser.registerFunction("factorial", fact);
		}

It falls outside the scope of this tutorial but registering a function with a static method is error prone in OSGi because it can prevent garbage collection of class loaders. In the `osgi.enroute.examples.maven` repository you'll find a proper solution within the possibilities of the used library.
{: .warning }

We now need to install our project in the local Maven repository. Do `Run As/Maven Install`.

## In the Mean Time on the Bndtools Side

After we install the Maven project, we should get an error in the running `osgi.enroute.examples.eval.application` project. The following error should be reported after about 5 seconds when the Bnd Maven Repository detects that the `osgi.enroute.examples.eval.provider` project has changed in the local Maven repo:

	! Failed to start bundle osgi.enroute.examples.eval.application-1.0.0.201604110918, 
	      exception Could not resolve module: osgi.enroute.examples.eval.application [8]
	  Unresolved requirement: Import-Package: osgi.enroute.examples.eval.api; version="[1.0.0,2.0.0)"
	    -> Export-Package: osgi.enroute.examples.eval.api; 
	    	bundle-symbolic-name="osgi.enroute.examples.eval.provider"; 
	    	bundle-version="1.0.0.201604110917"; version="1.0.0"
	       osgi.enroute.examples.eval.provider [9]
	         Unresolved requirement: Import-Package: com.google.common.math; version="[19.0.0,20.0.0)"
	
	! Failed to start bundle osgi.enroute.examples.eval.provider-1.0.0.201604110917, 
		exception Could not resolve module: osgi.enroute.examples.eval.provider [9]
	  		Unresolved requirement: Import-Package: com.google.common.math; version="[19.0.0,20.0.0)"

Agreed, this diagnostics output is not always easy to understand. However, in general the culprit is at the end. (But not always!) In this case, it is at the end. It is clear that the we're missing the package `com.google.common.math`. 


## Resolving

The first thing we should do is to resolve. However, since Guava is not yet in our repository, this gives us a similar error. 

	org.osgi.service.resolver.ResolutionException: 
		Unable to resolve <<INITIAL>> version=null: 
			missing requirement osgi.enroute.examples.eval.application 
	->  Unable to resolve osgi.enroute.examples.eval.application 
		version=1.0.0.201604110918: 
			missing requirement objectClass=osgi.enroute.examples.eval.api.Eval 
	->  Unable to resolve osgi.enroute.examples.eval.provider 
		version=1.0.0.201604110917: 
			missing requirement com.google.common.math; version=[19.0.0,20.0.0)]]

So we now need to add the Guava dependency to the repository. Adding these type of dependencies is explained in [Central](310-central).

When we now resolve, the resolution is satisfied. Saving the `osgi.enroute.examples.eval.bndrun` file will update the list of `-runbundles`. 

## Running 
Unfortunately, we need to restart the application because files in the local Maven repository do not change their name. This means that Bndtools currently does not see the update.
 
We can now enter:

	G! expr "factorial(10)"
	expr "factorial(10)"
	3628800.0
{: .shell }


	






 
