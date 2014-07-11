---
title: Quick Start
layout: book
summary: A quick-start guide to get engaged with OSGi enRoute. It shows how to quickly use the complete toolchain.
---

Since bnd(tools) is the central toolchain for OSGi enRoute starting with enRoute means starting with bndtools. The enRoute project maintains a Github repository with an archetypical workspace. This workspace is setup to contain:

* A properly configured bnd workspace
* A configuration that uses JPM as the remote repository (which contains Maven Central).
* A gradle build
* Prepared for building on Travis.
 
In this quick start we develop a little project that, suprise, prints out "hello world". Now, just keep one thing in mind, this setup takes a few shortcuts to make things simpler but that are not advised for an actual development. So try this at home, but not at work. We'll get back to this in the last chapter.

## Prerequisites

* [Java 8][2], probably already got it? If not, this is a good time to get started!
* [git][6], unlikely that you do not have it installed yet?
* [Eclipse Luna][3], if you do not know which variant, pick the _Eclipse Standard_ variant.
* Bndtools 2.4M1 or later, either from the [Eclipse Market Place][4] (available under Eclipse's Help for some reason) or you can be more adventurous and try out the latest and greatest at [cloudbees][1], you can install it also from the Eclipse `Help/Install New Software` menu.

This quick start is about learning to use OSGi enRoute, not about learning Java nor Eclipse. It is assumed that you have experience with both tools.

## Creating a Workspace

We are going to use the OSGi enRoute archetype workspace, which is a [Github repository][8]. In this case we clone the archetype repository and disconnect it. We need to use a good name for your workspace, make it a short path, and don't use spaces in the path. In this example we assume *nix and the path `/Ws/com.acme.prime` but you can use other paths, just mentally replace it when we use this path. Assuming that name, we can do the following steps:

	$ mkdir /Ws
	$ cd /Ws
	$ git clone git@github.com:osgi/osgi.enroute.archetype.git com.acme.prime
	Cloning into 'com.acme.prime'...
	...
	Checking connectivity... done.

We can now fire up Eclipse and select the `/Ws/com.acme.prime` as the Eclipse workspace. First, we must open the bndtools perspective. You can select an Eclipse perspective with `Window/Open Perspective/Bndtools`. Whenever you see a text like (`File/Open`) we intend to convey a menu path. 

If there is no `Bndtools` entry, select `Other ...` and then select Bndtools. If there is still no entry, then you have [not installed bndtools yet][9]. 

Select `File/Import/General/Existing Projects into Workspace`. As the root directory we select `/Ws/com.acme.prime`. This will allow us to import the `cnf` project. A bnd workspace requires a `cnf` project. This project configures bndtools and contains information shared between all the projects in the bnd workspace. You can look upon the bnd workspace as a kind of module that imports and exports bundles, in that view, the `cnf` project contains is private information. 
 
## Creating a Project

Let's make the archetypical `Hello world` (and in the dynamic OSGi world also `Goodbye World!`). So do (`File/New/Bndtools OSGi Project`). This will open a wizard that asks lots of questions. There are two things important.

* For the name fill in `com.acme.prime.hello.provider`. bndtools will use the extension to select a project that creates a bundle that provides an implementation for an API.
* In the next page, select the enRoute template.
* And then finish the wizard.

## Changing the Source Code

To see something happening, we add the `Hello` and `Goodbye` to the `com.acme.prime.hello.provider.HelloImpl` class. You can add the following methods to the component:

	@Activate void activate() { System.out.println("Hello World"); }
	@Deactivate void deactivate() { System.out.println("Goodbye World"); }

If you resolve the annotations, please select the OSGi annotations and the bnd variants.

TODO: remove the bnd annotations from the profile.

## Create a Run Descriptor

We now have a project. This project cannot run yet, we need to add a run specification. So select `File/New/Run Descriptor`. In this wizard. Call it `hello`, this will later be the name of our application. Then select the `OSGi enRoute Base Launcher` template. This will open the Run tab:

![Resolve tab](/img/book/qs/resolve.jpg)

The `hello` run specification must be told to include the `com.acme.prime.hello.provider` bundle for it is this bundle we want to see if it tells us hello. So we can add this by dragging it from the left side to the right side.

## Resolving

A bundle is a social animal and usually needs some other bundles before it wants to perform. So we must ask bndtools to resolve the dependencies, fortunately, the Resolve tab has a big `Resolve` button. If we hit it, we get a list of bundles that is the minimal closure to make our initial requirement runnable.

![Resolve tab](/img/book/qs/resolve-result.jpg)

We should save the `hello` run descriptor now.

## Launching the project

At the right-top of the Run tab you see a `Run OSGi` and `Debug OSGi` button. Hit it and enjoy the warm welcome from this amazing enRoute application! If you can't find it, it is the bottom part of the window, the output of the Eclipse console.
 
## Adding a Dependency
Lets add a simple dependency that is not included in the enRoute Base profile. Let's use JLine, a command line processor, to create a quit command. Add the following code to `HelloImpl.java`.

	@Component(name = "com.acme.prime.hello")
	public class HelloImpl extends Thread {
		final static Logger log = LoggerFactory.getLogger(HelloImpl.class);
	
		@Activate
		void activate() {
			System.out.println("Hello World");
			start();
		}
	
		@Deactivate
		void deactivate() {
			System.out.println("Goodbye World");
			interrupt();
		}
	
		public void run() {
			try {
				ConsoleReader r = new ConsoleReader();
				String line;
				while ( !isInterrupted() && (line=r.readLine("> "))!=null) {
					if ( "quit".equals(line))
						FrameworkUtil.getBundle(HelloImpl.class).stop();
					System.out.println(line.toUpperCase());
				}
			} catch (Exception e) {
				throw new RuntimeException(e);
			}	
		}
	}

There will be compile errors and maybe bndtools complains that it wants to terminate the process. This is not necessary and you can safely ignore those warnings since bndtools will always refresh the classes on changes. So keep the framework running!

So how do we get this JAR for JLine? Easy, first click on the `bnd.bnd` file and select the build tab:

![Resolve tab](/img/book/qs/build-tab.jpg)

In the left bottom corner, under the package explorer there is a view with the bnd repositories. We can see if JLine is present there by typing JLine in the search input control.

![Resolve tab](/img/book/qs/search-jpm.jpg)

Nope, out of luck. Fortunately, there is a link that allows us to continue searching on jpm4j.org. If you click on this link then it opens a web browser view on [JPM][10].

TODO unfortunately, the Linux browser in Eclipse is not operational for this, you can also go to [jpm4j.org][10] and search there.

![Resolve tab](/img/book/qs/jline.jpg)
 
At the right side of the entries you will see version vignettes. If you drag a version vignette to the build tab and drop it on the Build path control then you get the following pop up:

![Resolve tab](/img/book/qs/depsfromjpm.jpg)

Click finish and save the `bnd.bnd` file. This should get rid of any compile errors. However, we now get a warning from the console that there are unresolved bundles. This makes sense because we added a dependency to JLine but we do not have it running as a bundle.

So double click the `hello.bndrun` file and click on the `Resolve` button, the save the file. If things were done in the right order then you should see the `Hello World` again and the prompt. Type a few words, which are echoed in upper case, and then type `quit` with a return. You should now also see the `Goodbye World` because we just made the bundle commit suicide (which is not a good practice, also not in OSGi).

There is a small chance that you did something different and that the you do not get the prompt. In that case, terminate the running process, goto the Run tab on the `hello.bndrun` file, and click `Run OSGi` again. If this does not resolve the issue, try the next step since this will add some debugging.

Otherwise, you can try the [Forum](/forum.html).

Caveat: This is still early days for enRoute, so feedback appreciated.

## Debugging
Of course OSGi enRoute will never let you down, you're live will be tranquil, and you can spend lots of time on the beach. Ehh, well we try but Watson is not that advanced yet and in the mean time you will have to do some debugging and diagnosing to make actual applications work.

One of the great tools is the Apache Felix Web Console, especially with Xray. So double click the `hello.bndrun` file and add the `aQute.xray.plugin` to the `Run Requirements` control, and then hit `Resolve`. This will add a web server, Apache Felix Web Console, and XRay. Save the file, and then go to  [http://localhost:8080/system/console/xray](http://localhost:8080/system/console/xray). The user id password is, surprisingly innovative, `admin` and `admin`. The Apache Felix Web Console is an amazing tool, learn to use it.

TODO There is a bug in Jetty, so for now you have to also add org.apache.felix.eventadmin to the initial requirements.

![Resolve tab](/img/book/qs/xray.jpg)

## Creating an Application
Ok, this was fun. But how do we deploy this? Well, we can make this into an application, an executable JAR file. If you go to the `hello.bndrun`, the `Run` tab, then you see there is an `Export` button at the right top. This will ask you for what type of export (`Executable JAR`) and where to put it. For now, place it into the `/Ws/com.acme.prime/com.acme.prime.hello.provider/hello.jar` file.

Since we are going to start the application outside Eclipse, now is a good time to kill the launched framework. 

Next step is the infamous command line shell. 

	$ cd /Ws/com.acme.prime/com.acme.prime.hello.provider
	$ java -jar hello.jar
	Hello World
	> quit
	Goodbye World
	QUIT
	
Obviously, we also packed the Web server so you can also still go to   [http://localhost:8080/system/console/xray](http://localhost:8080/system/console/xray).

You can quite this app by hitting control-c.

## Putting it on Github


## Continuous Integration




   

	
	

Fire up bndtools and create a new workspace. 
  
Select the bndtools perspective (`Window/Open Perspective/Other .../Bndtools`). So (`File/Open`) means goto the File menu and select Open.


You can create this 

* Use git to clone this repository somewhere on your file system. Make sure the path to the repository does not contain spaces, especially on windows.
* Open Eclipse and select this folder as a workspace, then do `Import/Existing Projects` from this folder, which will only be the cnf project.
* You now have a working bndtools workspace. 
* You can follow the tutorials at [enroute.osgi.org][7]

Make sure you always create projects in the bnd workspace. A bnd workspace is always flat and the projects must therefore reside in the same folder as the cnf project.


[1]: https://bndtools.ci.cloudbees.com/job/bndtools.master/lastSuccessfulBuild/artifact/build/generated/p2/
[2]: http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html
[3]: https://www.eclipse.org/downloads/
[4]: http://marketplace.eclipse.org/
[5]: http://jpm4j.org/#!/md/install
[6]: http://git-scm.com/book/en/Getting-Started-Installing-Git
[7]: http://enroute.osgi.org
[8]: https://github.com/osgi/osgi.enroute.archetype
[9]: http://bndtools.org/installation.html
[10]: http://www.jpm4j.org
[10]: forum.html
