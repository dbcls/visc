---
layout: home
lang: ja
alt_url: /en/
nav_exclude: true
---

{% include hero.html
  title="VISC — バリアント情報標準化研究会"
%}


{% assign latest = site.data.meetings | sort: "date" | reverse | first %}

{% if latest %}
<div class="meeting-highlight compact">
  <div class="mh-head">
    <span class="mh-label">最新の研究会</span>
    <span class="mh-short">
      <a href="{{ latest.url }}" target="_blank" rel="noopener">{{ latest.short }}</a>
    </span>
  </div>

  <div class="mh-title">{{ latest.title }}</div>

  {% if latest.date_text %}<div class="mh-row"><strong>日程：</strong>{{ latest.date_text }}</div>{% endif %}
  {% if latest.place or latest.city %}
    <div class="mh-row"><strong>場所：</strong>{{ latest.place }}{% if latest.city %}（{{ latest.city }}）{% endif %}</div>
  {% endif %}

  <div class="mh-actions">
    <a class="mh-link" href="{{ '/meetings/' | relative_url }}">開催記録を見る</a>
  </div>
</div>
{% endif %}


### 最新のお知らせ

<ul>
{% for post in site.posts limit:3 %}
  <li>
    <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
    <small>— {{ post.date | date: "%Y-%m-%d" }}</small>
  </li>
{% endfor %}
</ul>

### クイックリンク
- **Meetings:** 開催記録・資料（約20回） → [一覧]({{ '/meetings/' | relative_url }})
- **Projects:** GVO・グラフゲノムなど → [一覧]({{ '/projects/' | relative_url }})
- **Databases:** TogoVar / JoGo との連携 → [詳細]({{ '/databases/' | relative_url }})
- **Join:** 参加方法・行動規範 → [参照]({{ '/join/' | relative_url }})

