---
layout: toc-page
title: About 
description: About enRoute 
permalink: /About/
order: 0 
author: enRoute@paremus.com
sponsor: OSGi™ Alliance 
---


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
{% for f in site.about %}{%unless f.noindex%}<tr>
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
<br>
