---
layout: mypost
title: python3 串口控制USB转GSM模块打电话发短信
categories: [python]
---

- 安装依赖

``` bash
pip install pyserial
```

- 串口连接

``` python3
import serial
s = serial.Serial("/dev/ttyUSB0")
```

- 打电话

``` python3
s.write("ATD10086;\r\n".encode())
```

- 发短信

``` python3
# 设置短信模式为PDU
s.write(b'AT+CMGF=0\r\n')

# 设置短信编码
s.write(b'AT+CSCS="UCS2"\r\n')

# 手机号码 16进制unicode码
s.write('AT+CMGS="00310030003000380036"\r\n'.encode())

# 短信内容 16进制unicode码
s.write('00680065006c006c006f00204e16754c'.encode())

# 发送代码
s.write(b'\x1A\r\n')
```

- 读取短信

``` python3
import re

# 读取所有短信
s.write(b'AT+CMGL="ALL"\r\n')

# 获取全部返回
res = s.read()
while True:
    count = s.inWaiting()
    if count == 0:
        break
    res += s.read(count)

# 匹配短信文本
msg_list = re.findall('\+CMGL\: (\d+),"REC READ","(.*?)","","(.*?)"\\r\\n(.*?)\\r\\n', res.decode())
msg_list = [list(i) for i in msg_list]
for msg in msg_list:
    msg[1] = unicode2str(msg[1])
    msg[-1] = unicode2str(msg[-1])
print(msg_list)
```

- 字符串转16进制unicode码

``` python3
def str2unicode(text):
    code = ''
    for i in text:
        hex_i = hex(ord(i))
        if len(hex_i) == 4:
            code += hex_i.replace('0x', '00')
        else:
            code += hex_i.replace('0x', '')
    return code
```

- 16进制unicode码转字符串

``` python3
def unicode2str(code):
    text = ''
    tmp = ''
    for i in range(len(code)):
        tmp += code[i]
        if len(tmp) == 4:
            text += "\\u" + tmp
            tmp = ''
    text = eval(f'"{text}"')
    return text
```