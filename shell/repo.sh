sed -i 's@^\(deb.*stable main\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/termux-packages-24 stable main@' $PREFIX/etc/apt/sources.list

sed -i 's@^\(deb.*games stable\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/game-packages-24 games stable@' $PREFIX/etc/apt/sources.list.d/game.list

sed -i 's@^\(deb.*science stable\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/science-packages-24 science stable@' $PREFIX/etc/apt/sources.list.d/science.list

echo -e "\033[32m[OK]\033[0m \033[42;37m 修改sources.list成功, 进入更新程序，请一路回车完成后续步骤 \033[0m"

pkg update

echo -e "\033[32m[OK]\033[0m \033[42;37m 已切换清华源，请重启Termux使设置生效 \033[0m"
