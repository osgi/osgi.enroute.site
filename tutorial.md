---
layout: toc-page
title: Tutorials 
description: Tutorials 
permalink: /Tutorial/
order: 1
author: enRoute@paremus.com
sponsor: OSGi™ Alliance 
---

These tutorials are step by step recipes which focus on creating, running and modifying an OSGi application. We start with the simple `Quick Start` introduction, and then move on to  develop a more sophisticated three-tier Microservices applicaton. The tutorials aim to be quick to complete and describe actions rather than background detail. If you want a little more information about the application you're making and what enRoute is providing then the  [Examples](/Examples/) and [About](/About/) pages are good places to start.

A basic familiarity with Java, Git, Eclipse and Maven is assumed. The approximate time required to complete each tutorial is indicated in each tutorial's description.

<br>
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

<div>
<table>

{% for tutorial in site.tutorial %}<tr><td><a href="{{tutorial.url}}">{{tutorial.title}}</a></td><td>{{tutorial.summary}}</td></tr>
{% endfor %}

</table>
</div>


---
