---
title: Maven with the Bndtools Bundle Plugin
summary: A description of how to use Maven with the bnd Maven plugin
---

> bnd-maven-plugin under review

**Please note that the bnd-maven-plugin is currently under review (refer
<https://github.com/bndtools/bnd/issues/629> and
<https://github.com/bndtools/bndtools/wiki/Maven-Integration-Requirements>)
so some of the links in this page are no longer reachable.**

The toolchain described on this page is suitable for creating standard
OSGi bundles. [Bndtools](http://bndtools.org/) is a plugin for the
Eclipse IDE that provides a rich OSGi development experience. Bndtools
builds on a headless [Bnd](http://bnd.bndtools.org) tool which is
the 'Swiss Army Knife for OSGi'. The
[bnd-maven-plugin](https://github.com/bndtools/bnd/tree/master/bnd-maven-plugin-parent)
is a maven plugin which makes it possible to execute bndtools builds
using maven. This documentation is based on version 2.3 of Bndtools, the
bnd-maven-plugin version 1.0.2 and Eclipse 4.4.x.

The example project used in this description is available [here in
github](https://github.com/bosschaert/coderthoughts/tree/master/bnd-maven-plugin-projects/OSGiBundleProject).

Getting Started with Bndtools
-----------------------------

To get started with Bndtools, simply launch Eclipse and install Bndtools
from the Eclipse Marketplace. If you don't have the Eclipse Marketplace
in your Eclipse Help menu it can easily be added by going to Help -\>
Install New Software and selecting the Marketplace Client there.

Creating the project in Eclipse
-------------------------------

As Bndtools is an IDE-based tool, this tutorial starts with creating the
relevant projects in Eclipse. A headless build is added as a second
step.

Start by creating a Bndtools OSGi Project in Eclipse:

![](NewProject2.png "NewProject2.png")

Name the project `OSGiBundleProject` and select ***maven*** project
layout in the project creation wizard. Select *Empty Project* in the
template selection dialog. Then click **Next** and **Finish**.

If this is your first Bndtools project in the Eclipse workspace you will
be asked to create a Bndtools configuration project:

![](CreateCnf.png "CreateCnf.png")

Accept the defaults as above and **Next** and **Finish**.

Your Eclipse workspace is now configurated for developing OSGi bundles
with Bndtools.

### Add a Bundle Activator

Let's add a Bundle Activator to the bundle. As the bundle activator
implements the OSGi `BundleActivator` interface, put the `osgi.core`
bundle on the build path in the `bnd.bnd` file:

![](BuildPathCore.png "BuildPathCore.png")

Next create a Bundle Activator class:

![](Activator.png "Activator.png")

And declare it in the `bnd.bnd` file. Also make sure to add the package
of the Bundle Activator class to the Private Packages section. Packages
in the project are only included in the bundle if they are either in the
Private Packages section or in the Export Packages section.

![](BndFile.png "BndFile.png")

Also note that Bndtools has automatically calculated the imports for
this bundle.

### Maven Project Layout

As we selected a maven project layout, you can see that the source code
for the project is placed in the `src/main/java` location and the
resulting bundle is created in the `target` directory, following Maven
conventions for these locations.

**Note:** to follow Maven conventions for the version and output file
add the following line to the `bnd.bnd` file:

`  Bundle-Version: 1.0.0.SNAPSHOT`  
`  -outputmask = ${@bsn}-${version;===S;${@version}}.jar`

In the future this will be done automatically. Note that
`1.0.0.SNAPSHOT` automatically gets translated into `1.0.0-SNAPSHOT` for
Maven. This is done by the `outputmask` instruction.

### Run the bundle inside Bndtools/Eclipse

To run the bundle inside Eclipse, go to the ***Run*** tab in the
`bnd.bnd` editor. Select an OSGi Framework and click the **Run OSGi**
button.

![](RunInBndtools.png "RunInBndtools.png")

Building from the command line using Maven
------------------------------------------

The `bnd-maven-plugin` can build Bndtools projects from within Maven.
The idea is that the build is done *exactly* like Bndtools builds the
project, therefore the `bnd-maven-plugin` uses the Bndtools dependencies
to build the project and not the standard maven dependencies.

**Note**: to build an OSGi bundle using normal Maven dependencies, use
the Felix maven-bundle-plugin, [as described
here](MavenFelixBundlePluginEclipseToolchain "wikilink").

### Create the `pom.xml`

To build the project from Maven, a minimal `pom.xml` file is needed. As
the building is controlled from the Bndtools metadata in the `bnd.bnd`
file, most of the information can be omitted from the pom.

The `pom.xml` must provide the minimal information to be a valid pom.
This means that groupId, artifactId and version need to be specified. In
addition the packaging needs to be set to **bundle**. Finally, the
`bnd-maven-plugin` needs to be added to the list of plugins in order for
it to participate in the build.

`<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"`  
`  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">`  
`  <modelVersion>4.0.0</modelVersion>`  
``  
`  <groupId>org.foo.bar</groupId>`  
`  <artifactId>OSGiBundleProject</artifactId>`  
`  <version>1.0.0-SNAPSHOT</version>`  
`  <packaging>bundle</packaging>`  
``  
`  <build>`  
`    <plugins>`  
`      <plugin>`  
`        <groupId>biz.aQute.bnd</groupId>`  
`        <artifactId>bnd-maven-plugin</artifactId>`  
`        <version>1.0.2</version>`  
`        <extensions>true</extensions>`  
`      </plugin>`  
`    </plugins>`  
`  </build>`  
`</project>`

### Execute the Build

Simply execute `mvn install` to execute the Maven build:

`OSGiBundleProject $ mvn install`  
`[INFO] Scanning for projects...`  
`[INFO] + /Users/David/apps/eclipse44RC3/eclipse/workspace/OSGiBundleProject`  
`[INFO]`  
`[INFO] ------------------------------------------------------------------------`  
`[INFO] Building OSGiBundleProject 1.0.0-SNAPSHOT`  
`[INFO] ------------------------------------------------------------------------`  
`   ... lots of output ...`  
`[INFO] ------------------------------------------------------------------------`  
`[INFO] BUILD SUCCESS`  
`[INFO] ------------------------------------------------------------------------`  
`[INFO] Total time: 5.207s`  
`[INFO] Finished at: Sat Jun 07 20:48:43 IST 2014`  
`[INFO] Final Memory: 19M/310M`  
`[INFO] ------------------------------------------------------------------------`

### More advanced examples

More advanced samples can be found in the bnd-maven-plugin source
repository. Documentation [can be found
here](https://github.com/bndtools/bnd/blob/master/bnd-maven-plugin-parent/README.md)
and the [actual samples are
here](https://github.com/bndtools/bnd/tree/master/bnd-maven-plugin-parent/samples/sample-projects).

Note
----

The `bnd-maven-plugin` is a relatively new plugin. If you find any
issues feel free to [submit them
here](https://github.com/bndtools/bnd/issues?labels=bnd-maven-plugin).
Patches are also welcome!

Additional information on the `bnd-maven-plugin` can be found on this
blog:
[<http://coderthoughts.blogspot.com/2014/05/running-bndtools-osgi-builds-with-maven.html>](http://coderthoughts.blogspot.com/2014/05/running-bndtools-osgi-builds-with-maven.html)

