---
title: Provider Project
layout: tutorial
lprev: 300-api.html
lnext: 340-junit.html
summary: Create a project that provides an implementation of the Eval service.
---

## What you will learn in this section

In this section we create another project that provides an implementation for our Eval API, a so called _provider_.

## Create a Provider Project

In the previous section we created an API for an expression evaluator. We now need a so called *provider* for this service. A provider is responsible for the contract defined in the API so that *consumers* can use the service. In the case of the Eval service the consumer will call the `eval(String)` method and the provider must implement it. In the previous section we also learned that the last segment in the project name defines its *type*; this is supported by OSGi enRoute templates. A provider project must therefore have a name that ends in `.provider`. We also like to start the project name with the workspace, the service API name and an indication of what kind of implementation this is. Well, this is going to be an awful simple implementation, so the name should be:

	com.acme.prime.eval.provider

So let's create a new project with this name. In Eclipse, choose `New/Bndtools/Bnd OSGi Project`. Enter the new name (`com.acme.prime.eval.provider`), select the OSGi enRoute templates, and follow the defaults.

![Provider Project](/img/tutorial_base/provider-create-0.png)

## Implementation

Our friendly OSGi enRoute template already has created a `EvalImpl.java` class for us. This is already setup as a Declarative Service (DS) µservice component because the `@Component` annotation was added. If your component class implements one or more interfaces, then these will be registered as OSGi services. So in this case, we want to implement an `Eval` interface so that we're registered as an Eval service. So the first thing we should do is add this `Eval` interface to the class:

	@Component(name = "com.acme.prime.eval")
	public class EvalImpl implements Eval { }
	
## Build Path
 
Unfortunately, this causes an error; Eclipse cannot find the `Eval` class because we're not linked to the `com.acme.prime.eval.api` project yet. Hold your temptation to add this to the Eclipse Build Path because this will then fail later in the continuous integration where there is no Eclipse. Nope, we must add the dependency to bnd to get fidelity between our user friendly Eclipse world and the software engineering world of continuous integration. 

The dependencies of bnd are defined in the `bnd.bnd` file. We can control the build path through the build path editor. Double click on the `bnd.bnd` file and select the `Build` tab.

![Build Tab](/img/tutorial_base/provider-create-1.png)

This tab not only shows you the bnd errors, it also shows you the current build path (OSGi enRoute API, JUnit, etc). To add the API project, click on the green plus ('+') just above the list. This pops up a list of all the *repositories*. As you can see, the top repository is the workspace and contains our API project. 

![Adding to the Build Path](/img/tutorial_base/provider-create-2.png)

You can type text in the search box to filter the list. Double click the `com.acme.prime.eval.api` project and click in `Finish`. Save the `bnd.bnd` file because otherwise there is no effect.

You can now go back to the `EvalImpl` class and import the `Eval` interface. Just select the `Eval` name (which is red underlined) and click `Control-1`. You then click on Command-1, and select  `Import 'Eval' (com.acme.prime.eval.api)`. This will take care of the import. Don't forget to save!

Bugger, still errors!

##  Code

Alas, we got rid of the import error but in place of this error we now get a red underlined `EvalImpl` class. The problem is that we need to provide the `eval` method as prescribed by the Eval interface that it now implements. Let's keep it simple:

	@Component(name = "com.acme.prime.eval")
	public class EvalImpl implements Eval {
		Pattern EXPR = Pattern.compile( "\\s*(?<left>\\d+)\\s*(?<op>\\+|-)\\s*(?<right>\\d+)\\s*");
		
		@Override
		public double eval(String expression) throws Exception {
			Matcher m = EXPR.matcher(expression);
			if ( !m.matches())
				throw new IllegalArgumentException("Invalid expression " + expression);
			
			double left = Double.valueOf( m.group("left"));
			double right = Double.valueOf( m.group("right"));
			switch( m.group("op")) {
			case "+": return left + right;
			case "-": return left - right;
			}
			return Double.NaN;
		}
	}
 
Ok, ok, simple might still give it too much credit but we're not here to learn parsing. At least it has (some) error handling! Notice that we can only handle trivial additions and subtractions of constants.

## Imports

It is about time now to take a look at what our module (bundle) really looks like. Let's double click on `bnd.bnd` and select the `Contents` tab. This tab shows us how the bundle is layed out:

* Private packages – Packages that are only available inside the bundle. Another bundle could have the same name for the package but different contents.
* Exported packages – Packages that we provide to other bundles and which we are supposed to maintain over time.
* Imported packages – Packages we expect someone else to export, hoping that they are as good as we will be in maintaining that package over time.

![Contents](/img/tutorial_base/provider-imports-0.png)

If we translate this to a picture with the standard OSGi notation it looks as follows:

![Bundle Layout](/img/tutorial_base/provider-imports-1.png)

We can see that our simple bundle is importing the `com.acme.prime.eval.api` package to get the `Eval` interface. This is quite unpleasant for our users since they are forced to always download two bundles. Since the service API package and our simple implementation are tightly coupled (virtually any change will force a change in our provider) we can simplify the life of our customers by exporting the API from our provider bundle. This can be done by dragging the imported package in the right 'Import Packages' list to the Exported Package list and dropping it there. If there is already an export of the `com.acme.prime.eval.api` then you should remove it, it is a placeholder.

After you save the `bnd.bnd` file, you'll see that the imports disappear.

![Exporting the  API](/img/tutorial_base/provider-imports-2.png)

Exporting the API should only be done by the providers of the service API, never by the consumers.

Note that the OSGi enRoute templates setup the API projects in such a way that they cannot be used in runtime and therefore require that the provider exports them.
{: .note }

Anyway, our bundle now looks different:

![Exporting the  API](/img/tutorial_base/provider-imports-3.png)


## How Does it Work?

The concepts of consumers and providers can be confusing, mostly because they are often confused with implementers of an interface and clients of an interface. However, providers of a service API can both implement and/or be a client of interfaces in the service package. A provider is responsible for providing the value of the contract and a consumer receives the value of the contract. The reason we need to distinguish between these two roles is that they have far ranging consequences for how you package and version bundles.

Lets say you buy a house from me. In this scenario you are consumer of the contract and I am the provider of the contract. These roles are, surprisingly, not symmetrical. For example, if the seller adds an extra room after the contract was signed then the buyer will not object (ok, in general, you get my point). However, if the seller removes a room the buyer is going to be upset. A consumer can expect backward compatibility but a provider is closely bound to the contract. Virtually any change in the service contract will require a provider to be updated to provide the new functions. 

So a consumer is relatively distant from the contract and it often plays the role of a consumer in many different service contracts. A provider usually provides only a single service contact while being a consumer in other service contracts.  

Therefore the best practice in OSGi is for a provider to include its service API codes and export it. Separating the API from the provider makes no sense since there is a 1:1 relation between provider and API, unlike the consumer that will get backward compatibility from the API. Having the API in the bundle just makes life easier. That said, do not make the mistake to place them in the same _project_ since that would require compiling against a JAR that would also contain the implementation. Compilation should always be done against API only JARs to prevent accidentally becoming dependent on implementation code.

In this section we dragged the service API import to the exported package list. For developers not used to bnd this can be surprising because the API is not part of the provider project; it came from the API project. However, in bnd you can put any package in your bundle that is available on the build path.

 



