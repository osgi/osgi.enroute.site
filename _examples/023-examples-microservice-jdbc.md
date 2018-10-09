---
title: The Microservice Example - JDBC persistence
layout: toc-guide-page
lprev: 020-examples-microservice.html 
lnext: 010-examples.html 
summary: A walkthrough of the Microservice example JDBC persistence layer
author: enRoute@paremus.com
sponsor: OSGi™ Alliance 
---

The microservice example is an OSGi enRoute application created from the [enRoute project bare archetype](../about/112-enRoute-Archetypes.html#the-project-bare-archetype). The microservice example contains a REST endpoint which talks to a data access service for persistence. The application project then packages up these services and their dependencies into a runnable JAR file.

There are two choices for the persistence service implementation used in this example, one using JDBC and one using JPA. This page describes the JDBC implementation of the back-end persistence service. The front end of the application project is described [here](020-examples-microservice.html)


## The DAO Impl Module

The `dao-impl` module contains an implementation of the DAO API using the [Transaction Control Service](https://osgi.org/specification/osgi.cmpn/7.0.0/service.transaction.control.html) with JDBC as the persistence mechanism. It contains two declarative services components in src/main/java, with each one implementing a DAO service.

### The DAO Impl Implementation

<p>
  <a class="btn btn-primary" data-toggle="collapse" href="#PersonDaoImpl" aria-expanded="false" aria-controls="PersonDaoImpl">
    PersonDaoImpl.java
  </a>
</p>
<div class="collapse" id="PersonDaoImpl">
  <div class="card card-block">
{% highlight java tabsize=4 %}
{% include osgi.enroute/examples/microservice/dao-impl/src/main/java/org/osgi/enroute/examples/microservice/dao/impl/PersonDaoImpl.java %}
{% endhighlight %}
  </div>
</div>
<p>
  <a class="btn btn-primary" data-toggle="collapse" href="#AddressDaoImpl" aria-expanded="false" aria-controls="AddressDaoImpl">
    AddressDaoImpl.java
  </a>
</p>
<div class="collapse" id="AddressDaoImpl">
  <div class="card card-block">
{% highlight java tabsize=4 %}
{% include osgi.enroute/examples/microservice/dao-impl/src/main/java/org/osgi/enroute/examples/microservice/dao/impl/AddressDaoImpl.java %}
{% endhighlight %}
  </div>
</div>

* **@Component** - This annotation indicates that types are Declarative Services components. Both components implement interfaces, and are therefore registered as services using those interfaces.

* **@Reference** - Both components consume services from the service registry using field injection. These references are named `provider` so that they can be easily used in configuration.

* **@Activate** -  An activate method will be called back just before an instance of the component is ready for use. In this component we use this opportunity to link the component's [JDBC Resource Provider](https://osgi.org/specification/osgi.cmpn/7.0.0/service.transaction.control.html#d0e127779) to the [Transaction Control Service](https://osgi.org/specification/osgi.cmpn/7.0.0/service.transaction.control.html#service.transaction.control-main.body) it will be using, creating a *scoped* `Connection` *resource*.

### What is Transaction Control?

The Transaction Control Service is a simple programmatic API for transaction lifecycle management and scoping. The client obtains the Transaction Control Service from the service registry and combines it with a Resource Provider instance. The resource provider may also be obtained from the service registry, or it might be created using a factory service. 

Combining a Resource Provider with a Transaction Control service creates a [Scoped Resource](https://osgi.org/specification/osgi.cmpn/7.0.0/service.transaction.control.html#d0e126935) which can be used in any Transaction Control scope.

Importantly a Scoped Resource:

 * Is thread-safe. If two threads use the same Scoped Resource their method calls will delegate to different physical resources. This also ensure that they are isolated from each other.

 * Participates in a transaction if there is one ongoing. If a transaction has been started by the Transaction Control Service then the Scoped Resource will join that transaction automatically

 * Is self-closing. Normally code that interacts with resources is filled with try/finally statements. As Scoped Resources can see which Transaction Control scope is using them they can clean up automatically when the scope finishes. This also applies to derived objects like Statements and ResultSets.

 * Is pooled by default. The resource provider transparently uses a pool of physical resources to support multiple concurrently running scopes.

### Scope lifecycles

The Transaction Control service is used to start or suspend scopes and transactions. There are four lifecycle methods:

 * `required` - the most commonly used method, this ensures that a transaction is running, starting one if necessary. If there was an existing non-transactional scope running then this is suspended for the lifetime of the transaction.

* `requiresNew` - similar to `required` except that this method *always* starts a new transaction, suspending whatever scope was running before.

* `supports` - this method ensures that a scope is active by starting a non-transactional scope if there is no scope currently running. Otherwise the existing scope is used.

* `notSupported` - similar to `supports` except this method will suspend any active transaction by starting a new non-transactional scope.

The `Callable` passed to these lifecycle methods is known as *scoped work*.

You can see from the `PersonDaoImpl` service that it makes calls out to an `AddressDao` service from inside its scoped work. The `AddressDaoImpl` (which is the implementation of that service) is then also using Transaction Control. In this case the existing scope or transaction created by the PersonDaoImpl will be re-used by the AddressDao. Also, as the AddressDaoImpl is using the same `JDBCConnectionProvider` its Scoped Resource (the JDBC Connection) will use the same physical connection as the `PersonDaoImpl` did, thus ensuring proper transaction isolation.


## The rest-app module

The rest-app module is responsible for gathering together the rest service module, the dao-impl, the application configuration, and all of their dependencies into a runnable OSGi application.

### The POM

The pom.xml is of interest. Unsurprisingly it references the rest service module and the dao-impl module, the OSGi reference implementations, and the OSGi debug bundles, however it also includes two other dependencies.

 * The H2 library is a popular, easily embedded database implementation. This dependency is included because a database is needed at runtime to store and retrieve data using JDBC. The dao-impl project remains decoupled, but the application must choose the database to be used.

 * Apache Johnzon is an implementation of the JSON-P API. JSON-P is used in the rest-service as a way to provide JSON serialization, but an implementation is needed at runtime. The application must therefore choose the implementation to use.

To create the exported application requires an OSGi repository index, so this module enables the `bnd-indexer-maven-plugin`, and it uses the `bnd-export-maven-plugin` to export the `app.bndrun` file.

Finally this project enables the `bnd-resolver-maven-plugin` for the `app.bndrun` and `debug.bndrun`, so that these files may be resolved from the command line.

### The rest-app Configuration

The rest-app project creates a bundle. This bundle makes use of the [OSGi Configurator specification](https://osgi.org/specification/osgi.cmpn/7.0.0/service.configurator.html) to provide configuration for the application in an easily consumable JSON format. This file is visible in `src/main/resources/OSGI-INF/configurator`

<p>
  <a class="btn btn-primary" data-toggle="collapse" href="#AppConfig" aria-expanded="false" aria-controls="AppConfig">
    configuration.json
  </a>
</p>
<div class="collapse" id="AppConfig">
  <div class="card card-block">
{% highlight java tabsize=4 %}
{% include osgi.enroute/examples/microservice/rest-app/src/main/resources/OSGI-INF/configurator/configuration.json %}
{% endhighlight %}
  </div>
</div>

The first few lines of this file define the identity of this configuration resource. The three nested objects define configurations that must be put into Configuration Admin.

The first object's key contains a `~` character, indicating that it is a *factory configuration*. The PID of this configuration is `org.apache.aries.tx.control.jdbc.xa` which means it is configuring the [Aries Tx Control JDBC Resource Provider](http://aries.apache.org/modules/tx-control/xaJDBC.html). This is what causes a `JDBCConnectionProvider` service to be registered in the service registry. This configuration targets the H2 database by setting the `osgi.jdbc.driver.class` and sets the database connection URL.

The other two configurations are *singleton* configurations which target the two DAO components. These configurations set a target filter for the reference named `provider` in each component. The filter is set up to select the `name` property from the resource provider configuration so that the components will continue to work in a system where multiple resource providers are present.

#### Requiring the Configurator

The presence of a configuration resource in a bundle is not sufficient to put the configuration into Configuration Admin. The Configurator Extender is required to find the configuration resource, parse it, and create the necessary configuration objects. Requiring the configurator extender is simple, and is achieved through the use of an otherwise empty Java package under `src/main/java`

<p>
  <a class="btn btn-primary" data-toggle="collapse" href="#RequireConfigurator" aria-expanded="false" aria-controls="RequireConfigurator">
    Package-info.java
  </a>
</p>
<div class="collapse" id="RequireConfigurator">
  <div class="card card-block">
{% highlight java tabsize=4 %}
{% include osgi.enroute/examples/microservice/rest-app/src/main/java/config/package-info.java %}
{% endhighlight %}
  </div>
</div>

The `@RequireConfigurator` annotation on the package adds a requirement for the configurator to the bundle manifest, as required by the Configurator specification. This requirement also ensures that a Configurator implementation will be included in any resolve operation.

### The rest-app.bndrun

The `rest-app.bndrun` sets up the requirements and launch parameters for the microservice application.

Firstly the file defines the index that will be used by this bndrun, and uses it to configure this as a standalone bndrun file (meaning that it does not inherit from the rest of the workspace) so that only items from the index will be used when resolving.

Next the file defines the run requirements using `-runrequires`. This uses the OSGi requirement syntax to select the rest-service module, Apache Johnzon, and the H2 database. It also includes the configuration bundle produced by this application project.

Finally the file declares the OSGi framework implementation that should be used, and the Java version that should be assumed when resolving.

The remaining section `-runbundles` is automatically when resolving. It contains the complete list of bundles that have been determined to be needed to run the application.

If you are in an IDE then this file can be run and resolved directly, otherwise the file can be resolved from the command line and run as an executable JAR file.

The default target Java version for the OSGi enRoute examples is Java 8. Due to the incompatible changes made in Java 9 you may need to change the `-runee` instruction to point at your JRE version and re-resolve if you want to use a later version of Java to run the example.
{: .note }

### The debug.bndrun

The `debug.bndrun` inherits the requirements and launch parameters from the `app.bndrun`, and adds:
* An additional repository index for the test bundles
* Requirements for the Felix Gogo shell and the Felix web console

As a result when this bndrun file is resolved and run it includes the main application and the debug bundles, making this an easy way to debug the application when running in an IDE. If command line debugging is preferred then the export maven plugin can be reconfigured to export the `debug.bndrun`, rather than the `rest-app.bndrun`.

## Using a different database

This example currently uses the H2 library, which is a popular, easily embedded database implementation.

However, it is easy to use other *OSGi-friendly* database implementations. By *OSGi-friendly*, we mean implementations which publish a `org.osgi.service.jdbc.DataSourceFactory` service, such as PostgreSQL.

The changes required to use PostgreSQL instead of H2 are outlined below:

### Install PostgreSQL

The H2 database is *embedded*, so requires no installation. To use PostgreSQL you either need access to an existing installation or you need to install it yourself from [here](https://www.postgresql.org/).


### Dependencies

Replace the H2 dependency with the PostgreSQL dependency in the `dependencies` section of the file `rest-app/pom.xml`.

{% highlight xml %}
<dependency>
    <groupId>org.postgresql</groupId>
    <artifactId>postgresql</artifactId>
    <version>42.2.5</version>
    <scope>runtime</scope>
</dependency>
{% endhighlight %}


### Configuration

Configure the rest-app to use PostgreSQL instead of H2 in `configuration.json`.

Note that PostgreSQL requires a username and password for authentication, which are also configured here:

{% highlight json %}
// Configure PostgrSQL JDBC resource provider
"org.apache.aries.tx.control.jdbc.xa~microservice": {
       "name": "microservice.database",
       "osgi.jdbc.driver.class": "org.postgresql.Driver",
       "url": "jdbc:postgresql://dbhost/dbname",
       "user": "demo",
       "password": "secret"
   }
{% endhighlight %}

### Requirements

Replace the initial requirement for H2 with PostgreSQL in `rest-app.bndrun`:

{% highlight shell-session %}
-runrequires: \
    osgi.identity;filter:='(osgi.identity=org.postgresql.jdbc42)'
{% endhighlight %}

## The JPA implementation

The JPA DAO implementations, and the resulting application packaging, are described in the next page.
