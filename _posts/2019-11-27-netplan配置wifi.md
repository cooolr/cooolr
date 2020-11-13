---
layout: mypost
title: netplan配置wifi
categories: [linux]
---

- 查看无线网卡名称

```
ifconfig a
```

- 新加配置文件

wlan0替换成第一步ifconfig看到的实际无线网卡的名称
"ssid"和"password"替换成需要连接的wifi信息

> sudo vi /etc/netplan/80-cloud-init.yaml

```
network:
    version: 2
    wifis:
        wlan0:
            dhcp4: true
            access-points:
                "ssid":
                    password: "password"
```

- 使配置生效

```
# 检查语法，如有错误请检查缩进
sudo netplan generate
# 使配置生效
sudo netplan apply
```

> 参考: [Ubuntu Server 18.04 设置WIFI上网](https://busy.org/@oflyhigh/ubuntu-server-18-04-wifi)

> 参考: [静态ip dns配置](https://www.hi-linux.com/posts/49513.html)