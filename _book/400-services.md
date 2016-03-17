---
title: Service Catalog
layout: book
---

This is the OSGi enRoute Base Profile service catalog. The following services are currently available and documented.

<div>
<table>

{% for service in site.services %}<tr><td><a href="{{service.url}}">{{service.title}}</a></td><td>{{service.summary}}</td></tr>
{% endfor %}

</table>
</div>
