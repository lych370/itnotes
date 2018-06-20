# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# personal-config
#!/bin/sh
# By Levin

# ******** Default display ********
PS1="[\u @ \h > \w ] \$ "

innerip=`ip addr | grep -o -P '1[^2][0-9?](\.[0-9]{1,3}){3}(?=\/)'`
gateway=`ip route | grep 'via' |cut -d ' ' -f 3`
echo -e "\e[1m `uname -srm`\e[0m  \nGATEWAY:\e[1;32m$gateway\e[0m <-- IP:\e[1;35m$innerip\e[0m \n \e[1;36m `date` \e[0m"


# ******** PATH ********
# proxy | use privoxy transfer socks5 to http
#export http_proxy=http://192.168.1.1:8010
#export https_proxy=http://192.168.1.1:8010


# ******** alias ********

# ----- device&system -----

# trim for ssd
alias trim='sudo fstrim -v /home && sudo fstrim -v /'

# mount win
alias win='sudo ntfs-3g /dev/sda4 /mnt/windows'

# ---power---

alias hs='systemctl hybrid-sleep'
alias hn='systemctl hibernate'
alias sp='systemctl suspend'
alias pf='systemctl poweroff'

# powertop
alias powertopauto='sudo powertop --auto-tune'

# tlp
alias tlpbat='sudo tlp bat'
alias tlpac='sudo tlp ac'
alias tlpcputemp='sudo tlp-stat -t'

# battery
alias batsate='cat /sys/class/power_supply/BAT0/capacity'

# CPU
alias cpuwatch='watch cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq'

# ----GPU---
alias nvidiaoff='sudo tee /proc/acpi/bbswitch <<<OFF'
alias nvidiaon='sudo tee /proc/acpi/bbswitch <<<ON'
alias nvidiasettings='sudo optirun -b none nvidia-settings -c :8'

# ---audio---
# beep
alias beep='sudo rmmod pcspkr && sudo echo "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf'

# ---wireless---

#bluetooth
alias bluetoothon='sudo systemctl start bluetooth'
alias bluetoothoff='sudo systemctl stop bluetooth'

# ---print---
alias printer='sudo systemctl start org.cups.cupsd.service'

# atd
alias atd='systemctl start atd'

# tree
alias tree='tree -C -L 1 --dirsfirst'

# ===system===

# Arch
alias up='pacman -Syu && trizen -Syua'
alias pacman='sudo pacman'
alias orphan='pacman -Rscn $(pacman -Qdttq)' 

# temporary locale
alias x='export LANG=en_US.UTF-8 LC_CTYPE=en_US.UTF-8 LC_MESSAGES=en_US.UTF-8 && startx'
alias xtc='export LANG=zh_TW.UTF-8 LC_CTYPE=zh_TW.UTF-8 LC_MESSAGES=zh_TW.UTF-8 && startx'
alias xsc='export LANG=zh_CN.UTF-8 LC_CTYPE=zh_CN.UTF-8 LC_MESSAGES=zh_CN.UTF-8 && startx'

alias cn='export LANG=zh_CN.UTF-8 LC_CTYPE=zh_CN.UTF-8 LC_MESSAGES=zh_CN.UTF-8'
alias en='export LANGUAGE=en_US.UTF-8'

# file operation
alias ls='ls --color=auto'
alias rm='mv -f --target-directory=/home/levin/.local/share/Trash/files/'
alias ll='ls -lh'
alias la='ls -lah'
alias cp='cp -i'
alias grep='grep --color'

# --- network---

#web server
alias np='sudo systemctl start nginx php-fpm'
alias npre='sudo systemctl restart nginx php-fpm'
alias npstop='sudo systemctl stop nginx php-fpm'
alias nmp='sudo systemctl start nginx mariadb php-fpm'
alias nmpre='sudo systemctl restart nginx mariadb php-fpm'
alias nmpstop='sudo systemctl stop nginx mariadb php-fpm'

# ssh server
alias sshstart='sudo systemctl start sshd'

# update hosts
alias hosts='sudo curl -# -L -o /etc/hosts https://raw.githubusercontent.com/googlehosts/hosts/master/hosts-files/hosts'

# shadowsocks 1080
alias ssstart='sudo systemctl start shadowsocks@ss'
alias ssstop='sudo systemctl stop shadowsocks@ss'
alias ssrestart='sudo systemctl restart shadowsocks@ss'

# privoxy 8010
alias privoxystart='sudo systemctl start privoxy'
alias privoxyrestart='sudo systemctl restar privoxy'
alias privoxyrestop='sudo systemctl stop privoxy'

#proxychains
alias px='proxychains'

# iconv -- file content encoding
alias iconvgbk='iconv -f GBK -t UTF-8' 
# convmv -- filename encoding
alias convmvgbk='convmv -f GBK -T UTF-8 --notest --nosmart'

#teamviwer
alias tvstart='sudo systemctl start teamviewerd.service'

#docker
alias dockerstart='sudo systemctl start docker'

# youdao dict 有道词典
alias yd='ydcv'

# install/update geoip database
alias geoipdata="cd /tmp && wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz && wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz && wget http://download.maxmind.com/download/geoip/database/asnum/GeoIPASNum.dat.gz && gunzip GeoIP.dat.gz && gunzip GeoIPASNum.dat.gz && gunzip GeoLiteCity.dat.gz && sudo cp GeoIP.dat GeoIPASNum.dat GeoLiteCity.dat /usr/share/GeoIP/ && cd -"

# libvirtd
alias virt='sudo modprobe virtio && sudo systemctl start libvirtd'

#--for fun--
# cmatrix
alias matrix='cmatrix'

# starwar
alias starwar='telnet towel.blinkenlights.nl'

#aquarium
alias aquarium='asciiaquarium'

# npm -g list --depth=0
alias npmlistg='sudo npm -g list --depth=0'

# bash-powerline : https://github.com/riobard/bash-powerline
source ~/.bash-powerline.sh
