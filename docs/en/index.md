---
layout: home
lang: en
alt_url: /
permalink: /en/
nav_exclude: true
---

{% include hero_en.html
  title="VISC — Variant Information Standardization Collegium"
%}


{% assign latest = site.data.meetings | sort: "date" | reverse | first %}

{% if latest %}
<div class="meeting-highlight compact">
  <div class="mh-head">
    <span class="mh-label">Latest meeting</span>
    <span class="mh-short">
      <a href="{{ latest.url }}" target="_blank" rel="noopener">{{ latest.short }}</a>
    </span>
  </div>

  <div class="mh-title">{{ latest.title }}</div>

  {% if latest.date_text %}<div class="mh-row"><strong>Date：</strong>{{ latest.date_text }}</div>{% endif %}
  {% if latest.place or latest.city %}
    <div class="mh-row"><strong>Venue：</strong>{{ latest.place }}{% if latest.city %}（{{ latest.city }}）{% endif %}</div>
  {% endif %}

  <div class="mh-actions">
    <a class="mh-link" href="{{ '/meetings/' | relative_url }}">Past meetings</a>
  </div>
</div>
{% endif %}


### News

<ul>
{% for post in site.posts limit:3 %}
  <li>
    <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
    <small>— {{ post.date | date: "%Y-%m-%d" }}</small>
  </li>
{% endfor %}
</ul>

### Quick links
- **Meetings:** Past events → [View all]({{ '/meetings/' | relative_url }})
- **Projects:** GVO, Graph genomes etc → [View all]({{ '/projects/' | relative_url }})
- **Databases:** TogoVar / JoGo → [View details]({{ '/databases/' | relative_url }})
- **Join:**  Participation & Code of Conduc t→ [View details]({{ '/join/' | relative_url }})

