# -*- coding: utf-8 -*-

import os,sys

if sys.version[0] == '2':
    print('\n此脚本仅运行在python3环境, 请安装最新版QPython并切换到python3环境')
    sys.exit()

runfile = os.environ['HOME'] + '/bin/qpython3-android5.sh'

if 'termux' in runfile:
    print('\n你已在termux的python环境中')
    sys.exit()

with open(runfile, 'r') as f:
    text = f.read()

text = text.replace('. $DIR/init.sh && $DIR/python3-android5 "$@"', 'echo $AP_PORT > /sdcard/qpython/AP_PORT&&echo $AP_HANDSHAKE > /sdcard/qpython/AP_HANDSHAKE&&$DIR/ssh -p8122 -i /sdcard/qpython/id_rsa -t localhost "cd /sdcard/qpython&&python $@"')

with open(runfile, 'w') as f:
    f.write(text)

print('\n配置完成，编辑器运行环境已切换到termux, 来回切换python版本即可还原')