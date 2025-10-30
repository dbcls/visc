---
layout: page
title: Projects
permalink: /projects/
---

# Projects

<div class="cards">
{% for p in site.projects %}
  <div class="card">
    <h3><a href="{{ p.url | relative_url }}">{{ p.title }}</a></h3>
    {% if p.website %}
      <p><a href="{{ p.website }}" target="_blank" rel="noopener">Website</a></p>
    {% endif %}
    {% if p.repos %}
      <p>Repos:
      {% for r in p.repos %}
        <a href="{{ r }}" target="_blank" rel="noopener">{{ r }}</a>{% unless forloop.last %}, {% endunless %}
      {% endfor %}
      </p>
    {% endif %}
    <p>{{ p.excerpt }}</p>
  </div>
{% endfor %}
</div>

