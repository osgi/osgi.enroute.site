---
title: Dependencies
layout: tutorial
prev: 450-debug.html
next: 600-testing.html
summary: Handling external dependencies (or where is Maven Central)
---

## What You Will Learn in This Section

In this section we look into how we can depend on other projects inside and outside our workspace. We introduce the _build path_ and the repositories that come with your workspace.

## External Dependency
There is a lot of code that we're proud of but the `EvalImpl` class is not really one of them. To preserve our pride we could of course spent a couple of weeks and come with a new evaluator but why invent the wheel when large groups have already done that already untold times and make it amazingly gratis available for you?

However, that raises the question how to get this external dependency in in our build? Well, we should first search in our local repositories. At the left bottom of your Eclipse window there are is a list of repositories:

![Repositories](/img/tutorial_base/dependencies-repo-0.png)

Now there is a simple parser on Maven central that is quite nice for our purpose: [PARSII][1] and has an MIT License. Would it not be nice if we could easily add this to our build path? So why not search for `PARSII` in the repositories view.

![Repositories](/img/tutorial_base/dependencies-repo-1.png)

This comes up empty, but we do get a link to 'Continue Search on jpm4j.org'. If we click this link, it opens a window on the [jpm4j.org](jpm4j.org) website.

![Repositories](/img/tutorial_base/dependencies-repo-2.png)

