---
title: Getting Xcore to work in Bndtools
summary: How to make an Xcore project work within Bndtools, both via the UI and command line.
---

This [example project](https://github.com/CoastalHacking/xcore-bndtools-example) shows
how Xcore can work within Bndtools. It's divided into two sub-goals:

* Get Xcore to work via the Eclipse UI with Bndtools
* Get Xcore to work via Bnd Gradle Plugin on the command line

## Getting Xcore to Work via Eclipse UI

High level:

* Create and configure an Xcore project
* Add Xcore-related repositories and dependencies using Bndtools semantics
* Customize for Equinox runtime
* Compile and test the Xcore model

### Create and Configure Xcore Project

(Note: the example uses the project name and package name of `com.example.bndtools.xcore.model`.)

* Create a Bnd workspace based on the GitHub "bndtools/workspace" template
* Create a new project: "Bnd OSGi Project" &rarr; "OSGi Standard Templates" &rarr; "Component Development". Consider this the "Xcore project"
* Via context menu on above project, select "Configure" &rarr; "Convert to Xtext Project"
* Via context menu root project (which contains "cnf"), select "Configure" &rarr; "Convert to Gradle Project"
* Create the following basic Xcore model in the Xcore project, saved in the "model/Model.xcore" file. (Note: the "model" directory is not a source directory.)

```java
    @GenModel(
      bundleManifest="false",
      updateClasspath="false",
      modelDirectory="/com.example.bndtools.xcore.model/src",
      oSGiCompatible="true",
      forceOverwrite="true"
    )
    package com.example.bndtools.xcore.model
    
    class One
    {
      refers Two two opposite one 
    }
    
    class Two
    {
      refers One one opposite two
    }
```

### Add repositories and dependencies using bndtools semantics

* Resolve the Xcore dependencies (i.e. `@GenModel` annotation) by adding the following repositories to `build.bnd` cnf project:

```
    -plugin.5.Xtext: \
      aQute.bnd.repository.p2.provider.P2Repository; \
        url = http://download.eclipse.org/modeling/tmf/xtext/updates/releases/2.10.0/; \
        name = Xtext
    
    -plugin.6.EmfCore: \
      aQute.bnd.repository.p2.provider.P2Repository; \
        url = http://download.eclipse.org/modeling/emf/emf/updates/2.10.x/core/S201501230452/; \
        name = EmfCore
    
    -plugin.7.EmfBase: \
      aQute.bnd.repository.p2.provider.P2Repository; \
        url = http://download.eclipse.org/modeling/emf/emf/updates/2.10.x/base/S201501230348/; \
        name = EmfBase
    
    -plugin.8.EmfXcore: \
      aQute.bnd.repository.p2.provider.P2Repository; \
        url = http://download.eclipse.org/modeling/emf/emf/updates/2.10.x/xcore/R201502020452/; \
        name = EmfXcore
    
    # Downloads everything, will be slow
    # Currently only needed for the one JDT dependency 
    -plugin.9.Neon: \
      aQute.bnd.repository.p2.provider.P2Repository; \
        url = http://download.eclipse.org/eclipse/updates/4.6/R-4.6.1-201609071200/; \
        name = Neon
```

* Add the following build dependencies to the Xcore project's `bnd.bnd`:
  * `org.eclipse.emf.ecore`
  * `org.eclipse.xtext.xbase.lib`
  * `org.eclipse.emf.ecore.xcore.lib`
  * `org.eclipse.emf.common`
  * `org.eclipse.xtext.ecore`
  * `org.eclipse.emf.codegen.ecore.xtext`
  * `org.eclipse.emf.ecore.xcore`
  * `org.eclipse.xtext`
  * `org.eclipse.xtext.xbase`
  * `org.eclipse.emf.codegen.ecore`
  * `org.eclipse.jdt.core`

### Customize For Equinox Runtime

* Modify the Xcore `bnd.bnd` to include the following:

```
    # plugin.xml and its properties are needed
    # To generate these, edit and save Xcore model
    # Model not needed for runtime
    Include-Resource: plugin.xml, plugin.properties, OSGI-OPT/model=model
    
    # The bsn needs to specify the singleton attribute
    Bundle-SymbolicName: ${p};singleton:=true
```

* Export all of the auto-generated packages:

```
    # Mirrors what the auto-generated plugin.xml declares
    Export-Package: \
      com.example.bndtools.xcore.model,\
      com.example.bndtools.xcore.model.impl,\
      com.example.bndtools.xcore.model.util
```

### Compile and test the Xcore model

After saving `bnd.bnd`, which triggers a build, Xcore should auto-generate
the following source and related files:

* `src/com.example.bndtools.xcore.model.*` Java files
* `build.properties`
* `plugin.properties`
* `plugin.xml`

Note: Xcore shouldn't add any additional libraries to the Xcore project build path.

#### Unit Test

Refer to the [Testing the Provider with %28Standard%29 JUnit](/tutorial_base/340-junit.html)
section for background on unit testing in Bndtools.

* In the Xcore project, add the following to `test/com.example.bndtools.xcore.model/ExampleTest.java`:

```java
    @Test
    public void testXcore() {
      One one = ModelFactory.eINSTANCE.createOne();
      Two two = ModelFactory.eINSTANCE.createTwo();
      one.setTwo(two);
      assertEquals(one, two.getOne());
    }
```

Running the above as a standard JUnit test should successfully execute.

#### Integration Test

Refer to the [Testing in OSGi](/tutorial_base/600-testing.html) 
section for background on integration testing in bndtools.

By default, Xcore uses the package name of the model as the EMF namespace
URI (nsURI). Xcore registers this nsURI using the Equinox [Extension Registry](http://www.eclipse.org/equinox/bundles/),
declared in the Xcore project's `plugin.xml` file. The nsURI is registered in
the [EMF Package Registry](http://download.eclipse.org/modeling/emf/emf/javadoc/2.11/index.html?org/eclipse/emf/ecore/EPackage.Registry.html).

The integration test below queries the EMF Package Registry for the model's nsURI.
If found, it implies the bundle was able to register its extension point to
the Equinox Extension Registry and register the model's nsURI to the EMF Package Registry.

* Create a new project: "Bnd OSGi Project" &rarr; "OSGi Standard Templates" &rarr; "Integration Testing". Consider this the ITest project.
* Add the following to the Build Path in the ITest `bnd.bnd`:
  * `org.eclipse.emf.ecore`
  * `org.eclipse.emf.common`
  * `com.example.bndtools.xcore.model`
* Modify the following in the `bnd.bnd` Run configuration:
  * In the "Core Runtime" section:
    * "OSGi Framework": `org.eclipse.osgi`. Do not choose Felix since Equinox-specific extensions are used.
    * Execution Env: `JavaSE-1.8` or similar
  * In the "Run Requirements":
    * The model and test bundles
    * `org.eclipse.emf.ecore`
    * `org.eclipse.emf.common`
    * `org.eclipse.xtext.xbase.lib`
    * `org.eclipse.emf.ecore.xcore.lib`
    * `org.eclipse.core.resources`
  * Click on the "Resolve" button and save
* Add the following test to `/com.example.bndtools.xcore.test/src/com/example/bndtools/xcore/test/ExampleIntegrationTest.java`:

```java
    @Test
    public void shouldBeRegistered() {
      String nsURI = "com.example.bndtools.xcore.model";
      EPackage.Registry registry = EPackage.Registry.INSTANCE;
      EPackage ePackage = registry.getEPackage(nsURI);
      assertNotNull(ePackage);
    }
```
* Via the context menu on the ITest project, select "Run As" &rarr; "Bnd OSGi Test Launcher (JUnit)".

This should successfully execute.

## Get Xcore to work via Gradle on the command line

* Create "build.gradle"
* Build jar
* Add plugin as dependency

### Create "build.gradle"

Per the Bnd Gradle Plugin [README](https://github.com/bndtools/bnd/blob/master/biz.aQute.bnd.gradle/README.md#workspace):

> If special Gradle build behavior is needed, beyond changes to the project's `bnd.bnd`
> file, then you should place a `build.gradle` file in the root of the project
> and place your customizations in there.

* Create a new `build.gradle` file in the Xcore project with the following: 

```gradle
plugins {
    id 'org.xtext.builder' version '1.0.12'
}

// Needed for plugin repository
repositories {
    jcenter()
}

ext.xtextVersion = "2.10.0"

// Non-plugin dependencies managed via bnd.bnd
dependencies {
    compile "org.eclipse.xtext:org.eclipse.xtext:${xtextVersion}"
    compile "org.eclipse.xtext:org.eclipse.xtext.xbase:${xtextVersion}"
    compile 'org.eclipse.emf:org.eclipse.emf.ecore.xcore.lib:+'

    xtextLanguages 'org.eclipse.emf:org.eclipse.emf.ecore.xcore:+'
    xtextLanguages 'org.eclipse.emf:org.eclipse.emf.ecore.xcore.lib:+'
    xtextLanguages 'org.eclipse.emf:org.eclipse.emf.codegen.ecore:+'
    xtextLanguages 'org.eclipse.emf:org.eclipse.emf.codegen.ecore.xtext:+'
    xtextLanguages "org.eclipse.xtext:org.eclipse.xtext.ecore:${xtextVersion}"
    xtextLanguages 'org.eclipse.jdt:org.eclipse.jdt.core:+'
}

xtext {
    version = "${xtextVersion}"
    languages {
        ecore {
            setup = 'org.eclipse.xtext.ecore.EcoreSupport'
        }
        codegen {
            setup = 'org.eclipse.emf.codegen.ecore.xtext.GenModelSupport'
        }
        xcore {
            setup = 'org.eclipse.emf.ecore.xcore.XcoreStandaloneSetup'
            generator.outlet.producesJava = true
        }
    }
    sourceSets {
        main {
            srcDir 'model'
            // Move the generated Xcore output to the src directory
            output {
                dir(xtext.languages.xcore.generator.outlet, 'src')
            }
        }
    }
}
```

Notes on the above:

* The added repository section is needed for plugin dependency resolution
* The `compile` and `xtextLanguages` dependencies are managed via the Xcore project's `bnd.bnd` file
* The `srcDir 'model'` directive tells Xtext to use the `model` directory as its source directory
* The generated source output is moved to Bndtools's default source directory

### Build jar

The below uses [Buildship](https://projects.eclipse.org/projects/tools.buildship) to visually
control Gradle.

* Install Buildship
* Open "Gradle Executions" and "Gradle Tasks" views
* In "Gradle Tasks", select the Xcore project, "build" folder, "jar" task, execute it:

```
:com.example.bndtools.xcore.model:generateXtext
:com.example.bndtools.xcore.model:compileJava
:com.example.bndtools.xcore.model:processResources UP-TO-DATE
:com.example.bndtools.xcore.model:classes
:com.example.bndtools.xcore.model:jar

BUILD SUCCESSFUL

Total time: 14.425 secs
```

You should see something similar to the above.
