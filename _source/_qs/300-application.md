---
title: Creating an Application
layout: tutorial
prev: 200-workspace.html
next: /book/200-quick-start.html#End
summary: Creating a sample enRoute Application
---

In the previous section we created a fresh clean OSGi enRoute workspace in `~/git/com.acme.prime` and selected the `Bndtools` perspective. In this section we're going to create an application project in this workspace that will run inside an OSGi framework. This application will create a command for a command line. It will simply echo the command but turn lower case characters into upper case. It should operate something like:

	g! upper:upper "this is lower case"
	THIS IS LOWER CASE
	g!
	
So let's get started by creating a new Bndtools Project. Select `File/New/Bndtools OSGi Project`.

![Create Application Project](/img/qs/app-create-0.png)

This will open a wizard. Now naming is important and we've found that using Java package like names that use the workspace name as a prefix works best for projects. So we pick `com.acme.prime.upper.application.`. For OSGi enRoute, this `.application` suffix is crucial since it defines the template we will use. So in the first page we enter this name.

![Create Application Project](/img/qs/app-create-1.png)
 
Click on `Next` to go to the page where we select the _template_. For this tutorial, it is mandatory to use the OSGi enRoute template since our workspace is not setup for the other templates. The OSGi enRoute templates creates specific project types based on the suffix of the project name. In this case we create an application project.
 
![Select the OSGi enRoute template](/img/qs/app-create-2.png)
 
Select `Next` to go to the Java settinges page, which would should not change since OSGi enRoute has already set this up.
 
![Select the OSGi enRoute template](/img/qs/app-create-3.png)
 
So we can just click `Finish` and get it over with. If Eclipse has done its work, Eclipse should give you the following view:
 
![Select the OSGi enRoute template](/img/qs/app-create-4.png)
 
## Code Changes
 
The OSGi enRoute template has already created some source code for us, which (surprise!), is a Gogo command. This is not specially for the tutorial. An application project should contain very little code but hold the requirements so that bnd(tools) can use the dependencies to construct a deployable unit. It turns out having a Gogo command for such application is actually very useful.
 
So double click on the `UpperApplication.java` source file to open the Java editor. A few explanations:
 
* `@Component` – This annotation makes this object a Declarative Services _service component_. A service component automatically is registered as a service and it can very easily dynamically depend on other services.
* `service` – This is the service that will be registered for this component.
* `property` – The properties in the component annotation are service properties that Gogo will use to register commands. Gogo commands have a _scope_ and a _function_. A command in Gogo is therefore `<scope>:<function>`, the scope is optional. The function must match a method in this class.
* `name` – This is the name, called Persistent ID or PID in OSGi, used for the configuration for this component.
 
Providing an implementation for our requirements should be rather trivial:
 
	public String upper(String m) throws Exception {
		return m.toUpperCase();
	}

## Defining a Runtime

Double click on the `com.acme.prime.upper.bndrun` file and select the `Run` tab. In this tab we can express the requirements we have on the runtime. Initially, we only have a requirement on the current project. However, to do something useful, it might be useful to add the Gogo shell.

In the left list, marked `Available Bundles`, we can type `gogo` in the search box. This limits the set of available bundles to Gogo. Then drag the shell to the right side, the list titled `Run Requirements`. 

![Initial Requirements](/img/qs/resolve-initial-0.png)

We only have to add the Gogo shell bundle because we will _resolve_ the runtime. Resolving means that bnd(tools) will look at what is required, add that to the runtime, and then look what those new elements require, ad nauseum. So click on the `Resolve` button. This will open a dialog that shows you what bundles are required in runtime.

![Resolved set](/img/qs/resolve-initial-1.png)

You can `Finish` this set, which will set the `Run Bundles` list. This list is normally closed but if you open it you can the resulting bundles.

![Resolved set](/img/qs/resolve-initial-2.png)

Save the `com.acme.prime.upper.bndrun` file and then click on the `Debug OSGi` button at the right top of the window.

![Resolved set](/img/qs/run-buttons-0.png)