Unfortunately the browser support in Linux Eclipse does not work well with jpm4j. You can go to the `Eclipse/Preferences/Bndtools/JPM. There you can select an external browser.
{: .bug}

This website provides has lots of interesting info and it contains more than Maven Central. Any JAR on there can be added to the build path of our project with a drag-and-drop operation. The drag always starts with the version vignette. The drop goes either to the `Central` repository or to the `Build` tab (where it is added to the build-path and the repository). Since we need to have the PARSII parser on our build path we first double click the `bnd.bnd` file, and the select the `Build` tab. We then drag the version vignette (the green 1.1.0 thingy) on the `Build Path` list. 

![Repositories](/img/tutorial_base/dependencies-repo-3.png)


This will open a dialog: 

![Repositories](/img/tutorial_base/dependencies-repo-4.png)

Since this is a JAR as we like them (no dependencies!) we only have to add one JAR to our build path. If there were dependencies, we would have gotten the change to add them as well. If we now refresh the `Repositories` view then we see that we've also added the PARSII library to our repository.

![Repositories](/img/tutorial_base/dependencies-repo-5.png)

Since now have the PARSII library on our build path, we can use it in our `EvalImpl` class. This small library significantly simplifies our code:

	@Component(
		name = "com.acme.prime.eval.simple", 
		property = {
			Debug.COMMAND_SCOPE + "=test", 
			Debug.COMMAND_FUNCTION + "=eval" 
		}
	)
	public class EvalImpl implements Eval {
		@Override
		public double eval(String expression) throws Exception {
			return Parser.parse(expression).evaluate();
		}	
	}

When we save this class we suddenly get an error from the Eclipse console, something like: 'could not resolve ...'. The big yellow window that is yelling at you might be a bit annoying at first but we often went on a wild goose chase because we did not see the error in the console. 

In retrospect we could have expected this error since we created an external dependency in our source which was satisfied by the build path but we did not add anything to the runtime.

## Packaging

Back to the black art of packaging. Let's see how our bundle is shaping up: click on `bnd.bnd` and then select the `Contents` tab. It is clear that this bundle cannot resolve because it imports the `parsii.eval` package; a package for which the runtime has no providing bundle.

![Importing parsii](/img/tutorial_base/dependencies-pack-0.png)

The bundle therefore looks like:

![Importing parsii](/img/tutorial_base/dependencies-pack-1.png)

We now have 2 options. We can add the PARSII bundle to the runtime or we can add the imported packages to our own bundle. What is best? In this case the answer is quite easy since the PARSII is actually not a bundle; it is only a simple JAR. You can verify this easily. Select the PARSII bundle in the respositories view under the Central repository (search for parsii). If you double click on the JAR it opens the JAR Viewer, and the manifest is shown. This rather meager manifest is not an OSGi manifest, ergo, this is not a bundle. So option 2, adding the packages to the JAR is the best solution.

Go back to the `Contents` tab of the provider bundle. If you now drag the `parsii.eval` package from the Imported Packages list to the Private Packages list and save the `bnd.bnd` file then you see that a new import replaces the the `parsii.eval` package: `parsii.tokenizer`. You can now also drag this package to the Private Packages list but lets learn something new.

Adding these packages by hand can become tedious. So select the `Source` tab of the `bnd.bnd` editor:

![Importing parsii](/img/tutorial_base/dependencies-pack-2.png)

What you now see is the underlying `bnd.bnd` properties file; in bnd everything is a property! We can now replace the clause in the `Private-Package` header and use wildcards like `parsii.*`:

	Private-Package:  \
		com.acme.prime.eval.provider,\
		parsii.*

If you now save the `bnd.bnd` file and select the `Contents` tab you see that the imports have disappeared. Our provider bundle now looks like:

![Importing parsii](/img/tutorial_base/dependencies-pack-3.png)

Copying packages into your bundle from the class path often creates surprise, disgust and vomiting for the more traditional developers. For now you have to believe us that we do know why we break this taboo. it actually works quite well.

## Playing

Since there are now no longer any errors, we can now use our Gogo shell command to test out our efforts. We're now no longer restricted by a single operation so can go wild and find answers to all the (mathematical) questions we always wanted to know but were afraid to ask:

	g! test:eval pi
	3.141592653589793
	g! test:eval sin(pi)
	1.2246467991473532E-16
	g! test:eval sin(1)*sin(1)+cos(1)*cos(1)
	1.0
{: .shell }
	
There is a small chance that you did something different and that the you do not get the prompt. In that case, terminate the running process, goto the Run tab on the `bnd.bnd` file, and click `Run OSGi` again. If this does not resolve the issue, try the next step since this will add some debugging.

Otherwise, you can try the [Forum](/forum.html) and look for a good (technically educated) Samaritan to help you out.

## How Does it Work?

The basic dependency model of bnd is based on the OSGi Bundle Symbolic Name (BSN). The Build Path, the Run Bundle and a number of other paths and bundles all specify their dependency on an OGSi bundle by declaring a BSN and an version range. These specifications are translated into actual JARs on the file system through _repositories_. A repository takes a request for a BSN and provides bnd with the versions available for that BSN, and can turn an actual BSN and version into a file. Repositories are _plugins_, that is they are not an intrinsic part of bnd. It is actually quite easy to write a repository that links to some external repository. The repositories that are loaded are visible in the repositories view in the left bottom.

In the enRoute project we have the following repositories:

* Workspace – The workspace repository represents all the bundles in the workspace built by projects. You can add an such bundles as a dependency to your project.
* Release – This is the repository where our final bundles are released in, you can find the storage of this repo in ./cnf/release
* Central – This is a view on the JPM repository, which contains Maven Central. It does not provide direct access to the 700.000+ JARs JARs since this set is growing. Since the JPM repository is in constant flux, it is possible to get different build results over time. Therefore, the JPM repository keeps a view which is under source control; you can find this file in `./cnf/repository.json`.

We found the file on JPM and added it to the build path with drag and drop; this also added the JAR to the Central repository. You can verify this by looking in the `./cnf/repository.json` file, this file contains the PARSSI JAR.

We then added the packages from PARSII to our own bundle because the PARSII JAR was not a bundle. We could have turned it into a bundle, but copying the classes in your own bundle is ok as long as they are copied to the Private Package area. Private classes are never exposed to the outside and can not conflict with other bundles as long as you make sure none of the objects is in the public API in one of the exported packages. That is, if the Eval interface had a reference to for example the `parsii.eval.Parsers` class then we could not do this; it could cause really nasty OSGi errors. In general, bnd will notify you when that happens. In this case we're ok since the PARSII JAR is fully encapsulated in our bundle.


[1]: https://github.com/scireum/parsii
