---
layout: home
lang: en
alt_url: /
permalink: /en/
nav_exclude: true
---

{% include hero_en.html
  title="VISC — Variant Information Standardization Collegium"
  cta_label="Next meeting"
  cta_url="/visc/meetings/"
%}

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

