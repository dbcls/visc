<div style="background:yellow; padding:8px; border:1px solid #ccc;">
  LIQUID TEST: {{ 1 | plus: 1 }}
</div>
---
layout: home
lang: ja
alt_url: /en/
nav_exclude: true
---

{% include hero.html
  title="VISC — バリアント情報標準化研究会"
  cta_label="最新の研究会"
<!-- DEBUG meetings_count={{ site.data.meetings | size }} -->
<!-- DEBUG meetings_keys={{ site.data.meetings[0] | inspect }} -->

  {% assign latest = site.data.meetings | sort: "date" | reverse | first %}
<p>DEBUG latest short: {{ latest.short }}</p>
<p>DEBUG latest date: {{ latest.date }}</p>

  {% if latest %}
  <div class="highlight-meeting">
  <h3>
    {{ latest.title }}
    <a href="{{ latest.url }}" target="_blank" rel="noopener">
      {{ latest.short }}
    </a>
  </h3>

  {% if latest.date_text %}
    <p><strong>日程：</strong>{{ latest.date_text }}</p>
  {% endif %}

  {% if latest.place or latest.city %}
    <p><strong>場所：</strong>
      {{ latest.place }}{% if latest.city %}（{{ latest.city }}）{% endif %}
    </p>
  {% endif %}

  <p>
    <a class="btn" href="{{ '/meetings/' | relative_url }}">
      開催記録一覧を見る
    </a>
  </p>
  </div>
  {% endif %}

  cta_url="/visc/meetings/"
%}

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

