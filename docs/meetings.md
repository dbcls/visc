---
layout: page
title: Meetings
permalink: /meetings/
---

# Meetings（開催記録）

VISC（バリアント情報標準化研究会）の開催記録は、  
**GitHub Wiki** に掲載しています。

- 👉 [VISC GitHub Wiki 全体を見る](https://github.com/dbcls/visc/wiki){:target="_blank"}

以下は主要な開催回へのリンク一覧です（最新順）。

<ul>
{% assign list = site.data.meetings | sort: "date" | reverse %}
{% for m in list %}
  <li>
    <a href="{{ m.url }}" target="_blank" rel="noopener">{{ m.title }}</a>
    <small> — {{ m.date }}{% if m.no %}（No. {{ m.no }}）{% endif %}</small>
  </li>
{% endfor %}
</ul>

---
※ 各回の議事録・発表資料・動画リンクなどは Wiki ページをご参照ください。

