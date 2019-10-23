---
layout: toc-page
title: Examples 
description: Examples 
permalink: /Examples/
order: 2
author: enRoute@paremus.com
sponsor: OSGi™ Alliance
---
enRoute examples illustrate the use of the enRoute indexes and [archetypes](../about/112-enRoute-Archetypes.html). They also demonstrate the more frequently used OSGi™ specifications. Additional examples will be added over time: requests, suggestions and contributions are most welcome.

All of the examples are available on Github, so clone the workspaces and play!

<div class="alert alert-warning">
When you clone the enRoute repository at <a href="https://github.com/osgi/osgi.enroute">https://github.com/osgi/osgi.enroute</a> you will be given the tip of the latest development snapshot. We work hard to keep the snapshots running smoothly, but in general we recommend that you use the latest release tag, currently <code>7.0.0</code>, as a stable base. To do this just type<code>git checkout 7.0.0</code>
</div>

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
