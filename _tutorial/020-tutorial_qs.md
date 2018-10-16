---
title: Quick Start 
layout: toc-guide-page
lprev: 015-Prerequisite.html 
lnext: 022-tutorial_osgi_runtime.html
summary: Your first really simple OSGi REST Microservice (< 5 minutes).
author: enRoute@paremus.com
sponsor: OSGi™ Alliance 
---

## Summary 

In this tutorial we'll first run, and then re-create and re-run, a simple OSGi Microservice.

## Build and Run

We start by first downloading, building and running the enRoute `quick start` example. In addition to demonstrating the simple application this will also confirm that your local [environment](015-Prerequisite.html#required-tools) meets the required prerequisites.

Download the [enroute examples](https://github.com/osgi/osgi.enroute) from GitHub and change directory into `examples/quickstart`.

### Building the example
 
Build the Application with the following command:

    $ mvn verify
{: .shell } 

If you're using a Java version higher than 8 to run this tutorial then you'll need to set the appropriate `runee` in the `examples/quickstart/app/app.bndrun` and then resolve the application. For Java 9 use `JavaSE-9`, for Java 10 use `JavaSE-10` and for Java 11 use `JavaSE-11`. Once you have made this edit issue the command `mvn bnd-indexer:index bnd-indexer:index@test-index bnd-resolver:resolve` to generate the index, test index, and resolve the bndrun (you should be able to see the changes in the `runbundles` list afterwards). Once you've done this the first time then you can `mvn verify` to your heart's content.
{: .note } 

### Running the example

We now have a runnable artifact which can be started with the command:

    $ java -jar app/target/app.jar
{: .shell }

To test that the application is running visit the [quickstart](http://localhost:8080/quickstart/index.html) application URL for a friendly greeting,

![Quickstart](img/quickstart.png){: height="400px" width="400px"}

or if minimalism is more your thing, the raw REST endpoint [http://localhost:8080/rest/upper/lower](http://localhost:8080/rest/upper/lower).

When you want to terminate the application press **Ctrl+C**.

## Recreating Quick Start

We'll now recreate the quick start example locally as though it were your own greenfield OSGi project. 

It is assumed that you have the required [environment](015-Prerequisite.html#required-tools) installed on your laptop. 
{: .note }

### Project Setup

First issue the command to create the project template:

    $ mvn archetype:generate -DarchetypeGroupId=org.osgi.enroute.archetype -DarchetypeArtifactId=project -DarchetypeVersion=7.0.0
{: .shell }

Filling the project details with appropriate values: 

    Define value for property 'groupId': org.osgi.enroute.examples.quickstart
    Define value for property 'artifactId': quickstart
    Define value for property 'version' 1.0-SNAPSHOT: :
    Define value for property 'package' org.osgi.enroute.examples.quickstart.quickstart: : org.osgi.enroute.examples.quickstart.rest
    [INFO] Using property: app-artifactId = app
    [INFO] Using property: app-target-java-version = 8
    [INFO] Using property: impl-artifactId = impl
    Confirm properties configuration:
    groupId: org.osgi.enroute.examples.quickstart
    artifactId: quickstart
    version: 1.0-SNAPSHOT
    package: org.osgi.enroute.examples.quickstart.rest
    app-target-java-version: 8
    Y: : 
{: .shell }

If you're using an IDE then this would be a good time to import the generated maven projects.
{: .note }

### Implementing the Microservice

Having created the project skeleton, edit `quickstart/impl/src/main/java/org/osgi/enroute/examples/quickstart/rest/ComponentImpl.java` 

{% highlight shell-session %}
package org.osgi.enroute.examples.quickstart.rest;

import org.osgi.service.component.annotations.Component;

@Component
public class ComponentImpl {
    
    //TODO add an implementation
    
}

{% endhighlight %}

and add the following implementation details

<p>
  <a class="btn btn-primary" data-toggle="collapse" href="#Upper" aria-expanded="false" aria-controls="Upper">
    Upper.java
  </a>
</p>
<div class="collapse" id="Upper">
  <div class="card card-block">
{% highlight java tabsize=4 %}
{% include osgi.enroute/examples/quickstart/rest/src/main/java/org/osgi/enroute/examples/quickstart/rest/Upper.java %}
{% endhighlight %}

  </div>
</div>

and then save the file.

The important modifications include:
* A JAX-RS resource method implementation, replacing the the `TODO` section.
* The `@Component` is modified to register this component as an OSGi service.
* The `@JaxrsResource` annotation is used to mark this as a JAX-RS whiteboard resource.
* Remember to change the name of the component from `ComponentImpl.java` to `Upper.java`

### Building the Implementation

It's now time to build the implementation project.

<div>
 <ul class="nav nav-tabs" role="tablist">
  <li role="presentation" class="active"><a href="#impl-build-cli" aria-controls="impl-build-cli" role="tab" data-toggle="tab">Using the CLI</a></li>
  <li role="presentation"><a href="#impl-build-eclipse" aria-controls="impl-build-eclipse" role="tab" data-toggle="tab">Using Eclipse</a></li>
 </ul>

 <div class="tab-content">
  <div markdown="1" role="tabpanel" class="tab-pane active" id="impl-build-cli">
From the `quickstart/impl` project we now build the impl bundle.

    $ mvn package
{: .shell }
      
Here, we use the `package` goal to check that the code compiles and can be successfully packaged into a bundle. If we had tests or other post-packaging checks then we could have used the `verify` goal instead.

If the `package` fails then check your code and try again. Once you can package it cleanly then continue to the next stage. 
{: .warning }
  </div>
  <div  markdown="1" role="tabpanel" class="tab-pane" id="impl-build-eclipse">
When using Bndtools your IDE will be incrementally rebuilding your projects every time that you save, so there's no need to run a build. You can also run a build manually.
      
Right click the `quickstart` module in the left pane, and select **Run As -> Maven**

![Modularity and complexity](img/10.png)

Enter package as the goal and click **Run**
  </div>
 </div>
</div>


### Resolving the Application

Before generating the runtime dependency information used by the OSGi framework take a look at the file `quickstart\app\app.bndrun`

{% highlight shell-session %}
index: target/index.xml

-standalone: ${index}

-runrequires: osgi.identity;filter:='(osgi.identity=org.osgi.enroute.examples.quickstart.impl)'
-runfw: org.eclipse.osgi
-runee: JavaSE-1.8
{% endhighlight %}

Note that your `runee` may be different if you chose to use a higher version of Java
{: .note }

As shown, the bndrun contains a `runrequires` statement that specifies a [capability](../FAQ/200-resolving.html#namespaces); i.e. the implementation for `quickstart`. However, no `runbundles` a currently listed; i.e. the actual bundles needed at runtime to create `quickstart`.

The `runbundles` are automatically calculated for us via the process of [resolving](../FAQ/200-resolving.html).

<div>
 <ul class="nav nav-tabs" role="tablist">
  <li role="presentation" class="active"><a href="#resolve-cli" aria-controls="resolve-cli" role="tab" data-toggle="tab">Using the CLI</a></li>
  <li role="presentation"><a href="#resolve-eclipse" aria-controls="resolve-eclipse" role="tab" data-toggle="tab">Using Eclipse</a></li>
 </ul>

 <div class="tab-content">
  <div markdown="1" role="tabpanel" class="tab-pane active" id="resolve-cli">
From the root of the `quickstart` project we now generate our indexes and resolve the application using the bnd-resolver-maven-plugin. As the `app` project references other projects in the same reactor we use the `-pl` flag to pick the `app` project and the `-am` flag to be sure all of our dependencies are packaged and up to date:

    $ mvn -pl app -am  bnd-indexer:index bnd-indexer:index@test-index bnd-resolver:resolve package
{: .shell }

Note that the indexes are automatically regenerated every time you run through the package phase. If you want to generate the indexes for the `app` module without packaging everything then you can do so by issuing `mvn -pl app -am  bnd-indexer:index bnd-indexer:index@test-index`
{: .note }

  </div>
  <div markdown="1" role="tabpanel" class="tab-pane" id="resolve-eclipse">
In the `app` maven module, open the `app.bndrun` to display the `Bndtools Resolve` screen. Here we can see that the implementation bundle is added to the run requirements.

Click the **Resolve** button...

![Modularity and complexity](img/5.png){: height="400px" width="400px"}

Now click **Finish** button...

![Modularity and complexity](img/6.png){: height="400px" width="400px"}

Note that Bndtools automatically keeps your indexes up to date, so there is no need to manually generate them.
{: .note }
  </div>
 </div>
</div>

If you look again at the `app.bndrun` file you will now see that our rest service implementation `org.osgi.enroute.examples.quickstart.impl`, OSGi Declarative Services implementation `org.apache.felix.scr`, and a number of other bundles required at runtime are now listed by `runbundles`.

{% highlight shell-session %}
{% include osgi.enroute/examples/quickstart/app/app.bndrun %}
{% endhighlight %}

Note that your runbundles list may be different if you are using a different version of Java
{: .note }

### Running the application

We now create a runnable application JAR.

Note that in this version of `quickstart` only the REST endpoint will be available.
{: .note} 

<div>
 <ul class="nav nav-tabs" role="tablist">
  <li role="presentation" class="active"><a href="#run-cli" aria-controls="run-cli" role="tab" data-toggle="tab">Using the CLI</a></li>
  <li role="presentation"><a href="#run-eclipse" aria-controls="run-eclipse" role="tab" data-toggle="tab">Using Eclipse</a></li>
 </ul>

 <div class="tab-content">
  <div markdown="1" role="tabpanel" class="tab-pane active" id="run-cli">
Now that the initial development is done we're ready to build and package the whole application by running the following command in the project root.
      
    $ mvn package
{: .shell }

Your version of `quickstart` may now be started as described [above](020-tutorial_qs.html#running-the-example). It won't have a UI, but the REST endpoint will be available at [http://localhost:8080/rest/upper/lower](http://localhost:8080/rest/upper/lower).
  </div>
  <div markdown="1" role="tabpanel" class="tab-pane" id="run-eclipse">
In the `app` maven module, open the `app.bndrun` to display the `Bndtools Resolve` screen. Select the **Run OSGi** button

![Modularity and complexity](img/7.png)

See the results in the console screen.

![Modularity and complexity](img/8.png)

With the project running, navigate to [http://localhost:8080/rest/upper/lower](http://localhost:8080/rest/upper/lower) and check the results

![Modularity and complexity](img/9.png)

If you want to get hold of the runnable application jar then right click the `quickstart` module in the left pane, and select **Run As -> Maven**

![Modularity and complexity](img/10.png)

Enter package as the goal and click **Run**

![Modularity and complexity](img/11.png){: height="400px" width="400px"}

Wait for maven to finish the generation.

![Modularity and complexity](img/12.png)

The runnable jar file created will be `app/target/app.jar`, and may be started as described [above](020-tutorial_qs.html#running-the-example). It won't have a UI, but the REST endpoint will be available at [http://localhost:8080/rest/upper/lower](http://localhost:8080/rest/upper/lower).

   </div>
 </div>
</div>
