# OSGi's Best Kept Secret

This Application Note is about _resolving_ in OSGi. Resolving is the process of constructing an application out of _modules_. Resolving takes a list of _initial requirements_, a description of the _target system(s)_, and a _repository_. It will use the list of initial requirements to find modules in the repository that provide the required capabilities. Clearly, these modules have their own requirements, retrieveing applicable modules is therefore a recursive process. A _resolver_ will find a solution where all requirements are satisfied or indicates there is no solution.

The resolver model is based on technology developed in OSGi since 2006 with [RFC-0112 Bundle Respository](http://www.openehealth.org/download/attachments/688284/rfc-0112_BundleRepository.pdf). This RFC layed out a model that was gradually implemented in the OSGi specifications and for which many tools were developed. Resolving automates a task that is today mainly done manually.

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
* **Requirement** – A requirement represents the _needs_ of an artifact when it is installed in the environment. Since we describe the environment with capabilities, we need a way to assert the properties of a capability in a given namespace. A requirement therefore consists of a type and an _OSGi filter_. The type is the same as for the capabilities, it is the namespace. The filter is buildup of a powerful filter language based on LDAP filters. It can assert expressions of arbitrary complexities. 

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

To make the model more clear let's take a closer look to a simple bundle `B` that exports package `p.e` and imports a package `p.i`. When the bundle is installed it will require that some other bundle, or the framework, provides package `p.i`. We can describe this bundle as follows:

     Resource for bundle B
       caps:
         osgi.wiring.package; osgi.wiring.package=p.e
       reqs:
         osgi.wiring.package; filter:='(osgi.wiring.package=p.i)'

## Completeness

Although we did not sh


