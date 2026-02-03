---
layout: page
title: Meetings
permalink: /meetings/
lang: ja
---

# Meetings（開催記録）

会合の詳細（議事・資料・動画等）は **GitHub Wiki** に掲載しています。  
👉 <a href="https://github.com/dbcls/visc/wiki" target="_blank" rel="noopener">VISC GitHub Wiki 全体を見る</a>

以下は主要な開催回へのリンク一覧です（最新順）。

<div class="meeting-cards">
{% assign list = site.data.meetings | sort: "no" | reverse %}
{% for m in list %}
  <div class="meeting-card">

    <!-- タイトルと略称を同じ h3 内に -->
    <h3 class="meeting-title">
      {{ m.title }}&nbsp;<a class="meeting-short" href="{{ m.url }}" target="_blank" rel="noopener">{{ m.short }}</a>
    </h3>

    {% if m.date_text %}
      <p><strong>日程：</strong>{{ m.date_text }}</p>
    {% endif %}

    {% if m.place or m.city %}
      <p><strong>場所：</strong>
        {% if m.place %}{{ m.place }}{% endif %}
        {% if m.place and m.city %}（{% endif %}{% if m.city %}{{ m.city }}{% endif %}{% if m.place and m.city %}）{% endif %}
      </p>
    {% endif %}

  </div>
{% endfor %}
</div>

<p class="note">※ 各回の議事録・発表資料・動画リンクなどは Wiki ページをご参照ください。</p>

