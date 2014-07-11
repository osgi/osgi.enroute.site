---
title: Quick Start
summary: A quick-start guide to get engaged with OSGi enRoute. It shows how to quickly use the complete toolchain.
---

This repository represents a template workspace for bndtools, it is the easiest way to get started with OSGi enRoute. If you want to get started, go ahead

## Prerequisites

* [Java 8][2], probably already got it? If not, this is a good time to get started!
* [git][6], unlikely that you do not have it installed yet?
* [Eclipse Luna][3], if you do not know which variant, pick the _Eclipse Standard_ variant.
* Bndtools 2.4M1 or later, either from the [Eclipse Market Place][4] (available under Eclipse's Help for some reason) or you can be more adventurous and try out the latest and greatest at [cloudbees][1], you can install it also from the Eclipse `Help/Install New Software` menu.
* Optinally download [jpm][5] and install bnd with it (`sudo jpm install bnd@*`). This is the command line option of bnd that also runs in bndtools; it can be useful to diagnose issues and has a number of interesting commands.

## The 'I am just trying it out' Way

If you're just trying things out, then the easiest way is the following steps. However, this setup is not recommended for actual development, see later sections if you're interested why.

* Use git to clone this repository somewhere on your file system. Make sure the path to the repository does not contain spaces.
* Open Eclipse and select this folder as a workspace, then do `Import/Existing Projects` from this folder, which will only be the cnf project.
* You now have a working bndtools workspace. 
* You can follow the tutorials at [enroute.osgi.org][7]

## The 'I want to do it properly!' Way
In the simplistic setup 

## Creating the Workspaces

Ok, now we've loaded our toolbelt we get started. We have to create an Eclipse workspace folder and a bnd workspace folder. The reason they are different folders is that the Eclipse workspace folder contains personal preferences and other precious data that you do not want to share with others. This information is irrelevant for the build result (at least in bnd(tools)) but it can be precious to you. Since you do not want to share this information (not everybody loves your fancy color scheme you spent so many hours on perfecting) it should be stored separately from the bnd workspace, which does get shared with others. This also makes it easy to nuke a workspace back to its remote git state without accidentally killing your precious color schemes.

* Create a folder on a easy to remember place that will hold all your workspaces. Believe me, you will make quite a few over time and it is better to get organized from the beginning. Some hints for this folder's path:
  * Do not use spaces in the path name, many tools barf at spaces. 
  * Make the path from the root short, always nice to have shorter path names in the shell and also in Eclipse it prevents confusion.
  
  For example, `c:\Ws` or `/Ws`. We call this folder the `ws` folder from now on.
* In the `ws` folder create an Eclipse workspace. Some guidelines:
  * Match the name to the git repository
  * Do name the workspace with a really unique name, this makes it possible to share it with others. Also make sure to take advantage of the sorting order so that long lists remain readable. The reverse domain name is quite workable for this goal. 
  
  E.g. com.example.acme.prime.
* In the Eclipse workspace folder, clone this git repository into the folder `scm`:
      com.acme.prime$ git clone git@github.com:osgi/osgi.enroute.archetype.git scm
* If you do not want to use git, remove the `scm/.git` folder. Otherwise connect the `scm/.git` folder to your repository of choice. TBD



[1]: https://bndtools.ci.cloudbees.com/job/bndtools.master/lastSuccessfulBuild/artifact/build/generated/p2/
[2]: http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html
[3]: https://www.eclipse.org/downloads/
[4]: http://marketplace.eclipse.org/
[5]: http://jpm4j.org/#!/md/install
[6]: http://git-scm.com/book/en/Getting-Started-Installing-Git
[7]: http://enroute.osgi.org
