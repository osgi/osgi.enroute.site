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

There exists a bnd(tools) template to create web resources that is highly recommended to use. Use the OSGi enRoute Templates and make sure the name of the project ends with `.webresource`. The remaining section explains how Web Resource can be made but only continue reading this if you want to wrap your own resources. Though web resources are extremely easy to use and hide a lot of complexity, some of this complexity is reflected in the wrapping of the resources. Though in practice one it is done once, it is relatively easy to maintain.

A web resource, for example Angular, must be wrapped in a bundle. The preferred location is `/static/<owner>/<product>/<version>`. This location will make the resource available over the web in a specific version. This is however not required. For Angular this would be something like `/static/google/angular/1.4.4`.

The web resource should then provide a capability. This capability name must be the generic path, in the previous Angular example this would be /google/angular. It should specify its version and a root attribute. The `root` path must point to a folder in the bundle that contains the resources. In our angular example this would be `/static/google/angular/1.4.4` but it can be anywhere in the bundle. The root path is not required to be publicly available though is is recommended.

	Provide-Capability: \
		osgi.enroute.webresource; \
     		osgi.enroute.webresource=/google/angular; \
     		version:Version=1.4.4; \
     		root=/static/google/angular/1.4.4
 
Obviously macros should be used in bnd to remove the inevitable redundancy.

A bundle that wants to use a web resource should create a requirement to the provided capability. For example:

	Require-Capability: \
		osgi.enroute.webresource; \
     		filter:='(&(osgi.enroute.webresource=/google/angular)(version>=1.4.4)(!(version>=2.0.0)))';
     		resource:List="angular.js,angular-route.js,angular-resource.js";
     		priority:Integer=1000
 
The requirement can specify a resource and a priority attribute. The resource attribute is a list if resources in the root folder of the bundle that provides the web resource capability. The priority is used to influence the order of include.

In runtime, the webserver creates a virtual URI:

	/osgi.enroute.webresource/<bsn>/<version>/<glob>
 
The `<bsn>`is the bundle symbolic name and the `<version>` is the exact version of the bundle. The webserver will find this bundles and then look up all web resource wires from this bundle to any actual web resources. It will then create a file that contains all the resources that are listed by the requirements and that match the globbing pattern. The priority will define the order, the higher, the earlier the resource is loaded.
Additionally, any resources that match the globbing pattern in the requiring bundle's web folder are added at the end. That is, applications should place their own web resources that can be merged into one file in the /web folder.

When building with bnd, macros can be used to synchronize the version and bsn with the html file(s). For example:

	<link 
		rel="stylesheet" 
		type="text/css"
		href="/osgi.enroute.webresource/${bsn}/${Bundle-Version}/*.css">
	<script 
		src="/osgi.enroute.webresource/${bsn}/${Bundle-Version}/*.js">

Adding these requirements of course is rather unpleasant and incredibly error prone. It is therefore recommended that each web resource creates a customized requirement annotation that can then be used by its clients. See manifest annotations. For example, in the Angular web resource this looks like:

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

This makes creating the requirement as simple as applying an annotation. In general there is a single class that represents the application, this class is quite well suited for this purpose. It is recommended that all web resource requirements are placed on the same class.

	@RequireAngular( 
		resource={"angular.js", 
					"angular-resource.js" ) 
	public class MyApplication { }
 




[webserver]: https://github.com/osgi/osgi.enroute.examples.webserver.application
[webserver-resource]: https://github.com/osgi/osgi.enroute.examples.webserver.webresource

