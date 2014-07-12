---
title: Quick Start
layout: book
summary: A quick-start guide to get engaged with OSGi enRoute. It shows how to quickly use the complete toolchain.
---

In this quick start we develop a little project that, surprise, surprise,  prints out "Hello world", and because it is OSGi based, we will also cover the "Goodbye World". 

This tutorial is light on the explanations because it focuses on introducing the overall architecture of enRoute, not the details. Over time this site will be filled with tutorials and documentation (or references to those) that will explain the minute details. This however, is about some big steps.

We will cover the whole chain, from creating a workspace all the way to continuous integration.

A disclaimer. This quick start is about learning to use OSGi enRoute, not about learning Java, Git, nor Eclipse. It is assumed that you have basic experience with these tools.

If you have any questions about this quick-start, please discuss them in the [forum][10].

Another disclaimer, this is still under development. Feedback appreciated. And note that you can clone this site and send us pull requests.

## Prerequisites

* [Java 8][2], probably already got it? If not, this is a good time to get started!
* [git][6], unlikely that you do not have it installed yet?
* [Eclipse Luna][3], if you do not know which variant, pick the _Eclipse Standard_ variant, make sure it has Git support.
* [Bndtools][9], while we're under construction you have to install it from [cloudbees][1] update site, this is the latest build and not release so do not use it for production.


## Creating a Workspace

Since bnd(tools) is the central toolchain for OSGi enRoute starting with enRoute means starting with bnd(tools), the bnd based tools. A crucial concept in bnd is the _workspace_. The workspace contains a number of _projects_, that can each create multiple _bundles_. The workspace also has a `cnf` directory that contains shared information that can be referenced and used in the projects. 

The enRoute project maintains a Github repository with [an archetypical workspace for bnd][13]. This workspace is setup to contain:

* A properly configured bnd workspace
* A configuration that uses JPM as the remote repository (which contains Maven Central) for external dependencies.
* A gradle build
* Prepared for building on Travis CI

### Naming 
First we must decided on a name (very important!). Best practice is to use a directory with all your workspaces that has a short path since it is likely you use it a lot in a shell, for example `/Ws`. Then use reverse domain names for the workspace name, based on your domain name and the topic of the workspace, for example `com.acme.prime`. To prevent yourself from unnecessary misery, do not use spaces in the path. In this chapter we use `/Ws/com.acme.prime` as the Eclipse workspace location.

### Start bndtools
So fire up Eclipse and select `/Ws/com.acme.prime` as the Eclipse workspace. You'll get the start screen, just close it and select the bndtools perspective. You can select an Eclipse perspective with `Window/Open Perspective/Bndtools`. 

A bit of legend, whenever you see a text like `File/Open` we hope you treat it as a menu path. That is, go to the menu bar, click on `File`, then select `Open`. If the menu path starts with @/ then it is from the context menu on the selected object, which has been clearly defined in the previous sentence. 

Back to `Window/Open Perspective/Bndtools`. If there is no `Bndtools` entry, select `Other ...` and then select Bndtools. If there is still no entry, then you have [not installed bndtools yet][9]. 

### Import the Archetype Workspace
We are going to use the OSGi enRoute archetype workspace, which is a [Github repository][8]. We need to import this archetype so select `File/Import/Projects from Git/Clone URI`. The URI that we should use is

> `git@github.com:osgi/scm.git`

This will give us:

![Import archetype](/img/book/qs/git-import-1.jpg)

Select the `master` branch on the next page, and then on the `Next-Next` page we must provide the path. By default git places the projects in a subdirectory `git` of your home directory. (This is an Eclipse preference.) However, we want to keep the Eclipse workspace and the bnd archetype workspace together for simplicity but not in the same folder for various reasons. So we should place it in the `scm` (for Source Control Management, e.g. Git)  subfolder of the Eclipse workspace, ergo: `/Ws/com.acme.prime/scm`.

![Import archetype](/img/book/qs/git-local-dest.jpg)

On the next page we must define how to import the projects. A bnd workspace contains potentially many projects so the default option is ok, `Import existing projects`, so you can click `Next` and `Finish`. This will give you a Package Explorer with a single project `cnf`. 

Congratulations, you've created your first workspace!

