---
title: Tutorial to work with Maven Repositories
layout: tutorial
summary: Shows the steps to add a remote Maven repository to a bnd workspace
lprev: /book/150-tutorials
lnext: 100-prerequisites
noindex: true
---

![Maven Tutorial](/tutorial_maven/img/maven.gif)
{: .thumb200-l }

OSGi enRoute's toolchain is based on Gradle but it can actually interact with Maven quite well. It is possible to use artifacts from Maven repositories as well as publishing to Maven local or remote, release or snapshot repositories.

This tutorial takes you through the steps to use remote Maven repositories like Nexus and/or Artifactory. It shows you how to use artifacts from Maven Central as well as how to release locally  via snapshots and actual releases.

The example we're using is a bit warped because we're mixing development of Maven with the development of Bndtools. Though Bndtools is in general quite good in picking up the changes from other projects in the workspace, the Maven philosophy is quite different. In general you need to execute a command to build or install a project. For Bndtools users this can be quite confusing because they expect things to be updated automatically; Maven users will keep trying to launch a new build before they realize the jar has already been updated.

It is therefore not recommended to mix bnd and Maven projects in a single workspace for real world projects.

The result of this tutorial can be found on Github at [https://github.com/osgi/osgi.enroute.examples.maven](https://github.com/osgi/osgi.enroute.examples.maven).

A disclaimer. This tutorial is about learning to use Maven with OSGi enRoute, not about learning Java, Git, Eclipse, nor Maven basics. It is assumed that you have basic experience with these tools. It is also assumed you have at least done the [Quick Start Tutorial].

If you have any questions about this tutorial, please discuss them in the [forum][forum]. And as always, [pull requests][osgi.enroute.site] are highly appreciated.

## Sections

<div>
<ol>

{% for t in site.tutorial_maven %}{%unless t.noindex%}<li><a href="{{t.url}}">{{t.title}}</a> – {{t.summary}}</li>
{%endunless%}{% endfor %}

</ol>
</div>


## End

So, you've finished this tutorial! What's next?

We'd love some feedback. Our most favorite feedback is a pull request on the documentation. As an early user you must have run into some rough edges, outright stupidities, or you had a brilliant idea. Just go to the [OSGi enRoute][osgi.enroute.site] repository on Github. Clone it in your own account, make your changes or additions, and send a pull request. We, and others like you, highly appreciate these kind of contributions.

After you've done this tutorial you should have a basic feeling of how to build an application using Distributed OSGi with  OSGi enRoute. So the best way to continue learning is to build a small application based on these principles. Running into real problems is the best way to learn a technology. If you run into problems, use the [Forum][forum] to ask questions and get answers.

And watch this space, we will expand this site with hundreds of data sheets of services you can find on the net. These data-sheets will show you how to use this service in your application with real examples.

[forum]: /forum.html
[osgi.enroute.site]: https://github.com/osgi/osgi.enroute.site
[Quick Start Tutorial]: /qs/050-start
