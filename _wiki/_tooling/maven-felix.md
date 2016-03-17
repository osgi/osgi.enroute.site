---
title: Maven with the Apache Felix Bundle Plugin
summary: the Maven with the Felix Bundle Plugin and the Eclipse IDE toolchain
---

This page describes the Maven with the Felix Bundle Plugin and the
Eclipse IDE toolchain.

Purpose
-------

The toolchain described on this page is suitable for creating standard
OSGi Bundles. It supports both development in the Eclipse IDE as well as
command-line builds using Maven.

A project with 3 bundles is created:

-   A bundle providing an API
-   A bundle containing a service that implements the API
-   A bundle with a consumer of the service

Note that this description assumes some basic Maven knowledge. For more
information on Maven in general see:
[maven.apache.org](http://maven.apache.org)

This example is based on OSGi 4.2 APIs.

The example project used in this description is available [here in
github](http://github.com/bosschaert/osgi-toolchain-mvn-felix-eclipse-example).

Maven Command-line Build
------------------------

This description starts with the Maven setup. Maven 3.0.4 is used.

The Maven build produces all 3 bundles by invoking

`mvn install`

from the command line at the root of the directory tree.

The Maven build heavily depends on the Apache Felix
[maven-bundle-plugin](http://felix.apache.org/site/apache-felix-maven-bundle-plugin-bnd.html),
which in turn leverages the [BND tool](http://www.aqute.biz/Bnd/Bnd) by
Peter Kriens for the OSGi Manifest generation.

### Root pom

The root
`[http://github.com/bosschaert/osgi-toolchain-mvn-felix-eclipse-example/blob/master/pom.xml pom.xml]`
is a simple top-level pom file that lists the 3 submodules and sets up
things such as the compiler version, the version of the Felix Bundle
Plugin to use and some other properties.

### API Bundle

The API bundle provides the Java API used by the Service Provider and
Service Consumer bundles. It defines this example interface:

`package org.example.osgi.api;`  
``  
`public interface MyService {`  
`  String doSomething(String arg);`  
`}`

The directory holding the `.java` files for this package also holds a
text file with the name `packageinfo`. This file defines the version of
this package when exported from the bundle. The version of the package
currently is 1.0 so the contents of the
`[http://github.com/bosschaert/osgi-toolchain-mvn-felix-eclipse-example/blob/master/api-bundle/src/main/java/org/example/osgi/api/packageinfo packageinfo]`
file is:

`version 1.0.0`

#### Versioning Packages

Having a version `packageinfo` file placed alongside the code it relates
to makes applying [semantic
versioning](http://www.osgi.org/wiki/uploads/Links/SemanticVersioning.pdf)
easier. When the Java package changes in a binary compatible way (for
consumers) the version should be increased to 1.1.0. Binary incompatible
changes to the package are marked with a major version increase, e.g.
2.0.0. Note that the package version is ***unrelated*** to the version
of the hosting bundle. Also, if a bundle contains more than one package,
the version of each package evolves separately and they can therefore be
different from each other.

The
`[http://github.com/bosschaert/osgi-toolchain-mvn-felix-eclipse-example/blob/master/api-bundle/pom.xml pom.xml]`
for the API Bundle looks like this:

`<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"`  
`  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">`  
`  <modelVersion>4.0.0</modelVersion>`  
``  
`  <parent>`  
`    <groupId>org.example.osgi.mvn-felix-eclipse</groupId>`  
`    <artifactId>mvn-felix-eclipse-example</artifactId>`  
`    <version>1.0-SNAPSHOT</version>`  
`  </parent>`  
`  <artifactId>api-bundle</artifactId>`  
`  <packaging>bundle</packaging>`  
`  `  
`  <build>`  
`    <plugins>`  
`      <plugin>`  
`        <groupId>org.apache.felix</groupId>`  
`        <artifactId>maven-bundle-plugin</artifactId>`  
`        <extensions>true</extensions>`  
`        <configuration>`  
`          <instructions>`  
`            <Bundle-SymbolicName>${project.name}</Bundle-SymbolicName>`  
`            <Export-Package>org.example.osgi.api</Export-Package>`  
`          </instructions>`  
`        </configuration>`  
`      </plugin>`  
`    </plugins>`  
`  </build>`  
`</project>`

These are noteworthy points of this pom:

1.  The packaging specified is `bundle`. This is the OSGi bundle
    packaging that is provided by the maven-bundle-plugin.
2.  The Maven version (of `1.0-SNAPSHOT`) is mapped to a valid OSGi
    version where needed. Hence the OSGi bundle will have version
    `1.0.0.SNAPSHOT`.
3.  The Export-Package tag specifies the packages exported from the
    bundle. The generated Export-Package header in the bundle will have
    the versions as specified in the packageinfo files. Uses clauses
    will also be added if applicable.
4.  It is not necessary to specify the Bundle-SymbolicName. If omitted
    it is generated from the maven artifact group ID and artifact ID
    together.
5.  The maven-bundle-plugins will generate other required OSGi manifest
    headers such as Bundle-ManifestVersion, and adds OSGi manifest
    headers that map to Maven metadata such as Bundle-Name,
    Bundle-Version and Bundle-License where this makes sense.

### Service Bundle

The example Service Bundle has an Activator that registers an
implementation of the MyService interface in the OSGi Service Registry:

`package org.example.osgi.svc.impl;`  
``  
`import org.example.osgi.api.MyService;`  
`import org.osgi.framework.*;`  
``  
`public class Activator implements BundleActivator {`  
`    private ServiceRegistration reg;`  
``  
`    @Override`  
`    public void start(BundleContext context) throws Exception {`  
`        reg = context.registerService(MyService.class.getName(), new MyServiceImpl(), null);`  
`    }`  
``  
`    @Override`  
`    public void stop(BundleContext context) throws Exception {`  
`        reg.unregister();`  
`    }`  
`}`

As can be seen from the imports above, there are two dependencies:

-   The MyService interface defined in the api-bundle
-   The OSGi framework APIs

The `org.example.osgi.svc.impl` is an implementation package that will
not be exported and therefore does not need to be versioned.

The service bundle can be built using this
`[http://github.com/bosschaert/osgi-toolchain-mvn-felix-eclipse-example/blob/master/service-bundle/pom.xml pom.xml]`:

`<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"`  
`  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">`  
`  <modelVersion>4.0.0</modelVersion>`  
``  
`  <parent>`  
`    <groupId>org.example.osgi.mvn-felix-eclipse</groupId>`  
`    <artifactId>mvn-felix-eclipse-example</artifactId>`  
`    <version>1.0-SNAPSHOT</version>`  
`  </parent>`  
`  <artifactId>service-bundle</artifactId>`  
`  <packaging>bundle</packaging>`  
``  
`  <dependencies>`  
`    <dependency>`  
`      <groupId>${project.groupId}</groupId>`  
`      <artifactId>api-bundle</artifactId>`  
`      <version>${project.version}</version>`  
`      <scope>provided</scope>`  
`    </dependency>`  
`  `  
`    <dependency>`  
`      <groupId>org.osgi</groupId>`  
`      <artifactId>org.osgi.core</artifactId>`  
`      <version>4.2.0</version>`  
`      <scope>provided</scope>`  
`    </dependency>`  
`  </dependencies>`  
`  `  
`  <build>`  
`    <plugins>`  
`      <plugin>`  
`        <groupId>org.apache.felix</groupId>`  
`        <artifactId>maven-bundle-plugin</artifactId>`  
`        <extensions>true</extensions>`  
`        <configuration>`  
`          <instructions>`  
`            <Bundle-SymbolicName>${project.name}</Bundle-SymbolicName>`  
`            <Bundle-Activator>org.example.osgi.svc.impl.Activator</Bundle-Activator>`  
`            <Import-Package>*</Import-Package>`  
`          </instructions>`  
`        </configuration>`  
`      </plugin>`  
`    </plugins>`  
`  </build>`  
`</project>`

The dependencies are described here as ordinary Maven dependencies. Some
noteworthy elements:

-   No packages are exported from this bundle. All the code is private
    so there is no Export-Package instruction.
-   The dependencies are listed with the `provided` scope. Note that
    without specifying this scope you may end up finding your
    dependencies embedded in your resulting bundle, which is generally
    not what you want.
-   The Bundle-Activator is specified as part of the configuration.
-   Imported packages are not explicitly listed. For this project a
    simple `*` wildcard works fine. The maven plugin will generate the
    Import-Package statement from the dependencies used in the code.
-   The generated Import-Package statement in the bundle uses the OSGi
    semantic versioning rules combined with the exported package
    versions of the dependencies to generate the following
    Import-Package statement:

`Import-Package: org.example.osgi.api;version="[1.0,2)",org.osgi.framework;version="[1.5,2)" `

More specific Import-Package rules can be specified. See the
[felix](http://felix.apache.org/site/apache-felix-maven-bundle-plugin-bnd.html)
and [BND](http://www.aqute.biz/Bnd/Bnd) documentation.

### Consumer Bundle

The consumer bundle uses a basic
[ServiceTracker](http://www.osgi.org/javadoc/r4v42/org/osgi/util/tracker/ServiceTracker.html)
in its bundle activator to track `MyService` implementations. When a
`MyService` implementation is found, it is invoked with `Testing123` as
argument.

`package org.example.osgi.consumer.impl;`  
``  
`import org.example.osgi.api.MyService;`  
`import org.osgi.framework.*;`  
`import org.osgi.util.tracker.ServiceTracker;`  
``  
`public class Activator implements BundleActivator {`  
`    private ServiceTracker st;`  
``  
`    @Override`  
`    public void start(BundleContext context) throws Exception {`  
`        st = new ServiceTracker(context, MyService.class.getName(), null) {`  
`            @Override`  
`            public Object addingService(ServiceReference reference) {`  
`                Object svc = super.addingService(reference);`  
`                if (svc instanceof MyService) {`  
`                    invokeService((MyService) svc);`  
`                }`  
`                return svc;`  
`            }`  
`        };`  
`        st.open();`  
`    }`  
``  
`    @Override`  
`    public void stop(BundleContext context) throws Exception {`  
`        st.close();`  
`    }`  
``  
`    void invokeService(MyService svc) {`  
`        String input = "Testing123";`  
`        System.out.println("Invoking Service with input: " + input);`  
`        System.out.println("  Result: " + svc.doSomething(input));`  
`    }`  
`}`

The
[pom.xml](http://github.com/bosschaert/osgi-toolchain-mvn-felix-eclipse-example/blob/master/consumer-bundle/pom.xml)
for the consumer bundle is nearly identical to the one from the
service-bundle.

Note that the consumer-bundle ***has no*** dependency on the
service-bundle but rather depends on the api-bundle. There is no direct
link between the service implementor and consumer.

### Building it all

To build all three bundles run:

`mvn install`

At the root of the directory tree. You'll see it finish as follows:

`[INFO] ------------------------------------------------------------------------`  
`[INFO] Reactor Summary:`  
`[INFO] `  
`[INFO] mvn-felix-eclipse-example ......................... SUCCESS [0.275s]`  
`[INFO] api-bundle ........................................ SUCCESS [1.487s]`  
`[INFO] service-bundle .................................... SUCCESS [0.518s]`  
`[INFO] consumer-bundle ................................... SUCCESS [0.356s]`  
`[INFO] ------------------------------------------------------------------------`  
`[INFO] BUILD SUCCESS`  
`[INFO] ------------------------------------------------------------------------`  
`[INFO] Total time: 3.328s`  
`[INFO] Finished at: Mon Jul 23 11:33:37 IST 2012`  
`[INFO] Final Memory: 11M/81M`  
`[INFO] ------------------------------------------------------------------------`

The generated bundles are in the `target` directories of each module's
subdirectory.

Eclipse IDE
-----------

The Maven configuration described above can be imported into Eclipse by
using the 'Eclipse Maven Integration' [m2e Eclipse
plugin](http://www.eclipse.org/m2e).

This description uses Eclipse 3.8 with the m2e plugin installed.

### Importing the Maven projects

Import the projects into Eclipse using the Maven project import wizard.

![](MavenImport1.png "MavenImport1.png")

Select the directory that contains the root pom.

![](MavenImport2.png "MavenImport2.png")

Click Finish and you have your Eclipse workspace configured.

![](Eclipse.png "Eclipse.png")

### Launching and Debugging

In Eclipse running and debugging use the same launch configuration. This
example shows how to debug the OSGi service.

Start by setting a breakpoint in the service implementation:

![](Breakpoint.png "Breakpoint.png")

Next launch the framework in debug mode. Create a new Debug Launch
configuration for an OSGi Framework. Deselect all bundles of the Target
Platform and select all bundles from the workspace.

![](LaunchConfig.png "LaunchConfig.png")

Note that if not all your bundles appear in the Workspace list, you can
make them appear by restarting Eclipse. There seems to be a bug in the
m2e plugin in relation to refreshing project information in the launch
configuration. You may need to convert them to plug-in projects.
Right-click project -\> Configure -\> Convert to Plug-in Projects...

Note: As of Eclipse 3.8 its necessary to specify 4 bundles in the Target
Platform to load the Eclipse Console properly:

`org.apache.felix.gogo.command`  
`org.apache.felix.gogo.runtime`  
`org.apache.felix.gogo.shell`  
`org.eclipse.equinox.console`  
`org.eclipse.osgi.services`

Older versions of Eclipse don't need this configuration. Click "Add
Required Bundles" to ensure everything you need is there.

You may also need to add the following to the imported packages section
in dependencies: Consumer-bundle

`org.example.osgi.api`  
`org.osgi.framework`  
`org.osgi.util.tracker`

Service-bundle

`org.example.osgi.api`  
`org.osgi.framework`

The IDE will launch the framework in debug mode and as soon as the
service is invoked it stops at the breakpoint from where we can do the
debugging.

![](Debugging.png "Debugging.png")

In the console at the `osgi>` prompt the OSGi shell can also be used to
control the framework.

The same launch configuration can be used to run the bundles outside of
the debugger.

System Testing
--------------

### Pax Exam

[Pax Exam](http://team.ops4j.org/wiki/display/paxexam3/Pax+Exam) is a
testing framework for testing OSGi bundles in a Maven environment. Pax
Exam is developed by the OPS4J Community licensed under the Apache
License 2.0.

This section shows how to test the functionality in the Service Bundle.
The test makes assumptions about how the Service Bundle interacts with
the OSGi framework and hence it requires the tests to run in an actual
OSGi framework. Pax Exam provides such a testing environment.

#### Service Bundle Tests `pom.xml`

The tests are stored in a separate Maven module: `service-bundle-tests`.
Its
[pom.xml](http://github.com/bosschaert/osgi-toolchain-mvn-felix-eclipse-example/blob/master/service-bundle-tests/pom.xml)
takes care of setting up Pax Exam and its dependencies.

` `<project>  
`   `<modelVersion>`4.0.0`</modelVersion>  
` `  
`   `<parent>  
`     `<groupId>`org.example.osgi.mvn-felix-eclipse`</groupId>  
`     `<artifactId>`mvn-felix-eclipse-example`</artifactId>  
`     `<version>`1.0-SNAPSHOT`</version>  
`   `</parent>  
`   `<artifactId>`service-bundle-tests`</artifactId>  
` `  
`   `<properties>  
`     `<paxexamversion>`2.5.0`</paxexamversion>  
`     `<paxurlversion>`1.4.0`</paxurlversion>  
`   `</properties>  
` `  
`   `<dependencies>  
`     `<dependency>  
`       `<groupId>`${project.groupId}`</groupId>  
`       `<artifactId>`api-bundle`</artifactId>  
`       `<version>`${project.version}`</version>  
`       `<scope>`provided`</scope>  
`     `</dependency>  
` `  
`     `  
`     `<dependency>  
`       `<groupId>`org.ops4j.pax.exam`</groupId>  
`       `<artifactId>`pax-exam-container-native`</artifactId>  
`       `<version>`${paxexamversion}`</version>  
`       `<scope>`test`</scope>  
`     `</dependency>  
` `  
`     `<dependency>  
`       `<groupId>`org.ops4j.pax.exam`</groupId>  
`       `<artifactId>`pax-exam-junit4`</artifactId>  
`       `<version>`${paxexamversion}`</version>  
`       `<scope>`test`</scope>  
`     `</dependency>  
` `  
`     `<dependency>  
`       `<groupId>`org.ops4j.pax.exam`</groupId>  
`       `<artifactId>`pax-exam-link-mvn`</artifactId>  
`       `<version>`${paxexamversion}`</version>  
`       `<scope>`test`</scope>  
`     `</dependency>  
` `  
`     `<dependency>  
`       `<groupId>`org.ops4j.pax.url`</groupId>  
`       `<artifactId>`pax-url-aether`</artifactId>  
`       `<version>`${paxurlversion}`</version>  
`       `<scope>`test`</scope>  
`     `</dependency>  
` `  
`     `<dependency>  
`       `<groupId>`org.apache.felix`</groupId>  
`       `<artifactId>`org.apache.felix.framework`</artifactId>  
`       `<version>`4.0.3`</version>  
`       `<scope>`test`</scope>  
`     `</dependency>  
` `  
`     `  
`     `<dependency>  
`       `<groupId>`org.slf4j`</groupId>  
`       `<artifactId>`slf4j-simple`</artifactId>  
`       `<version>`1.5.10`</version>  
`       `<scope>`test`</scope>  
`     `</dependency>  
`   `</dependencies>  
` `</project>

Note that Pax Exam can work with many OSGi frameworks, the above example
`pom.xml` happens to use Apache Felix.

#### Service Bundle test class

A small Pax Exam-based system test can be written as in
[MyServiceTestCase.java](http://github.com/bosschaert/osgi-toolchain-mvn-felix-eclipse-example/blob/master/service-bundle-tests/src/test/java/org/example/osgi/svc/MyServiceTestCase.java):

` package org.example.osgi.svc;`  
` `  
` import javax.inject.Inject;`  
` import org.example.osgi.api.MyService;`  
` import org.junit.Assert;`  
` import org.junit.Test;`  
` import org.junit.runner.RunWith;`  
` import org.ops4j.pax.exam.CoreOptions;`  
` import org.ops4j.pax.exam.Option;`  
` import org.ops4j.pax.exam.junit.Configuration;`  
` import org.ops4j.pax.exam.junit.JUnit4TestRunner;`  
` import org.osgi.framework.BundleContext;`  
` import org.osgi.framework.ServiceReference;`  
`  `  
` @RunWith(JUnit4TestRunner.class)`  
` public class MyServiceTestCase {`  
`  `  
`   @Inject`  
`   private BundleContext ctx;`  
`  `  
`   @Configuration`  
`   public Option[] config() {`  
`     return CoreOptions.options(`  
`       CoreOptions.mavenBundle("org.example.osgi.mvn-felix-eclipse", "api-bundle"),`  
`       CoreOptions.mavenBundle("org.example.osgi.mvn-felix-eclipse", "service-bundle"),`  
`       CoreOptions.junitBundles());`  
`   }`  
`  `  
`   @Test`  
`   public void getHelloService() {`  
`     ServiceReference ref = ctx.getServiceReference(MyService.class.getName());`  
`     MyService svc = (MyService) ctx.getService(ref);`  
` `  
`     Assert.assertEquals("This service implementation should reverse the input",`  
`       "4321", svc.doSomething("1234"));`  
`   }`  
` }`

This example test verifies the service registration done in the Service
Bundle. The `config()` method specifies the bundles that need to be
installed as part of the test run. The `service-bundle` has a dependency
on `api-bundle` so both are specified. The test method itself uses the
injected `BundleContext` to interact with the OSGi framework. Note that
the `@RunWith(JUnit4TestRunner.class)` is needed to have the test run
via Pax Exam.

#### Running the Bundle Tests

Running the tests from maven is simply done by executing the following
from the service-bundle-tests directory:

` mvn test`

or

` mvn install`

After running this command you'll see the following output:

` -------------------------------------------------------`  
`  T E S T S`  
` -------------------------------------------------------`  
` Running org.example.osgi.svc.MyServiceTestCase`  
` ... lots of logging output ...`  
` Tests run: 1, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 0.788 sec`  
` `  
` Results :`  
` `  
` Tests run: 1, Failures: 0, Errors: 0, Skipped: 0`  
` `  
` [INFO] ------------------------------------------------------------------------`  
` [INFO] BUILD SUCCESS`  
` [INFO] ------------------------------------------------------------------------`  
` [INFO] Total time: 2.444s`  
` [INFO] Finished at: Fri Dec 21 13:15:26 GMT 2012`  
` [INFO] Final Memory: 5M/81M`  
` [INFO] ------------------------------------------------------------------------`

This example only shows a very small subset of what is possible with Pax
Exam. For more options and details on how to set up debugging see the
[Pax Exam documentation
pages](http://team.ops4j.org/wiki/display/paxexam/Documentation).

