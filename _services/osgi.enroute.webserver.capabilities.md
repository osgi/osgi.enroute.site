---
title: osgi.enroute.webserver.capabilities
layout: service
version: 1.0
summary: Handles static web pages and OSGi enRoute web resources 
---

![OSGi WebServer Overview](/img/services/osgi.enroute.webserver.overview.png)

## When to Use?

A large part of a web site usually consists of static resources like images, scripts, html, etc. These resources must be mapped to a proper path on the local webserver. The webserver can provide this feature by mapping a folder in the bundle to a path (i.e. the URL) on the webserver.

In a large webserver it is likely that the same web resources must be present in multiple versions. This is especially opportune for Javascript. Such web resources also have dependencies that are managed by a myriad of dependency systems that also interact like amd, commonjs, bower, npm, and ES6. Even with these solutions it requires a lot of manual care to support multiple versions of the same web resources. 

The webserver therefore provides the possibility to wrap the web resources in bundles and use the OSGi dependency model to create a coherent set. This set can then be included as a single file in the web application's HTML. 

## Example

In the bundle that requires a web resource:

	@RequireWebserverExtender
	@Component(name="osgi.enroute.examples.webserver")
	public class WebserverApplication  { }

Several web resources are declared by the enRoute base API.

See [OSGi enRoute Webserver example][webserver] for more example code. This project uses an example [Web Resource][webserver-resource] that demonstrates how to build and wrap web resources.  

## Static Resources

A webserver extender must map static resources in the `/static` directory to a URL as viewed from the web. This is done by removing the `/static` part and using the remaining path. For example, a resource `/static/foo/bar/baz.png` must be available under `/foo/bar/baz.png` on the local webserver. Since the `/static` URL space is shared, it is strongly recommended that paths do not clash. 

However, resources from different bundles are overlaid. That is, multiple bundles can contribute resources to the same folder. If multiple resources use the exact same path, then the bundle with the highest bundle id will win.


## Efficiency

Webservers are in an excellent position to optimize the traffic. They have access to the static resources in the bundles and can easily cache and pre-zip the resources on the file system. They should support debug and production modes to handle caching.

Webservers are expected to support caching, compression, ranges, ETags, If* headers, and more to optimize the use of bandwidth. 

## Web Resources

A _web resource bundle_ contains resources that must be made available on a webserver. The `osgi.enroute.webresource` namespace defines a mechanism to include web resources in an application using the OSGi Capability model.

A web resource bundle should provide an annotation to require that web resource, or a compatible later version. By placing the web resource bundle on the build path, a contained annotation can be applied to some core application class. For example:

	@RequireAngularWebResource( resource="angular.js" )
	@RequireWebserverExtender
	@Component(name="com.example.myapp")
	public class MyApp  { ... }

During resolving, the required web resource bundles are automatically included in the application. (In their compatible version!) When installed on the OSGi framework, they are actually also resolved. The webserver then uses the resolution wiring to find out the set of web resource bundles that belong to an application. For an application to include then that set of web resources, it uses the standard CSS include or Javascript include mechanism with a magic URL:

	/osgi.enroute.webresource/<bsn>/<version>/<glob>

You can get the bsn and the version from the macros in bnd:
	
	<!DOCTYPE html>
	<html lang="en">
		<head>
		<title>OSGI ENROUTE EXAMPLES WEBSERVER APPLICATION</title>
		<link rel="stylesheet" type="text/css"
			href="/osgi.enroute.webresource/${bsn}/${Bundle-Version}/*.css">
	</head>
	
	<body>
		<center>
			<img
				src="/osgi.enroute.webresource/${bsn}/${Bundle-Version}/enroute-logo-64.png">
		</center>
		<script src="/osgi.enroute.webresource/${bsn}/${Bundle-Version}/*.js"></script>
	</body>
	</html>

The remaining section explains how to make a Web Resource, but only continue reading if you want to wrap your own resources. Though Web Resources are extremely easy to use and hide a lot of complexity, some of this complexity is displaced to the wrapping of the resources. In practice, though, it is done only once and is relatively easy to maintain.

## Making a Web Resource Bundle

There exists a bnd(tools) template to create web resource bundles. Use of this template is highly recommended. Create a new project using the OSGi enRoute Templates and make sure the name of the project ends with `.webresource`. This is a normal bndtools project but has bnd.bnd file setup for web resources and has some annotations to require that web resource bundle.

A web resource, for example Angular JS, must be wrapped in a bundle. The preferred location is `/static/<owner>/<product>/<version>`. This location will make the resource available over the web as a specific version. This is however not required. For Angular, using this approach would result in something like `/static/google/angular/1.4.4`.

