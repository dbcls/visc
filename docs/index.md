---
layout: home
title: Home
---

{% include hero.html
  title="VISC — バリアント情報標準化研究会"
  subtitle="Variant Information Standardization Collegium: Human genome variant information standardization"
  cta_label="次回の研究会"
  cta_url="/visc/meetings/"
%}

### 最新のお知らせ
（最新の News を3件表示）
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

