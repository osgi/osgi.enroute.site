---
title: Service Catalog
layout: book
---

This is the OSGi enRoute Base Profile service catalog. The following services are currently available and documented.

<div>
<ol>

{% for service in site.services %}<li><a href="{{service.url}}">{{service.title}}</a> – {{service.summary}}</li>
{% endfor %}

</ol>
</div>
