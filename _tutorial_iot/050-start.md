---
title: IoT Tutorial
layout: tutorial
lprev: /tutorial_base/050-start.html
lnext: /tutorial_rsa/050-start.html
noindex: true
---
![Thumbnail for IoT Tutorial](/img/tutorial_iot/exploring-led-breadboard-1.png)
{: .thumb200-l }

The Internet of Things ... a concept that has as many definitions as there are things you can connect to the Internet. However, most definitions place an emphasis on the _edge devices_ and the _gateways_, which is of course right in the realm that was the raison d'être of OSGi already so long ago.

This tutorial uses OSGi enRoute to develop an application for a [Raspberry Pi][pi]. The Raspberry Pi is a formidable machine that would put many laptops to shame a few years ago. The OS is Linux and it has lots of inputs and outputs. For OSGi enRoute, we've developed a number of bundles that allow you to play with the Raspberry. This tutorial will explain how to get started with the Raspberry Pi and then show how to do interesting things.

A disclaimer. This tutorial is about learning to use OSGi enRoute, not about learning Java, Git, Eclipse, nor the Raspberry Pi setup details. It is assumed that you have basic experience with these tools.

If you have any questions about this tutorial, please discuss them in the [forum][forum]. And as always, [pull requests][osgi.enroute.site] are highly appreciated.

## Sections

<div>
<ol>

{% for t in site.tutorial_iot %}{%unless t.noindex%}<li><a href="{{t.url}}">{{t.title}}</a> – {{t.summary}}</li>
{%endunless%}{% endfor %}

</ol>
</div>


## End

So, you've finished this tutorial! What's next?

Well, first, since we're still in beta, we'd love feedback. Our most favorite feedback is a pull request on the documentation. As an early user you must have run into some rough edges, outright stupidities, or you had a brilliant idea. Just go to the [OSGi enRoute][osgi.enroute.site] repository on Github. Clone it in your own account, make your changes or additions, and send a pull request. We, and others like you, highly appreciate these kind of contributions.

After you've done this tutorial you should have a basic feeling of how to build an application with  OSGi enRoute. So the best way to continue learning is to build a small application based on these principles. Running into real problems is the best way to learn a technology. If you run into problems, use the [Forum][forum] to ask questions and get answers.

And watch this space, we will expand this site with hundreds of data sheets of services you can find on the net. These data-sheets will show you how to use this service in your application with real examples. 

[forum]: /forum.html
[pi]: https://www.raspberrypi.org/
[osgi.enroute.site]: https://github.com/osgi/osgi.enroute.site
