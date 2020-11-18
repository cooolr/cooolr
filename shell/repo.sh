sed -i 's@^\(deb.*stable main\)$@#\1\ndeb https://mirrors.ustc.edu.cn/termux stable main@' $PREFIX/etc/apt/sources.list

echo -e "\033[32m[OK]\033[0m \033[42;37m 已切换中科大源，进入更新程序，请一路回车完成后续步骤 \033[0m"

pkg update