TODO Please restart your workspace, there is a bug in bndtools that sometimes causes projects to be put in the wrong place if you don't restart.

### About the Workspace

A bnd workspace requires a `cnf` project. This project configures bndtools and contains information shared between all the projects in the bnd workspace. You can look upon the bnd workspace as a kind of next order module that imports and exports bundles, in that view, the `cnf` project contains is private information. So, we now have the following structure:

	/Ws               workspaces
	  com.acme.prime  Eclipse Workspace
	    .metadata     The Eclipse metadata
	    scm           The source control folder
	      .git        The git control folder
	      cnf         The bnd control folder 
	      ....        Build files

Fortunately, from Eclipse it looks very simple:

![Import archetype](/img/book/qs/final.jpg)

You have to restart Eclipse to make sure bndtools picks up the location.

## Creating a Project
Now we need to create a project that will do the hard work of printing `Hello world` and `Goodbye World!`. There is fortunately a template for this! So do `File/New/Bndtools OSGi Project`. This will open a wizard that asks lots of questions. There are two things important.

* For the name fill in `com.acme.prime.hello.provider`. bndtools will use the extension (`provider`) to select a project that creates a bundle that provides an implementation for an API. enRoute recognizes the following names:
  * `test` – An OSGi test project, tests are run inside a framework.
  * `provider`, `adapter` – An implementation project
  * `api` – API only project
  * `application` – An application project. This is a project that binds together a set of components and parameterizes them.
* In the `Next` page, select the enRoute template.
* And then `Finish` the wizard.

During initialization the project could have some warnings and errors but in the end should have no errors.

## Changing the Source Code

To see something happening, we add the `Hello` and `Goodbye` printouts to the `com.acme.prime.hello.provider.HelloImpl` class. You can add the following methods to the component:

	@Activate void activate() { 
		System.out.println("Hello World"); 
	}
	@Deactivate void deactivate() { 
		System.out.println("Goodbye World"); 
	}

If you resolve the annotation imports, please select the OSGi annotations and the bnd variants.

TODO: remove the bnd annotations from the profile.

## Create a Run Descriptor

We now have a project. This project cannot run yet, we need to add a run specification. So select the project in the Package Explorer and then `@/File/New/Run Descriptor`. In this wizard. Call it `hello`, this will later be the name of our application. Then select the `OSGi enRoute Base Launcher` template. This will open the Run tab:

![Resolve tab](/img/book/qs/resolve.jpg)

The `hello` run specification must be told to include the `com.acme.prime.hello.provider` bundle for it is this bundle we want to see if it tells us hello. So we can add this by dragging it from the left side to the right side.

## Resolving

A bundle is a social animal and usually needs some other bundles before it wants to perform. So we must ask bndtools to resolve the dependencies, fortunately, the Resolve tab has a big `Resolve` button. If we hit it, we get a list of bundles that is the minimal closure to make our initial requirement runnable.

![Resolve tab](/img/book/qs/resolve-result.jpg)

If we click on `Finish`, then the list of bundles will be saved as the `-runbundles` variable, which controls what bundles should be installed and instarted.

We should then save the `hello` run descriptor.

## Launching the project

At the right-top of the Run tab you see a `Run OSGi` and `Debug OSGi` button. Hit it and enjoy the warm welcome from this amazing enRoute application! If you can't find it, it is at the bottom part of the window, the output of the Eclipse console.
 
## Adding a Dependency
Lets add a simple dependency that is not included in the enRoute Base profile. Let's use [JLine][15], a command line processor, to create a quit command.
 
Let's add the following code to `HelloImpl.java`.

	@Component(name = "com.acme.prime.hello")
	public class HelloImpl extends Thread {
	  final static Logger log = 
	    LoggerFactory.getLogger(HelloImpl.class);
	
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
		  while ( !isInterrupted() 
		    && (line=r.readLine("> "))!=null) {
	        if ( "quit".equals(line))
	          FrameworkUtil.getBundle(
	            HelloImpl.class).stop();
	        System.out.println(line.toUpperCase());
	      }
	    } catch (Exception e) {
	      throw new RuntimeException(e);
	    }	
	  }
	}

There will be compile errors because we are missing dependencies. Some can be solved, like the OSGi framework because it is already on the build path. Others, the JLline dependencies are not available.

