---
title: The Microservice Example  
layout: toc-guide-page
lprev: 010-examples.html 
lnext: 010-examples.html 
summary: A walkthrough of the Microservice example front end
author: enRoute@paremus.com
sponsor: OSGi™ Alliance 
---

The microservice example is an OSGi enRoute application created from the [enRoute project bare archetype](../about/112-enRoute-Archetypes.html#the-project-bare-archetype). The microservice example contains a REST endpoint which talks to a data access service for persistence. The application project then packages up these services and their dependencies into a runnable JAR file.

There are two choices for the persistence service implementation used in this example, one using JDBC and one using JPA. This page describes the front end of the application. The back-end persistence services and application projects are described in

The microservice example project has the following layout:

    $ pwd
    ~/microservice 
    $ ls 
    dao-api		dao-impl	rest-app		rest-service
    dao-impl-jpa	rest-app-jpa	rest-service-test	pom.xml
{: .shell }


## The Reactor POM

The reactor POM is responsible for setting common configuration for the build plugins used by modules in the build, and for setting the scopes and versions of common dependencies. 

As the enRoute example projects all live in a single workspace each of their reactor poms inherit configuration from this root reactor. In scenarios where application projects have their own dedicated workspaces, then the following items would be included directly in each of their reactor poms.

The root reactor pom defines configuration for the [bnd plugins](/about/115-bnd-plugins.html) used by enRoute, and the following common dependencies.

### APIs
The OSGi and Java EE APIs commonly used in OSGi enRoute applications are included at provided scope. This is because they should not be used at runtime, instead being provided by implementations, such as the OSGi framework.

### Implementations
The OSGi reference implementations used in OSGi enRoute are included at runtime scope so that they are eligible to be selected for use by the application at runtime, but not available to compile against.

### Debug and Test
The remaining dependencies are made available at test scope so that they may be used when unit testing, integration testing, or debugging OSGi enRoute applications.

## The DAO API Module

The DAO API module contains the API for the data access service. The packages contain the service interfaces and the [Data Transfer Objects](../FAQ/420--dtos.html) used to pass data between the service client and implementation. 

### The API packages

You may have noticed that both of the api packages contain `package-info.java` files. These files look like this:

<p>
  <a class="btn btn-primary" data-toggle="collapse" href="#PkgInfo" aria-expanded="false" aria-controls="PkgInfo">
    package-info.java
  </a>
</p>
<div class="collapse" id="PkgInfo">
  <div class="card card-block">
{% highlight java tabsize=4 %}
{% include osgi.enroute/examples/microservice/dao-api/src/main/java/org/osgi/enroute/examples/microservice/dao/package-info.java %}
{% endhighlight %}
{% highlight java tabsize=4 %}
{% include osgi.enroute/examples/microservice/dao-api/src/main/java/org/osgi/enroute/examples/microservice/dao/dto/package-info.java %}
{% endhighlight %}
  </div>
</div>

The annotations of these packages indicate that they should:
* be exported from the bundle
* be versioned at version `1.0.0`

### Defining API roles

When an API package defines a service interface it is important to consider the *role* of the interface. Is the interface designed to be implemented by a provider, or by a consumer?

If you're confused it can be worth thinking about the Java Servlet API, where we have the `Servlet` interface and the `ServletRequest` interface. The `Servlet` interface is designed to be implemented by consumers - most web applications will implement this interface lots of times. The `ServletRequest` interface, however, is designed to only be implemented by providers, such as Eclipse Jetty or Apache TomCat. If a method is added to `ServletRequest` then only the providers need to be updated (this happens with each new release of the Servlet specification) but if a new method were added to `Servlet` (which has never happened) then it would break **all** the people using Servlets.

In this case the API interfaces are all designed to be implemented by the provider of the service, so both are annotated with `@ProviderType`

<p>
  <a class="btn btn-primary" data-toggle="collapse" href="#PersonDao" aria-expanded="false" aria-controls="PersonDao">
    PersonDao.java
  </a>
</p>
<div class="collapse" id="PersonDao">
  <div class="card card-block">
{% highlight java tabsize=4 %}
{% include osgi.enroute/examples/microservice/dao-api/src/main/java/org/osgi/enroute/examples/microservice/dao/PersonDao.java %}
{% endhighlight %}
  </div>
</div>
<p>
  <a class="btn btn-primary" data-toggle="collapse" href="#AddressDao" aria-expanded="false" aria-controls="AddressDao">
    AddressDao.java
  </a>
</p>
<div class="collapse" id="AddressDao">
  <div class="card card-block">
{% highlight java tabsize=4 %}
{% include osgi.enroute/examples/microservice/dao-api/src/main/java/org/osgi/enroute/examples/microservice/dao/AddressDao.java %}
{% endhighlight %}
  </div>
</div>

### The POM

The pom.xml is simple, it includes the OSGi API, which provides the annotations described above, it activates the `bnd-maven-plugin` which will generate the OSGi manifest, and the `bnd-baseline-maven-plugin` which ensures that future versions of the API use correct [semantic versions](../FAQ/210-semantic_versioning.html).

## The REST Service Module

The REST module contains the REST layer of the application. It contains two declarative services components in `src/main/java`, and a unit test in `src/test/java`. The `src/main/resources` folder contains files contributing a Web User Interface for the component.

### The POM

The pom.xml is simple, it includes the OSGi API, enterprise API and testing dependencies required by the module, and it activates the `bnd-maven-plugin` which will generate the OSGi manifest, and a Declarative Service descriptor for the component.

### The DS REST Component
The DS REST component contains a number of important annotations.

<p>
  <a class="btn btn-primary" data-toggle="collapse" href="#RestComponentImpl" aria-expanded="false" aria-controls="RestComponentImpl">
    RestComponentImpl.java
  </a>
</p>
<div class="collapse" id="RestComponentImpl">
  <div class="card card-block">
{% highlight java tabsize=4 %}
{% include osgi.enroute/examples/microservice/rest-service/src/main/java/org/osgi/enroute/examples/microservice/rest/RestComponentImpl.java %}
{% endhighlight %}

  </div>
</div>

* **@Component** - This annotation indicates that `RestComponentImpl` is a [Declarative Services](../faq/300-declarative-services) component. The `service` attribute means that even though `RestComponentImpl` does not directly implement any interfaces it will still be registered as a service. The `@Component` annotation also acts as a runtime _Requirement_; prompting the host OSGi framework to automatically load a Declarative Services implementation.

* **@JaxrsResource** - This annotation marks the `RestComponentImpl` service as a JAX-RS resource type that should be processed by the [JAX-RS whiteboard](../FAQ/400-patterns.html#whiteboard-pattern). It also acts as a runtime _Requirement_; prompting the host OSGi framework to automatically load a JAX-RS Whiteboard implementation.

* **@JSONRequired** - This annotation marks the component as requiring a serializer capable of supporting JSON. The service declares that it produces JSON in the @Produces annotation, but this can only work if a suitable implementation is available at runtime. This annotation also acts as a runtime _Requirement_; prompting the host OSGi framework to automatically load a JAX-RS Whiteboard extension that can support JSON serialization.

* **@HttpWhiteboardResource** - This annotation indicates to the [Http Whiteboard](../FAQ/400-patterns.html#whiteboard-pattern) that the `Upper` bundle contains one or more static files which should be served over HTTP. The pattern attribute indicates the URI request patterns that should be mapped to resources from the bundle, while the prefix attribute indicates the folder within the bundle where the resources can be found.

The @Path, @Produces, @GET, @POST, @DELETE and @PathParam annotations are defined by JAX-RS, and used to map incoming requests to the resource methods.

### The DS JSON Serializer
The DS JSON Serializer component contains a number of important annotations.

<p>
  <a class="btn btn-primary" data-toggle="collapse" href="#JsonpConvertingPlugin" aria-expanded="false" aria-controls="JsonpConvertingPlugin">
    JsonpConvertingPlugin.java
  </a>
</p>
<div class="collapse" id="JsonpConvertingPlugin">
  <div class="card card-block">
{% highlight java tabsize=4 %}
{% include osgi.enroute/examples/microservice/rest-service/src/main/java/org/osgi/enroute/examples/microservice/rest/JsonpConvertingPlugin.java %}
{% endhighlight %}

  </div>
</div>

* **@Component** - This annotation indicates that `JsonpConvertingPlugin` is a [Declarative Services](../faq/300-declarative-services) component. Note that unlike the `RestComponentImpl` this component *does* implement interfaces and will be automatically registered as a service using the `MessageBodyReader` and `MessageBodyWriter` interfaces. Also the `@Component` annotation declares this component to be `PROTOTYPE` scope - this means that the person using the service can ask for multiple separate instances, and is recommended for all JAX-RS extensions. 

* **@JaxrsExtension** - This annotation marks the `JsonpConvertingPlugin` service as a JAX-RS extension type that should be processed by the [JAX-RS whiteboard](../FAQ/400-patterns.html#whiteboard-pattern).

* **@JaxrsMediaType** - This annotation marks the component as providing a serializer capable of supporting the named media type, in this case the standard media type for JSON. 

#### The DS JSON Serializer Implementation

The implementation of the `JsonpConvertingPlugin` makes use of two specifications - one is JSON-P, a JSON parser and emitter, the other is the OSGi Converter.

The OSGi Converter is a useful utility that can convert objects from one type to another. It contains many standard conversions, however in this case we use a pair of custom rules.

We use the first rule to teach the converter how to turn the DTOs from our API into JSON-P `JsonValue` instances. depending on the type of the incoming object we pick the appropriate JSON type to create - if the incoming object is a complex value we recursively convert the types that make it up. The resulting `JsonValue` can then be easily serialized to a JSON string.

It turns out that the reverse mapping is even easier - the second rule is used to convert a `JsonStructure` into a DTO. A `JSONStructure` is either a `JsonArray`, a `JsonObject` or a `JsonValue`. A `JsonArray` **is a** `List` of `JsonStructure` objects and a `JsonObject` **is a** `Map` of `String` to `JsonStructure` objects, therefore the converter can natively handle these types as it would any list or map type. All that remains is teaching the converter how to handle `JsonValue` which is easily achieved by transforming to the implicit java type and calling the converter again!


### The Unit Test

The unit test makes use of JUnit 4 to perform a basic test on the `JsonpConvertingPlugin`. This test is why the Johnzon implementation is needed as a `test` scope dependency.

## The REST Service Test

The `rest-service-test` component is generated from enRoute's [bundle-test archetype](../about/112-enRoute-Archetypes.html#the-bundle-test-archetype). Rather than creating a bundle for use in the application this project uses the [bnd-testing-maven-plugin](../about/115-bnd-plugins.html#the-bnd-testing-maven-plugin) to test the rest service bundle.

### The Test Case

The REST service test cases are written using JUnit 4

<p>
  <a class="btn btn-primary" data-toggle="collapse" href="#RestServiceIntegrationTest" aria-expanded="false" aria-controls="RestServiceIntegrationTest">
    RestServiceIntegrationTest.java
  </a>
</p>
<div class="collapse" id="RestServiceIntegrationTest">
  <div class="card card-block">
{% highlight java tabsize=4 %}
{% include osgi.enroute/examples/microservice/rest-service-test/src/main/java/org/osgi/enroute/examples/microservice/rest/service/test/RestServiceIntegrationTest.java %}
{% endhighlight %}

  </div>
</div>

Note that:

* The test class includes a `@Capability` annotation advertising a `PersonDao` service. This is because the test case provides a mock service for use in testing, and so we don't need a separate implementation to be resolved

* The test set up method uses Mockito to create a mock `PersonDao`, and gets hold of a JAX-RS client using the service registry

* The `testServiceRegistered` method validates that there are no JAX-RS whiteboard services present unless a `PersonDao` service is present

* The `testGetPerson` method uses the JAX-RS client to call the REST API, firstly expecting no results, then registering a person with the mock DAO and expecting that result to be returned.

### The integration-test.bndrun

The `integration-test.bndrun` file defines the set of test cases and bundles that should be used when testing.

<p>
  <a class="btn btn-primary" data-toggle="collapse" href="#testBndrun" aria-expanded="false" aria-controls="testBndrun">
    integration-test.bndrun
  </a>
</p>
<div class="collapse" id="testBndrun">
  <div class="card card-block">
{% highlight java tabsize=4 %}
{% include osgi.enroute/examples/microservice/rest-service-test/integration-test.bndrun %}
{% endhighlight %}

  </div>
</div>

Note that:

* The `Test-Cases` header uses a bnd macro to select all public, concrete classes with names ending in `Test`

* The `-runrequires` header includes requirements for the bundle we want to test (`rest-service`) the tester bundle, and Apache Johnzon (as a JSON-P implementation)

* The `-runbundles` list is generated by the resolver based on the requirements from the `-runrequires`. This therefore includes things like the JAX-RS whiteboard, but not a dao implementation as the tester bundle advertises a dao service capability.

The two possible DAO implementations, and the resulting application packaging, are described in subsequent pages.