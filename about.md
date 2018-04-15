---
layout: toc-page
title: About 
description: About enRoute 
permalink: /About/
order: 0 
author: enRoute@paremus.com
sponsor: OSGi™ Alliance 
---

## What is enRoute?
enRoute is intended to provide a gentle, hands-on introduction to those who wish to start building modular systems. 

* enRoute enables the quick and simple creation of stand-alone OSGi applications:
    * Providing basic guidance for using R7 specifications
    * Providing a simple set of dependencies for using OSGi R7 Reference Implementations
* enRoute takes an opinionated approach focusing on: 
    * Declarative Services (DS)
    * A Maven based toolchain
* All enRoute examples are based on the latest OSGi R7 Specifications and Reference Implementations.

enRoute is not intended to be an encyclopedia for experienced OSGi developers, nor is enRoute aligned with any particular open source initiative. enRoute is intended to be a useful toolbox, and to give a solid understanding of the basics of OSGi.

## More information

<hr>
<style>
table, td, th {    
    text-align: left;
}

table {
    width: 100%;
}

th {
    padding: 15px;
    color: Black;
}
td {
    padding 10px;
    color: Black;
}
</style>
<table>
        <colgroup>
                <col style="width:30%">
                <col style="width:70%">
        </colgroup>
{% for f in site.about %}{%unless f.noindex%}<tr>
        <td><a href="{{f.url}}">{{f.title}}</a></td><td> {{f.summary}}</td>
</tr>
{%endunless%}{% endfor %}

</table>


---
