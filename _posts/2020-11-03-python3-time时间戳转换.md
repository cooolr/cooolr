---
layout: mypost
title: python3 time时间戳转换
categories: [python]
---

```python
import time
```

- 格式化时间转时间戳

```python
ctime = time.strftime("%Y-%m-%d %H:%M:%S")

# 先转成struct_time
ctime = time.strptime(ctime, "%Y-%m-%d %H:%M:%S")

# 再转成时间戳
ctime = time.mktime(ctime)
```

- 时间戳转格式化时间

```python
stamp = time.time()

# 先转成struct_time
stamp = time.localtime(stamp)

# 再转成格式化时间
ctime = time.strftime("%Y-%m-%d %H:%M:%S", stamp)
```