If you now look at the Eclipse console view, you'll see that the Gogo shell has started:

	____________________________
	Welcome to Apache Felix Gogo
	
	g! 

Let's see if our command works:

	g! upper:upper "this is lower case"
	THIS IS LOWER CASE
	g!

Obviously it works, and we're now 100% Function complete!

## Debugging

You can debug this project as you can any other project. You can set breakpoints and single stop. There is one difference with more traditional Java. In our case, we generate a bundle that gets deployed on every change we make. If you change some code an save it, a new bundle will get deployed. If you get more requirements in the `bndrun` file, those new bundles will be deployed or no longer necessary bundles get removed. This works so well that the dialog box that Eclipse sometimes pops up to tell you it could not patch the class files can be ignored because bnd does not rely on patching.

![Resolved set](/img/qs/debug-patch-0.png)

So just click the checkbox and dismiss it. So that out of the way, let's change our code from making this upper case code to return lower case code. (Don't kill the running framework.)

	public String upper(String m) throws Exception {
		return m.toUpperCase();
	}

	g! upper:upper "THIS IS UPPER CASE"
	this is upper case
	g!
 
## OSGi Details

We're running in a framework but there is not much to see of the framework yet. Obviously, we will need tools to see what bundles are running and what services are registered. Well, every application project has a basic `bndrun` file and a `debug.bndrun` file. The `debug.bndrun` file inherits from the basic one but it adds a lot of support to look inside the framework.

Let's first kill our running framework. Just click the red button on the console view. Also, if you've done some debugging, you might want to treturn to the Bndtools perspective.

Then double click the `debug.bndrun` file and select the `Run` tab, then click on the `Resolve` button. This gives us a much larger list of bundles. The debug enRoute settings add Web Console, XRay, a web server etc. These are invaluable tools. 

![Resolved set](/img/qs/debug-details-0.png)

So save the `debug.bndrun` file and click `Debug OSGi`. First, this `bndrun` file will run in trace mode. (You can control this through the `-runtrace` property that you can see when you double click the `debug.bndrun` file and select the `Source` tab.) In trace mode, the launcher provides detailed information about the launch process as well the ongoing update process when there are changed in bndtools.

Anyway, the cool part now is that we have [Web Console](http://felix.apache.org/site/apache-felix-web-console.html) running with XRay. Just click on [http://localhost:8080/system/console/xray](http://localhost:8080/system/console/xray).

![Resolved set](/img/qs/debug-xray-0.png)

In the full tutorial the possibilities of XRay are further explained.

## Creating an Executable

The last part of this quick start is creating an executable JAR out of our application. The export facility of bnd(tools) makes it possible to create a JAR that contains all the dependencies, including the launcher and the framework. This is sometimes hard to understand for enterprise developers, that you can actually run code without an application server!

Double click on the `com.acme.prime.upper.bndrun` file and select the `Run` tab.

At the top of this window you see the following buttons:

![Resolved set](/img/qs/run-buttons-0.png)

The `Export` button creates an executable JAR out of the specification of its corresponding `bndrun` file. The execution will be identical to when you run your code inside eclipse. So click on the `Export` button:

![Resolved set](/img/qs/export-0.png)

Click on `Next` to go to the wizard page that requests for the path to save the executable JAR at. Suggest you save it on the desktop under the name `com.acme.prime.upper.jar`:

![Resolved set](/img/qs/export-1.png)
 
Then we click `Finish`. Let's go to a shell to see if we can execute our code.

	$ cd ~/Desktop
	$ java -version
	java version "1.8.0"
	Java(TM) SE Runtime Environment (build 1.8.0-b132)
	Java HotSpot(TM) 64-Bit Server VM (build 25.0-b70, mixed mode)
	$ java -jar com.acme.prime.upper.jar
	____________________________
	Welcome to Apache Felix Gogo
	
	g! upper:upper "Some Mixed Test"
	some mixed test
	g!
{: .shell}

You can do Control-C to exit.
	
	



	






 
   
 
 