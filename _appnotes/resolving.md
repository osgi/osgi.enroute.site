# OSGi's Best Kept Secret

This Application Note is about _resolving_ in OSGi. Resolving is the process of constructing an application out of _modules_. Resolving takes a list of _initial requirements_, a description of the _target system(s)_, and a _repository_. It will use the list of initial requirements to find modules in the repository that provide the required capabilities. Clearly, these modules have their own requirements, retrieveing applicable modules is therefore a recursive process. A _resolver_ will find a solution where all requirements are satisfied or indicates there is no solution.

The resolver model is based on technology developed in OSGi since 2006 with [RFC-0112 Bundle Respository](http://www.openehealth.org/download/attachments/688284/rfc-0112_BundleRepository.pdf). This RFC layed out a model that was gradually implemented in the OSGi specifications and for which many tools were developed. Resolving automates a task that is today mainly done manually.

<div>
This application note is sponsored by <a href="https://www.sma.de"><img src=https://upload.wikimedia.org/wikipedia/commons/thumb/f/f8/Logo_SMA.svg/40px-Logo_SMA.svg.png></a>
</div>


## What Problem is Being Solved?

The pain that the resolver solves is well known to anybody that builds application from modules, the so called _assembly_ process. All developers know the dreadful feeling of having to drag in more and more dependencies to get rid of class not found errors when the application runs. For many, Maven was a godsend because it made this process so much easier because dependencies are _transitive_. If you depend on some artifact, then this artifact would bring its own dependencies to the final application.

Unfortunately, that godsend was tainted because the limitatation of the human mind/motivation, the aggregate problem that causes a transitive dependency on the whole even if only a fraction of an artifact is used, and a serious fundamental problem with transitive dependencies that large graphs of dependencies sometimes requires the presence of the same module but in different versions.

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

Really, when you use bndtools very little is visible to a developer of this gibberish. It is left to the tools to process this. Tools that have a lot harder time comprehending our language then vice versa.

## Repositories

A _repository_ is a collection of resources. This could be Maven Central or it could be a single bundle. That said, neither is a good idea in practice. The repository is the _scope_ of the resolution. Only resources in the repository can be selected. Although the naive idea then is to make the scope as large as possible to let the computer do the work, it is better to _curate_ the repository. 

The are many reasons why you need a curated repository but basically it comes down to garbage in gives garbage out. 
