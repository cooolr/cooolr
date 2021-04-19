#!/data/data/com.termux/files/usr/bin/bash

#====================================================
#   System Request: Termux
#   Author: lr
#   Dscription: Qpython Run ON Termux
#   Version: 1.1
#   Email: i@lr.cool
#   Date: 2021-04-09 10:00:00
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
shell_version="1.1"

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
    if [[ $(ls /storage/emulated/0|wc -l) -lt 1 ]]; then
        echo -e "${Error} ${RedBG} 获取读写手机存储权限失败，请授权${Font}"
        termux-setup-storage
        sleep 2
        echo -e "${OK} ${GreenBG} 已获取读写手机存储权限，进入安装流程 ${Font}"
        sleep 1
    else
        echo -e "${OK} ${GreenBG} 已获取读写手机存储权限，进入安装流程 ${Font}"
        sleep 3
    fi
}

install () {
    is_sdcard
    apt update
    judge "更新apt软件包列表"
    apt install -y wget openssh python
    judge "安装openssh和python环境"
    
    echo -e "${GreenBG} 正在生成openssh私钥，请一路回车确认直至成功 ${Font}"
    ssh-keygen -t rsa -m PEM -f openssh_rsa_id
    judge "生成openssh私钥"

    apt install -y dropbear
    judge "安装dropbear"
    
    dropbearconvert openssh dropbear  openssh_rsa_id dropbear_rsa_id
    judge "openssh私钥转成dropbear私钥"

    mkdir ~/.ssh
    dropbearkey -y -f dropbear_rsa_id|grep ssh-rsa|xargs echo >>~/.ssh/authorized_keys
    judge "写入dropbear公钥到~/.ssh/authorized_keys"
    
    mkdir -p /sdcard/qpython/scripts3
    cp dropbear_rsa_id /sdcard/qpython/id_rsa
    judge "复制dropbear私钥到/sdcard/qpython目录"

    rm -rf dropbear_rsa_id openssh_rsa_id
    judge "清理文件"
    
    apt install -y openssh
    judge "重新安装openssh"

    echo -e 'import os,socket\nsocket.setdefaulttimeout(0.1)\ntry:\n    socket.socket().connect(("127.0.0.1",8022))\nexcept:\n    os.system("sshd")' >~/.ssh/sshd.py
    judge "写入python程序，自启动sshd服务"

    touch ~/.bashrc
    if [[ $(cat ~/.bashrc|grep -c "sshd.py") -lt 1 ]]; then
        echo $sudo'python ~/.ssh/sshd.py' >>~/.bashrc
    fi
    judge "写入.bashrc文件，自启动sshd.py"

    wget http://lr.cool/files/androidhelper.zip
    wget http://lr.cool/shell/qpy.py
    v=$(python3 -V|awk {'print $2'}|awk -F. {'print $1"."$2'})
    mkdir -p /data/data/com.termux/files/usr/lib/python$v/site-packages/androidhelper
    unzip -n androidhelper.zip -d /data/data/com.termux/files/usr/lib/python$v/site-packages/androidhelper
    cp qpy.py /data/data/com.termux/files/usr/lib/python$v/site-packages/
    rm -f androidhelper.zip
    rm -f qpy.py
    judge "下载安装androidhelper"

    wget http://lr.cool/shell/qpython+.py
    cp qpython+.py /sdcard/qpython/scripts3/qpython+.py
    rm -f qpython+.py
    judge "生成/sdcard/qpython/scripts3/qpython+.py"

    python3 ~/.ssh/sshd.py
    judge "启动dropbear后台服务"

    echo -e "\n\033[33m请在qpython运行qpython+.py完成后续配置\033[0m\n"
}

uninstall () {
    is_termux
    v=$(python -V|awk {'print $2'}|awk -F. {'print $1"."$2'})
    sed -i "/sshd.py/d" ~/.bashrc
    rm -f /sdcard/qpython/id_rsa
    rm -rf /data/data/com.termux/files/usr/lib/python$v/site-packages/androidhelper
    rm -rf /data/data/com.termux/files/usr/lib/python$v/site-packages/qpy.py
    pkill sshd
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
