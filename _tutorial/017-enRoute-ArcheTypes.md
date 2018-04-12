---
title: OSGi enRoute Archetypes 
layout: toc-guide-page
lprev: 015-Prerequisite.html 
lnext: 020-tutorial_qs.html
summary: Explanation of the Maven Archetypes used by enRoute
author: enRoute@paremus.com
sponsor: OSGi™ Alliance  
---


An archetype is a type of Maven project template which is used to generate your build so that you can get up and running quickly. It’s absolutely possible to use enRoute without using these archetypes, but they are recommended as a simple way to configure and manage your OSGi build.

All of the enRoute archetypes are found using the org.osgi.enroute.archetype group id. They all make use of build plugins from the bnd project, and they all make use of the OSGi APIs and Reference Implementations as defined by the OSGi enRoute indexes.

There are two main kinds of OSGi enRoute Archetypes:

* Project Archetypes
* Module Archetypes

## Project Archetypes

A project archetype is a template that you’ll use relatively infrequently because its purpose is to set up a completely new OSGi enRoute workspace. The project archetype will create your top-level reactor POM, and define configuration templates for all of the build plugins and dependencies that you’re likely to use in your OSGi enRoute applications.

There are two enRoute project Archetypes:

* The project archetype
* The project-bare archetype

### The project Archetype

The project archetype is designed to get you up and running as fast as possible, setting up a top-level reactor POM and a simple OSGi enRoute application.

This simple application consists of a Declarative Services component project and an enRoute application project. Together these provide a simple application, just like you can see in the quickstart example.

### The project-bare Archetype
The project-bare archetype creates an absolutely minimal enRoute workspace. It doesn’t contain any modules, giving you the maximum flexibility to create your own application modules

## Module Archetypes

A module archetype defines an enRoute Maven module that will be built and output an artifact. The output of the module will depend on the type of archetype that you use:

* The api archetype
* The ds-component archetype
* The rest-component archetype
* The bundle-test archetype
* The application archetype

### The api Archetype

The api archetype is used to build an API bundle for your enRoute application. This type of bundle is where you should define your [public interfaces](../FAQ/450-Designing-APIs.html) and [DTO](../FAQ/420--dtos.html)s. These packages should be versioned and exported.


### The ds-component Archetype 

The ds-component archetype is used to create an OSGi service using [Declarative Services](../FAQ/300-declarative-services.html). This provides a simple programming model for referencing [services](../FAQ/400-patterns.html#services) from the OSGi service registry and then publishing your implementation as a service. Declarative Services uses annotations to define components and injection sites, and these annotations are ready for use in the basic component.

### The rest-component Archetype

The rest-component archetype is similar to the ds-component  archetype, in that it defines an OSGi service using Declarative Services. This service, however, makes use of the OSGi [JAX-RS whiteboard](../FAQ/400-patterns.html#whiteboard-pattern) specification to transparently provide the JAX-RS resource methods as REST endpoints. This archetype is therefore an excellent way to get started when writing a REST microservice. 
                                                  
### The bundle-test Archetype 

The bundle-test archetype creates a special kind of bundle known as a *tester bundle*, and then executes this bundle in an OSGi framework. This allows a bundle-test project to run tests inside a real OSGi framework, observing changes in services and lifecycle events. The archetype provides a template JUnit test, and a bndrun file which configures both the tester bundle and the execution of the tests.

### The application Archetype

The application archetype is different from the other enRoute modules, in that its output is not an OSGi bundle but rather a runnable application. The application archetype is designed to reference the other modules in your application, and use them to resolve an application based on your runtime requirements.

These requirements are provided in a bndrun file, which defines how the OSGi application should be launched, and what should be contained in it. This bndrun can be resolved to turn its requirements into a list of bundles to run, and then exported into a runnable jar file.

In addition to gathering requirements an application module also defines the configuration that will be supplied to the application. This configuration is supplied as a bundle which gets deployed into the application framework and is processed by an [OSGi configurator implementation](https://osgi.org/hudson/job/build.cmpn/lastSuccessfulBuild/artifact/osgi.specs/generated/html/cmpn/service.configurator.html).

## Project Setup For SNAPSHOT Archetypes

<div class="alert alert-warning">
  Maven automatically searches for archetypes in the Maven Central repository, but it will not discover archetypes from other repositories without additional configuration. This section describes the configuration necessary to use the OSGi enRoute SNAPSHOT archetypes. It is not necessary for enRoute archetypes with release versions.
</div>

To prepare for the tutorials paste the following Maven project skeleton to a file named `settings.xml` in your project root directory.

<p>
  <a class="btn btn-primary" data-toggle="collapse" href="#collapseExample" aria-expanded="false" aria-controls="collapseExample">
    settings.xml 
  </a>
</p>
<div class="collapse" id="collapseExample">
  <div class="card card-block">

{% highlight html %}
    <settings>
      <profiles>
        <profile>
          <id>OSGi</id>
          <activation>
            <activeByDefault>true</activeByDefault>
          </activation>
          <repositories>
            <repository>
              <id>osgi-archetype</id>
              <url>https://oss.sonatype.org/content/groups/osgi</url>
              <releases>
                <enabled>true</enabled>
                <checksumPolicy>fail</checksumPolicy>
              </releases>
              <snapshots>
                <enabled>true</enabled>
                <checksumPolicy>warn</checksumPolicy>
              </snapshots>
            </repository>
          </repositories>
        </profile>
      </profiles>
    </settings>
{% endhighlight %}

  </div>
</div>
