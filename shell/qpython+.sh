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

apt install -y dropbear python
judge "安装dropbear和python包"

dropbearkey -t rsa -f id_rsa
judge "生成私钥"

mkdir ~/.ssh
dropbearkey -y -f id_rsa|grep ssh-rsa|xargs echo >>~/.ssh/authorized_keys
judge "写入公钥到~/.ssh/authorized_keys"

cp id_rsa /sdcard/qpython/
rm -f id_rsa
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

wget http://lr.cool/files/androidhelper.zip
v=$(python -V|awk {'print $2'}|awk -F. {'print $1"."$2'})
mkdir ~/../usr/lib/python$v/site-packages/androidhelper
unzip androidhelper.zip -d ~/../usr/lib/python$v/site-packages/androidhelper
judge "下载安装androidhelper"

wget http://lr.cool/shell/qpython+.py
cp qpython+.py /sdcard/qpython/scripts3/qpython+.py
rm -f qpython+.py
judge "生成/sdcard/qpython/scripts3/qpython+.py"

echo "${Green}请在qpython运行 qpython+.py 完成后续配置${Font}"