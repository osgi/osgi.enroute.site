---
layout: toc-page
title: Examples 
description: Examples 
permalink: /Examples/
order: 2
author: enRoute@paremus.com
sponsor: OSGi™ Alliance
---
enRoute examples illustrate the use of the more frequently used OSGi™ specifications. Additional examples will be added over time: requests, suggestions and contributions are most welcome.

All of the examples are available on Github, so clone the workspaces and play!

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
{% for f in site.examples %}{%unless f.noindex%}<tr>
        <td><a href="{{f.url}}">{{f.title}}</a></td><td> {{f.summary}}</td>
</tr>
{%endunless%}{% endfor %}

</table>


---
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