The web resource should then provide a capability. This capability name must be the generic path, so in the previous Angular JS example this would be `/google/angular`. It should specify its version and a root attribute. The `root` path must point to a folder in the bundle that contains the resources. In our angular example this would be `/static/google/angular/1.4.4` but it can be anywhere in the bundle. The root path is not required to be publicly available, though it is a recommended practice so that multiple versions do not conflict.

	Provide-Capability: \
		osgi.enroute.webresource; \
     		osgi.enroute.webresource=/google/angular; \
     		version:Version=1.4.4; \
     		root=/static/google/angular/1.4.4
 
Obviously macros should be used in bnd to remove the inevitable redundancy.

A bundle that wants to use a web resource should create a requirement against the provided capability. For example:

	Require-Capability: \
		osgi.enroute.webresource; \
     		filter:='(&(osgi.enroute.webresource=/google/angular)(version>=1.4.4)(!(version>=2.0.0)))';
     		resource:List="angular.js,angular-route.js,angular-resource.js";
     		priority:Integer=1000
 
The requirement can specify a resource and a priority attribute. The resource attribute is a list if resources in the root folder of the bundle that collectively provide the Web Resource capability. The priority is used to influence the order of inclusion.

In runtime, the webserver creates a virtual URI:

	/osgi.enroute.webresource/<bsn>/<version>/<glob>
 
The `<bsn>` is the bundle symbolic name and the `<version>` is the exact version of the bundle. The webserver will find this bundle and then look up all Web Resource wires from this bundle to any actual Web Resources. It will then create a file that contains all the resources that are listed by the requirements and that match the globbing pattern. The priority will define the order; the higher the value, the earlier the resource is loaded.
Additionally, any resources that match the globbing pattern in the requiring bundle's web folder are added at the end. That is, applications should place their own resources that can be merged into one file in the `/web` folder.

When building with bnd, macros can be used to synchronize the version and bsn with the html file(s). For example:

	<link 
		rel="stylesheet" 
		type="text/css"
		href="/osgi.enroute.webresource/${bsn}/${Bundle-Version}/*.css">
	<script 
		src="/osgi.enroute.webresource/${bsn}/${Bundle-Version}/*.js">

Adding these requirements is of course rather unpleasant and incredibly error prone. It is therefore recommended that each web resource bundle creates a customized requirement annotation that can then be used by its clients. (See manifest annotations.) For example, in the Angular web resource this looks like:

	@RequireCapability(
		ns = WebResourceNamespace.NS, 
		filter = "(&(osgi.enroute.webresource=/google/angular)${frange;1.4.4})")
	@Retention(RetentionPolicy.CLASS)
	public @interface RequireAngularWebResource {
	 	String[]resource() default {
	 			"angular.js", "angular-route.js"
	 	};	 
	 	int priority() default 1000;
	}
 
This creates (when using bnd) the `@RequireAngularWebResource` annotation that, when applied anywhere in a bundle, will create the aforementioned requirement.

This makes creating the requirement as simple as applying an annotation. In general there is a single class that represents the application, this class is quite well suited for this purpose. It is recommended that all web resource requirements be placed in the same class.

	@RequireAngular( 
		resource={"angular.js", 
					"angular-resource.js" ) 
	@RequireWebserverExtender
	public class MyApplication { }
 

## Questions & Discussions

### Where can I find the engine behind this? I would like to see what actually makes all this work. The description on this page makes it somehow look like magic.

It is not magic, it is juist one of the things you can do with the OSGi capability model. The webserver has a simple implementation in the [OSGi enRoute bundles project][bundles]

### Is there a reason why these requirement/capability pairs do not resolve at compile time? 

During compile time the annotation works as the proof that the web resource bundle exist. However, we want the flexibility to use a later compatible version when we establish the bundles for the application. So the require annotation should require a version range that ensures a compatible version is included in the application.

In runt time, the OSGi framework resolves the actual situation and then the webserver uses this information to create the virtual URL. 

### Are there any more general examples of capability/requirements that do _not_ use extenders?

The whole OSGi framework is based on the Capability model. All Import-Package, Require-Bundle, Export-Package, etc. are all require or provide capabilities. Many different namespaces have been created by the OSGi Alliance already. Contracts, Services, META-INF/services, implementations, etc.

[webserver]: https://github.com/osgi/osgi.enroute.examples/tree/master/osgi.enroute.examples.webserver.application
[webserver-resource]: https://github.com/osgi/osgi.enroute.examples/tree/master/osgi.enroute.examples.webserver.webresource
[bundles]: https://github.com/osgi/osgi.enroute.bundles/tree/master/osgi.enroute.web.simple.provider