Maybe bndtools complains that it wants to terminate the process. This is not necessary and you can safely ignore those warnings since bndtools will always refresh the classes on changes. So keep the framework churning along!

So how do we get this JAR for JLine? Easy, first click on the `bnd.bnd` file and select the `Build` tab:

![Resolve tab](/img/book/qs/build-tab.jpg)

We need to add JLine to the Build path control. To do this, goto the left bottom corner, under the Package Explorer, there is a view with the bnd repositories. We can see if JLine is present there by typing JLine in the search input control.

![Resolve tab](/img/book/qs/search-jpm.jpg)

Nope, out of luck. Fortunately, there is a link that allows us to continue searching on jpm4j.org. If you click on this link then it opens a web browser view on [JPM][10].

TODO unfortunately, the Linux browser in Eclipse is not operational for this, you can also go to [jpm4j.org][10] and search there.

![Resolve tab](/img/book/qs/jline.jpg)
 
At the right side of the entries you will see version vignettes. If you drag a version vignette to the `Build` tab and drop it on the `Build path` control then you get the following pop up:

![Resolve tab](/img/book/qs/depsfromjpm.jpg)

Click finish and save the `bnd.bnd` file. Goto the `HelloImpl class` and fix the imports. This should get rid of any compile errors. However, we now get a warning from the console that there are unresolved bundles. This makes sense because we added a dependency to JLine but we do not have it running as a bundle.

## Updating the Bndrun file

So double click the `hello.bndrun` file and click on the `Resolve` button, the make it re-look at the dependency situation. The JLine bundle should now be added to the result. `Finish`, and save the `hello.bndrun` file.

If things were done in the right order then you should see the `Hello World` again and the prompt. Type a few words, which are echoed in upper case, and then type `quit` with a return. You should now also see the `Goodbye World` because we just made the bundle commit suicide (which is not a good practice, also not in OSGi).

There is a small chance that you did something different and that the you do not get the prompt. In that case, terminate the running process, goto the Run tab on the `hello.bndrun` file, and click `Run OSGi` again. If this does not resolve the issue, try the next step since this will add some debugging.

Otherwise, you can try the [Forum](/forum.html).

## Debugging

Of course OSGi enRoute will never let you down, you're live will be tranquil, and you can spend lots of time on the beach. Ehh, well we try but Watson is not that advanced yet and in the mean time you will have to do some debugging and diagnosing to make actual applications work.

One of the great tools is the Apache Felix Web Console, especially with Xray. So double click the `hello.bndrun` file and add the `aQute.xray.plugin` to the `Run Requirements` control

TODO There is a bug in Jetty, so for now you have to also add org.apache.felix.eventadmin to the initial requirements, this should in general not be necessary.

