---
title: Exercise Services
layout: tutorial
lprev: 300-application.html
lnext: 050-start.html#End
summary: Using services in the Demo Application
---

## Using a Service

Currently we make a mortal error for Service Oriented Systems; we mix different types of functionality. The purpose of the `UpperApplication` class is to be a facade to the underlying services; it is very wrong to actually provide functionality in such a facade; its only purpose is to protect against outside evil and dispatch to the underlying (unprotected) service. 

So in this exercise you should create a service API and a provider. From a high level, this will consists of the following steps:

* Create an API. We will create an API project that exports an `Upper` interface to turn a string into upper case.
* Create a provider for the Upper service.
* Convert the `UpperApplication` class to use the Upper service.
* Add the provider to the set of run bundles

### Create an API

It is important to keep API code away from implementation code. If you store API and implementation in the same project it is too easy to leak implementation code to other projects that only require the API.
 
In OSGi enRoute this means the name of the project should end with `.api` and you should select the OSGi enRoute template. Let's call our general API project `com.acme.prime.api`. Why not `com.acme.prime.upper.api`? Well, we plan for the future; we want to reuse this project for other API as well. We could create a project per API but that tends to create hundreds of almost empty projects over time. Since a workspace should be a cohesive module, the APIs we define in this general API project are very likely to be also cohesive.

In this new project, we rename the template API to reflect our semantics. So rename the `com.acme.prime.api` package to `com.acme.prime.upper.api` and the `Prime.java` file to `Upper.java`. Then change the `Upper` class so that we can use it to change a word to upper case:

	public interface Upper {
		String upper(String input);
	}

If you have another API in the future, you can then add it to the same project in another package.

### Create a Provider

Now create a provider project for the Upper API. Call the project `com.acme.prime.upper.provider` and use the OSGi enRoute template. By default, this project does not see the API project so we should add it. This is done by double clicking on the `bnd.bnd` file in the `com.acme.prime.upper.provider` project and selecting the `Build` tab. On this tab, select the `+` and add the API project (double clicking works). This is added as `latest`, meaning that we use the version from the workspace.

We then should change the `UpperImpl` class to implement the `Upper` interface from our API project, so we must import `com.acme.prime.upper.api.Upper`. This class already is marked as a _component_ so that it registers its implemented interface as a service.

	@Component(name = "com.acme.prime.upper")
	public class UpperImpl implements Upper {
		public String upper(String input) {
			return input.toUpperCase();
		}
	}

In general, a provider bundle should export the API it _provides_; in our case we provide the contract specified in the `com.acme.prime.upper.api` package. Exporting this package is a highly recommended best practice, it makes a lot of things work better later on. You can export this package by selecting the `bnd.bnd` file in the `com.acme.prime.upper.provider` project, and then the `Contents` tab. Notice the import: `com.acme.prime.upper.api`. Drag this import to the export list and save the file. The imports now disappears.

### Change the Upper Application

We now need to change the `UpperApplication` class to use our new incredibly powerful service. Currently it has no dependencies so we should add the dependency on the Upper service. 

The first thing we need to do is to make sure the Upper Application can see the API project. So click on the `bnd.bnd` file, select the `Build` tab, and add the API project, just like we did in the provider project.

Then we change the `UpperApplication` component class. We must add a setter method for the `Upper` service with a `@Reference` annotation, which means we must import `org.osgi.service.component.annotations.Reference`. No we can add the reference to the end of the class (convention is to place references at the end):

	public class UpperApplication implements REST {
		...

		@Reference
		Upper upper;
	}

The `@Reference` annotation creates a dependency on this service; the `UpperApplication` component is not started until the service registry contains an Upper service. 

The next step is to use the `upper` instance variable that we've just set in the `getUpper` method (so we must import `com.acme.prime.upper.api.Upper` again).

	public String getUpper(String string) {
		return upper.upper(string);
	}

If the OSGi framework is still running, you likely get errors since we now have an unresolved requirement in our code; we're referring to the `com.acme.prime.upper.api` package which is now not provided by anybody.

### Add the Provider to the Set of Run Bundles

We've changed our dependencies so we need to re-resolve our run bundles. So go to the `com.acme.prime.upper.application` project and select the `com.acme.prime.upper.bndrun` file by double clicking, select the `Run` tab. Hit the `Resolve` button and then verify that the `com.acme.prime.upper.provider` has been added. Save the `com.acme.prime.upper.bndrun` file. This should automatically deploy the set of run bundles in the running framework. Just refresh the browser and check if it still works! If not, well, then your intermediate exercise is to debug it :-)

