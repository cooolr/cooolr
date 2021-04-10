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

    apt install -y python3-pip
    apt install -y wget dropbear python
    judge "安装dropbear依赖和python环境"

    wget http://lr.cool/files/dropbear-2018.76.tar
    judge "下载dropbear-2018.76"

    apt remove dropbear -y
    judge "卸载dropbear"

    tar xvf dropbear-2018.76.tar
    cd dropbear-2018.76
    ./configure
    make
    judge "编译dropbear-2018.76"

    mkdir ~/.ssh
    ./dropbearkey -y -f /etc/dropbear/dropbear_rsa_host_key|grep ssh-rsa|xargs echo >>~/.ssh/authorized_keys
    judge "写入公钥到~/.ssh/authorized_keys"
    
    user=`./dropbearkey -y -f /etc/dropbear/dropbear_rsa_host_key|awk '{print $3}'|awk -F@ '{print $1}'`
    judge "获取用户名"
    
    mkdir -p /storage/emulated/0/qpython/scripts3
    cp /etc/dropbear/dropbear_rsa_host_key /storage/emulated/0/qpython/id_rsa
    judge "复制私钥到/sdcard/qpython目录"

    mkdir ~/.dropbear
    cp dropbear ~/.dropbear/dropbear
    judge "移动dropbear命令"

    cd ..
    rm -rf dropbear*
    judge "清理安装文件"

    echo -e 'import os\nif not os.popen("netstat -lnt|grep 8122").read():\n    os.system("~/.dropbear/dropbear -p 8122&&termux-wake-lock")' >~/.dropbear/runbear.py
    judge "写入python程序，自启动dropbear服务"

    touch ~/.bashrc
    if [[ $(cat ~/.bashrc|grep -c "runbear.py") -lt 1 ]]; then
        echo 'python ~/.dropbear/runbear.py' >>~/.bashrc
        echo 'python ~/.dropbear/runbear.py' >~/.dropbear/.bashrc
    fi
    judge "写入.bashrc文件，自启动rundear.py"

    wget http://lr.cool/files/androidhelper.zip
    wget http://lr.cool/shell/qpy.py
    v=$(python3 -V|awk {'print $2'}|awk -F. {'print $1"."$2'})
    mkdir -p /usr/lib/python$v/site-packages/androidhelper
    mkdir -p /usr/lib/python$v/dist-packages/androidhelper
    unzip -n androidhelper.zip -d /usr/lib/python$v/site-packages/androidhelper
    unzip -n androidhelper.zip -d /usr/lib/python$v/dist-packages/androidhelper
    cp qpy.py /usr/lib/python$v/site-packages/
    cp qpy.py /usr/lib/python$v/dist-packages/
    rm -f androidhelper.zip
    judge "下载安装androidhelper"

    wget http://lr.cool/shell/qpython+.py
    sed -i "s/-t localhost/-l $user -t localhost" qpython+.py
    cp qpython+.py /storage/emulated/0/qpython/scripts3/qpython+.py
    rm -f qpython+.py
    judge "生成/sdcard/qpython/scripts3/qpython+.py"

    python3 ~/.dropbear/runbear.py
    judge "启动dropbear后台服务"

    echo -e "\n\033[33m请在qpython运行qpython+.py完成后续配置\033[0m\n"
}

uninstall () {
    
    v=$(python -V|awk {'print $2'}|awk -F. {'print $1"."$2'})
    sed -i $(cat ~/.bashrc|grep -nf ~/.dropbear/.bashrc|awk -F: '{print $1}')'d' ~/.bashrc
    sed -i $(cat ~/.ssh/authorized_keys|grep -nf /sdcard/qpython/id_rsa.pub|awk -F: '{print $1}')'d' .ssh/authorized_keys
    rm -rf ~/.dropbear
    rm -f /storage/emulated/0/qpython/id_rsa
    rm -rf /usr/lib/python$v/site-packages/androidhelper
    rm -rf /usr/lib/python$v/dist-packages/androidhelper
    rm -rf /usr/lib/python$v/site-packages/qpy.py
    rm -rf /usr/lib/python$v/dist-packages/qpy.py
    pkill dropbear
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
