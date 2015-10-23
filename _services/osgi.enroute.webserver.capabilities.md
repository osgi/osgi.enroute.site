---
title: osgi.enroute.webserver.capabilities
layout: service
version: 1.0
summary: Handles static web pages and OSGi enRoute web resources 
---

![OSGi WebServer Overview](/img/services/osgi.enroute.webserver.overview.png)

## When to Use?

A large part of a web site usually consists of static resources like images, scripts, html, etc. These resources must be mapped to a proper path on the local webserver.

A common problem with resources is that they require a path on the webserver. This creates a maintenance burden since often these resources (mostly Javascript) are versioned. Supporting multiple versions simultaneously requires path & dependency management on the client side. This webserver feature provides an alternative model that allows you to wrap your Javascript (or other) resources in a bundle and let the OSGi framework take care of the dependency management that is then used by the webserver to do path management.

%%% The last sentence is not clear. What gets used by the webserver to do path management?

%%% What do you mean by "webserver feature" in the above text?
 Are you referring to the service component presented on this page?
 Karaf,for example has a specific meaning for "feature". Is there are specific meaning here? 


## Example

The bundle that requires a web resource:

	@RequireWebserverWebresource
	@Component(name="osgi.enroute.examples.webserver")
	public class WebserverApplication  { }

Several web resources are declared by the enRoute base API.

See [OSGi enRoute Webserver example][webserver] for more example code. This project uses an example [Web Resource][webserver-resource] that demonstrates how to build and wrap web resources.  

%%% Note: the links in this paragraph do not seem to work.

## Static Pages

%%% Why "Static Pages" and not "Static Resources"? Isn't a "page" just a type of resource?

A webserver extender must map static resources in the `/static` directory to a URL as viewed from the web. This is done by removing the `/static` part and using the remaining path. For example, a resource `/static/foo/bar/baz.png` must be available under `/foo/bar/baz.png` on the local webserver. Since the `/static` URL space is shared, it is strongly recommended that paths not clash.

The extender must overlay all resources in bundle ID order. That is, multiple bundles can contribute to the same folder and the bundle with the highest ID will overwrite bundles with the same resource paths but a lower bundle id.

%%% The above paragraph is difficult to understand.

Web extenders must also WebResourceNamespace resources.

%%% Should, or must? Why is this so?

Web extenders must also provide support for common web standards like ranges, zipping, caching, etc.

%%% Should, or must? Why is this so?

## Web Resources

A Web Resource is a bundle that contains resources that must be made available on a webserver. This Web Resource namespace defines a mechanism to include web resources in an application.

%%% Which Web Resource namespace? I thought it was just written that a Web Resource is a bundle. What is the relationship with a namespace?

There exists a bnd(tools) template to create Web Resources. Use of this template is highly recommended. Create a new project using the OSGi enRoute Templates and make sure the name of the project ends with `.webresource`. The remaining section explains how to make a Web Resource, but only continue reading if you want to wrap your own resources. Though Web Resources are extremely easy to use and hide a lot of complexity, some of this complexity is displaced to the wrapping of the resources. In practice, though, it is done only once and is relatively easy to maintain.

%%% This did not work for me. When I create a new project using the enRoute templates, even when I name the project ending in `.webresource`, the resulting project is not a Web Resource project. That is, unless there is nothing specific to web resources in this project template, and I am just misunderstanding...

A Web Resource, for example Angular, must be wrapped in a bundle. The preferred location is `/static/<owner>/<product>/<version>`. This location will make the resource available over the web as a specific version. This is however not required. For Angular, using this approach would result in something like `/static/google/angular/1.4.4`.

The Web Resource should then provide a capability. This capability name must be the generic path, so in the previous Angular example this would be `/google/angular`. It should specify its version and a root attribute. The `root` path must point to a folder in the bundle that contains the resources. In our angular example this would be `/static/google/angular/1.4.4` but it can be anywhere in the bundle. The root path is not required to be publicly available, though it is a recommended practice.

	Provide-Capability: \
		osgi.enroute.webresource; \
     		osgi.enroute.webresource=/google/angular; \
     		version:Version=1.4.4; \
     		root=/static/google/angular/1.4.4
 
Obviously macros should be used in bnd to remove the inevitable redundancy.

A bundle that wants to use a Web Resource should create a requirement against the provided capability. For example:

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

Adding these requirements is of course rather unpleasant and incredibly error prone. It is therefore recommended that each Web Resource create a customized requirement annotation that can then be used by its clients. (See manifest annotations.) For example, in the Angular web resource this looks like:

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
	public class MyApplication { }
 




[webserver]: https://github.com/osgi/osgi.enroute.examples.webserver.application
[webserver-resource]: https://github.com/osgi/osgi.enroute.examples.webserver.webresource


%%% Pretty neat example! Where can I find the engine behind this? I would like to see what actually makes all this work. The description on this page makes it somehow look like magic.

%%% Is there a reason why these requirement/capability pairs do not resolve at compile time? They only resolve at runtime. It is still wonderful that this happens, but it would be very useful if they actually resolved at compile time, too.

%%% Are there any more general examples of capability/requirements that do _not_ use extenders?