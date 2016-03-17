---
title: Prosyst toolchain
summary: Prosyst toolchian for creating standard bundles
---

The toolchain described on this page is suitable for creating standard
OSGi bundles and integrate them in full working runtime environments.
**ProSyst mBS SDK** is a set of Eclipse IDE plugins that provide a rich
OSGi development experience, enabling 3rd party developers to easily
create, optimize and test OSGi applications and services. For this
tutorial we will create a simple bundle and integrate it on a full
runtime environment running **mBS OSGi** framework.

The example is based on the OSGi 4.2 framework APIs using ProSyst mBS
SDK 7.3. More detailed information on each step can be found on the [mBS
SDK
documentation.](http://dz.prosyst.com/pdoc/mBS_SH_SDK_7.3.0/getting_started/stepbystep.html)

## Getting Started with ProSyst mBS SDK

To start creating bundles and runtime environments first you should
download an [evaluation version](http://dz.prosyst.com/download/) of the
ProSyst mBS SDK. You should then install it on your Eclipse IDE
following the instructions
[here](http://dz.prosyst.com/pdoc/mBS_SH_SDK_7.3.0/getting_started/gs_eclipse.html).

  
  

## Overview of the Bundle Development Process

A bundle can provide some functionality to other bundles in the form of
services. In such case you go through all steps below.

If your bundle contains Java code, for example for starting and stopping
threads, but this code is not intended to be used by other bundles as a
service, you can ignore steps 1 and 2.

A bundle can simply export a library to other bundles in the framework -
it does not need a Bundle Activator nor should it register services.
Hence, you may skip steps 1, 2 and 3.

![](devbundles.png "devbundles.png")

Step 1. **Service** **Interface**

There must be an interface for each service that will be included in the
bundle. This interface represents the service to the other bundles in
the server.

Step 2. **Service Interface Implementation**.

Each service has its own implementation. There must be at least one
class that implements the interface. There can be some help components
as well.

Step 3. **Bundle Activator**.

There should be a class which implements
org.osgi.framework.BundleActivator to define starting and stopping
operations on the bundle.

Step 4. **Source Code Compilation**. After all bundle-related Java files
are written, they should be compiled so that they can be loaded on the
framework.

Step 5. **Manifest File**.

This is a text file that contains miscellaneous properties and values of
bundles. The properties are defined in the OSGi Framework Specification
document. For example, they can be Java packages to import and the class
name of the Bundle Activator.

Step 6. **Bundle JAR File.**

When all files for a bundle are created (class files and manifest), they
must be packed in a JAR file so that the bundle can be deployed on the
OSGi framework.

Step 7. **Bundle Deployment.**

To activate a bundle, a bundle developer installs and starts it on the
OSGi framework.

Step 8. **Bundle Management.**

The OSGi framework supports enhanced runtime management of a bundle.

### **Step 1. Create the Service Interface**

Bundle developers register and access a service in a bundle through the
service interface. The service interface defines the methods that the
consumers of the service can call.

To clarify, consider the `Test` service interface. Test declares a
single method, `showHello`. The service interface, in particular its
Java package, is exported to other bundles through the *Export-Package*
header in the bundle manifest file.

` `  
`  package bundles.test.serv;`  
`     public interface Test {`  
`       public void showHello();          `  
`    }`

### **Step 2. Create the Service Interface Implementation**

You must provide an implementation of the service interface. Later, you
should provide an instance of the implementation class when registering
the service in the framework.

The Test interface implementation is the `TestImpl` class. The
`showHello` method simply prints a string in the system output. Since
the `Test` interface is small, there are no additional classes in this
implementation.

``  
`  package bundles.test.serv; `  
`    public class TestImpl implements Test { `  
`      public  void showHello() {`  
`       System.out.println("Hello framework!");`  
`      }`  
`    }`

### **Step 3. Create the Bundle Activator**

The Bundle Activator object implements the
`org.osgi.framework.BundleActivator` interface. In the start/stop method
of the Bundle Activator, the programmer encloses the operations that the
bundle executes when started/stopped. Such operations are:

1.  On bundle start. When started, start is called by the Framework.
    -   Registering the services in a bundle.
    -   Referring to other services to retrieve data for the proper
        operation of the bundle.
    -   Starting threads

2.  On bundle stop. When stopped, the Framework invokes stop .
    -   Unregistering the services in the bundle.
    -   Releasing all engaged services when resolving the bundle.
    -   Terminating threads

If the operation mode of your bundle does not require any special
settings at startup, such as service registration or consumption, it is
not necessary to have a Bundle Activator.

#### Registering a Service

After you provide the service interface and its implementation, in the
body of the `BundleActivator.start()` method you can register the
service with the framework. For this purpose, use the
`org.osgi.framework.BundleContext` object passed by the framework. Of
course, you can register the service in another bundle class.

You register a service under the class name of the interface. Pair this
class name with an instance of the interface implementation (the
so-called *service object*).

The code bellow contains the `TestActivator` class that registers a
service under the Test interface class name. `TestActivator` provides a
service object, implementing the Test interface (a TestImpl instance).

``  
`package bundles.test.serv;`  
` `  
`import java.util.*; `  
`import org.osgi.framework.*;`  
`                 `  
`public class TestActivator implements BundleActivator {`  
`  ServiceRegistration servReg;  `  
` `  
`  public void start(BundleContext bc) throws BundleException {`  
`    try {`  
`      TestImpl servImpl = new TestImpl();`  
`      Hashtable properties = new Hashtable();`  
`      properties.put("description", "simple test service");        `  
`      servReg = bc.registerService("bundles.test.serv.Test", servImpl, properties);`  
`    } catch (Exception exc) {`  
`      throw new BundleException(exc.getMessage(), exc);`  
`    }`  
`  }`  
`            `  
`  public void stop(BundleContext bc) throws BundleException {`  
`    servReg.unregister();     `  
`  }`  
`} `

You can send a specific service object to each requesting bundle by
means of a Service Factory. A Service Factory must implement the
`org.osgi.framework.ServiceFactory` interface. This interface defines
the `getService` and `ungetService` methods. The `getService` method is
invoked by the framework the first time the specified bundle requests a
service object by using the `BundleContext.getService`(ServiceReference)
method. The `ungetService` method is invoked by the framework when a
service has been released by a bundle.

The example in this guide defines a Service Factory called
`TestFactory`. The `getService` method extracts the ID of the requesting
bundle and prints it to the system output. At each invocation of the
service, a new service object is created and subsequently passed to the
requesting bundle. The ungetService method has an empty implementation
for conciseness.

``  
`  package bundles.test.serv; `  
` `  
`  import org.osgi.framework.*; `  
` `  
`  public class TestFactory implements ServiceFactory {`  
`    public Object getService(Bundle requester, ServiceRegistration servReg) { `  
`      long requesterId = requester.getBundleId();`  
`      System.out.println("The Id of the requesting bundle is: " + requester);`  
`      return new TestImpl();`  
`    }`  
` `  
`    public void ungetService(Bundle requester,`  
`                             ServiceRegistration servReg, `  
`                             Object service) {`  
`    }`  
`  } `

To activate a Service Factory, pair the service interface with the
Service Factory object at service registration instead of with the
service interface implementation.

In the example below, the `TestActivator` class registers a service
using `TestFactory`.

``  
`(...)`  
` try {  `  
`      ServiceFactory factory = new TestFactory();`  
`      Hashtable properties = new Hashtable(); `  
`      properties.put("Description", "Simple test service");`  
`      servReg = bc.registerService("bundles.test.serv.Test", factory, properties);`  
`      } catch(Exception exc) {`  
`        throw new BundleException(exc.getMessage(), exc);`  
`      }`  
`(...)`

#### Obtaining and Releasing a Service

If you need to consume services found in other bundles running in the
framework, you can refer them with the `BundleContext` object assigned
to your bundle. First, you should call the
`BundleContext.getServiceReference()` method to obtain
`org.osgi.framework.ServiceReference` for the target service. Next, you
can retrieve the service object with `BundleContext.getService` passing
the `ServiceReference` object as the argument. To release a service
object, use `BundleContext.ungetService`.

You can get the class name(s) under which a service is registered using
`ServiceReference.getProperty` method with the "objectClass" key (the
`org.osgi.framework.Constants.OBJECTCLASS` field).

Another important issue is that of tracking the services you need - it
is possible that the service previously retrieved has been unregistered
and the service object you have is no longer valid. Another case is when
the service you need is not available at startup - your bundle might
halt its execution until the service becomes obtainable. According to
the OSGi Core Specification, there are two ways to trace the
availability of a service - by using a service listener and by using a
service tracker.

Service Listener - Using a service listener follows to a high extent the
conventional Java model of event delivery by means of listeners. In this
case, you have to implement an `org.osgi.framework.ServiceListener`,
which will receive events synchronously when a service object is
registered, unregistered or modified (i.e. the properties of the service
have changed). To distinguish the events, use the `getType` method of
the `ServiceEvent` object passed in the listener's serviceChanged method
and compare it with `ServiceEvent.REGISTERED, ServiceEvent.MODIFIED` and
`ServiceEvent.UNREGISTERING`. To activate the listener, invoke the
`addServiceListener` method of `BundleContext` provided to your bundle
activator.

When using a service listener, prior to listener registration you should
initially obtain the service by using the method calls
getServiceReference and then getService on the BundleContext. Using the
listener pattern also may lead to some potential faults since it is
possible several threads to simultaneously synchronously call the
listener.

Service Tracker - Using a service tracker will ease you in tracing a
certain service (you do not have to retrieve the service in advance) and
will avoid potential problems related to the synchronous access to a
service listener. To benefit from the service tracker utility,
instantiate `org.osgi.util.tracker.ServiceTracker` providing as
constructor arguments the `BundleContext` allocated to your bundle, the
full class name of the service interface, and optionally a
`ServiceTrackerCustomizer` for customized service tracking. Then, call
tracker's open method. Next, when your bundle needs the service, get it
by invoking the `getService` method of the tracker.

The `AnotherActivator` class below is a Bundle Activator that uses the
`BundleContext` objects in its start and stop methods to retrieve and
free the Test service discussed in this document. It is assumed that the
Test service is in a bundle, which is running in the framework.

``  
`  import org.osgi.framework.BundleActivator;`  
`  import org.osgi.framework.BundleContext;`  
`  import org.osgi.framework.ServiceReference;`  
`  import bundles.test.serv.Test;`  
`  `  
`  public class AnotherActivator implements BundleActivator {`  
` `  
`    ServiceReference servRef;`  
`    Test serv;`  
`  `  
`    public void start(BundleContext bc) {  `  
`      servRef = bc.getServiceReference("bundles.test.serv.Test");`  
`      serv = (Test) bc.getService(servRef);`  
`      serv.showHello();`  
`    }`  
`  `  
`    public void stop(BundleContext bc) {`  
`      bc.ungetService(servRef); `  
`    } `  
`  } `

**Troubleshooting:**

1.  If you do not specify your Bundle Activator as a public class, you
    will receive an IllegalAccessException at bundle startup. The
    framework throws this exception because it tries to instantiate this
    class but it cannot access it.
2.  A thread may keep running after the bundle stops. This occurs
    because the JVM cannot clean up locks when the stop method of a
    thread is called. In this case, you should explicitly quit the
    threads of the bundle in BundleActivator.stop().

### **Step 4. Compile the Java Source Code**

To produce class files, which the target Java virtual machine will
launch, you have to compile the bundle's Java source files. You can
include in the classpath the JAR files of referenced bundles, and
bundles/syslib.jar, which holds the OSGi framework implementation
including the APIs from the OSGi Service Platform Core Specification and
custom service and utility APIs.

Assuming that the Java files are placed in the test/serv directory, the
compilation command using the JDK compiler can be:

**Windows:**

`javac -classpath .;C:/osgi_sdk/runtime/osgi/bundles/syslib.jar test/serv/*.java`

**Linux:**

`javac -classpath .;/home/user/osgi_sdk/runtime/osgi/bundles/syslib.jar test/serv/*.java`

### **Step 5. Write the Manifest File**

The bundle developer decides what properties should be put in the
manifest file. Bundle properties are reviewed in the OSGi Service
Platform Core Specification document. Consider these bundle properties
and their values:

``  
`Manifest-Version: 1.0`  
`Bundle-Vendor: ACME Corp.`  
`Bundle-Version: 1.6`  
`Bundle-Activator: bundles.test.serv.TestActivator`  
`Bundle-Name: Test Bundle`  
`Export-Package: bundles.test.serv`  
`Export-Service: Test Service`  
`Import-Package: org.osgi.framework; version="1.4"`  
`Bundle-SymbolicName: bundles.test.service`  
`Bundle-ManifestVersion: 2`

**Troubleshooting:**

1.  If your bundle has a Bundle Activator and the *Bundle-Activator*
    header is missing in the manifest, the bundle may not start and no
    error may be indicated.
2.  If in the *Bundle-Activator* header you specify a class that does
    not implement `org.osgi.framework.BundleActivator`, the framework
    will throw a `BundleException` at bundle startup.
3.  Make sure that you write each header in a new line, i.e. that you
    use CRLF as separator between two headers. Otherwise, the framework
    will not read the header information and load the necessary
    resources.
4.  If the Bundle Activator imports package not declared within the
    Import-Package manifest header, a `java.lang.ClassNotFoundException`
    exception will be thrown at startup.

### **Step 6. Generate the Bundle JAR File**

You can generate the bundle JAR file by using the jar command of the
JDK. Assuming that the class files and the manifest file are located in
the test/serv directory, the command could be:

` jar cmf test/serv/manifest.mf testbundle.jar test/serv/*.class `

**Troubleshooting:** If the bundle JAR does not include the Bundle
Activator specified in the manifest, the framework will throw a
ClassNotFoundException at bundle startup.

### Step 7. Install and Start the Bundle

To activate the bundle, you must install and start it on the OSGi
framework, for example by using the Text Console or the Web Admin
Console.

### Step 8. Manage and Reconfigure the Bundle

After running the bundle on the OSGi Runtime, you can manage the bundle
life cycle by means of console or visual administration.

**Troubleshooting:** Usually, defining a synchronised method improperly
may bring a deadlock situation and cause the server framework to hang.
To achieve greater efficiency, most of the framework job is done within
the same thread as the requester that caused the deadlock. You can
decrease deadlocks if you do not refer the framework in synchronised
methods.

  
  

Creating a Bundle
=================

### Create a Plug-in Project

1. Select File \> New \> Project.

2. In the dialogue that appears, choose the Plug-in Project option and
click Next.

![](create-plugin-project.png "create-plugin-project.png")

3. In the next dialogue, fill in the project's name in the Project name
field and check the an OSGi Framework option in the Target Platform pane
and choose the standard option from the drop-down menu. Click Next to
proceed.

![](project-properties.png "project-properties.png")

4. Finally, you have to specify an initial set of properties for the new
bundle:

![](plugin-properties.png "plugin-properties.png")

-   **Plug-in ID** – Bundle's symbolic name. It is a unique
    non-localizable name based on the reverse domain name convention.
    The symbolic name along with the bundle version will uniquely
    identify the bundle in the framework. The existence of more than one
    bundle with the same version and symbolic name is forbidden.
-   **Plug-in Version** – Bundle's version.
-   **Plug-in Name** – Human-readable name for the bundle.
-   **Plug-in Provider** – Bundle's vendor.
-   **Execution Environment** - The minimum set of Java APIs required
    for the bundle to run as discussed in the OSGi Compendium
    Specification 4.2. In Eclipse the execution environment should be
    mapped to a selected JRE. On the target device, the OSGi framework
    automatically changes the set of supported execution environments
    depending on the JVM it is started on.
-   '''Classpath '''– A comma-separated list of JAR file path names or
    directories inside the bundle containing classes and resources.
-   '''Options '''– In this pane, to have the bundle activator structure
    (an implementation of the `org.osgi.framework.BundleActivator`
    interface) automatically created, select the Generate an activator,
    a Java class that controls the plug-ins life cycle option from the
    Options pane. Specify the class name in the Activator field.

5. Select Next to use a template to have a simple bundle structure
generated by Eclipse. Optional Step

![](plugin-templates.png "plugin-templates.png")

6. Click Finish when ready. As a result, Eclipse will generate the
skeleton of the plug-in project, respectively of the OSGi bundle. When
prompted if the project should be associated with the plug-in
development perspective, choose Yes.

![](plugin-project-struct.png "plugin-project-struct.png")

Two of the components that have been generated are the bundle activator
and the bundle manifest. The bundle activator provides start and stop
methods for initialisation at bundle startup and for resource disposing
operations at bundle stop. The bundle manifest however, contains headers
which the framework interprets in order to install and activate the
bundle correctly. The manifest is named '''MANIFEST.MF '''and is located
in the ''META-INF ''directory. Initially, it will contain only the
headers that correspond to the plug-in properties, provided during the
creation of the plug-in project. For example, the manifest file of the
bundle we have created looks like this:

![](manifest.png "manifest.png")

  
  

### Write Program Code and Resources

After you create the plug-in project to hold the content of your bundle,
you can proceed with developing bundle's Java code and relevant
resources within Eclipse. The APIs provided in the OSGi Runtime
modification you have chosen as the PDE target platform will
automatically become available in the "code assist" feature of the Java
editor.

  
  

### Build the Bundle

After you have created the bundle content, you can build it into a JAR
file to install it on the OSGi Runtime, transfer it to another device,
etc.

To build a bundle JAR file in Eclipse:

1. Choose the plug-in project where the bundle resides.

2. Select the Export command from the popup menu or from the File menu.

3. From the dialogue that appears, expand the Plug-in Development node
and choose the Deployable plug-ins and fragments option. Click Next to
continue.

![](export-options.png "export-options.png")

4. In the next dialogue, select the bundles you would like to export
from the Available Plug-ins and Fragments pane. Then specify the
location where the JAR file will be generated in the Directory field:

![](export-jar.png "export-jar.png")

In case you want to have the JAR file signed, go to the JAR Signing tab
and specify the keystore holding signer's key pair and certificate. If
needed, use the options in the Options tab, e.g. to replace the
"qualifier" part from the bundle version with a specific string.

5. Click Finish to trigger the generation. After the process finishes,
you will be able to find the newly-created JAR file at the plugins
folder rooted in the earlier specified directory path. The file will be
named after the plug-in's ID and version, i.e. after the bundle symbolic
name and version.

  
  

### Install the Bundle

To install a bundle from Eclipse on an OSGi Runtime image, use the
options of the Frameworks view (install from your local file system) or
of the Package Explorer view within the Plug-in Development perspective
(install from the workspace).

  
  

### Sign the Bundle

If the target OSGi Runtime is started with security management based on
signer-specific permissions, you can sign your bundles with an "own"
certificate (private/public key pair and certificate) so that they will
receive specific permissions upon startup. Unsigned bundles will get
only a limited set of permissions and will be able to execute only a few
operations in the OSGi context.

You have two options for signing:

-   At generation of the bundle JAR file through the Eclipse PDE export
    wizard. In this case, you can specify only one signer of the bundle.
-   Upon installation of the bundle on the target OSGi Runtime through
    the Eclipse tooling of the OSGi SDK. To turn on this feature:

1. Specify JDK jarsigner executable and signer certificates in the
mToolkit preferences page (Window \> Preferences \> mToolkit \>
Certificates).

![](sign_prefs.png "sign_prefs.png")

2. Go to the Frameworks view in the workbench and open the connection
properties of the OSGi Runtime.

3. Check the Sign content before deployment box from the runtime's
connection properties and select the own certificate entries to use for
signing bundles.

![](sign.png "sign.png")

  
  

## Create and Model an Image Description

1. Create an image description file to hold the settings for the later
image generation.

-   Select a project/folder you have created in advance in one of the
    navigation views of the workbench and from the File menu select File
    \> New \> Other.
-   In the shown dialogue, expand the OSGi node and click Image
    Description to open the corresponding wizard. Click Next.
-   In the New Image Description wizard specify the location and name of
    the image description as well as if it will inherit the settings
    from another description or if it will be created from the scratch.

The Smart Home Runtime comes with a set of three predefined target
images - **Basic OSGi**, **Core OSGi** and **Home Gateway**. A target
image represents an instance of the Smart Home Runtime with features
designed to meet the needs of a production use case deployed on a
specific platform.

![](eclipse_workspaceimage_mbs.png "eclipse_workspaceimage_mbs.png")

The **Basic OSGi Image** provides the minimum set of bundles that are
needed for a functional Smart Home Runtime. It contains basic
functionality like mBSA support, APIs from the OSGi Core and Compendium
Specifications 4.2, console administration of the OSGi framework
implementation, etc.

The **Core OSGi Image** is designed to provide the basis for OSGi
application development. Except the basic functionality provided by the
OSGi Basic Image, it also provides functionality that is most likely to
be used on top of the OSGi Framework like the Web Admin Console, OSGi
service APIs and their implementations from the OSGi Core and Compendium
Specifications 4.2, basic ProSyst APIs, etc.

The **Home Gateway Image** is defined to contain the set of bundles
shaping the features most useful for an OSGi-enabled gateway in a home
system. It extends the Core OSGi Image with support for USB
communication, Bluetooth communication, SSL/TLS JSSE-based
communication, video cameras management, KNX device management, ZigBee
standard support, Z-Wave support, notification management, home device
management abstraction, home automation management, etc.

The rich set of features in the ProSyst Smart Home Runtime is delivered
in the form of functional modules. Each module adds support for a
specific technology or API to the OSGi platform. The modular structure
of the product provides a logical paradigm for flexible creation of
images picking up the best configuration of module components for the
target device.

-   Click Finish. On success, the image will be automatically opened in
    the editor of the Eclipse workbench.

2. Add the bundles providing image's functional features. In the image
description editor, configure the set of image bundles in the Bundles
pane. You can insert bundles from the active PDE target platform, from
the workspace and from a location external to Eclipse. Use the Add
Required Bundles button to have the dependencies of specific image
bundles resolved by automatically adding the required bundles from the
target platform.

3. Select the platform the image will execute on. In the Platform
Settings \> Platforms pane, select the device platform. In the Platform
Settings \> Startup Scripts choose the OSGi startup script corresponding
to the JVM the target device will run. 4. (Optional) Include the JVM in
the image if it is not pre-loaded on the device. In the VMs section, if
necessary include the JVM the runtime will execute upon. The OSGi
Runtime contains a pre-packaged J9 2.4 JVM with versions for Windows and
for Linux. If you will use this JVM, you need to specify its location.
The JVM will be present in the <image_root_dir>/jvms/<jvm_dir>
directory.

5. (Optional) For remote management from Eclipse activate tooling
support in the image. In the Build Settings pane, select the Include
tooling support option.

6. (Optional) For detection on OS level of faults and high resource
consumption as well as for remote launching of the OSGi runtime image in
normal, debug or profiling mode from Eclipse, include mBSA. In the Build
Settings pane, select the Include runtime management agent (mBSA)
option.

7. If needed, in the Framework Options pane configure the OSGi framework
features such enable resource management and turn off lazy activation
support.

  
  

Testing
=======

The OSGi Runtime Validator provides means for validating a specific
target image. Validation is performed by using a set of validation
artifacts: start scripts, TEE module from the OSGi Runtime, test
projects, test cases and test configurations.

### Functional Validation

Go through the following steps if you want to execute functional
validation:

1. Make sure you have the Test Execution Environment components present
in your runtime image.

You can use the Image Builder to generate a specific target image that
best suits your requirements and includes the Test Execution Environment
components.

2. Copy the content of the directory tee from the OSGi Runtime Validator
directory (<osgi_sdk_home_dir>/runtime-validator) to the OSGi Runtime
directory (*osgi* by default) within the runtime image on the target
platform.

3. Copy the appropriate test cases from the folder testcases of the OSGi
Runtime Validator to directory *osgi/testcases*.

4. Copy the files from validator's folder bin/vms to the respective
folder in the OSGi Runtime installation directory.

5. Copy the content of the JVM-specific folder bin/vms/<vm_name> to the
respective folder in the OSGi Runtime installation directory and modify
the **tc.prs** file, if needed.

6. It is possible that you have to execute some additional steps for a
concrete OSGi Runtime Module configuration like importing the
certificates available for OSGi Runtime Module testing.

7. Open a console in the bin/vms/<vm_name> OSGi Runtime directory and
execute the `server test` command with the required options - as a
result the **test** script will be called, and then the **server** one
with options that you have specified. The command (or its required
options) to be executed might be different from server test depending on
the concrete OSGi Runtime Module configuration.

8. List available test projects by calling tee.ls -p

9. Execute a chosen test project by calling the `tee.ex` console command
with option -p on a specific project, for example tee.ex -p
osgi\_fw\_tc.xml Project files are related to specific OSGi Runtime
Module configurations.

10. After a project has been executed, the results are generated in HTML
documents in a project-specific sub-directory within the *tee/sa/logs*
directory. The test execution results report has the following structure
by default:

-   <project_name> - Indicates the name of the test project that has
    been executed
-   *<current_date_and_time>*
-   '''summary.html '''- Contains information about the name and the
    status of the executed test case(s), additional test project
    information and a link to the **env.html** document
-   '''env.html '''- Holds a list of all system properties and their
    values set during the test project execution.
-   *<test_case_name_and_version>*
-   '''<current_time_and_date >.html '''- Contains the full description
    of the test case execution results, as well as information about the
    elapsed time and memory delta (specifies the difference between the
    memory at the beginning and at the end of the test case execution).
-   **levels\_<test_case_model>.html** - Holds a short description of
    the different test levels

SDK-specific and OSGi test cases can also be run with different server
test options or by setting different properties in the **tc.prs** file.
One example is running test cases with Java security switched on by
typing in the console: `server test security` or by setting the
mbs.security system property to *jdk12* and the mbs.sm one to *true* in
**tc.prs**.

OSGi test cases require that Java security and certificate handling are
always enabled. To see available script options, check the help of
**server** script by typing server help.

  
  

