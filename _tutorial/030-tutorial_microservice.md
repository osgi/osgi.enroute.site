---
title: Microservices
layout: toc-guide-page
lprev: 022-tutorial_osgi_runtime.html
lnext: 032-tutorial_microservice-jpa.html
summary: Creating a REST based 3-tier Microservice with JDBC persistence (< 10 minutes).
author: enRoute@paremus.com
sponsor: OSGi™ Alliance
---

This tutorial is Maven and command-line based; the reader may follow this verbatim or use their favorite Java IDE.

## Introduction

Using the [enRoute Archetypes](../about/112-enRoute-Archetypes.html) this tutorial walks through the creation of a REST Microservice comprised of the following structural elements:
* An API module
* A DAO Implementation module
* A REST Service Implementation module
* The Composite Application module

with each module having a POM that describes its dependencies.

We start by creating the required project skeleton.

For this tutorial we put the project in the `~` (AKA `/home/user`) directory. If you put your project in a different directory, be sure to replace the `~` with your directory path when it appears in shell snippets in the tutorial.
{: .note }

## Creating the Project

Using the [bare-project Archetype](../about/112-enRoute-Archetypes.html#the-project-archetype), in your project root directory create the **microservice** project:

    ~ $ mvn archetype:generate \
        -DarchetypeGroupId=org.osgi.enroute.archetype \
        -DarchetypeArtifactId=project-bare \
        -DarchetypeVersion=7.0.0
{: .shell }

with the following values:

    Define value for property 'groupId': org.osgi.enroute.examples
    Define value for property 'artifactId': microservice
    Define value for property 'version' 1.0-SNAPSHOT: : 0.0.1-SNAPSHOT
    Define value for property 'package' org.osgi.enroute.examples: :
    Confirm properties configuration:
    groupId: org.osgi.enroute.examples
    artifactId: microservice
    version: 0.0.1-SNAPSHOT
    package: org.osgi.enroute.examples
    Y: :
{: .shell }

**Note** - if you use alternative `groupId`, `artifactId` values remember to update the `package-info.java` and `import` statements in the files used throughout the rest of this tutorial.
{: .note }


We now create the required modules.

## The DAO API

Change directory into the newly created `microservice` project directory; then create the `api` module using the [api Archetype](../about/112-enRoute-Archetypes.html#the-api-archetype) as shown:

    ~ $ cd microservice
    ~/microservice $ mvn archetype:generate \
        -DarchetypeGroupId=org.osgi.enroute.archetype \
        -DarchetypeArtifactId=api \
        -DarchetypeVersion=7.0.0
{: .shell }

with the following values:

    Define value for property 'groupId': org.osgi.enroute.examples.microservice
    Define value for property 'artifactId': dao-api
    Define value for property 'version' 1.0-SNAPSHOT: : 0.0.1-SNAPSHOT
    Define value for property 'package' org.osgi.enroute.examples.microservice.dao.api: :org.osgi.enroute.examples.microservice.dao
    Confirm properties configuration:
    groupId: org.osgi.enroute.examples.microservice
    artifactId: dao-api
    version: 0.0.1-SNAPSHOT
    package: org.osgi.enroute.examples.microservice.dao
    Y: :
{: .shell }

Now create the following two files:

`~/microservice/dao-api/src/main/java/org/osgi/enroute/examples/microservice/dao/PersonDao.java`
<p>
  <a class="btn btn-primary" data-toggle="collapse" href="#PersonDao" aria-expanded="false" aria-controls="PersonDao">
    PersonDAO.java
  </a>
</p>
<div class="collapse" id="PersonDao">
  <div class="card card-block">

{% highlight java %}
{% include osgi.enroute/examples/microservice/dao-api/src/main/java/org/osgi/enroute/examples/microservice/dao/PersonDao.java %}
{% endhighlight %}
</div>
</div>

`~/microservice/dao-api/src/main/java/org/osgi/enroute/examples/microservice/dao/AddressDao.java`
<p>
  <a class="btn btn-primary" data-toggle="collapse" href="#AddressDao" aria-expanded="false" aria-controls="AddressDao">
    AddressDAO.java
  </a>
</p>
<div class="collapse" id="AddressDao">
  <div class="card card-block">

{% highlight java %}
{% include osgi.enroute/examples/microservice/dao-api/src/main/java/org/osgi/enroute/examples/microservice/dao/AddressDao.java %}
{% endhighlight %}
</div>
</div>

### Dependencies

`dao-api` has no dependencies.

### Visibility
`dao-api` is an API package which is imported by `RestComponentImpl`, `PersonDaoImpl` & `AddressDaoImpl`; hence it must must be exported. This is indicated by the automatically generated file `~/microservice/dao-api/src/main/java/org/osgi/enroute/examples/microservice/dao/package-info.java`:
<p>
  <a class="btn btn-primary" data-toggle="collapse" href="#package-info-dao" aria-expanded="false" aria-controls="package-info-dao">
    package-info.java
  </a>
</p>
<div class="collapse" id="package-info-dao">
  <div class="card card-block">
{% highlight java tabsize=4 %}
{% include osgi.enroute/examples/microservice/dao-api/src/main/java/org/osgi/enroute/examples/microservice/dao/package-info.java %}
{% endhighlight %}

  </div>
</div>

For further detail see [Semantic Versioning](../FAQ/210-semantic_versioning.html).

### Defining the DTO

Data transfer between the components is achieved via the use of [Data Transfer Objects (DTOs)](../FAQ/420-dtos.html).

To achieve this create the following two files:

`~/microservice/dao-api/src/main/java/org/osgi/enroute/examples/microservice/dao/dto/PersonDTO.java`
<p>
  <a class="btn btn-primary" data-toggle="collapse" href="#PersonDTO" aria-expanded="false" aria-controls="PersonDTO">
    PersonDTO.java
  </a>
</p>
<div class="collapse" id="PersonDTO">
  <div class="card card-block">

{% highlight java %}
{% include osgi.enroute/examples/microservice/dao-api/src/main/java/org/osgi/enroute/examples/microservice/dao/dto/PersonDTO.java %}
{% endhighlight %}
</div>
</div>

`~/microservice/dao-api/src/main/java/org/osgi/enroute/examples/microservice/dao/dto/AddressDTO.java`
<p>
  <a class="btn btn-primary" data-toggle="collapse" href="#AddressDTO" aria-expanded="false" aria-controls="AddressDTO">
   AddressDTO.java
  </a>
</p>
<div class="collapse" id="AddressDTO">
  <div class="card card-block">

{% highlight java %}
{% include osgi.enroute/examples/microservice/dao-api/src/main/java/org/osgi/enroute/examples/microservice/dao/dto/AddressDTO.java %}
{% endhighlight %}
</div>
</div>

and again, we advertise this Capability by creating the following `package-info.java` file:

`~/microservice/dao-api/src/main/java/org/osgi/enroute/examples/microservice/dao/dto/package-info.java`
<p>
  <a class="btn btn-primary" data-toggle="collapse" href="#package-info-dto" aria-expanded="false" aria-controls="package-info-dto">
    package-info.java
  </a>
</p>
<div class="collapse" id="package-info-dto">
  <div class="card card-block">

{% highlight java %}
{% include osgi.enroute/examples/microservice/dao-api/src/main/java/org/osgi/enroute/examples/microservice/dao/dto/package-info.java %}
{% endhighlight %}
</div>
</div>


## The DAO Implementation

Now, in the `microservice` project directory, create the `impl` module using the [ds-component Archetype](../about/112-enRoute-Archetypes.html#the-ds-component-archetype):

    ~/microservice $ mvn archetype:generate \
        -DarchetypeGroupId=org.osgi.enroute.archetype \
        -DarchetypeArtifactId=ds-component \
        -DarchetypeVersion=7.0.0
{: .shell }

with the following values:

    Define value for property 'groupId': org.osgi.enroute.examples.microservice
    Define value for property 'artifactId': dao-impl
    Define value for property 'version' 1.0-SNAPSHOT: : 0.0.1-SNAPSHOT
    Define value for property 'package' org.osgi.enroute.examples.microservice.dao.impl: :
    Confirm properties configuration:
    groupId: org.osgi.enroute.examples.microservice
    artifactId: dao-impl
    version: 0.0.1-SNAPSHOT
    package: org.osgi.enroute.examples.microservice.dao.impl
    Y: :
{: .shell }

Now create the following four files:

`~/microservice/dao-impl/src/main/java/org/osgi/enroute/examples/microservice/dao/impl/PersonTable.java`
<p>
  <a class="btn btn-primary" data-toggle="collapse" href="#PersonTable" aria-expanded="false" aria-controls="PersonTable">
    PersonTable.java
  </a>
</p>
<div class="collapse" id="PersonTable">
  <div class="card card-block">


{% highlight java %}
{% include osgi.enroute/examples/microservice/dao-impl/src/main/java/org/osgi/enroute/examples/microservice/dao/impl/PersonTable.java %}
{% endhighlight %}
</div>
</div>


`~/microservice/dao-impl/src/main/java/org/osgi/enroute/examples/microservice/dao/impl/PersonDaoImpl.java`
<p>
  <a class="btn btn-primary" data-toggle="collapse" href="#PersonDaoImpl" aria-expanded="false" aria-controls="PersonDaoImpl">
    PersonDaoImpl.java
  </a>
</p>
<div class="collapse" id="PersonDaoImpl">
  <div class="card card-block">


{% highlight java %}
{% include osgi.enroute/examples/microservice/dao-impl/src/main/java/org/osgi/enroute/examples/microservice/dao/impl/PersonDaoImpl.java %}
{% endhighlight %}
</div>
</div>


`~/microservice/dao-impl/src/main/java/org/osgi/enroute/examples/microservice/dao/impl/AddressTable.java`
<p>
  <a class="btn btn-primary" data-toggle="collapse" href="#AddressTable" aria-expanded="false" aria-controls="AddressTable">
    AddressTable.java
  </a>
</p>
<div class="collapse" id="AddressTable">
  <div class="card card-block">

{% highlight java %}
{% include osgi.enroute/examples/microservice/dao-impl/src/main/java/org/osgi/enroute/examples/microservice/dao/impl/AddressTable.java %}
{% endhighlight %}
</div>
</div>


`~/microservice/dao-impl/src/main/java/org/osgi/enroute/examples/microservice/dao/impl/AddressDaoImpl.java`
<p>
  <a class="btn btn-primary" data-toggle="collapse" href="#AddressDaoImpl" aria-expanded="false" aria-controls="AddressDaoImpl">
    AddressDaoImpl.java
  </a>
</p>
<div class="collapse" id="AddressDaoImpl">
  <div class="card card-block">


{% highlight java %}
{% include osgi.enroute/examples/microservice/dao-impl/src/main/java/org/osgi/enroute/examples/microservice/dao/impl/AddressDaoImpl.java %}
{% endhighlight %}
</div>
</div>

### Dependencies

The `dao-impl` has a dependency on `dao-api`. Also `PersonalDaoImpl.java` and `AddressDaoImpl.java` implementations (see below) have dependencies on the `slf4j` logging API. This dependency information is added to the `<dependencies>` section of `dao-impl/pom.xml`: i.e. `dao-impl`'s [repository](../FAQ/200-resolving.html#managing-repositories).

{% highlight xml %}
<dependency>
    <groupId>org.osgi.enroute.examples.microservice</groupId>
    <artifactId>dao-api</artifactId>
    <version>0.0.1-SNAPSHOT</version>
</dependency>
<dependency>
    <groupId>org.slf4j</groupId>
    <artifactId>slf4j-api</artifactId>
    <version>1.7.25</version>
</dependency>
{% endhighlight %}

### Visibility

Implementations should **NOT** be shared; hence no `package-info.java` file.
{: .note }

## The REST Service

In the `microservice` project directory now create the `rest-component` module using the [rest-component Archetype](../about/112-enRoute-Archetypes.html#the-rest-component-archetype):

    ~/microservice $ mvn archetype:generate \
        -DarchetypeGroupId=org.osgi.enroute.archetype \
        -DarchetypeArtifactId=rest-component \
        -DarchetypeVersion=7.0.0
{: .shell }

with the following values:

    Define value for property 'groupId': org.osgi.enroute.examples.microservice
    Define value for property 'artifactId': rest-service
    Define value for property 'version' 1.0-SNAPSHOT: : 0.0.1-SNAPSHOT
    Define value for property 'package' org.osgi.enroute.examples.microservice.rest.service: : org.osgi.enroute.examples.microservice.rest
    Confirm properties configuration:
    groupId: org.osgi.enroute.examples.microservice
    artifactId: rest-service
    version: 0.0.1-SNAPSHOT
    package: org.osgi.enroute.examples.microservice.rest
    Y: :
{: .shell }

Now create the following two files:

`~/microservice/rest-service/src/main/java/org/osgi/enroute/examples/microservice/rest/RestComponentImpl.java`
<p>
  <a class="btn btn-primary" data-toggle="collapse" href="#RestComponentImpl" aria-expanded="false" aria-controls="RestComponentImpl">
    RestComponentImpl.java
  </a>
</p>
<div class="collapse" id="RestComponentImpl">
  <div class="card card-block">


{% highlight java %}
{% include osgi.enroute/examples/microservice/rest-service/src/main/java/org/osgi/enroute/examples/microservice/rest/RestComponentImpl.java %}
{% endhighlight %}
</div>
</div>


`~/microservice/rest-service/src/main/java/org/osgi/enroute/examples/microservice/rest/JsonpConvertingPlugin.java`
<p>
  <a class="btn btn-primary" data-toggle="collapse" href="#JsonpConvertingPlugin" aria-expanded="false" aria-controls="JsonpConvertingPlugin">
   JsonpConvertingPlugin.java
  </a>
</p>
<div class="collapse" id="JsonpConvertingPlugin">
  <div class="card card-block">


{% highlight java %}
{% include osgi.enroute/examples/microservice/rest-service/src/main/java/org/osgi/enroute/examples/microservice/rest/JsonpConvertingPlugin.java %}
{% endhighlight %}
</div>
</div>


Create the directory `~/microservice/rest-service/src/main/resources/static/main/html` and added the following file:

`~/microservice/rest-service/src/main/resources/static/main/html/person.html`
<p>
  <a class="btn btn-primary" data-toggle="collapse" href="#person" aria-expanded="false" aria-controls="person">
    person.html
  </a>
</p>
<div class="collapse" id="person">
  <div class="card card-block">


{% highlight html %}
{% include osgi.enroute/examples/microservice/rest-service/src/main/resources/static/main/html/person.html %}
{% endhighlight %}  
</div>
</div>

And also the `~/microservice/rest-service/src/main/resources/static/css` directory for the following `style.css` file

`~/microservice/rest-service/src/main/resources/static/css/style.css`
<p>
  <a class="btn btn-primary" data-toggle="collapse" href="#style" aria-expanded="false" aria-controls="style">
   style.css
  </a>
</p>
<div class="collapse" id="style">
  <div class="card card-block">


{% highlight css %}
{% include osgi.enroute/examples/microservice/rest-service/src/main/resources/static/css/style.css %}
{% endhighlight %}
</div>
</div>

Finally, place the following `index.html` file in directory `~/microservice/rest-service/src/main/resources/static`

`~/microservice/rest-service/src/main/resources/static/index.html`
<p>
  <a class="btn btn-primary" data-toggle="collapse" href="#index" aria-expanded="false" aria-controls="index">
    index.html
  </a>
</p>
<div class="collapse" id="index">
  <div class="card card-block">


{% highlight html %}
{% include osgi.enroute/examples/microservice/rest-service/src/main/resources/static/index.html %}
{% endhighlight %}
</div>
</div>

and create the directory `~/microservice/rest-service/src/main/resources/static/main/img` into which save the following icon with the name `enroute-logo-64.png`.

![enRoute logo](img/enroute-logo-64.png)

### Dependencies

As the `rest-service` module has dependencies on the `dao-api` and `json-api` these dependencies are added to the `<dependencies>` section in `~/microservice/rest-service/pom.xml`. A `JSON-P` implementation dependency is also included so that the `rest-service` can be unit tested.

{% highlight xml %}
<dependency>
    <groupId>org.apache.servicemix.specs</groupId>
    <artifactId>org.apache.servicemix.specs.json-api-1.1</artifactId>
    <version>2.9.0</version>
</dependency>
<dependency>
    <groupId>org.osgi.enroute.examples.microservice</groupId>
    <artifactId>dao-api</artifactId>
    <version>0.0.1-SNAPSHOT</version>
</dependency>
<dependency>
    <groupId>org.apache.johnzon</groupId>
    <artifactId>johnzon-core</artifactId>
    <version>1.1.0</version>
</dependency>
{% endhighlight %}

### Visibility

Implementation types should **NOT** be shared; hence we have no `package-info.java` file in the REST component.
{: .note }


## The Composite Application

We now pull these Modules together to create the Composite Application.

In the `microservice` project directory create the `application` module using the [application Archetype](../about/112-enRoute-Archetypes.html#the-application-archetype):

    ~/microservice $ mvn archetype:generate \
        -DarchetypeGroupId=org.osgi.enroute.archetype \
        -DarchetypeArtifactId=application \
        -DarchetypeVersion=7.0.0
{: .shell }

with the following values:

    Define value for property 'groupId': org.osgi.enroute.examples.microservice
    Define value for property 'artifactId': rest-app
    Define value for property 'version' 1.0-SNAPSHOT: : 0.0.1-SNAPSHOT
    Define value for property 'package' org.osgi.enroute.examples.microservice: :
    Define value for property 'impl-artifactId': rest-service
    Define value for property 'impl-groupId' org.osgi.enroute.examples.microservice: :
    Define value for property 'impl-version' 0.0.1-SNAPSHOT: :
    Define value for property 'app-target-java-version' 8: :
    Confirm properties configuration:
    groupId: org.osgi.enroute.examples.microservice
    artifactId: rest-app
    version: 0.0.1-SNAPSHOT
    package: org.osgi.enroute.examples.microservice
    impl-artifactId: rest-service
    impl-groupId: org.osgi.enroute.examples.microservice
    impl-version: 0.0.1-SNAPSHOT
    app-target-java-version: 8
    Y: :
{: .shell }

### Define Runtime Entity

Our Microservice is composed of the following elements:
* A REST Service
* An implementation of JSON-P (org.apache.johnzon.core)
* An in memory database (H2).

These dependencies are expressed as runtime Requirements in the `~/microservice/rest-app/rest-app.bndrun` file:

{% highlight shell-session %}
index: target/index.xml

-standalone: ${index}

-resolve.effective: active

-runrequires: \
    osgi.identity;filter:='(osgi.identity=org.osgi.enroute.examples.microservice.rest-service)',\
    osgi.identity;filter:='(osgi.identity=org.apache.johnzon.core)',\
    osgi.identity;filter:='(osgi.identity=org.h2)',\
    osgi.identity;filter:='(osgi.identity=org.osgi.enroute.examples.microservice.rest-app)'
-runfw: org.eclipse.osgi
-runee: JavaSE-1.8
{% endhighlight %}


### Dependencies

By adding the following dependencies inside the `<dependencies>` section of the file `~/microservice/rest-app/pom.xml`, we add the necessary Capabilities to the `rest-app`'s repository.

{% highlight xml %}
<dependency>
    <groupId>org.osgi.enroute.examples.microservice</groupId>
    <artifactId>dao-impl</artifactId>
    <version>0.0.1-SNAPSHOT</version>
</dependency>
<dependency>
    <groupId>org.apache.johnzon</groupId>
    <artifactId>johnzon-core</artifactId>
    <version>1.1.0</version>
</dependency>
<dependency>
    <groupId>com.h2database</groupId>
    <artifactId>h2</artifactId>
    <version>1.4.196</version>
    <scope>runtime</scope>
</dependency>
{% endhighlight %}

### Runtime Configuration

Finally, our Microservice will be configured using the new R7 Configurator mechanism.

The [application Archetype](../about/112-enRoute-Archetypes.html##the-application-archetype) enables this via `~/microservice/rest-app/src/main/java/config/package-info.java`.
<p>
  <a class="btn btn-primary" data-toggle="collapse" href="#package-info-config" aria-expanded="false" aria-controls="package-info-config">
    package-info.java
  </a>
</p>
<div class="collapse" id="package-info-config">
  <div class="card card-block">

{% highlight java %}
{% include osgi.enroute/examples/microservice/rest-app/src/main/java/config/package-info.java %}
{% endhighlight %}
</div>
</div>

To pass in the appropriate configuration, overwrite the contents of `~/microservice/rest-app/src/main/resources/OSGI-INF/configurator/configuration.json` with the following:

 <p>
  <a class="btn btn-primary" data-toggle="collapse" href="#configuration" aria-expanded="false" aria-controls="configuration">
    configuration.json
  </a>
</p>
<div class="collapse" id="configuration">
  <div class="card card-block">


{% highlight json %}
{% include osgi.enroute/examples/microservice/rest-app/src/main/resources/OSGI-INF/configurator/configuration.json %}
{% endhighlight %}
</div>
</div>

## Build

Check the modules that make up your application build cleanly from the top level project directory

    ~/microservice $ mvn -pl !rest-app verify
{: .shell }

**Note** - If you are a linux/unix/*nix user, you might need to escape the exclamation point in the above command.
{: .note }

Now build the rest-app bundle using package command.

    ~/microservice $ mvn -pl rest-app package
{: .shell }

**Note** - if this build fails then check your code and pom dependencies and try again.
{: .note }

We now generate the required OSGi indexes from the project dependencies, and resolve our application.

    ~/microservice $ mvn -pl rest-app -am bnd-indexer:index \
        bnd-indexer:index@test-index bnd-resolver:resolve
{: .shell }

**Note** Don't do a clean before running this step, it's building the indexes and resolution from the bundles you made in the previous step. Also, you don't need to run this step every time, just if your dependency graph needs to be recalculated.
{: .note }

And finally generate the runnable jar from the top level project directory.

    ~/microservice $ mvn verify
{: .shell }

Re-inspecting `~/microservice/rest-app/rest-app.bndrun` we can see that this now explicitly references the acceptable version range for each required OSGi bundle. At runtime the OSGi framework resolves these _requirements_ against the _capabilities_ in the specified target repository: i.e. `target/index.xml`.

{% highlight shell-session %}
{% include osgi.enroute/examples/microservice/rest-app/rest-app.bndrun %}
{% endhighlight %}

## Run

To dynamically assemble and run the resultant REST Microservice simply change back to the top level project directory and type the command:

    ~/microservice $ java -jar rest-app/target/rest-app.jar
{: .shell }

The REST service can be seen by pointing a browser to [http://localhost:8080/microservice/index.html](http://localhost:8080/microservice/index.html)

![Microservice demo](img/MicroService.png){: height="450px" width="450px"}

Stop the application using Ctrl+C in the console.

Finally, if we create and run the [debug version](022-tutorial_osgi_runtime.html) of the Microservice we can see all of the OSGi bundles used in the actual runtime assembly.

    g! lb
    START LEVEL 1
       ID|State      |Level|Name
        0|Active     |    0|System Bundle (5.7.0.SNAPSHOT)|5.7.0.SNAPSHOT
        1|Active     |    1|Logback Classic Module (1.2.3)|1.2.3
        2|Active     |    1|Logback Core Module (1.2.3)|1.2.3
        3|Active     |    1|Apache Aries Javax Annotation API (0.0.1.201711291743)|0.0.1.201711291743
        4|Active     |    1|Apache Aries JAX-RS Specification API (0.0.1.201803231639)|0.0.1.201803231639
        5|Active     |    1|Apache Aries JAX-RS Whiteboard (0.0.1.201803231640)|0.0.1.201803231640
        6|Active     |    1|Apache Commons FileUpload (1.3.2)|1.3.2
        7|Active     |    1|Apache Commons IO (2.5.0)|2.5.0
        8|Active     |    1|Apache Felix Configuration Admin Service (1.9.0.SNAPSHOT)|1.9.0.SNAPSHOT
        9|Active     |    1|Apache Felix Configurer Service (0.0.1.SNAPSHOT)|0.0.1.SNAPSHOT
       10|Active     |    1|Apache Felix Gogo Command (1.0.2)|1.0.2
       11|Active     |    1|Apache Felix Gogo Runtime (1.0.10)|1.0.10
       12|Active     |    1|Apache Felix Gogo Shell (1.0.0)|1.0.0
       13|Active     |    1|Apache Felix Http Jetty (3.4.7.R7-SNAPSHOT)|3.4.7.R7-SNAPSHOT
       14|Active     |    1|Apache Felix Servlet API (1.1.2)|1.1.2
       15|Active     |    1|Apache Felix Inventory (1.0.4)|1.0.4
       16|Active     |    1|Apache Felix Declarative Services (2.1.0.SNAPSHOT)|2.1.0.SNAPSHOT
       17|Active     |    1|Apache Felix Web Management Console (4.3.4)|4.3.4
       18|Active     |    1|Apache Felix Web Console Service Component Runtime/Declarative Services Plugin (2.0.8)|2.0.8
       19|Active     |    1|Johnzon :: Core (1.1.0)|1.1.0
       20|Active     |    1|Apache ServiceMix :: Specs :: JSon API 1.1 (2.9.0)|2.9.0
       21|Active     |    1|H2 Database Engine (1.4.196)|1.4.196
       22|Active     |    1|dao-api (0.0.1.201803251221)|0.0.1.201803251221
       23|Active     |    1|dao-impl (0.0.1.201803251221)|0.0.1.201803251221
       24|Active     |    1|rest-app (0.0.1.201803251650)|0.0.1.201803251650
       25|Active     |    1|rest-service (0.0.1.201803251221)|0.0.1.201803251221
       26|Active     |    1|org.osgi:org.osgi.service.jaxrs (1.0.0.201803131808-SNAPSHOT)|1.0.0.201803131808-SNAPSHOT
       27|Active     |    1|org.osgi:org.osgi.util.converter (1.0.0.201803131810-SNAPSHOT)|1.0.0.201803131810-SNAPSHOT
       28|Active     |    1|org.osgi:org.osgi.util.function (1.1.0.201803131808-SNAPSHOT)|1.1.0.201803131808-SNAPSHOT
       29|Active     |    1|org.osgi:org.osgi.util.promise (1.1.0.201803131808-SNAPSHOT)|1.1.0.201803131808-SNAPSHOT
       30|Active     |    1|osgi.cmpn (4.3.1.201210102024)|4.3.1.201210102024
       31|Active     |    1|slf4j-api (1.7.25)|1.7.25
       32|Active     |    1|OSGi Transaction Control JDBC Resource Provider - XA Transactions (1.0.0.201801251821)|1.0.0.201801251821
       33|Active     |    1|Apache Aries OSGi Transaction Control Service - XA Transactions (1.0.0.201801251821)|1.0.0.201801251821
{: .shell }
