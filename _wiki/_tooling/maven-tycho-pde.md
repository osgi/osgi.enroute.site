---
title: Maven, Tycho, PDE Toolchain
summary: the Maven with Tycho and Eclipse/PDE toolchain.
---

This page describes the Maven with [Tycho](http://eclipse.org/tycho/)
and Eclipse/PDE toolchain.

Purpose
-------

The toolchain described on this page is suitable for creating standard
OSGi bundles. It supports both development in the Eclipse IDE as well as
command-line builds using Maven.

The main differences between this tool chain and the [Maven, Felix
Bundle Plugin and
Eclipse](MavenFelixBundlePluginEclipseToolchain "wikilink") tool chain
are:

-   The Tycho-based tool chain aims at OSGi Manifest-First based
    development where the developer directly authors the OSGi Manifest.
    The Felix/BND-based tool chain generates the OSGi Manifest based on
    rules.
-   Although Tycho is run from Maven, most of its build information is
    derived from the OSGi Manifest. For example, dependencies are not
    specified in the `pom.xml` but are directly taken from the OSGi
    metadata.
-   Tycho is designed to integrate with the Eclipse PDE tools.

Like in the [Maven, Felix Bundle Plugin and
Eclipse](MavenFelixBundlePluginEclipseToolchain "wikilink") page, a
project with 3 bundles is created:

-   A bundle providing an API.
-   A bundle containing a service that implements the API.
-   A bundle with a consumer of the service.

Note that this description assumes some basic Maven knowledge. For more
information on Maven in general see:
[maven.apache.org](http://maven.apache.org).

This page will give an introduction to using Tycho. For the main Tycho
documentation pages see here: <http://eclipse.org/tycho>

The example project used in this description is available [here in
github](http://github.com/bosschaert/osgi-toolchain-mvn-tycho-eclipse-example).

Maven Command-line Build
------------------------

This description starts with the Maven setup. Maven 3.0.4 is used with
Tycho 0.16.0.

The Maven build produces all 3 bundles by invoking

` mvn install`

from the command line at the root of the directory tree.

### Root pom

The root
`[http://github.com/bosschaert/osgi-toolchain-mvn-tycho-eclipse-example/blob/master/pom.xml pom.xml]`
is a simple top-level pom file that lists the 3 submodules and sets up
the Tycho integration. This pom contains a moderate amount of content.
You'll see that the `pom.xml` files of the submodules are virtually
empty. The root pom has the following content:

` `<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">  
`   `<modelVersion>`4.0.0`</modelVersion>  
` `  
`   `<groupId>`org.example.osgi.mvn-tycho-eclipse`</groupId>  
`   `<artifactId>`mvn-tycho-eclipse-example`</artifactId>  
`   `<version>`1.0.0-SNAPSHOT`</version>  
`   `<packaging>`pom`</packaging>  
` `  
`   `<properties>  
`     `<project.build.sourceEncoding>`UTF-8`</project.build.sourceEncoding>  
`     `<tycho-version>`0.16.0`</tycho-version>  
`   `</properties>  
` `  
`   `<modules>  
`     `<module>`api-bundle`</module>  
`     `<module>`service-bundle`</module>  
`     `<module>`consumer-bundle`</module>  
`   `</modules>  
` `  
`   `<repositories>  
`     `  
`     `<repository>  
`       `<id>`eclipse-juno`</id>  
`       `<layout>`p2`</layout>  
`       `<url>[`http://download.eclipse.org/releases/juno`](http://download.eclipse.org/releases/juno)</url>  
`     `</repository>  
`   `</repositories>  
` `  
`   `<build>  
`     `<plugins>  
`       `<plugin>  
`         `  
`         `<groupId>`org.eclipse.tycho`</groupId>  
`         `<artifactId>`tycho-maven-plugin`</artifactId>  
`         `<version>`${tycho-version}`</version>  
`         `<extensions>`true`</extensions>  
`       `</plugin>  
`     `</plugins>  
`   `</build>  
` `</project>

### API Bundle

The API bundle provides the Java API used by the Service Provider and
Service Consumer bundles. It defines this [example
interface](http://github.com/bosschaert/osgi-toolchain-mvn-tycho-eclipse-example/blob/master/api-bundle/src/org/example/osgi/svc/ServiceOne.java):

` package org.example.osgi.svc;`  
` `  
` public interface ServiceOne {`  
`   String myOperation(String arg);`  
` }`

#### API Bundle Manifest

As this tool chain uses a Manifest-First approach a
[MANIFEST.MF](http://github.com/bosschaert/osgi-toolchain-mvn-tycho-eclipse-example/blob/master/api-bundle/META-INF/MANIFEST.MF)
file is provided:

` Manifest-Version: 1.0`  
` Bundle-ManifestVersion: 2`  
` Bundle-SymbolicName: api-bundle`  
` Bundle-Version: 1.0.0.qualifier`  
` Export-Package: org.example.osgi.svc;version="1.0.0"`  
` Bundle-RequiredExecutionEnvironment: JavaSE-1.6`

This is clearly a fairly minimal OSGi Bundle Manifest. The package
containing the Service Interface is exported at version 1.0.0. Note that
JavaSE-1.6 is declared as the Required Execution Environment. Tycho will
also use this information during the compilation phase.

#### API Bundle `pom.xml` and `build.properties`

The
`[http://github.com/bosschaert/osgi-toolchain-mvn-tycho-eclipse-example/blob/master/api-bundle/pom.xml pom.xml]`
of the API Bundle contains only the bare minimum required by Maven for a
pom: A parent, its ID and the packaging type. While the code in this
bundle does not have any dependencies, even bundles that do have
dependencies wil have a pom.xml this small when using Tycho. This is
because all the dependency information is obtained from the OSGi
metadata in the MANIFEST.MF.

` `<project>  
`   `<modelVersion>`4.0.0`</modelVersion>  
`   `<parent>  
`     `<groupId>`org.example.osgi.mvn-tycho-eclipse`</groupId>  
`     `<artifactId>`mvn-tycho-eclipse-example`</artifactId>  
`     `<version>`1.0.0-SNAPSHOT`</version>  
`   `</parent>  
` `  
`   `<artifactId>`api-bundle`</artifactId>  
`   `<packaging>`eclipse-plugin`</packaging>  
` `</project>

Note that it's important to select `eclipse-plugin` as the packaging
type, as this gets Tycho into action. Eclipse Plugins are OSGi bundles
and Tycho uses this identifier to declare its build producing an OSGi
bundle.

In addition to the pom.xml, Tycho needs a `build.properties` file. This
file specifies the source and output directories and also lists what is
included in the ultimate Bundle. The
`[http://github.com/bosschaert/osgi-toolchain-mvn-tycho-eclipse-example/blob/master/api-bundle/build.properties build.properties]`
used in this example is the same for all Bundles:

` source.. = src/`  
` output.. = target/classes/`  
` bin.includes = META-INF/,.`

See [build.properties
docs](http://help.eclipse.org/juno/index.jsp?topic=/org.eclipse.pde.doc.user/reference/pde_feature_generating_build.htm)
for a description of the keys used in this file.

### Service Bundle

The example Service Bundle has an
[Activator.java](http://github.com/bosschaert/osgi-toolchain-mvn-tycho-eclipse-example/blob/master/service-bundle/src/org/example/osgi/svc/impl/Activator.java)
that registers an implementation of the ServiceOne interface in the OSGi
Service Registry:

` package org.example.osgi.svc.impl;`  
` `  
` import org.example.osgi.svc.ServiceOne;`  
` import org.osgi.framework.BundleActivator;`  
` import org.osgi.framework.BundleContext;`  
` `  
` public class Activator implements BundleActivator {`  
`   // Stored in a static member for testing purposes`  
`   static BundleContext bundleContext;`  
` `  
`   @Override`  
`   public void start(BundleContext context) throws Exception {`  
`     bundleContext = context;`  
`     bundleContext.registerService(ServiceOne.class.getName(), new ServiceOneImpl(), null);`  
`   }`  
` `  
`   @Override`  
`   public void stop(BundleContext context) throws Exception {`  
`     bundleContext = null;`  
`   }`  
` }`

As can be seen from the imports above, there are two dependencies:

-   The ServiceOne interface defined in the api-bundle.
-   The OSGi Framework APIs

#### Service Bundle Manifest

The
[MANIFEST.MF](http://github.com/bosschaert/osgi-toolchain-mvn-tycho-eclipse-example/blob/master/service-bundle/META-INF/MANIFEST.MF)
of the Service Bundle is as follows:

` Manifest-Version: 1.0`  
` Bundle-ManifestVersion: 2`  
` Bundle-SymbolicName: service-bundle`  
` Bundle-Version: 1.0.0.qualifier`  
` Bundle-Activator: org.example.osgi.svc.impl.Activator`  
` Import-Package: org.example.osgi.svc;version="[1.0.0,2.0.0)",`  
`  org.osgi.framework;version="[1.5.0,2.0.0)"`  
` Bundle-RequiredExecutionEnvironment: JavaSE-1.6`

This bundle does not export any packages but imports the service API and
OSGi framework packages with version ranges specified.

#### Service Bundle `pom.xml` and `build.properties`

The
`[http://github.com/bosschaert/osgi-toolchain-mvn-tycho-eclipse-example/blob/master/service-bundle/pom.xml pom.xml]`
of the Service Bundle is virtually identical to the `pom.xml` from the
API bundle. Note that this bundle does have dependencies, but they are
not specified in the pom. Tycho uses the information from the
MANIFEST.MF during the build.

` `<project>`  `  
`   `<modelVersion>`4.0.0`</modelVersion>  
`   `<parent>  
`     `<groupId>`org.example.osgi.mvn-tycho-eclipse`</groupId>  
`     `<artifactId>`mvn-tycho-eclipse-example`</artifactId>  
`     `<version>`1.0.0-SNAPSHOT`</version>  
`   `</parent>  
` `  
`   `<artifactId>`service-bundle`</artifactId>  
`   `<packaging>`eclipse-plugin`</packaging>  
` `</project>

Also make sure to include a
`[http://github.com/bosschaert/osgi-toolchain-mvn-tycho-eclipse-example/blob/master/service-bundle/build.properties build.properties]`.
The content is the same as for the API bundle.

### Consumer Bundle

The consumer bundle uses a basic
[ServiceTracker](http://www.osgi.org/javadoc/r4v42/org/osgi/util/tracker/ServiceTracker.html)
in its Bundle Activator to track ServiceOne services. Once a
`ServiceOne` instance is found, it is invoked with `Testing123` as
argument.

` package org.example.osgi.consumer;`  
` `  
` import org.example.osgi.svc.ServiceOne;`  
` import org.osgi.framework.BundleActivator;`  
` import org.osgi.framework.BundleContext;`  
` import org.osgi.framework.ServiceReference;`  
` import org.osgi.util.tracker.ServiceTracker;`  
` `  
` public class Activator implements BundleActivator {`  
`   private ServiceTracker st;`  
` `  
`   @Override`  
`     public void start(BundleContext context) throws Exception {`  
`       st = new ServiceTracker(context, ServiceOne.class.getName(), null) {`  
`         @Override`  
`         public Object addingService(ServiceReference reference) {`  
`           Object svc = super.addingService(reference);`  
`           if (svc instanceof ServiceOne) {`  
`             invokeService((ServiceOne) svc);`  
`           }`  
`           return svc;`  
`         }`  
`       };`  
`       st.open();`  
`     }`  
` `  
`   @Override`  
`     public void stop(BundleContext context) throws Exception {`  
`       st.close();`  
`     }`  
` `  
`   void invokeService(ServiceOne svc) {`  
`     String input = "Testing123";`  
`     System.out.println("Invoking Service with input: " + input);`  
`     System.out.println("  Result: " + svc.myOperation(input));`  
`   }`  
` }`

Both the
[pom.xml](http://github.com/bosschaert/osgi-toolchain-mvn-tycho-eclipse-example/blob/master/consumer-bundle/pom.xml)
as well as the
[build.properties](http://github.com/bosschaert/osgi-toolchain-mvn-tycho-eclipse-example/blob/master/consumer-bundle/build.properties)
for the consumer bundle are identical to the other bundles in the
project.

Note that the consumer-bundle ***has no*** dependency on the
service-bundle but rather depends on the api-bundle. There is no direct
link between the service provider and consumer.

The Consumer bundle has a
[MANIFEST.MF](http://github.com/bosschaert/osgi-toolchain-mvn-tycho-eclipse-example/blob/master/consumer-bundle/META-INF/MANIFEST.MF)
and
[build.properties](http://github.com/bosschaert/osgi-toolchain-mvn-tycho-eclipse-example/blob/master/consumer-bundle/build.properties)
similar to the Service bundle.

### Building it all

To build all three bundles run:

` mvn install`

from the root of the directory tree. You'll see it finish as follows:

` [INFO] ------------------------------------------------------------------------`  
` [INFO] Reactor Summary:`  
` [INFO] `  
` [INFO] mvn-tycho-eclipse-example ......................... SUCCESS [0.157s]`  
` [INFO] api-bundle ........................................ SUCCESS [1.274s]`  
` [INFO] service-bundle .................................... SUCCESS [0.297s]`  
` [INFO] consumer-bundle ................................... SUCCESS [0.254s]`  
` [INFO] ------------------------------------------------------------------------`  
` [INFO] BUILD SUCCESS`  
` [INFO] ------------------------------------------------------------------------`  
` [INFO] Total time: 12.592s`  
` [INFO] Finished at: Mon Dec 17 12:51:14 GMT 2012`  
` [INFO] Final Memory: 50M/102M`  
` [INFO] ------------------------------------------------------------------------`

The generate bundles are in the `target` directory of each module's
subdirectory.

Eclipse IDE / PDE
-----------------

The Tycho tooling is designed around the integration of Maven OSGi
builds with Eclipse. While this description starts with the Maven side,
a very common usage pattern is also to start from within the Eclipse
IDE. For example via the File -\> New -\> Project -\> Plug-in Project
wizard (make sure to specify 'standard' OSGi Framework as Target
Platform).

Going back to the example, it can be imported into Eclipse by using the
'Eclipse Maven Integration' [m2e Eclipse
plugin](http://www.eclipse.org/m2e/).

This description uses Eclipse 4.2.1 with the m2e 1.2.0.x plugin
installed.

### Importing the Maven projects

Import the projects into Eclipse using the Maven project import wizard.

![](MavenImport1.png "MavenImport1.png")

Select the directory that contains the root pom.

![](MavenImport3.png "MavenImport3.png")

Click Next and Finish a few times. The m2e integration may install some
additional plugins to work with the project. After completing this you
will get a configured Eclipse workspace as follows:

![](EclipseTycho.png "EclipseTycho.png")

In the above screenshot you can see the PDE Manifest Editor which
provides GUI tooling to author OSGi metadata directly in the
MANIFEST.MF.

### Launching and Debugging

In Eclipse running and debugging use the same launch configuration. This
example shows how to debug the OSGi service.

Start by setting a breakpoint in the service implementation:

![](BreakpointTycho.png "BreakpointTycho.png")

Next launch the framework in debug mode. Create a new Debug Launch
configuration for an OSGi framework:

![](LaunchConfigTycho.png "LaunchConfigTycho.png")

Deselect all bundles from the Target platform except for the following 4
bundles:

` org.eclipse.osgi.services`  
` org.eclipse.equinox.console`  
` org.apache.felix.gogo.runtime`  
` org.apache.felix.gogo.shell`

These 4 bundles are required to get a command line shell on the
framework in the debugger. In addition make sure to select the relevant
bundles from the current workspace.

<table>
<tbody>
<tr class="odd">
<td align="left"><p><strong>Note:</strong></p></td>
<td align="left"><p>As an alternative to manually configuring the launch configuration, you can also take the preconfigured one from the consumer-bundle project: <a href="http://github.com/bosschaert/osgi-toolchain-mvn-tycho-eclipse-example/blob/master/consumer-bundle/launch-demo.launch">launch-demo.launch</a></p></td>
</tr>
</tbody>
</table>

When launching the framework in debug mode our breakpoint gets reached:

![](DebuggingTycho.png "DebuggingTycho.png")

You can step through the code, inspect variables etc. If you hit 'go' on
the debugger, you can see the `osgi&gt;` prompt from the OSGi shell in
the console.

Bundle Testing
--------------

Bundles developed with Tycho can be tested using test fragments, which
are stored in separate projects. This section shows how to write a test
fragment to test the functionality in the Service Bundle. The test
fragment makes assertions about how the Service Bundle interacts with
the OSGi framework and hence it assumes that the Service Bundle is run
in an actual OSGi framework for the duration of the test. The Tycho test
functionality provides this environment.

### Service Bundle Test Fragment

Test Fragment project contains the
[ServiceBundleTest.java](http://github.com/bosschaert/osgi-toolchain-mvn-tycho-eclipse-example/blob/master/service-bundle-tests/src/org/example/osgi/svc/impl/ServiceBundleTest.java)
class that tests the Service Bundle:

` package org.example.osgi.svc.impl;`  
` `  
` import org.example.osgi.svc.ServiceOne;`  
` import org.junit.Assert;`  
` import org.junit.Test;`  
` import org.osgi.framework.BundleContext;`  
` import org.osgi.framework.ServiceReference;`  
` `  
` public class ServiceBundleTest {`  
`   @Test`  
`   public void testServiceRegistration() {`  
`   // The test is in the same package as the bundle, access package-private member`  
`   BundleContext ctx = Activator.bundleContext;`  
` `  
`   // Check that the service has been registered`  
`   ServiceReference ref = ctx.getServiceReference(ServiceOne.class.getName());`  
`   ServiceOne svc = ctx.getService(ref);`  
` `  
`   Assert.assertEquals("This service implementation should reverse the input",`  
`     "4321", svc.myOperation("1234"));`  
` `  
`   Assert.assertTrue(svc instanceof ServiceOneImpl);`  
`   }`  
` }`

The test is modeled as a Bundle Fragment which attaches to the
service-bundle. The Tycho build launches it all in an OSGi framework so
that the test can get access to a real BundleContext, Service Registry
etc.

#### Test Fragment Manifest

The fragment has the following
[MANIFEST.MF](http://github.com/bosschaert/osgi-toolchain-mvn-tycho-eclipse-example/blob/master/service-bundle-tests/META-INF/MANIFEST.MF):

` Manifest-Version: 1.0`  
` Bundle-ManifestVersion: 2`  
` Bundle-SymbolicName: service-bundle-tests`  
` Bundle-Version: 1.0.0.qualifier`  
` Fragment-Host: service-bundle`  
` Bundle-RequiredExecutionEnvironment: JavaSE-1.6`  
` Require-Bundle: org.junit;bundle-version="[4.0.0,5.0.0)"`

To operate Tycho needs the `Require-Bundle` statement on the `org.junit`
bundle.

#### Test Fragment `pom.xml` and `build.properties`

The tests are run in a special way through Tycho, inside an OSGi
framework. This is achieved by specifying the eclipse-test-plugin
packaging type in the
`[http://github.com/bosschaert/osgi-toolchain-mvn-tycho-eclipse-example/blob/master/service-bundle-tests/pom.xml pom.xml]`
of the service-bundle-tests module.

` `<project>  
`   `<modelVersion>`4.0.0`</modelVersion>  
`   `<parent>  
`     `<groupId>`org.example.osgi.mvn-tycho-eclipse`</groupId>  
`     `<artifactId>`mvn-tycho-eclipse-example`</artifactId>  
`     `<version>`1.0.0-SNAPSHOT`</version>  
`   `</parent>  
` `  
`   `<artifactId>`service-bundle-tests`</artifactId>  
`   `<packaging>`eclipse-test-plugin`</packaging>  
` `</project>

The build.properties file is exactly the same as the one used by the
bundles described above.

### Running the Bundle Tests

Running the bundle tests from maven is simply done by executing the
following from the service-bundle-tests directory:

` mvn integration-test`

or

` mvn install`

After running this command you'll see the following output:

` -------------------------------------------------------`  
`  T E S T S`  
` -------------------------------------------------------`  
` Running org.example.osgi.svc.impl.ServiceBundleTest`  
` Tests run: 1, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 0.022 sec`  
` `  
` Results :`  
` `  
` Tests run: 1, Failures: 0, Errors: 0, Skipped: 0`  
` `  
` [INFO] All tests passed!`  
` [INFO] ------------------------------------------------------------------------`  
` [INFO] BUILD SUCCESS`  
` [INFO] ------------------------------------------------------------------------`  
` [INFO] Total time: 12.069s`  
` [INFO] Finished at: Mon Dec 17 16:35:10 GMT 2012`  
` [INFO] Final Memory: 47M/96M`  
` [INFO] ------------------------------------------------------------------------`

### Debugging the tests from within Eclipse

You can also launch the tests from within Eclipse and debug them from
there. Do this as follows:

-   Set a breakpoint somewhere in the test class.
-   Launch it by right-clicking on `ServiceBundleTest` and selecting
    **Debug As -\>JUnit Plug-in Test**

Note the above might fail in which case the relevant bundles need to be
added to the launcher. This can be done by opening the Debug Launch
Configuration Editor and selecting the required bundles from the
Workspace:

![](LaunchConfigTychoTest.png "LaunchConfigTychoTest.png")

Also make sure that the **Auto-Start** setting of these bundles is set
to `true` (note that Fragments can't be started, so you can't specify
this on the service-bundle-test fragment).

<table>
<tbody>
<tr class="odd">
<td align="left"><p><strong>Note:</strong></p></td>
<td align="left"><p>The above approach leaves many more bundles selected as part of the target platform than necessary. This causes the launching of the tests to take longer than necessary. A more fine-tuned launch configuration can be found in the service-bundle-tests project: <a href="http://github.com/bosschaert/osgi-toolchain-mvn-tycho-eclipse-example/blob/master/service-bundle-tests/launch-tests.launch">launch-tests.launch</a></p></td>
</tr>
</tbody>
</table>

Once the debugger is up-and-running, it will reach our breakpoint and we
can step through the test, inspect the system etc:

![](DebugTychoTest.png "DebugTychoTest.png")

### Debugging tests run from Maven within Eclipse

You can also debug the tests when run from Maven inside Eclipse. Specify
the debug port by passing `-DdebugPort=8000` to Maven:

` mvn integration-test -DdebugPort=8000`

When the test is ready to run it will wait for the debugger to attach.
Set a breakpoint as described above and attach the debugger to the
remote process on port 8000 and you will get the debugger in action.

