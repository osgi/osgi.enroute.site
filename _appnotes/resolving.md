# Resolving

## OSGi's Best Kept Secret

This Application Note is about _resolving_ in OSGi. Resolving is the process of constructing an application out of _modules_. Resolving takes a list of _initial requirements_, a description of the _target system(s)_, and a _repository_. It will use the list of initial requirements to find modules in the repository that provide the required capabilities. Clearly, these modules have their own requirements, retrieveing applicable modules is therefore a recursive process. A _resolver_ will find a solution where all requirements are satisfied or indicates there is no solution.

The resolver model is based on technology developed in OSGi since 2006 with [RFC-0112 Bundle Respository](http://www.openehealth.org/download/attachments/688284/rfc-0112_BundleRepository.pdf). This RFC layed out a model that was gradually implemented in the OSGi specifications and for which many tools were developed. Resolving automates a task that is today mainly done manually.

<div>
This application note is sponsored by <a href="https://www.sma.de"><img src=https://upload.wikimedia.org/wikipedia/commons/thumb/f/f8/Logo_SMA.svg/40px-Logo_SMA.svg.png></a>
</div>


## What Problem is Being (Re)Solved?

The pain that the resolver solves is well known to anybody that builds application from modules, the so called _assembly_ process. All developers know the dreadful feeling of having to drag in more and more dependencies to get rid of class not found errors when the application runs. For many, Maven was a godsend because it made this process so much easier because dependencies are _transitive_. If you depend on some artifact, then this artifact would bring its own dependencies to the final application.

Unfortunately, that godsend was tainted because of a number of reasons.

* **Our small minds** – The limitatation of the human mind/motivationto properly maintain metadata is limited. Many open source projects show unnecessary dependencies that were once needed but no longer necessary. Fortunately, Maven Central/Sonatype now has become much more restrictive but before this filter a lot of Maven dependencies had errors.
* **Aggregate problem** – The aggregate problem is a dependency that is used for one small part but where a co-packaged part drags in other (and therefore unnecessary) dependencies. For example, many JARs provided support for Ant, a former build tool. This was useful if you happend to use Ant but it caused the addition of the Ant runtime in environments that never used Ant. The aggregate problem causes a serious increase of dependency fan-out in most projects.
* **Version Conflicts** – When you drag in a lot of dependencies then you invariably run into a situation where 2 of your dependencies require the same third dependency but in a different version. (This is called the _diamond_ problem.) Sometimes these versions are really incompatible, sometimes the higher would suffice.

The result is that all too often the class path of the final application is littered with never used byte codes and/or overlapping packages that came from artifiacts with different versions. 

Establishing the perfect class path for an application is a process for which the human mind is extremely badly suited and the transitive model of Maven has too many sharp edges. The resolver provides an alternative model that focuses on looking at the whole solutuon instead of having to live with the (sometimes arbitrary) decisions of developers of the often 5-6 layers deep transitive dependency.

## Principles

![image](https://user-images.githubusercontent.com/200494/31130842-cf5299d2-a858-11e7-907c-d6cb43954501.png)

The basic model of the resolving model is quite simple. It consists of just three entities:

* **Resource** – A resource is a _description_ of anything that can be _installed_ in an environment. When it is installed, it adds functions to that environment but before it can be installed it requires certain functions to be present. A resoruce can describe a bundle but it could also describe a piece of hardware or a certificate. It is important to realise that a resource is _not_ the artifact, it is a description of the _relation_ between the artifact and the target environment. For example, in OSGi the bundle is a JAR file that can be installed in a framework. A resource describes formally what that bundle can contribute to the environment and what it needs from the environment.
* **Capability** – A capability is a description of a resource's contribution to the environment when its artifact is installed. A capability has a _type_ and a set of _properties_. That is, it is a bit like a DTO. The type is defined by name and is therefore called the _namespace_. The properties are key value pairs, where the values can be scalars or collections of a String, integer, double, and long. 
* **Requirement** – A requirement represents the _needs_ of an artifact when it is installed in the environment. Since we describe the environment with capabilities, we need a way to assert the properties of a capability in a given namespace. A requirement therefore consists of a type and an _OSGi filter_. The type is the same as for the capabilities, it is the namespace. The filter is buildup of a powerful filter language based on LDAP filters. It can assert expressions of arbitrary complexities. A requirement can be _mandatory_ or _optional_.

It is important to realise that a resource and its capabilities and requirements are descriptions. The provide a formal presentation of an external artifact. Since these formal presentations can be read by a computer, we can calculate a closure of resources that, when installed together, have only resources where all their mandatory requirements are _satisfied_ by the other resources in the closure.

## Core Namespaces

Although the OSGi specifications started out with a set of header that each had their own semantics, over time the specification migrated completely to just the simple model of Resources, Capabilities, and Requirements. Since the function of the legacy headers were still needed, it was necessary to map these legacy headers to the formal model. This resulted in a number of core namespaces. 

* `osgi.wiring.identity` – `Bundle-SymbolicName` header.
* `osgi.wiring.bundle` – `Require-Bundle` header.
* `osgi.wiring.package` – `Import-Package` and `Export-Package` headers.
* `osgi.wiring.host` – `Fragment-Host` header.
* `osgi.ee` – `Bundle-RequiredExecutionEnvironment` header.
* `osgi.native` – `Bundle-NativeCode` header.
* `osgi.content` – Provides the URL and checksum to download the corresponding artifact. (This namespace is defined in the compendium Repository specification.)

Each namespace defines the names of the properties and their semantics. For the OSGi namespaces, there are class like `org.osgi.framework.namespace.IdentityNamespace` that contain the details of a namespace.

## Example

To make the model more clear let's take a closer look to a simple bundle `com.example.b` that exports package `com.example.e` and imports a package `com.example.i`. When the bundle is installed it will require that some other bundle, or the framework, provides package `com.example.i`. We can describe this bundle as follows:

     Resource for bundle B
       caps:
         osgi.wiring.identity; osgi.wiring.identity=com.example.b
         osgi.wiring.bundle; osgi.wiring.bundle=com.example.b
         osgi.wiring.host; osgi.wiring.host=com.example.b
         osgi.wiring.package; osgi.wiring.package=com.example.e
       reqs:
         osgi.ee; filter:="(&(osgi.ee=JavaSE)(version=1.8))"
         osgi.wiring.package; filter:='(osgi.wiring.package=com.example.i)'

## Who Wants to Provide That Gibberish???

Clearly, an `Import-Package: com.example.i` is a bit easier to read than the corresponding requirement, especially when the versions are taken into account. Clearly, if this had to be maintained by developers than a model like Maven would be far superior. Fortunately, almost all of the metadata that is needed to make this work does not require any extra work from the developer. The `bnd` tool that is available in Maven, Gradle, Eclipse, Intellij and other tooling can easily analyze a JAR file and automatically generate the requirements and capabilities. 

In certain cases it is necessary to provide requirements and capabilities that bnd cannot infer but then it the annotation support in bnd can be used to define an annotation that will add parameterised requirements to the resource.

Really, when you use bndtools very little of this gibberish is visible to a developer. The gibberish is left to the tools to process this. Tools that have a lot harder time comprehending our language then vice versa.

## How to Write Resolvable Bundles

For a bundle to be a good citizen in a resolution it suffices to follow the standard rules of good software engineering. However, since there is so much software out there that does not follow these rules, a short summary.

* **Minimise** – Every dependency has a cost. Always consider if all dependencies are necessary. Although a dependency can provide a short term gain for the coder, it will have consequences for the later stages in the development process. Perfect bundles are bundles that have no dependencies. Unfortunaly they are also then useless. However, a developer must alway be aware of this trade off.
* **API Driven** – Always, always, always separate API and implementation. A lot of developers avoid the overhead of developing an API when they consider the problem simple. The author of this app note is one of them but he never ever did not regret it and spent a lot of extra effort to add an API afterwards.
* **Service Oriented** – The best dependencies are service oriented dependencies. Services make the coupling between modules explicit and allow different implementations to provide the same service. For example, in OSGi enRoute there is a simple DTOs service that handles type conversions and JSON parsing/generating. In projects where I see the use of Jackson it always seems a mess of requirements.
* **Package Imports** – A bundle can require other bundles (the Maven model) or it can import packages from other bundles. The best imported packages are the ones used for services since they are _specification only_. Second best are _libraries_. Library packages have no internal state nor use statics. Importing implementation packages for convenience is usally deemed bad practice because it often indicates that the decompositon in bundles is not optimal.
* **Import Exports** – If a package is exported **and** used inside the same bundle then the exported package should also be imported. This allows the resolver more leeway.

## Repositories

A _repository_ is a collection of resources. This could be Maven Central or it could be a single bundle. That said, neither is a good idea in practice. The repository is the _scope_ of the resolution. Only resources in the repository can be selected. Although the naive idea then is to make the scope as large as possible to let the computer do the work, it is better to _curate_ the repository. 

The are many reasons why you need a curated repository but basically it comes down is the GIGO principle: garbage is garbage out. Another reason is running time. The resolver gets overwhelmed quickly when there are too many alternatives for a requirement. Resolving is an NP complete problem and this means that the resolution time quickly becomes very long when a lot of unnecessary alternatives need to be examined.

## Available Repositories

The bnd toolchain provides OSGi Repository access to many popular repositories.

* **OSGi XML Format** – The OSGi Alliance specified an XML format for repositories which is fully supported by bnd.
* **Maven Central** – You can provide subsets of Maven repositories using a simple text file or a pom.xml. It integrates fully with the local M2 repository.
* **Eclipse P2** – Eclipse repositories have a web based layout that can be parsed by 
* **File based** – You can store bundles in a directory structure and use it as a repository.
* **Eclipse Workspace** – In bndtools, all generated bundles are directly available to the resolver.

Since bnd has an extensive library to parse bundles and generate the resources it is relatively easy to parse bundles in other ways. For example, there is a Maven plugin that can generate an OSGi index.

## Where do I Find Repositories

In OSGi enRoute, the OSGi Alliance has provided a _base API_ bundle. This bundle contains all the APIs of enRoute and OSGi, which makes it easy to get started. The OSGi enRoute site also provides an _OSGi enRoute distro_. The distro is an OSGi repository file that provides access to implementations for the base API. The distro is maintained in a Maven POM. This POM lists the exact versions of a release.

This OSGi enRoute model is a best practice. Although this model allows for multiple distros, it is not its primary advantage. Separating API and implementations allows different groups to work independently from eachother without fear they tread on eachother's work. The API is the shared contract which allows application developers and bundle developers to work independent as long as they do not modify the API.

It is therefore advised to use this distro model internally as well. Developers should compile against API that is carefully evolved. A build manager maintains a release POM (or other repository definition) that is used by the rest.

## Workspace Repository

A natural repository is the bnd _Workspace_. A workspace is a collection of related projects. Since these projects are build together it is trivial to keep them compatible. The metadata burden can be mitigated by sharing it between these projects. 










