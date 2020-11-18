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

is_sdcard() {
    if [[ $(ls /sdcard|wc -l) -lt 1 ]]; then
        echo -e "${Error} ${RedBG} 未获取读写手机存储权限，请在设置授权后重新执行脚本 ${Font}"
        exit 1
    else
        echo -e "${OK} ${GreenBG} 已获取读写手机存储权限，进入安装流程 ${Font}"
        sleep 3
        
    fi
}

install () {
    is_sdcard

    apt update
    judge "更新apt软件包列表"

    apt install -y wget dropbear python
    judge "安装wget dropbear和python包"

    dropbearkey -t rsa -f id_rsa
    judge "生成私钥"

    mkdir ~/.ssh
    dropbearkey -y -f id_rsa|grep ssh-rsa|xargs echo >>~/.ssh/authorized_keys
    judge "写入公钥到~/.ssh/authorized_keys"

    mkdir -p /sdcard/qpython/scripts3
    cp id_rsa /sdcard/qpython/
    dropbearkey -y -f id_rsa|grep ssh-rsa|xargs echo >/sdcard/qpython/id_rsa.pub
    rm -f id_rsa
    judge "移动密钥到/sdcard/qpython目录"

    mkdir ~/.dropbear
    cp ~/../usr/bin/dropbearmulti ~/.dropbear/dropbear
    judge "移动dropbear命令"

    apt remove -y dropbear
    judge "卸载dropbear"

    echo -e 'import os\nif not os.popen("netstat -lnt|grep 8122").read():\n    os.system("~/.dropbear/dropbear -p 8122&&termux-wake-lock")' >~/.dropbear/runbear.py
    judge "写入python程序，自启动dropbear服务"

    touch ~/.bashrc
    if [[ $(cat ~/.bashrc|grep -c "runbear.py") -lt 1 ]]; then
        echo 'python ~\\.dropbear\\runbear.py' >>~/.bashrc
    fi
    judge "写入.bashrc文件，自启动rundear.py"

    wget http://lr.cool/files/androidhelper.zip
    v=$(python -V|awk {'print $2'}|awk -F. {'print $1"."$2'})
    mkdir ~/../usr/lib/python$v/site-packages/androidhelper
    unzip -n androidhelper.zip -d ~/../usr/lib/python$v/site-packages/androidhelper
    rm -f androidhelper.zip
    judge "下载安装androidhelper"

    wget http://lr.cool/shell/qpython+.py
    cp qpython+.py /sdcard/qpython/scripts3/qpython+.py
    rm -f qpython+.py
    judge "生成/sdcard/qpython/scripts3/qpython+.py"

    python ~/.dropbear/runbear.py
    judge "启动dropbear后台服务"

    echo -e "\n\033[33m请在qpython运行qpython+.py完成后续配置\033[0m\n"
}

uninstall () {
    rm -rf ~/.dropbear
    sed -i 's/python ~\\\\.dropbear\\\\runbear.py/#/g' ~/.bashrc
    nl ~/.bashrc|sed 'runbear.py'
    v=$(python -V|awk {'print $2'}|awk -F. {'print $1"."$2'})
    rm -rf ~/../usr/lib/python$v/site-packages/androidhelper
    sed -i 's/$(echo /sdcard/qpython/id_rsa.pub)/ /g' ~/.ssh/authorized_keys
    rm -f /sdcard/qpython/id_rsa
    rm -f /sdcard/qpython/id_rsa.pub
    pkill dropbear
    termux-wake-unlock
    judge "卸载TSQ"

}

menu() {
    echo -e "Termux Support QPython[TSQ] 安装管理脚本 ${Red}[${shell_version}]${Font}"
    echo -e "---authored by lr---"
    echo -e "QPython编程交流群: 540717901\n"

    echo -e "—————————————— 安装向导 ——————————————"""
    echo -e "${Green}1.${Font} 安装TSQ"
    echo -e "${Green}2.${Font} 卸载TSQ"
    echo -e "${Green}3.${Font} 退出 \n"

    read -rp "请输入数字：" menu_num
    case $menu_num in
    1)
        install
        ;;
    2)
        uninstall
        ;;

    3)
        exit 0
        ;;
    *)
        echo -e "${RedBG}请输入正确的数字${Font}"
        ;;
    esac
}

menu