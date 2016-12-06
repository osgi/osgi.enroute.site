Before you start any of the tutorials you must prepare your environment so that the right tools are installed. This page helps you to achieve this. We need to run the following tools on your computer:

* [Java 8][java8], probably already got it? If not, this is a good time to get started!
* [Eclipse Mars][mars], if you do not know which variant, pick the _Eclipse Standard_ variant
* [Git][git], unfortunately the built-in EGit in Eclipse needs some good old command line help


## Installing bndtools

You can install bndtools from the Eclipse market place, make sure you got version 3.3.0 or later. 
You can also install bndtools directly from the update site:

	https://dl.bintray.com/bndtools/bndtools/3.3.0

If we update bndtools with a stable release then we will place it here:

	https://dl.bintray.com/bndtools/bndtools/latest

You can find the details how to install bndtools on the [bndtools website](http://bndtools.org/installation.html#update-site)

Do not install the development version since it is currently incompatible with the tutorials.
{: .note }

## Conventions

Whenever you see a text like `File/Open` we hope you treat it as a menu path. That is, go to the menu bar, click on `File`, then select `Open`. If the menu path starts with @/ then it is from the context menu on the selected object, which has then been clearly defined in the previous sentence.

## OS Specific Issues

Since this part is rather sensitive to the operating system you're using, we have split it in different sections for each of the major operating systems.

* [Windows](#windows)
* [MacOS](#macos)
* [*nix](#unix)


### Windows

In the enRoute tutorials file paths are always indicated using the forward slash or solidus ('/') as is customary on *nix like systems. The reason is that bnd, since its files are portable, always uses relative addressing from the workspace and adopted the forward slash. For most developers mapping these paths to Windows should be straightforward.

The only addressing outside the workspace is to the user's home directory, the user's home directory is indicated by a path that starts with a tilde and a slash ('~/'). This maps to the path indicated in Java's `user.home` System property.  

Make sure you have a good command line shell available. If you're familiar with one, keep it. If command lines are uncomfortable for you, you might want to use [Git for Windows][gitforwindows] which includes a bash like shell. Though virtually all work in OSGi enRoute is done through Eclipse, there are some crucial elements where the shell is just much nicer.  

### MacOS

If you start using enRoute you will likely create a number of workspaces. There is a very handy utility plugin for Eclipse on MacOS that shows you which workspace is which icon in the task bar:

> [http://njbartlett.name/2011/10/09/workspace-mac-badge.html](http://njbartlett.name/2011/10/09/workspace-mac-badge.html)

There is also multi-workspace launcher plugin from Torkild U. Resheim that incorporates Neil Bartlett's task bar badge (above).

> [OS X Eclipse Launcher Utility](http://marketplace.eclipse.org/content/osx-eclipse-launcher)


[java8]: http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html
[mars]: https://www.eclipse.org/downloads/
[git]: http://git-scm.com/book/en/Getting-Started-Installing-Git
[gitforwindows]: http://msysgit.github.io
