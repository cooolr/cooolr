#!/data/data/com.termux/files/usr/bin/bash

#====================================================
#   System Request: Termux
#   Author: lr
#   Dscription: Qpython Run ON Termux
#   Version: 1.0
#   email: i@lr.cool
#====================================================

#fonts color
Green="\033[32m"
Red="\033[31m"
Yellow="\033[33m"
GreenBG="\033[42;37m"
RedBG="\033[41;37m"
Font="\033[0m"

#notification information
# Info="${Green}[信息]${Font}"
OK="${Green}[OK]${Font}"
Error="${Red}[错误]${Font}"

# 版本
shell_version="1.0"

judge() {
    if [[ 0 -eq $? ]]; then
        echo -e "${OK} ${GreenBG} $1 完成 ${Font}"
        sleep 1
    else
        echo -e "${Error} ${RedBG} $1 失败${Font}"
        exit 1
    fi
}

apt update
judge "更新apt软件包列表"

apt install -y curl dropbear python
judge "安装cutl dropbear和python包"

dropbearkey -t rsa -f id_rsa
judge "生成私钥"

mkdir ~/.ssh
dropbearkey -y -f id_rsa|grep ssh-rsa|xargs echo >>~/.ssh/authorized_keys
judge "写入公钥到~/.ssh/authorized_keys"

mv id_rsa /sdcard/qpython/
judge "移动私钥到/sdcard/qpython目录"

mkdir ~/.dropbear
cp ~/../usr/bin/dropbearmulti ~/.dropbear/dropbear
judge "移动dropbear命令"

apt remove -y dropbear
judge "卸载dropbear"

echo """import os
if not os.popen("netstat -lnt|grep 8122").read():
    os.system("~/.dropbear -p 8122&&termux-wake-lock")''' >~/.dropbear/runbear.py
judge "写入python程序，自启动dropbear服务"

echo 'python ~/.dropbear/runbear.py' >>~/.bashrc
judge "写入.bashrc文件，自启动rundear.py"

curl -O https://lr.cool/files/androidhelper.zip
v=$(python -V|awk {'print $2'}|awk -F. {'print $1"."$2'})
mkdir ~/../usr/lib/python$v/site-packages/androidhelper
unzip androidhelper.zip -d ~/../usr/lib/python$v/site-packages/androidhelper
judge "下载安装androidhelper"

echo """# -*- coding: utf-8 -*-
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
print('\n配置完成，编辑器运行环境已切换到termux, 来回切换python版本即可还原')""" >/sdcard/qpython/scripts3/qpython配置termux运行.py
judge "/sdcard/qpython/scripts3/qpython配置termux运行.py"

echo "${Green}请在qpython执行 <qpython配置termux运行.py> 即可配置成功${Font}"