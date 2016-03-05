---
title: Distributed OSGi Tutorial
layout: tutorial
summary: Develops a Chat application using Distributed OSGi
lprev: /tutorial_iot/050-start.html
lnext: /qs/050-start.html
noindex: true
---

![Thumbnail for IoT Tutorial](/img/tutorial_rsa/rsa-service-0.png)
{: .thumb200-l }

This tutorial takes you through the steps to build a trivial Chat application using distributed OSGi. We first build a service API for a Chat client and use this API in an implementation. Then we add a command to test the implementation. After this works, we run a Zookeeper server from Bndtools. This Zookeeper server is used by the Amdatu Distributed OSGi implementation to distribute the Chat services. To finish it off, we create a client in the browser. 

A disclaimer. This tutorial is about learning to use OSGi enRoute, not about learning Java, Git, Eclipse, nor the Raspberry Pi setup details. It is assumed that you have basic experience with these tools.

If you have any questions about this tutorial, please discuss them in the [forum][forum]. And as always, [pull requests][osgi.enroute.site] are highly appreciated.

## Sections

<div>
<ol>

{% for t in site.tutorial_rsa %}{%unless t.noindex%}<li><a href="{{t.url}}">{{t.title}}</a> – {{t.summary}}</li>
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
