---
layout: toc-page
title: FAQ 
description: Frequently asked Questions 
permalink: /FAQ/
order: 4
author: enRoute@paremus.com
sponsor: OSGi™ Alliance 
---

This section provides a brief introduction to OSGi, enRoute and important core concepts. 

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
<table>
        <colgroup>
                <col style="width:30%">
                <col style="width:70%">
        </colgroup>
{% for f in site.FAQ %}{%unless f.noindex%}<tr>
        <td><a href="{{f.url}}">{{f.title}}</a></td><td> {{f.summary}}</td>
</tr>
{%endunless%}{% endfor %}

</table>


---
