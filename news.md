---
layout: page
title: News
permalink: /news/
---

# News

Below is the full list of updates. The **Home** page shows the latest posts.

<ul>
{% for post in site.posts %}
  <li>
    <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
    <small> — {{ post.date | date: "%Y-%m-%d" }}</small>
  </li>
{% endfor %}
</ul>