Then hit `Resolve`. This will add a web server, Apache Felix Web Console, and XRay. Save the file, and then go to  [http://localhost:8080/system/console/xray](http://localhost:8080/system/console/xray). The user id password is, surprisingly innovative, `admin` and `admin`. The Apache Felix Web Console is an amazing tool, learn to use it.

BTW, if the provider bundle is grey, push the `Start All` button at the top of XRay.

![Resolve tab](/img/book/qs/xray.jpg)

## Creating an Application

Ok, this was fun. But how do we deploy this? Well, we can make this into an application, an executable JAR file. If you go to the `hello.bndrun`, the `Run` tab, then you see there is an `Export` button at the right top. This will ask you for what type of export (`Executable JAR`) and where to put it. For now, place it into the `/Ws/com.acme.prime/com.acme.prime.hello.provider/hello.jar` file.

Since we are going to start the application outside Eclipse, now is a good time to kill the launched framework. 

Next step is using the infamous command line shell that we all hate but could not live without:

	$ cd /Ws/com.acme.prime/scm/com.acme.prime.hello.provider
	$ java -jar hello.jar
	Hello World
	> quit
	Goodbye World
	QUIT
	
Obviously, we also packed the Web server so you can also still go to   [http://localhost:8080/system/console/xray](http://localhost:8080/system/console/xray).

You can quite this app by hitting control-c.

## Building Outside the IDE

If you can't automatically build it then it is not software engineering. Automating repeated processes is at the heart of building software. It is that OSGi enRoute/bnd includes a full gradle build that does not require any extra work. The raison d'être of bnd is that it runs inside an IDE like Eclipse but can also run from a shell. Great care has been taken to ensure that bnd builds identical artifacts inside the IDE and from the command line. 

So we only have to fire up a shell and run the build.

There is a script included, `gradlew`, that will download the correct gradle version. You can also install gradle (>= 1.12) and use it. It should go without saying, but you should also have java 8 installed on the command line.

	$ cd /Ws/com.acme.prime
	$ java -version
	java version "1.8.0"
	Java(TM) SE Runtime Environment ...
	$ ./gradlew
	Downloading https://b../biz.aQute.bnd-latest.jar to 
	    /Ws/com.acme.prime/cnf/cache/biz.aQute.bnd-latest.jar ...
	:help
	
	Welcome to Gradle 1.12.
	To run a build, run gradlew <task> ...
	To see a list of available tasks, run gradlew tasks
	To see a list of command-line options, run gradlew --help
	BUILD SUCCESSFUL

For almost all features of bndtools there is a corresponding gradle task you can execute. You can see all the possible tasks with `./gradlew tasks`. For example, you automatically get a task to build your `hello` application:

	$ ./gradlew export.hello
	:com.acme.prime.hello.provider:compileJava
	:com.acme.prime.hello.provider:processResources UP-TO-DATE
	:com.acme.prime.hello.provider:classes
	:com.acme.prime.hello.provider:jar
	Warning: Please update this Bundle-Description in com.acme.prime.hello.provider/bnd.bnd
	:com.acme.prime.hello.provider:assemble
	:com.acme.prime.hello.provider:export.hello
	Plugin found aQute.launcher.plugin.ProjectLauncherImpl 1.4.0.201406101507

	BUILD SUCCESSFUL

TODO should print out where it stores it.

This task will store the output in `com.acme.prime.hello.provider/generated/distributions/hello.jar`.

## Putting it on Github

We should now create a repository on [Github][11], for which you will need an account. There is a nice tutorial about [setting up new repositories on Github][12].Lets call this new repository the same as the workspace `com.acme.prime`.

![Create new repo](/img/book/qs/github-newrepo.jpg)

We need to copy the git URL so that we can connect our bnd workspace to this repository

> `git@github.com:osgi/com.acme.prime.git`

This URL will of course differ for you. Now, in bndtools we must connect our bnd workspace to this repository. This can all be done from inside Eclipse.

In the Package Explorer, select all the projects and the select on the context menu `@/Team/Disconnect`. We could reconnect this repository to our own new repository but since we do not want to inherit this unrelated history we need to delete it. 

In a perfect world we would reconnect the git repository from inside Eclipse. However, EGit is not up to the level of the CVS plugin in Eclipse and this turned to be quite cumbersome.

TODO Is there an easy way with EGit?

So we will reconnect form the shell. First we delete the old repo since it contains the history of the archetype which is of no importants to us.

	$ cd /Ws/com.acme.prime
	$ rm -rf scm/.git

Then we basically do what Github told us to do on the start page ...

	$ git init
	$ git add .
	$ git commit -m "first commit"
	$ git remote add origin git@github.com:osgi/com.acme.prime.git
	$ git push -u origin master

Sometimes command line interfaces are hard to beat ... If you go to [Github][11] then you should be able to see your workspace now.

## Continuous Integration

The bnd workspace is setup to be built continuously with [Travis CI][13]. The way to activate this is ridicuously simple. Just go to the site, create an account based on your Github credentials, and go to the your account page. Select the `Repositories` tab. The first time it is likely that you need to click on the `Sync Now` button, this refreshes your list of repositories. Find your new repository and set the right button to `ON`, that's it. Now every push will automatically build the repository.

After you enabled builds on Travis, go to the home page and see your repo being build. 

![Create new repo](/img/book/qs/travis.jpg)

### Conclusion

In this mini-tutorial we've covered a lot of ground. 

TBD


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
[11]: http://github.com
[12]: https://help.github.com/articles/create-a-repo
[13]: https://travis-ci.org/
[14]: https://github.com/osgi/osgi.enroute.archetype
[15]: http://jline.sourceforge.net/
