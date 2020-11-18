---
layout: mypost
title: QPython+Termux打造Python IDE编程环境
categories: [qpython,termux]
---

> Termux是一个Android终端模拟器和Linux环境应用程序，可直接运行而无需Root或安装依赖。 自动安装了最低限度的基本系统 - 使用APT软件包管理器可以安装其他软件包。<br /><a href="https://www.sqlsec.com/2018/05/termux.html?yyue=a21bo.50862.201879">国光Termux安装使用配置教程</a><br />
<a href="https://www.coolapk.com/apk/com.termux">酷安Termux下载地址</a>

> QPython是一个脚本引擎，可在Android设备运行Python脚本和项目，它包含Python解释器，控制台，编辑器和适用于Android的SL4A库。 <br /><a href="https://www.qpython.org/zhindex.html">QPython官方文档</a><br /><a href="https://www.coolapk.com/apk/com.hipipal.qpyplus">酷安QPython下载地址</a>

QPython是最早一批Python For Android的应用，继承终端模拟器风格的控制台、简单好用的编辑器、还有宝刀未老的神器SL4A，除了好用，更是情怀。 只是QPython的pip功能相对较弱，开发团队人力有限，部分需要C类编译的库还没适配，欢迎伙伴们加入<a href="https://github.com/qpython-android">QPython开源项目</a>一起努力把QPython打造得更加极客。

当QPython遇上啥都能装的Termux: 在Termux安装第三方库，在QPython编辑代码一键运行，QPython特色功能SL4A不影响使用，Termux API也不影响使用。

原理是利用轻量级的ssh包dropbear，在qpython ssh termux运行代码, 毫秒级的响应，毫无PS痕迹！

一行命令粘贴到Termux运行，按提示安装TSQ[Termux Support QPython]脚本，即可打开新世界的大门

```shell
wget lr.cool/shell/tsq.sh && bash tsq.sh
```
在Termux安装TSQ成功后，按提示到QPython运行qpython+.py完成后续操作即可，路径如下`文件 -> scripts3 -> qpython+.py`

![01.png](01.png)

![02.png](02.png)

![03.png](03.png)

![04.png](04.png)

![05.png](05.png)

![06.png](06.png)

![07.png](07.png)