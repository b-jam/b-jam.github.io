---
title: "Article Title"
date: 2021-12-01T10:00:00+13:00
draft: false
---
{{ define "main" }}
<h1>{{ .Title }}</h1>
<p>{{ .Content }}</p>
{{ end }}