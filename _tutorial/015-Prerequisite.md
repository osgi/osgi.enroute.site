---
title: Prerequisites 
layout: toc-guide-page
lprev: 032-tutorial_microservice-jpa.html 
lnext: 020-tutorial_qs.html 
summary: Prerequisites and configurations required for running these tutorials.
author: enRoute@paremus.com
sponsor: OSGi™ Alliance 
---

Before you start any of the tutorials you must prepare your environment so that the right tools are installed. This page helps you to achieve this. 

## Required Tools

We need to run the following tools on your computer - without them you won't get very far at all.

* [Java][java17], probably already got it? If not, this is a good time to get started! OSGi enRoute projects target Java 17 as a minimum version.
* [Maven][Maven], a popular build tool for Java applications with an enormous repository behind it. Make sure that you're on at least 3.3.9

<div class="alert alert-warning">
The creators of Java made some breaking changes in Java 9, and these affect lots of Java programs including the OSGi enRoute examples! OSGi enRoute knows how to cope with these changes, but only if it knows where it will be running. It is therefore important that you put the correct target Java version in your `bndrun` files. Don't worry, we'll give you a reminder when describing any places that are affected.
</div>

### Project Setup for SNAPSHOT Archetypes

If you're using enRoute for the first time, or just want to use the released archetypes then don't worry about this section.
{: .note }

Maven automatically searches for archetypes in the Maven Central repository, but it will not discover archetypes from other repositories without additional configuration. The released OSGi enRoute archetypes and indexes can therefore be used easily, but some extra work is required if you want to use SNAPSHOT versions.

To complete the tutorials with a SNAPSHOT version of the enRoute archetypes paste the following Maven project skeleton to a file named `settings.xml` in your project root directory.

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

Whenever you want to use the SNAPSHOT archetypes you must then reference this settings.xml file by using `mvn -s settings.xml ...`


## Useful Tools

These tools aren't strictly required but we think that they'll improve your experience of using the tutorials, and that they'll help you in starting your own projects.

* [Eclipse][mars], A powerful, flexible IDE for Java if you do not know which variant you want then pick the _Eclipse Standard_ variant. Make sure that you use version _Mars_ or higher.
* [Bndtools][bndtools] A plugin for Eclipse that adds IDE support for OSGi development. This includes automatically building your projects and nice editors for bnd metadata. Make sure that you have at least Bndtools 4.1.0 as enRoute makes use of lots of new OSGi features!
* [Git][git], Eclipse does include git support through EGit, but when it comes to git nothing really beats the good old command line.


### Installing Bndtools

You can install Bndtools 4.1.0.REL or higher directly from the Eclipse market place.

Alternatively you can install the Bndtools development snapshot directly from an update site using the instructions at:

        http://bndtools.org/installation.html#nonstandard_versions
        
### Using Eclipse Archetype Generation

Eclipse M2E provides support for Maven within Eclipse. Broadly speaking it is very good at this job, but its Archetype support can be a bit buggy at times. It is therefore recommended to use the command line to generate your projects. If you do want to use Eclipse then you'll need to add an archetype repository to your Eclipse workspace (Eclipse doesn't search Maven Central by default).

Open `Preferences / Maven / Archetypes / Add Remote Catalog...`

At this point you have a choice, you can either add the OSGi enRoute archetypes from the Maven Central Catalog (the default remote for the command line) or from the Sonatype OSGi repository. 

 * Maven Central: `https://repo.maven.apache.org/maven2/`
 * Sonatype OSGi: `https://oss.sonatype.org/content/groups/osgi`
 
Maven Central is the official location for released archetypes and so it contains several thousand of them. This means that it is much easier to find the correct archetype when using the Sonatype OSGi repository as it only contains the archetypes published by the OSGi Alliance. We'll leave the decision about which URL to use up to you.

## Conventions

Whenever you see a text like `File/Open` we hope you treat it as a menu path. That is, go to the menu bar, click on `File`, then select `Open`. If the menu path starts with @/ then it is from the context menu on the selected object, which has then been clearly defined in the previous sentence.

## OS Specific Issues

Since this part is rather sensitive to the operating system you're using, we have split it in different sections for each of the major operating systems.

* [Windows](#windows)
* [MacOS](#macos)
* [*nix](#unix)

### Windows

In the enRoute tutorials file paths are always indicated using the forward slash or solidus ('`/`') as is customary on *nix like systems. The reason is that bnd, since its files are portable, always uses relative addressing from the workspace and adopted the forward slash. For most developers mapping these paths to Windows should be straightforward.

The only addressing outside the workspace is to the user's home directory, the user's home directory is indicated by a path that starts with a tilde and a slash ('`~/`'). This maps to the path indicated in Java's `user.home` System property.

Some commands in this tutorial use line continuation symbols so that parameters can be differentiated and for ease of reading. The standard character used in this tutorial is the same one used by *nix like systems, the back slash ('`\`'). Be sure to remove these or replace them with the Windows equivalent symbol when running commands in your Windows command line shell (non-bash like shell).

Make sure you have a good command line shell available. If you're familiar with one, keep it. If command lines are uncomfortable for you, you might want to use [Git for Windows][gitforwindows] which includes a bash like shell. Though virtually all work in OSGi enRoute can be done through an IDE, the tutorials use a *shell first* approach so that you can choose the IDE you want to use.

### MacOS

If you start using enRoute you will likely create a number of workspaces. There is a very handy multi-workspace launcher plugin from Torkild U. Resheim that makes it easy to open multiple workspaces.

> [OS X Eclipse Launcher Utility](http://marketplace.eclipse.org/content/osx-eclipse-launcher)

### Unix

We aren't currently aware of any challenges on Unix systems. Please [let us know](mailto:osgi-users@eclipse.org) if you have any!

[java17]: https://adoptium.net/de/temurin/releases/?version=17
[Maven]: https://maven.apache.org
[mars]: https://www.eclipse.org/downloads/
[bndtools]: http://bndtools.org
[git]: http://git-scm.com/book/en/Getting-Started-Installing-Git
[gitforwindows]: http://msysgit.github.io

