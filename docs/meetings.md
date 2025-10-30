---
layout: page
title: Meetings
permalink: /meetings/
---

# Meetings（開催記録）

会合の詳細（議事・資料・動画等）は **GitHub Wiki** に掲載しています。  
👉 <a href="https://github.com/dbcls/visc/wiki" target="_blank" rel="noopener">VISC GitHub Wiki 全体を見る</a>

以下は主要な開催回へのリンク一覧です（最新順）。

<ul class="meetings-list">
{% assign list = site.data.meetings | sort: "no" | reverse %}
{% for m in list %}
  <li class="meeting-item">
    <div class="meeting-line">
      <span class="meeting-title">{{ m.title }}</span>
      <span class="meeting-sep"></span>
      <a class="meeting-link" href="{{ m.url }}" target="_blank" rel="noopener">{{ m.short }}</a>
    </div>
    {% if m.date_text %}
    <div class="meeting-meta">日程：{{ m.date_text }}</div>
    {% endif %}
    {% if m.place or m.city %}
    <div class="meeting-meta">
      場所：{% if m.place %}{{ m.place }}{% endif %}{% if m.place and m.city %}（{% endif %}{% if m.city %}{{ m.city }}{% endif %}{% if m.place and m.city %}）{% endif %}
    </div>
    {% endif %}
  </li>
{% endfor %}
</ul>

<p class="note">※ 各回の議事録・発表資料・動画リンクなどは Wiki ページをご参照ください。</p>

