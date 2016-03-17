---
title: App Notes
layout: book
---
Application notes are documenting a design or a tool in a way that is useful for people that implement application. They often show how to do things with the whole system. 

People are urged to write up their experiences in an application note and submit this as a [PR on Github].

<table>

{% for f in site.appnotes %}{%unless f.noindex%}<tr>
	<td><a href="{{f.url}}">{{f.title}}</a></td><td> {{f.summary}}</td>
</tr>
{%endunless%}{% endfor %}

</table>

[PR on Github]: https://github.com/osgi/osgi.enroute.site/pulls