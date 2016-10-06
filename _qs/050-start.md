---
title: Quick Start Tutorial
layout: tutorial
lprev: /book/150-tutorials.html
lnext: /tutorial_base/050-start.html
version: 2.0.0-SNAPSHOT
noindex: true
---

![Thumbnail for Quickstart Tutorial](/img/qs/app-0.png)
{: .thumb200-l }

In this quick start we develop a little project that, creates a single page web-application.

This tutorial is light on the explanations because it focuses on introducing the overall architecture of enRoute, not the details. Over time this site will be filled with tutorials and documentation (or references to those) that will explain the minute details. This however, is about some big steps.

We will cover the whole chain, from creating a workspace all the way to continuous integration.

A disclaimer. This quick start is about learning to use OSGi enRoute, not about learning Java, Git, nor Eclipse. It is assumed that you have basic experience with these tools.

If you have any questions about this quick-start, please discuss them in the [forum][forum].

## Sections

<div>
<ol>

{% for qs in site.qs %}{%unless qs.noindex%}<li><a href="{{qs.url}}">{{qs.title}}</a> – {{qs.summary}}</li>
{%endunless%}{% endfor %}

</ol>
</div>


## End

So, you've finished this tutorial! What's next?

Well, first, since we're still in beta, we'd love feedback. Our most favorite feedback is a pull request on the documentation. As an early user you must have run into some rough edges, outright stupidities, or you had a brilliant idea. Just go to the [OSGi enRoute][enroute-doc] repository on Github. Clone it in your own account, make your changes or additions, and send a pull request. We, and others like you, highly appreciate these kind of contributions.

This tutorial is only a quick start, we've not explained a lot and just tried to get you on a starting level as soon as possible. To get more background, we highly recommend doing the [Base Tutorial](220-tutorial-base.html). This tutorial follows the same route but shows how to design with service, the cornerstone of OSGi enRoute.

You then might want to read the [Service Oriented Systems](215-sos.html) chapter how to build Service Oriented Systems.

However, running into real problems is the best way to learn a technology. If you run into problems, use the [Forum][forum] to ask questions and get answers.

And watch this space, we will expand this site with hundreds data sheets of services you can find on the net. These data-sheets will show you how to use this service in your application with real examples. 

[forum]: /forum.html
[enroute-doc]: https://github.com/osgi/osgi.enroute.site
