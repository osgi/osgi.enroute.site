---
title: Base Tutorial
layout: tutorial
lprev: /qs/050-start.html
lnext: /tutorial_iot/050-start.html
version: 2.0.0
noindex: true
---

![Thumbnail for Base Tutorial](/img/tutorial_base/debug-xray-1.png)
{: .thumb200-l }

In this tutorial we develop a little project that creates a simple server application that interacts with an OSGi console shell. 

A disclaimer. This tutorial is about learning to use OSGi enRoute, not about learning Java, Git, nor Eclipse. It is assumed that you have basic experience with these tools.

If you have any questions about this tutorial, please discuss them in the [forum][forum].

{: style='clear:both;' }

## Sections

<div>
<ol>

{% for t in site.tutorial_base %}{%unless t.noindex %}<li><a href="{{t.url}}">{{t.title}}</a> – {{t.summary}}</li>
{%endunless%}{% endfor %}

</ol>
</div>


## End

So, you've finished this tutorial! What's next?

Well, first, since we're still in beta, we'd love feedback. Our most favorite feedback is a pull request on the documentation. As an early user you must have run into some rough edges, outright stupidities, or you had a brilliant idea. Just go to the [OSGi enRoute][enroute-doc] repository on Github. Clone it in your own account, make your changes or additions, and send a pull request. We, and others like you, highly appreciate these kind of contributions.

After you've done this tutorial you should have a basic feeling of how to build an application with  OSGi enRoute. So the best way to continue learning is to build a small application based on these principles. Running into real problems is the best way to learn a technology. If you run into problems, use the [Forum][forum] to ask questions and get answers.

And watch this space, we will expand this site with hundreds of data sheets of services you can find on the net. These data-sheets will show you how to use this service in your application with real examples. 

  

[forum]: /forum.html
[enroute-doc]: https://github.com/osgi/osgi.enroute.site

