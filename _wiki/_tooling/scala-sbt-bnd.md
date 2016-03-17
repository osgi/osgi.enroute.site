---
title: Scala SBT with bnd Toolchain
summary: A Scala based (sbt with the sbt bnd Plugin) toolchain for building Scala based OSGi bundles
---

This page describes a Scala based (sbt with the sbt bnd Plugin)
toolchain for building Scala based OSGi bundles.

Purpose
-------

In the Scala domain sbt ([simple build tool](http://www.scala-sbt.org))
is the most common build tooling. You could also use sbt for building
non Scala based projects e.g. Java projects.

The demo hello project consist of one bundle. The following aspects will
be shown by using this demo:

-   How to build a bundle in the command line with sbt
-   How the Scala language could be use to write Code based on the OSGi
    APIs e.g. BundleActivator
-   How to define in the sbt osgi plugin the export, private and how to
    modify the calculated import packages
-   Use Conditional-Package feature of bnd to embed the scala packages
    in the bundle
-   Create DS components with the bnd annotations

The example project used in this description is available [here in
github](https://github.com/tux2323/sbt-osgi-demo).

sbt Project Layout
------------------

A sbt project has a similar default project layout then a maven project.
The project layout of the demo hello project is:

-   hello
    -   src/main/scala
    -   libs
    -   project
        -   plugins.sbt
    -   target
    -   build.sbt

The folder *src/main/scala* contains two scala source files in a
subfolder which is called *demo*. In the hello demo there are two scala
files, which are named *Implementation* and *Interfaces*. The
*Implementation* source file contains some sample Scala classes which
are grouped to the package *demo.internal*. The source file with the
name *Interfaces* contains a trait, a trait is similar to a Java
interface. The interfaces are grouped in the package *demo.api*. A Scala
project can be divided in any source files name you like, the names must
not be the same then the class names.

The demo source of the *Interfaces* source file is shown bellow:

    package demo.api

    trait Printer {
      def print(msg : String)
    }

The demo source of the *Implementation* source file is shown bellow:

    package demo.internal

    import org.osgi.framework._
    import aQute.bnd.annotation.component._
    import aQute.bnd.annotation.component._

    import demo.api.Printer

    class SysoutPrinter extends Printer {

      def print(text : String) = println(text)

    }

    // Bundle Activator Demo class
    class Activator extends BundleActivator {

      val printer = new SysoutPrinter()

      override def start(context: BundleContext) {
        printer.print("Start OSGi Bundle")
      }

      override def stop(context: BundleContext) {
        printer.print("Stop OSGi Bundle")
      }

    }

    // DS Annotation Demo
    @Component
    class DeclarativeServicePrinter extends Printer {
        
        val printer = new SysoutPrinter()
      
        def print(text : String) = printer.print(text)
      
    }

    @Component
    class Client {
      
      var printer : Printer = null
      
      @Reference
      def setPrinter(printer : Printer) = this.printer = printer
      
      def unsetPrinter(printer : Printer) = this.printer = null
      
      @Activate
      def start = printer.print("Start DS Client Component")
      
      @Deactivate
      def stop = printer.print("Stop DS Client Component")
      
    }

sbt OSGi Plugin
---------------

To build OSGi bundles with sbt the [sbt OSGi
plugin](https://github.com/sbt/sbt-osgi) is provided which integrates
bnd . The plugin (version 0.4.0) integrates bnd version 1.50.0 into sbt.
The OSGi plugin must be declared in the project settings which are
defined in the project folder in the file *plugins.sbt*. To add OSGi
support add the following plugin declaration in the file
*project/plugins.sbt*.

    addSbtPlugin("com.typesafe.sbt" % "sbt-osgi" % "0.4.0")

Export, Import and Private Packages
-----------------------------------

The setting for bnd must be defined in the build configuration file
which is in the root folder of the project and is named *build.sbt*. To
define export and private packages and modify the calculated import
packages , the following properties could be used:

    osgiSettings

    OsgiKeys.exportPackage := Seq("demo.api")

    OsgiKeys.privatePackage := Seq("demo.internal")
    ''Italic text''
    OsgiKeys.importPackage := Seq(
        "sun.misc;resolution:=optional",
        "!aQute.bnd.annotation.*", 
        "*"
    )

Bundle Activator
----------------

To define a bundle activator the property *OsgiKeys.bundleActivator*
could be used in the *build.sbt* configuration file.

    osgiSettings

    OsgiKeys.bundleActivator := Option("demo.internal.Activator")

sbt Command-line Build
----------------------

To build the OSGi bundle invoke *sbt osgi-bundle*. The hello demo bundle
is build to the *scala-2.9.2* target folder. The sbt OSGi plugin could
also be invoked form the sbt console. The sbt build tool supports
incremental build which could also be used to build a OSGi bundle. For
the incremental build invoke *sbt \~osgi-bundle*. Then the bundle build
is triggered on each file change in the sbt project.

Import the Project into Eclipse
-------------------------------

The project can be imported into eclipse by the sbt eclipse plugin. To
get the eclipse settings for the project invoke *sbt eclipse*. Now the
project could be imported into eclipse. But the bundle could only be
build by invoking sbt from the command line. At the moment there is no
eclipse sbt integration in the eclipse scala IDE.

Note that to be able to run the eclipse plugin, you need the following
present in your *project/plugins.sbt*:

    addSbtPlugin("com.typesafe.sbteclipse" % "sbteclipse-plugin" % "2.1.0")

Declarative Service Annotation
------------------------------

To generate the DS XML descriptor files by the bnd annotation, add the
*Service-Component* header to the map of additionalHeaders to the
*build.sbt* configuration file.

    OsgiKeys.additionalHeaders := Map(
        "Service-Component" -> "*"
    )

Scala Package and Conditional-Package
-------------------------------------

Scala classes depends on the scala and scala.reflect package. If the
scala runtime library should not be provided as bundle in the OSGi
appliaction this packages could be embedded in the bundle. There for the
bnd feature *Conditional-Package* could be used. *Conditional-Package*
is like static linking in C for OSGi bundles.

The entire OSGi settings for the hello project are these:

    osgiSettings

    OsgiKeys.exportPackage := Seq("demo.api")

    OsgiKeys.privatePackage := Seq("demo.internal")

    OsgiKeys.importPackage := Seq(
        "sun.misc;resolution:=optional",
        "!aQute.bnd.annotation.*", 
        "*"
    )

    OsgiKeys.bundleActivator := Option("demo.internal.Activator")

    OsgiKeys.additionalHeaders := Map(
        "Service-Component" -> "*",
        "Conditional-Package" -> "scala.*"
    )
