# Resolving

## OSGi's Best Kept Secret

This Application Note is about _resolving_ in OSGi. Resolving is the process of constructing an application out of _resources_. Resolving takes a list of _initial requirements_, a description of the _target system(s)_, and one or more _repositories_. It will use the list of initial requirements to find resources in the repository that provide the required capabilities. Clearly, these resources have their own requirements, retrieveing applicable modules is therefore a recursive process. A _resolver_ will find a solution consisting of a set of resources where all requirements are satisfied or indicates there is no solution.

The resolver model is based on technology developed in OSGi since 2006 with [RFC-0112 Bundle Respository](http://www.openehealth.org/download/attachments/688284/rfc-0112_BundleRepository.pdf). This RFC layed out a model that was gradually implemented in the OSGi specifications and for which many tools were developed. Resolving automates a task that is mostlyy done manually today.

<div>
This application note is sponsored by <a href="https://www.sma.de"><img src=https://upload.wikimedia.org/wikipedia/commons/thumb/f/f8/Logo_SMA.svg/40px-Logo_SMA.svg.png></a>
</div>


## What Problem is Being (Re)Solved?

The pain that the resolver solves is well known to anybody that builds application from modules, the so called _assembly_ process. All developers know the dreadful feeling of having to drag in more and more dependencies to get rid of Class Not Found errors when the application starts (or after running for an hour). For many, Maven was a godsend because it made this process so much easier because dependencies in Maven are _transitive_. If you depend on some artifact, then this artifact brings its own dependencies to the final application.

Unfortunately, that godsend is also tainted because of a number of reasons. Though it has become easier to get _a_ result, the result is often littered with unnecessary or wrong artifacts.

* **Our small minds** – The limitatation of the human mind/motivationto properly maintain metadata is limited. Many open source projects show unnecessary dependencies that were once needed but no longer necessary. Fortunately, Maven Central/Sonatype now has become much more restrictive but before this filter a lot of Maven dependencies had errors.
* **Aggregate problem** – The aggregate problem is a dependency that is used for one small part but where a co-packaged part drags in other (and therefore unnecessary) dependencies. For example, many JARs provided support for Ant, a former build tool. This was useful if you happend to use Ant but it caused the addition of the Ant runtime in environments that never used Ant. The aggregate problem causes a serious increase of dependency fan-out in most projects.
* **Version Conflicts** – When you drag in a lot of dependencies then you invariably run into a situation where 2 of your dependencies require the same third dependency but in a different version. (This is called the _diamond_ problem.) Sometimes these versions are really incompatible, sometimes the higher would suffice.
* **Variations** – In many situations it is necessary to create different variations of an application. For example, an application could be delivered for different platforms or a demo and a full version. Since the Maven transitive dependency model creates a fixed graph it is not suitable to assemble these variations easily. That is, there often is not a single runtime.

The result is that all too often the class path of the final application is littered with never used byte codes and/or overlapping packages that came from artifacts with different versions. 

Establishing the perfect class path for an application is a process for which the human mind is extremely badly suited and the transitive model of Maven has too many sharp edges. The resolver provides an alternative model that focuses on looking at the whole solutuon space instead of having to live with the (sometimes arbitrary) decisions of developers of the often 5-6 layers deep transitive dependencies.

## Principles

![image](https://user-images.githubusercontent.com/200494/31130842-cf5299d2-a858-11e7-907c-d6cb43954501.png)

The basic model of the resolving model is quite simple. It consists of just three entities:

* **Resource** – A resource is a _description_ of anything that can be _installed_ in an environment. When it is installed, it adds functions to that environment but before it can be installed it requires certain functions to be present. A resoruce can describe a bundle but it could also describe a piece of hardware or a certificate. It is important to realise that a resource is _not_ the artifact, it is a description of the _relation_ between the artifact and the target environment. For example, in OSGi the bundle is a JAR file that can be installed in a framework. A resource describes formally what that bundle can contribute to the environment and what it needs from the environment.
* **Capability** – A capability is a description of a resource's contribution to the environment when its artifact is installed. A capability has a _type_ and a set of _properties_. That is, it is a bit like a DTO. The type is defined by name and is therefore called the _namespace_. The properties are key value pairs, where the values can be scalars or collections of a `String`, `Integer`, `Double`, and `Long`. 
* **Requirement** – A requirement represents the _needs_ of an artifact when it is installed in the environment. Since we describe the environment with capabilities, we need a way to assert the properties of a capability in a given namespace. A requirement therefore consists of a type and an _OSGi filter_. The type is the same as for the capabilities, it is the namespace. The filter is buildup of a powerful filter language based on LDAP. A filter can assert expressions of arbitrary complexity. A requirement can be _mandatory_ or _optional_.

It is important to realise that a resource and its capabilities and requirements are descriptions. They provide a formal representation of an external artifact. Since these formal representations can be read by a computer, we can calculate a closure of resources that, when installed together, have only resources where all their mandatory requirements are _satisfied_ by the other resources in the closure.

## Core Namespaces

Although the OSGi specifications started out with a set of headers that each had their own semantics, over time the specification migrated completely to the more simple and formal model of Resources, Capabilities, and Requirements. Since the function of the legacy headers were still needed, it was necessary to map these legacy headers to the formal model. This resulted in a number of OSGi core namespaces. 

* `osgi.wiring.identity` – `Bundle-SymbolicName` header.
* `osgi.wiring.bundle` – `Require-Bundle` header.
* `osgi.wiring.package` – `Import-Package` and `Export-Package` headers.
* `osgi.wiring.host` – `Fragment-Host` header.
* `osgi.ee` – `Bundle-RequiredExecutionEnvironment` header.
* `osgi.native` – `Bundle-NativeCode` header.
* `osgi.content` – Provides the URL and checksum to download the corresponding artifact. (This namespace is defined in the compendium Repository specification.)

Each namespace defines the names of the properties and their semantics. For the OSGi namespaces, there are classes like `org.osgi.framework.namespace.IdentityNamespace` that contain the details of a namespace.

## Example

To make the model more clear let's take a closer look to a simple bundle `com.example.bundle` that exports package `com.example.pe` and imports a package `com.example.pi`. When the bundle is installed it will require that some other bundle, or the framework, provides package `com.example.pi`. We can describe this bundle then as follows:

     Resource for bundle B
       capabilities:
         osgi.wiring.identity; osgi.wiring.identity=com.example.bundle
         osgi.wiring.bundle; osgi.wiring.bundle=com.example.bundle
         osgi.wiring.host; osgi.wiring.host=com.example.bundle
         osgi.wiring.package; osgi.wiring.package=com.example.pe
       requirements:
         osgi.ee; filter:="(&(osgi.ee=JavaSE)(version=1.8))"
         osgi.wiring.package; filter:='(osgi.wiring.package=com.example.pi)'

## Who Wants to Provide That Gibberish???

Clearly, an `Export-Package: com.example.pe` is a bit easier to read than the corresponding capability, let alone the filter in the requirement, especially when the versions are taken into accountthe filters become quite unreadable. Clearly, if this had to be maintained by human developers than a model like Maven would be far superior. Fortunately, almost all of the metadata that is needed to make this work does not require any extra work from the developer. For example, the `bnd` tool that is available in Maven, Gradle, Eclipse, Intellij and others can easily analyze a JAR file and automatically generate the requirements and capabilities. 

In certain cases it is necessary to provide requirements and capabilities that bnd cannot infer but then it the [Manifest annotations](http://bnd.bndtools.org/chapters/230-manifest-annotations.html) support in bnd can be used to define an annotation that will add parameterised requirements to the resource.

Really, when you use bndtools none of this gibberish is visible to normal developers unless they have a special case. The gibberish is left to the tools to process this. 

## How to Write Resolvable Bundles

For a bundle to be a good citizen in a resolution it suffices to follow the standard rules of good software engineering. However, since there is so much software out there that does not follow these rules, a short summary.

* **Minimise Dependencies** – Every dependency has a cost. Always consider if all dependencies are _really_ necessary. Although a dependency can provide a short term gain for the coder, it will have consequences for the later stages in the development process. Perfect bundles are bundles that have no dependencies. Unfortunaly they are also then useless. Therefore, a developer must alway be aware of this trade off.
* **API Driven** – Always, always, always separate API and implementation. A lot of developers avoid the overhead of developing an API when they consider the (initial) problem too simple to do the effort of a separate API. The author of this App note is one of them but he never ever did not regret this. Usually he spent a lot of extra effort to add an API afterwards.
* **Service Oriented** – The best dependencies are service oriented dependencies. Services make the coupling between modules explicit and allow different implementations to provide the same service. For example, in OSGi enRoute there is a simple DTOs service that handles type conversions and JSON parsing/generating. In projects where I see the use of Jackson it always seems to cause a mess of requirements.
* **Package Imports** – A bundle can require other bundles (the Maven model) or it can import packages from other bundles. The best imported packages are the ones used for services since they are _specification only_. Second best are _libraries_. Library packages have no internal state nor use statics. Importing implementation packages for convenience is usally deemed bad practice because it often indicates that the decompositon in bundles is not optimal.
* **Import the Exports** – If a package is exported **and** used inside the same bundle then the exported package should also be imported. This allows the resolver more leeway.

To see the requirements and capabilities of a bundle Bndtools has a special `Resolution` view. This shows the requirements and capabilities of a selected JAR file or a bnd.bnd file. This view uses a number of icons to represent the requirements/capabilities. You can hover over them to see further details.

* ![service](https://user-images.githubusercontent.com/200494/31222248-c962b09c-a9c6-11e7-99ac-1977a6c736fd.png) – `osgi.service`. 
* ![bullet_green](https://user-images.githubusercontent.com/200494/31222315-f8e60454-a9c6-11e7-82d8-bbaa7acc46b1.png) – `osgi.identity`
* ![package](https://user-images.githubusercontent.com/200494/31222346-1153abf4-a9c7-11e7-97df-1bfa7a967505.gif) – `osgi.wiring.package`
* ![java](https://user-images.githubusercontent.com/200494/31222445-6a2231ce-a9c7-11e7-8242-c226709f9a76.png) – `osgi.ee`
* ![wand](https://user-images.githubusercontent.com/200494/31222450-7156a204-a9c7-11e7-800e-9c67837f4cef.png) – `osgi.extender`
* ![bundle](https://user-images.githubusercontent.com/200494/31222500-9460eade-a9c7-11e7-9a75-50ae25a35c00.png) – `osgi.bundle`


## Resolving

![Resolving](https://user-images.githubusercontent.com/200494/31221580-73596198-a9c4-11e7-8d11-1e1fe7e37199.png)

The previous diagram adds the resolver to the earlier diagram of the basic model. It adds the following entities:

* **Repository** – A Repository is a collection of resources. Repositories can be represented in many different ways as will be discussed later.
* **Resolver** – The Resolver is the entity that takes a set of _initial requirements_, _system capabilities_, a set of repositories, and produces a _resolution_. 
* **Resolution** – A resolution is a _wiring_ of resources. It provides detailed information what requirements are matched with what capabilities from the included resources.

## Repositories

A _repository_ is a collection of resources. This could be Maven Central or it could be a single bundle. That said, neither is a good idea in practice. The repository is the _scope_ of the resolution. Only resources in the repository can be selected. Although the naive idea then is to make the scope as large as possible to let the computer do the work, it is better to _curate_ the repository. 

The are many reasons why you need a curated repository but basically it comes down is the GIGO principle: garbage is garbage out. Another reason is running time. The resolver gets overwhelmed quickly when there are too many alternatives for a requirement. Resolving is an NP complete problem and this means that the resolution time quickly becomes very long when a lot of alternatives need to be examined.

### Available Repositories

The bnd toolchain provides OSGi Repository access to many popular repository formats.

* **OSGi XML Format** – The OSGi Alliance specified an XML format for repositories which is fully supported by bnd.
* **Maven Central** – You can provide subsets of Maven repositories using a simple text file, a query on Maven Central, or a `pom.xml`. It integrates fully with the local `~/.m2` repository.
* **Eclipse P2** – Eclipse repositories have a web based layout that can be parsed by bnd.
* **File based** – You can store bundles in a directory structure and use it as a repository.
* **Eclipse Workspace** – In bndtools, all generated bundles in a workspaceare directly available to the resolver.

Since bnd has an extensive library to parse bundles and generate the resources it is relatively easy to parse bundles in other ways. For example, there is a Maven plugin that can generate an OSGi index.
# Resolving

## OSGi's Best Kept Secret

This Application Note is about _resolving_ in OSGi. Resolving is the process of constructing an application out of _resources_. Resolving takes a list of _initial requirements_, a description of the _target system(s)_, and one or more _repositories_. It will use the list of initial requirements to find resources in the repository that provide the required capabilities. Clearly, these resources have their own requirements, retrieveing applicable modules is therefore a recursive process. A _resolver_ will find a solution consisting of a set of resources where all requirements are satisfied or indicates there is no solution.

The resolver model is based on technology developed in OSGi since 2006 with [RFC-0112 Bundle Respository](http://www.openehealth.org/download/attachments/688284/rfc-0112_BundleRepository.pdf). This RFC layed out a model that was gradually implemented in the OSGi specifications and for which many tools were developed. Resolving automates a task that is mostlyy done manually today.

<div>
This application note is sponsored by <a href="https://www.sma.de"><img src=https://upload.wikimedia.org/wikipedia/commons/thumb/f/f8/Logo_SMA.svg/40px-Logo_SMA.svg.png></a>
</div>


## What Problem is Being (Re)Solved?

The pain that the resolver solves is well known to anybody that builds application from modules, the so called _assembly_ process. All developers know the dreadful feeling of having to drag in more and more dependencies to get rid of Class Not Found errors when the application starts (or after running for an hour). For many, Maven was a godsend because it made this process so much easier because dependencies in Maven are _transitive_. If you depend on some artifact, then this artifact brings its own dependencies to the final application.

Unfortunately, that godsend is also tainted because of a number of reasons. Though it has become easier to get _a_ result, the result is often littered with unnecessary or wrong artifacts.

* **Our small minds** – The limitatation of the human mind/motivationto properly maintain metadata is limited. Many open source projects show unnecessary dependencies that were once needed but no longer necessary. Fortunately, Maven Central/Sonatype now has become much more restrictive but before this filter a lot of Maven dependencies had errors.
* **Aggregate problem** – The aggregate problem is a dependency that is used for one small part but where a co-packaged part drags in other (and therefore unnecessary) dependencies. For example, many JARs provided support for Ant, a former build tool. This was useful if you happend to use Ant but it caused the addition of the Ant runtime in environments that never used Ant. The aggregate problem causes a serious increase of dependency fan-out in most projects.
* **Version Conflicts** – When you drag in a lot of dependencies then you invariably run into a situation where 2 of your dependencies require the same third dependency but in a different version. (This is called the _diamond_ problem.) Sometimes these versions are really incompatible, sometimes the higher would suffice.
* **Variations** – In many situations it is necessary to create different variations of an application. For example, an application could be delivered for different platforms or a demo and a full version. Since the Maven transitive dependency model creates a fixed graph it is not suitable to assemble these variations easily. That is, there often is not a single runtime.

The result is that all too often the class path of the final application is littered with never used byte codes and/or overlapping packages that came from artifacts with different versions. 

Establishing the perfect class path for an application is a process for which the human mind is extremely badly suited and the transitive model of Maven has too many sharp edges. The resolver provides an alternative model that focuses on looking at the whole solutuon space instead of having to live with the (sometimes arbitrary) decisions of developers of the often 5-6 layers deep transitive dependencies.

## Principles

![image](https://user-images.githubusercontent.com/200494/31130842-cf5299d2-a858-11e7-907c-d6cb43954501.png)

The basic model of the resolving model is quite simple. It consists of just three entities:

* **Resource** – A resource is a _description_ of anything that can be _installed_ in an environment. When it is installed, it adds functions to that environment but before it can be installed it requires certain functions to be present. A resoruce can describe a bundle but it could also describe a piece of hardware or a certificate. It is important to realise that a resource is _not_ the artifact, it is a description of the _relation_ between the artifact and the target environment. For example, in OSGi the bundle is a JAR file that can be installed in a framework. A resource describes formally what that bundle can contribute to the environment and what it needs from the environment.
* **Capability** – A capability is a description of a resource's contribution to the environment when its artifact is installed. A capability has a _type_ and a set of _properties_. That is, it is a bit like a DTO. The type is defined by name and is therefore called the _namespace_. The properties are key value pairs, where the values can be scalars or collections of a `String`, `Integer`, `Double`, and `Long`. 
* **Requirement** – A requirement represents the _needs_ of an artifact when it is installed in the environment. Since we describe the environment with capabilities, we need a way to assert the properties of a capability in a given namespace. A requirement therefore consists of a type and an _OSGi filter_. The type is the same as for the capabilities, it is the namespace. The filter is buildup of a powerful filter language based on LDAP. A filter can assert expressions of arbitrary complexity. A requirement can be _mandatory_ or _optional_.

It is important to realise that a resource and its capabilities and requirements are descriptions. They provide a formal representation of an external artifact. Since these formal representations can be read by a computer, we can calculate a closure of resources that, when installed together, have only resources where all their mandatory requirements are _satisfied_ by the other resources in the closure.

## Core Namespaces

Although the OSGi specifications started out with a set of headers that each had their own semantics, over time the specification migrated completely to the more simple and formal model of Resources, Capabilities, and Requirements. Since the function of the legacy headers were still needed, it was necessary to map these legacy headers to the formal model. This resulted in a number of OSGi core namespaces. 

* `osgi.wiring.identity` – `Bundle-SymbolicName` header.
* `osgi.wiring.bundle` – `Require-Bundle` header.
* `osgi.wiring.package` – `Import-Package` and `Export-Package` headers.
* `osgi.wiring.host` – `Fragment-Host` header.
* `osgi.ee` – `Bundle-RequiredExecutionEnvironment` header.
* `osgi.native` – `Bundle-NativeCode` header.
* `osgi.content` – Provides the URL and checksum to download the corresponding artifact. (This namespace is defined in the compendium Repository specification.)

Each namespace defines the names of the properties and their semantics. For the OSGi namespaces, there are classes like `org.osgi.framework.namespace.IdentityNamespace` that contain the details of a namespace.

## Example

To make the model more clear let's take a closer look to a simple bundle `com.example.bundle` that exports package `com.example.pe` and imports a package `com.example.pi`. When the bundle is installed it will require that some other bundle, or the framework, provides package `com.example.pi`. We can describe this bundle then as follows:

     Resource for bundle B
       capabilities:
         osgi.wiring.identity; osgi.wiring.identity=com.example.bundle
         osgi.wiring.bundle; osgi.wiring.bundle=com.example.bundle
         osgi.wiring.host; osgi.wiring.host=com.example.bundle
         osgi.wiring.package; osgi.wiring.package=com.example.pe
       requirements:
         osgi.ee; filter:="(&(osgi.ee=JavaSE)(version=1.8))"
         osgi.wiring.package; filter:='(osgi.wiring.package=com.example.pi)'

## Who Wants to Provide That Gibberish???

Clearly, an `Export-Package: com.example.pe` is a bit easier to read than the corresponding capability, let alone the filter in the requirement, especially when the versions are taken into accountthe filters become quite unreadable. Clearly, if this had to be maintained by human developers than a model like Maven would be far superior. Fortunately, almost all of the metadata that is needed to make this work does not require any extra work from the developer. For example, the `bnd` tool that is available in Maven, Gradle, Eclipse, Intellij and others can easily analyze a JAR file and automatically generate the requirements and capabilities. 

In certain cases it is necessary to provide requirements and capabilities that bnd cannot infer but then it the [Manifest annotations](http://bnd.bndtools.org/chapters/230-manifest-annotations.html) support in bnd can be used to define an annotation that will add parameterised requirements to the resource.

Really, when you use bndtools none of this gibberish is visible to normal developers unless they have a special case. The gibberish is left to the tools to process this. 

## How to Write Resolvable Bundles

For a bundle to be a good citizen in a resolution it suffices to follow the standard rules of good software engineering. However, since there is so much software out there that does not follow these rules, a short summary.

* **Minimise Dependencies** – Every dependency has a cost. Always consider if all dependencies are _really_ necessary. Although a dependency can provide a short term gain for the coder, it will have consequences for the later stages in the development process. Perfect bundles are bundles that have no dependencies. Unfortunaly they are also then useless. Therefore, a developer must alway be aware of this trade off.
* **API Driven** – Always, always, always separate API and implementation. A lot of developers avoid the overhead of developing an API when they consider the (initial) problem too simple to do the effort of a separate API. The author of this App note is one of them but he never ever did not regret this. Usually he spent a lot of extra effort to add an API afterwards.
* **Service Oriented** – The best dependencies are service oriented dependencies. Services make the coupling between modules explicit and allow different implementations to provide the same service. For example, in OSGi enRoute there is a simple DTOs service that handles type conversions and JSON parsing/generating. In projects where I see the use of Jackson it always seems to cause a mess of requirements.
* **Package Imports** – A bundle can require other bundles (the Maven model) or it can import packages from other bundles. The best imported packages are the ones used for services since they are _specification only_. Second best are _libraries_. Library packages have no internal state nor use statics. Importing implementation packages for convenience is usally deemed bad practice because it often indicates that the decompositon in bundles is not optimal.
* **Import the Exports** – If a package is exported **and** used inside the same bundle then the exported package should also be imported. This allows the resolver more leeway.

To see the requirements and capabilities of a bundle Bndtools has a special `Resolution` view. This shows the requirements and capabilities of a selected JAR file or a bnd.bnd file. This view uses a number of icons to represent the requirements/capabilities. You can hover over them to see further details.

* ![service](https://user-images.githubusercontent.com/200494/31222248-c962b09c-a9c6-11e7-99ac-1977a6c736fd.png) – `osgi.service`. 
* ![bullet_green](https://user-images.githubusercontent.com/200494/31222315-f8e60454-a9c6-11e7-82d8-bbaa7acc46b1.png) – `osgi.identity`
* ![package](https://user-images.githubusercontent.com/200494/31222346-1153abf4-a9c7-11e7-97df-1bfa7a967505.gif) – `osgi.wiring.package`
* ![java](https://user-images.githubusercontent.com/200494/31222445-6a2231ce-a9c7-11e7-8242-c226709f9a76.png) – `osgi.ee`
* ![wand](https://user-images.githubusercontent.com/200494/31222450-7156a204-a9c7-11e7-800e-9c67837f4cef.png) – `osgi.extender`
* ![bundle](https://user-images.githubusercontent.com/200494/31222500-9460eade-a9c7-11e7-9a75-50ae25a35c00.png) – `osgi.bundle`


## Resolving

![Resolving](https://user-images.githubusercontent.com/200494/31221580-73596198-a9c4-11e7-8d11-1e1fe7e37199.png)

The previous diagram adds the resolver to the earlier diagram of the basic model. It adds the following entities:

* **Repository** – A Repository is a collection of resources. Repositories can be represented in many different ways as will be discussed later.
* **Resolver** – The Resolver is the entity that takes a set of _initial requirements_, _system capabilities_, a set of repositories, and produces a _resolution_. 
* **Resolution** – A resolution is a _wiring_ of resources. It provides detailed information what requirements are matched with what capabilities from the included resources.

## Repositories

A _repository_ is a collection of resources. This could be Maven Central or it could be a single bundle. That said, neither is a good idea in practice. The repository is the _scope_ of the resolution. Only resources in the repository can be selected. Although the naive idea then is to make the scope as large as possible to let the computer do the work, it is better to _curate_ the repository. 

The are many reasons why you need a curated repository but basically it comes down is the GIGO principle: garbage is garbage out. Another reason is running time. The resolver gets overwhelmed quickly when there are too many alternatives for a requirement. Resolving is an NP complete problem and this means that the resolution time quickly becomes very long when a lot of alternatives need to be examined.

### Available Repositories

The bnd toolchain provides OSGi Repository access to many popular repository formats.

* **OSGi XML Format** – The OSGi Alliance specified an XML format for repositories which is fully supported by bnd.
* **Maven Central** – You can provide subsets of Maven repositories using a simple text file, a query on Maven Central, or a `pom.xml`. It integrates fully with the local `~/.m2` repository.
* **Eclipse P2** – Eclipse repositories have a web based layout that can be parsed by bnd.
* **File based** – You can store bundles in a directory structure and use it as a repository.
* **Eclipse Workspace** – In bndtools, all generated bundles in a workspaceare directly available to the resolver.

Since bnd has an extensive library to parse bundles and generate the resources it is relatively easy to parse bundles in other ways. For example, there is a Maven plugin that can generate an OSGi index.

### Managing Repositories

A repository generally represents a _release_ of a software product. For example, in OSGi enRoute, the OSGi Alliance has provided a _base API_ bundle. This bundle contains all the APIs of OSGi core, OSGi compendium, and an OSGi enRoute release. There is also an OSGi enRoute _distro_ for each release. The distro is a repository that provides access to implementations for the base API. The OSGi enRoute distro is maintained in a Maven POM. This POM lists the exact versions of a release. Many developers publish an OSGi Repository XML to allow the resolver access to the metadata of their bundles, for example [Knopflerfish](http://www.knopflerfish.org/releases/4.0.1/repository.xml) produces an OSGi XML Repository with all their bundles.

This model is in contrast with Maven Central and most other Maven repositories. These repositories are designed to contain everything that was ever released. An OSGi repository is more the content of a specific release. Since it generally only contains a specific release, it will disallow the resolver to use any unwanted resources.

### Workspace Repository

A natural repository is the bnd _workspace_ since a workspace is a collection of _related_ projects. Since these projects are build together it is trivial to keep them compatible. The metadata burden can be mitigated by sharing metadata between these releated projects. For example, in bnd all bundles share the same version. Although this might sometimes release unchanged bundles under a newer version, the only cost is a bit of disk space since the process is fully automated. A small price to pay for an otherwise very error prone manual process. The Gradle build can release to a Nexus repository and automatically generate an index.

## Resolving in Bndtools

By far the best way to get experience with the resolver is using the Bndtools `bndrun` files. Bndtools provides a friendly user interface that makes it easy to use the OSGi Resolver in an interactive way. You can play along with the following explanations by creating an [OSGi enRoute Application project](http://enroute.osgi.org/qs/050-start.html) from the templates.

If you double click on the `osgi.enroute.examples.resolver.application.bndrun` file (or whatever name you picked) it opens a _Run_ pane.

![Run pane](https://user-images.githubusercontent.com/200494/31168440-9b5ff29e-a8f5-11e7-857f-22ec30202fd7.png){:width="50%"}

Even though most lists are hidden, the pane is already quite overwhelming. So let's go through the GUI and explain it one by one.

### Core Runtime

Remember that a resolution is for a specific environment. In the `Core Runtime` pane we specify the OSGi framework that will be used as well as the _execution environment_. The execution environment is from a list of Java VM versions and OSGi specifications.

![image](https://user-images.githubusercontent.com/200494/31168839-0ea01c56-a8f7-11e7-988f-faf2aea7e233.png){:width="50%"}

These are used to calculate the _system capabilities_. That is, the environment is treated as a single resource that provides the capabilities of the Framework as well as the capabilities of the OSGi defined execution environments. The system resource is always included in the resolution but can of course never be downloaded, it is provided by the target environment.

### Browse Repos

This is a list of the resources that are found in the active repositories. A search field makes it easy to find specific resources. For example, if you type in `gogo` it will list all Gogo bundles.

![image](https://user-images.githubusercontent.com/200494/31168644-59c03bc2-a8f6-11e7-800b-5abb32609f67.png){:width="50%"}

One or more resources from the `Browse Repos` list can selected and then dragged to the `Run Requirements` list to the left. This adds an _identity requirement_ to the set of initial requirements. You can also drag to the `Run Blacklist` and `Run Bundles` lists.

### Run Requirements

This is the main list to watch. It contains the set of _initial requirements_ given to the resolver. The GUI makes it possible to add identity requirements and remove listed requirements. The easiest way is to use drag and drop form the `Browse Repos` list but it is also possible to use the green `+`, which opens a dialog from which bundles can be added directly from the selected repositories.

![Run Requirements](https://user-images.githubusercontent.com/200494/31171486-26d66416-a900-11e7-8856-0e4debb85e24.png){:width="50%"}

### Additional Panes

There are some more panes that are useful but they will be handled in diagnosing problems. For reference, a short introduction to these panes.

* **Repositories** – Allows the selection/unselection of some of the repositories. Can also switch the `bndrun` file to _standalone_. A standalone `bndrun` file has no relation to the workspace it resides in and establishes its own repositories.
* **Runtime Properties** – Makes it possible to define OSGi framework properties, command line arguments, and VMarguments.
* **Run Blacklist** – Any resources selected by the requirements in the blacklist can never be used in a resolution.
* **Run Bundles** – This is normally the output of the resolver. However, it is possible to add/remove bundles from this list when the resolver is bypassed.

## Resolving

Taking the initial requirement it is possible to resolve by clicking on the `Resolve` button. This will show a rather large dialog window with the resolution.

![Resolution](https://user-images.githubusercontent.com/200494/31171747-285c920a-a901-11e7-978c-b6fb46c9c5aa.png){:width="50%"}

This dialog window is divided in three main parts:

* **Required Resources** – The required resources are the solution that the resolver found based on the initial requirements and the system capabiltiies. 
* **Optional Resources** – During resolving some resources are included by an _optional_ requirement. The resolver cannot automatically add optional resources, optional resources require human choice. 
* **Reasons** – Clicking on a required resource or an optional resource will show a _requirements trace_ in this list. Sometimes a resource is added and it is not clear why it was added. Traversing through this list can then help finding out what caused its inclusion. This list is a great debugging tool.

If some of the listed optional resources are desired then they can all be selected. Pressing the `Update and Resolve` button will restart the resolver but now with the selected optional resources as mandatory. 

If the `Finish` button is pressed then the current required resources list is converted to the list of `Run Bundles`. You can inspect them at the right bottom of the `bndrun` editor window.

![image](https://user-images.githubusercontent.com/200494/31172730-0528b2ba-a905-11e7-8e75-1ff36f9556b9.png){:width="50%"}

After a succesful resolve you can either `Run`, `Debug`, or `Export` the `bndrun` file.

## Debugging Resolving

So far the ideal process of happy resolves and satisfied bundles has been described. It is now necessary to leave this rosy world and descent to the world of failed resolves. Unfortunately, the provided diagnostic information when a resolve fails is quite low.

When a resolve fails it returns a cause but more often than not this is not the real cause. This is not some shortcoming from the current resolver but a fundamental logical problem. The simplest form of a resolution is if you have for example 3 numbers 1,4,8. You need to find the sum 10 using only addition and subtraction. If you try out all the combination then you find that no combination works. A failure report could be that -3 is not available because the last tried permutation was 1+4+8. Clearly, before that permutation many other numbers were missing as well, the missing -3 just happened to be the last one ...

That said, there are a number of scenarios where the resolver does give a hint where the problem is.

## Missing Requirement false

This rather obscure message indicates that the resolver tries to include a _api_ bundle that was made unresolvable. 

In OSGi enRoute it is generally recommended (although also disputed by some) to include the API package of a service in the provider bundle. Since a provider has a very tight relation to the API there is no loss of flexibility by including the package. For this reason, OSGi enRoute templates make the API bundle _compile only_. Each API has a special Require-Capability header:

     Require-Capability: \
	  compile-only

This header creates a requirement that cannot be satisfied. There is nothing special with `compile-only`, it is just an unused namespace. It could also have been `foo-bar`.

In the resolver, you will see the following error chain:

     Unable to resolve <<INITIAL>> version=null:
        missing requirement osgi.enroute.examples.resolver.missingapi.provider 
     ->  Unable to resolve osgi.enroute.examples.resolver.missingapi.provider version=1.0.0.201710041250:
        missing requirement osgi.enroute.examples.resolver.missingapi.api; version=[1.0.0,1.1.0) 
     ->  Unable to resolve osgi.enroute.examples.resolver.missingapi.api version=1.0.0.201710041249:
        missing requirement false]]

**Note:** Unfortunately, the output is blurred by a misguided attempt to make the output more concise. Because of this, the distinction between a bundle and a package is unclear. Sadly you can only see the difference between a requirement for a bundle and a package by looking at the version. If this is a range then it is a package and if it is a version with a timestamp it is a bundle. (This works most of the time.) This is a bug in bnd and must be corrected.

As indicated, you really need to understand that this is the last path the resolver took. The `osgi.enroute.examples.resolver.missingapi.provider` bundle tries to find a provider for the package `osgi.enroute.examples.resolver.missingapi.api` and has found the `osgi.enroute.examples.resolver.missingapi.api` bundle. However, this API bundle has the impossible to satisfy `compile-only` requirement.

That said, it is better to look at the `Missing Requirements` list since this reports quite nicely what is missing.

![image](https://user-images.githubusercontent.com/200494/31177786-5aae5c3c-a917-11e7-98aa-112c380fb83b.png){:width="50%"}

The icon and the text more clearly indicate that it cannot resolve the `osgi.enroute.examples.resolver.missingapi.api` bundle due to the `compile-only` requirement.

Exporting the API package from the provider bundle will correct this case.

## Compendium Bundle

Many developers compile against the compendium bundle to get the OSGi service API packages.  Although compiling against an API bundle has advantages, using the compendium bundle in runtime is evil. Since the compendium bundle aggregates a large number of API packages it will have the tendency to unnecessarily constrain the versions of different APIs. That is, it blocks you from using newer APIs.  

In OSGi enRoute the base API bundle is similar. For this reason it is also made `compile-only`. However, the compendium bundle is a perfectly valid bundle. 

To make bundles that should not be used at runtime not resolvable there is the `Run Blacklist` list on the `bndrun` editor. This list contains bundles that should never be included in a resolution. 

For example, we create a bundle that implements the Wire Admin service.

     public class MyService implements WireAdmin {
          ...
     }

This will cause a requirement for an exported package `org.osgi.service.wireadmin`. Since the OSGi enRoute does not provide an implementation in its distro this API is not available from the OSGi base API. We therefore add the OSGi compendium bundle to the `-buildpath`. This then compiles fine.

However, when the resolve will then drag in the OSGi compendium bundle. 

![image](https://user-images.githubusercontent.com/200494/31179074-3153a0d2-a91b-11e7-972e-622c7db59dd5.png){:width="50%"}

If we look at the reasons when we select the compendium bundle we see that also the Configuration Admin imports from the compendium even though it actually might provide a higher version. 

![image](https://user-images.githubusercontent.com/200494/31178847-8d5ca4d8-a91a-11e7-9df1-4a586bc191c1.png){:width="50%"}

To get rid of the compendium bundle we can drag and drop it to the `Run Blacklist` window. Any requirement in the `Run Blacklist` list will automatically exclude all bundles that are selected by that requirement. 

## You Are Sure There Is a Provider!

Sometimes the resolver can complain about a missing requirement but you are sure that it is in the repository. The first thing is to try to isolate the problem. Almost any problem can be solved if you remove the redundant parts. Quite often developers are trying to debug this situation in a complex large `bndrun` file and then get overwhelmed.

Just create a new `bndrun` file and only add the bundle you think should provide the resource to the `Run Requires` list and then resolve. If this resolves fine then at least you know that that bundle can potentially resolve.

However, often you find that even on its own it does not resolve. In most case the error message and the `Reasons` list provide sufficient information to understand why it does not resolve.

It is still a mystery, try checking the `Run Blacklist` list. If it is not there, it might be time to raise a bug.

## Augmenting Legacy Bundles

The problem with metadata is that it can also be wrong. Especially legacy bundles lack the proper metadata to inform the resolver that they provide a service or require an implementation of a specification. Although this is not a problem in runtime since these requirements are generally not used by the Framework, they are designed for using the resolver in selecting a closure of bundles as is described in this app note. 

However, in certain cases it is really necesary to add a capability or a requirement to a bundle in the repository. Clearly it is possible to wrap the legacy bundle but this is cumbersome and can create confusion down the line.

Another method is to use the _augments_ that the bnd repositories support. Augments can add capabilities and requirements to existing bundles in a repository. However, it can only do this for the interactive resolve process. When the OSGi Framework resolves a number of bundles it will never takes augments into account.

There are two different ways to add the augments. 

* **Bndrun file** – Provide the augments in the `bndrun` file. This is an ad-hoc mechanism that is normally a last resort.
* **Resource** – Provide a resource in a repository that contains an `bnd.augment` capability. Such a resource has a file with properties that describe the augment for that repository. This is a good way when you have to curate a repository and need to fixup some legacy bundles. This resource can also add to the blacklist.

In both cases the augments are described using the standard OSGi/bnd syntax. The syntax is not a beauty since it stretches what you can do with the OSGi header format. However, augmenting should really be a last resort hack so maybe it is not really bad that the syntax is cumbersome.

You can add an augment with the `-augment` instruction in the `bndrun` file.

     -augment PARAMETER ( ',' PARAMETER ) *

Augmenting is adding additional capabilities and requirements. When bnd resolves a project or bndrun file, it will read these instructions. Since `-augment` is a merge property you can also use additional keys like `-augment.xyz`. 

The `key` of the `PARAMETER` is used for matching the Bundle Symbolic Name. It can contain the `*` wildcard character to match multiple bundles. The bundle symbolic name must be allowed as a value in a filter it is therefore not a globbing expression.

The following directives and attribute are architected:

* **version** – A version range. If a single version is given it will be used as `[<version>,∞)`. The version range can be prefixed with an `@` for a consumer range (to the next major) or a provider range (to the next minor) when the `@` is a suffix of the version. The range can restrict the augmentation to a limited set of bundles.
* **capability:** – The `capability:` directive specifies a Provide-Capability instruction, this will therefore likely have to be quoted to not confuse bnd with embedded comma's. Any number of clauses can be specified in a capability directive by separating the clauses with a comma. (This is where the syntax gets stretched.)
* **requirement:** – The `requirement:` directive specifies a Require-Capability instruction similar to the `capability:` directive.

To augment the repositories during a resolve, bnd will find all bundles that match the bundle symbolic name and fall within the defined range. If no range is given, only the bundle symbolic name will constrain the search. Each found bundle will then be decorated with the capabilities and requirements defined in the `capability:` and `requirement:` directive.

For example, we need to provide an extender capability to a bundle with the bundle symbolic name `com.example.prime` with version `[1.2,1.3)`. In that case add the following instruction to the `bndrun` file.

     -augment.prime = \
          com.example.prime; \
               capability:='osgi.extender; \
                    osgi.extender=some.extender; \
                    version:Version=1.2@'

The `capability:` and `requirement:` directives follow all the rules of the Provide-Capability and Require-Capability headers respectively. For the resolver, it is as if these headers were specified in their manifests. Since these headers can contain semicolons and commas they must be quoted. bnd will allow double quotes inside normal quotes and vice versa when it is necessary to nested quotes.

## First Time Curating a Repository

A workspace setup with bnd will generally provide a good start. However, when you need to grandfather in a lot of bundles from Maven Central then it is likely that you will need to spend some time to augment these bundles. This can be a depressing task since you'll find out how messy the world is. However, experience shows that once the repository is resolvable, maintaining it is less of a problem. 

A good example of a curated repository is the [OSGi enRoute Distro](https://github.com/osgi/osgi.enroute/blob/master/osgi.enroute.pom.distro/augments.bndrun). If you're responsible for a repository it might help to take a good look at the `augments.bndrun` file.

There are a number of (rudimentary) functions in the command line version of bnd that might be useful. Unfortunately, the commands currently assume an OSGi repository.

## Conclusion

Creating applications from reusable models is a goal that the software industry has been trying to achieve for a long time. To a certain extent, the Maven dependency model provides this model. However, it also is a model where dependencies are not strictly managed and much is left to chance. 

The resolver model provides an alternative (working inside maven if so desired) to establish a class path that optimises the whole application class path instead of just slavishly following transitively dependencies. Experience shows that organisations that use the resolver have a much better grip of what is actually running in their runtime. Not only minimises this runtime errors, it generally also makes it easier to migrate and evolve the code base.

AConverting an existing build into a resolve based build can be daunting but the efforts are worth it. For bnd users that use the workspace model the advantages will flow freely.














### Managing Repositories

A repository generally represents a _release_ of a software product. For example, in OSGi enRoute, the OSGi Alliance has provided a _base API_ bundle. This bundle contains all the APIs of OSGi core, OSGi compendium, and an OSGi enRoute release. There is also an OSGi enRoute _distro_ for each release. The distro is a repository that provides access to implementations for the base API. The OSGi enRoute distro is maintained in a Maven POM. This POM lists the exact versions of a release. Many developers publish an OSGi Repository XML to allow the resolver access to the metadata of their bundles, for example [Knopflerfish](http://www.knopflerfish.org/releases/4.0.1/repository.xml) produces an OSGi XML Repository with all their bundles.

This model is in contrast with Maven Central and most other Maven repositories. These repositories are designed to contain everything that was ever released. An OSGi repository is more the content of a specific release. Since it generally only contains a specific release, it will disallow the resolver to use any unwanted resources.

### Workspace Repository

A natural repository is the bnd _workspace_ since a workspace is a collection of _related_ projects. Since these projects are build together it is trivial to keep them compatible. The metadata burden can be mitigated by sharing metadata between these releated projects. For example, in bnd all bundles share the same version. Although this might sometimes release unchanged bundles under a newer version, the only cost is a bit of disk space since the process is fully automated. A small price to pay for an otherwise very error prone manual process. The Gradle build can release to a Nexus repository and automatically generate an index.

## Resolving in Bndtools

By far the best way to get experience with the resolver is using the Bndtools `bndrun` files. Bndtools provides a friendly user interface that makes it easy to use the OSGi Resolver in an interactive way. You can play along with the following explanations by creating an [OSGi enRoute Application project](http://enroute.osgi.org/qs/050-start.html) from the templates.

If you double click on the `osgi.enroute.examples.resolver.application.bndrun` file (or whatever name you picked) it opens a _Run_ pane.

![Run pane](https://user-images.githubusercontent.com/200494/31168440-9b5ff29e-a8f5-11e7-857f-22ec30202fd7.png | width="50%")

Even though most lists are hidden, the pane is already quite overwhelming. So let's go through the GUI and explain it one by one.

### Core Runtime

Remember that a resolution is for a specific environment. In the `Core Runtime` pane we specify the OSGi framework that will be used as well as the _execution environment_. The execution environment is from a list of Java VM versions and OSGi specifications.

![image](https://user-images.githubusercontent.com/200494/31168839-0ea01c56-a8f7-11e7-988f-faf2aea7e233.png | width="50%")

These are used to calculate the _system capabilities_. That is, the environment is treated as a single resource that provides the capabilities of the Framework as well as the capabilities of the OSGi defined execution environments. The system resource is always included in the resolution but can of course never be downloaded, it is provided by the target environment.

### Browse Repos

This is a list of the resources that are found in the active repositories. A search field makes it easy to find specific resources. For example, if you type in `gogo` it will list all Gogo bundles.

![image](https://user-images.githubusercontent.com/200494/31168644-59c03bc2-a8f6-11e7-800b-5abb32609f67.png | width="50%")

One or more resources from the `Browse Repos` list can selected and then dragged to the `Run Requirements` list to the left. This adds an _identity requirement_ to the set of initial requirements. You can also drag to the `Run Blacklist` and `Run Bundles` lists.

### Run Requirements

This is the main list to watch. It contains the set of _initial requirements_ given to the resolver. The GUI makes it possible to add identity requirements and remove listed requirements. The easiest way is to use drag and drop form the `Browse Repos` list but it is also possible to use the green `+`, which opens a dialog from which bundles can be added directly from the selected repositories.

![Run Requirements](https://user-images.githubusercontent.com/200494/31171486-26d66416-a900-11e7-8856-0e4debb85e24.png | width="50%")

### Additional Panes

There are some more panes that are useful but they will be handled in diagnosing problems. For reference, a short introduction to these panes.

* **Repositories** – Allows the selection/unselection of some of the repositories. Can also switch the `bndrun` file to _standalone_. A standalone `bndrun` file has no relation to the workspace it resides in and establishes its own repositories.
* **Runtime Properties** – Makes it possible to define OSGi framework properties, command line arguments, and VMarguments.
* **Run Blacklist** – Any resources selected by the requirements in the blacklist can never be used in a resolution.
* **Run Bundles** – This is normally the output of the resolver. However, it is possible to add/remove bundles from this list when the resolver is bypassed.

## Resolving

Taking the initial requirement it is possible to resolve by clicking on the `Resolve` button. This will show a rather large dialog window with the resolution.

![Resolution](https://user-images.githubusercontent.com/200494/31171747-285c920a-a901-11e7-978c-b6fb46c9c5aa.png | width="50%")

This dialog window is divided in three main parts:

* **Required Resources** – The required resources are the solution that the resolver found based on the initial requirements and the system capabiltiies. 
* **Optional Resources** – During resolving some resources are included by an _optional_ requirement. The resolver cannot automatically add optional resources, optional resources require human choice. 
* **Reasons** – Clicking on a required resource or an optional resource will show a _requirements trace_ in this list. Sometimes a resource is added and it is not clear why it was added. Traversing through this list can then help finding out what caused its inclusion. This list is a great debugging tool.

If some of the listed optional resources are desired then they can all be selected. Pressing the `Update and Resolve` button will restart the resolver but now with the selected optional resources as mandatory. 

If the `Finish` button is pressed then the current required resources list is converted to the list of `Run Bundles`. You can inspect them at the right bottom of the `bndrun` editor window.

![image](https://user-images.githubusercontent.com/200494/31172730-0528b2ba-a905-11e7-8e75-1ff36f9556b9.png | width="50%")

After a succesful resolve you can either `Run`, `Debug`, or `Export` the `bndrun` file.

## Debugging Resolving

So far the ideal process of happy resolves and satisfied bundles has been described. It is now necessary to leave this rosy world and descent to the world of failed resolves. Unfortunately, the provided diagnostic information when a resolve fails is quite low.

When a resolve fails it returns a cause but more often than not this is not the real cause. This is not some shortcoming from the current resolver but a fundamental logical problem. The simplest form of a resolution is if you have for example 3 numbers 1,4,8. You need to find the sum 10 using only addition and subtraction. If you try out all the combination then you find that no combination works. A failure report could be that -3 is not available because the last tried permutation was 1+4+8. Clearly, before that permutation many other numbers were missing as well, the missing -3 just happened to be the last one ...

That said, there are a number of scenarios where the resolver does give a hint where the problem is.

## Missing Requirement false

This rather obscure message indicates that the resolver tries to include a _api_ bundle that was made unresolvable. 

In OSGi enRoute it is generally recommended (although also disputed by some) to include the API package of a service in the provider bundle. Since a provider has a very tight relation to the API there is no loss of flexibility by including the package. For this reason, OSGi enRoute templates make the API bundle _compile only_. Each API has a special Require-Capability header:

     Require-Capability: \
	  compile-only

This header creates a requirement that cannot be satisfied. There is nothing special with `compile-only`, it is just an unused namespace. It could also have been `foo-bar`.

In the resolver, you will see the following error chain:

     Unable to resolve <<INITIAL>> version=null:
        missing requirement osgi.enroute.examples.resolver.missingapi.provider 
     ->  Unable to resolve osgi.enroute.examples.resolver.missingapi.provider version=1.0.0.201710041250:
        missing requirement osgi.enroute.examples.resolver.missingapi.api; version=[1.0.0,1.1.0) 
     ->  Unable to resolve osgi.enroute.examples.resolver.missingapi.api version=1.0.0.201710041249:
        missing requirement false]]

**Note:** Unfortunately, the output is blurred by a misguided attempt to make the output more concise. Because of this, the distinction between a bundle and a package is unclear. Sadly you can only see the difference between a requirement for a bundle and a package by looking at the version. If this is a range then it is a package and if it is a version with a timestamp it is a bundle. (This works most of the time.) This is a bug in bnd and must be corrected.

As indicated, you really need to understand that this is the last path the resolver took. The `osgi.enroute.examples.resolver.missingapi.provider` bundle tries to find a provider for the package `osgi.enroute.examples.resolver.missingapi.api` and has found the `osgi.enroute.examples.resolver.missingapi.api` bundle. However, this API bundle has the impossible to satisfy `compile-only` requirement.

That said, it is better to look at the `Missing Requirements` list since this reports quite nicely what is missing.

![image](https://user-images.githubusercontent.com/200494/31177786-5aae5c3c-a917-11e7-98aa-112c380fb83b.png | width="50%")

The icon and the text more clearly indicate that it cannot resolve the `osgi.enroute.examples.resolver.missingapi.api` bundle due to the `compile-only` requirement.

Exporting the API package from the provider bundle will correct this case.

## Compendium Bundle

Many developers compile against the compendium bundle to get the OSGi service API packages.  Although compiling against an API bundle has advantages, using the compendium bundle in runtime is evil. Since the compendium bundle aggregates a large number of API packages it will have the tendency to unnecessarily constrain the versions of different APIs. That is, it blocks you from using newer APIs.  

In OSGi enRoute the base API bundle is similar. For this reason it is also made `compile-only`. However, the compendium bundle is a perfectly valid bundle. 

To make bundles that should not be used at runtime not resolvable there is the `Run Blacklist` list on the `bndrun` editor. This list contains bundles that should never be included in a resolution. 

For example, we create a bundle that implements the Wire Admin service.

     public class MyService implements WireAdmin {
          ...
     }

This will cause a requirement for an exported package `org.osgi.service.wireadmin`. Since the OSGi enRoute does not provide an implementation in its distro this API is not available from the OSGi base API. We therefore add the OSGi compendium bundle to the `-buildpath`. This then compiles fine.

However, when the resolve will then drag in the OSGi compendium bundle. 

![image](https://user-images.githubusercontent.com/200494/31179074-3153a0d2-a91b-11e7-972e-622c7db59dd5.png | width="50%")

If we look at the reasons when we select the compendium bundle we see that also the Configuration Admin imports from the compendium even though it actually might provide a higher version. 

![image](https://user-images.githubusercontent.com/200494/31178847-8d5ca4d8-a91a-11e7-9df1-4a586bc191c1.png | width="50%")

To get rid of the compendium bundle we can drag and drop it to the `Run Blacklist` window. Any requirement in the `Run Blacklist` list will automatically exclude all bundles that are selected by that requirement. 

## You Are Sure There Is a Provider!

Sometimes the resolver can complain about a missing requirement but you are sure that it is in the repository. The first thing is to try to isolate the problem. Almost any problem can be solved if you remove the redundant parts. Quite often developers are trying to debug this situation in a complex large `bndrun` file and then get overwhelmed.

Just create a new `bndrun` file and only add the bundle you think should provide the resource to the `Run Requires` list and then resolve. If this resolves fine then at least you know that that bundle can potentially resolve.

However, often you find that even on its own it does not resolve. In most case the error message and the `Reasons` list provide sufficient information to understand why it does not resolve.

It is still a mystery, try checking the `Run Blacklist` list. If it is not there, it might be time to raise a bug.

## Augmenting Legacy Bundles

The problem with metadata is that it can also be wrong. Especially legacy bundles lack the proper metadata to inform the resolver that they provide a service or require an implementation of a specification. Although this is not a problem in runtime since these requirements are generally not used by the Framework, they are designed for using the resolver in selecting a closure of bundles as is described in this app note. 

However, in certain cases it is really necesary to add a capability or a requirement to a bundle in the repository. Clearly it is possible to wrap the legacy bundle but this is cumbersome and can create confusion down the line.

Another method is to use the _augments_ that the bnd repositories support. Augments can add capabilities and requirements to existing bundles in a repository. However, it can only do this for the interactive resolve process. When the OSGi Framework resolves a number of bundles it will never takes augments into account.

There are two different ways to add the augments. 

* **Bndrun file** – Provide the augments in the `bndrun` file. This is an ad-hoc mechanism that is normally a last resort.
* **Resource** – Provide a resource in a repository that contains an `bnd.augment` capability. Such a resource has a file with properties that describe the augment for that repository. This is a good way when you have to curate a repository and need to fixup some legacy bundles. This resource can also add to the blacklist.

In both cases the augments are described using the standard OSGi/bnd syntax. The syntax is not a beauty since it stretches what you can do with the OSGi header format. However, augmenting should really be a last resort hack so maybe it is not really bad that the syntax is cumbersome.

You can add an augment with the `-augment` instruction in the `bndrun` file.

     -augment PARAMETER ( ',' PARAMETER ) *

Augmenting is adding additional capabilities and requirements. When bnd resolves a project or bndrun file, it will read these instructions. Since `-augment` is a merge property you can also use additional keys like `-augment.xyz`. 

The `key` of the `PARAMETER` is used for matching the Bundle Symbolic Name. It can contain the `*` wildcard character to match multiple bundles. The bundle symbolic name must be allowed as a value in a filter it is therefore not a globbing expression.

The following directives and attribute are architected:

* **version** – A version range. If a single version is given it will be used as `[<version>,∞)`. The version range can be prefixed with an `@` for a consumer range (to the next major) or a provider range (to the next minor) when the `@` is a suffix of the version. The range can restrict the augmentation to a limited set of bundles.
* **capability:** – The `capability:` directive specifies a Provide-Capability instruction, this will therefore likely have to be quoted to not confuse bnd with embedded comma's. Any number of clauses can be specified in a capability directive by separating the clauses with a comma. (This is where the syntax gets stretched.)
* **requirement:** – The `requirement:` directive specifies a Require-Capability instruction similar to the `capability:` directive.

To augment the repositories during a resolve, bnd will find all bundles that match the bundle symbolic name and fall within the defined range. If no range is given, only the bundle symbolic name will constrain the search. Each found bundle will then be decorated with the capabilities and requirements defined in the `capability:` and `requirement:` directive.

For example, we need to provide an extender capability to a bundle with the bundle symbolic name `com.example.prime` with version `[1.2,1.3)`. In that case add the following instruction to the `bndrun` file.

     -augment.prime = \
          com.example.prime; \
               capability:='osgi.extender; \
                    osgi.extender=some.extender; \
                    version:Version=1.2@'

The `capability:` and `requirement:` directives follow all the rules of the Provide-Capability and Require-Capability headers respectively. For the resolver, it is as if these headers were specified in their manifests. Since these headers can contain semicolons and commas they must be quoted. bnd will allow double quotes inside normal quotes and vice versa when it is necessary to nested quotes.

## First Time Curating a Repository

A workspace setup with bnd will generally provide a good start. However, when you need to grandfather in a lot of bundles from Maven Central then it is likely that you will need to spend some time to augment these bundles. This can be a depressing task since you'll find out how messy the world is. However, experience shows that once the repository is resolvable, maintaining it is less of a problem. 

A good example of a curated repository is the [OSGi enRoute Distro](https://github.com/osgi/osgi.enroute/blob/master/osgi.enroute.pom.distro/augments.bndrun). If you're responsible for a repository it might help to take a good look at the `augments.bndrun` file.

There are a number of (rudimentary) functions in the command line version of bnd that might be useful. Unfortunately, the commands currently assume an OSGi repository.

## Conclusion

Creating applications from reusable models is a goal that the software industry has been trying to achieve for a long time. To a certain extent, the Maven dependency model provides this model. However, it also is a model where dependencies are not strictly managed and much is left to chance. 

The resolver model provides an alternative (working inside maven if so desired) to establish a class path that optimises the whole application class path instead of just slavishly following transitively dependencies. Experience shows that organisations that use the resolver have a much better grip of what is actually running in their runtime. Not only minimises this runtime errors, it generally also makes it easier to migrate and evolve the code base.

AConverting an existing build into a resolve based build can be daunting but the efforts are worth it. For bnd users that use the workspace model the advantages will flow freely.













