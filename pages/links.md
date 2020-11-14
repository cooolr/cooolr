---
layout: mypost
title: 友情链接
---

欢迎各位朋友与我建立友链，如需友链请到[留言板](chat.html)留言，我看到留言后会添加上的，本站的友链信息如下

```
名称：{{ site.title }}
描述：{{ site.description }}
地址：{{ site.domainUrl }}{{ site.baseurl }}
头像：{{ site.domainUrl }}{{ site.baseurl }}/static/img/logo.jpg
```
<ul>
  {%- for link in site.links %}
  <li>
    <p><img style="width: 40px;height: 40px;border-radius: 50%;box-shadow: 0 1px 5px rgba(0, 0, 0, 0.1);" src="{{ link.headurl }}" /><a href="{{ link.url }}" title="{{ link.desc }}" target="_blank" >{{ link.title }}</a></p>
  </li>
  {%- endfor %}
</ul>
