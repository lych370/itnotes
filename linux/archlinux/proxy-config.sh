#!/bin/sh
pacman -S proxychains-ng shadowsocks-qt5 privoxy --noconfirm
systemctl enable privoxy
#1080 is your socks5 client's local listen-port (shadowsocks-qt5)
echo "socks5 127.0.0.1 1080" >> /etc/proxychains.conf
echo "listen-address 127.0.0.1:8010" >> /etc/privoxy/conf
echo "forward-socks5 / localhost:8010 ." >> /etc/privoxy/conf
wget https://zfl9.github.io/gfwlist2privoxy/gfwlist.action
mv-f gfwlist.action /etc/privoxy/
echo 'actionsfile gfwlist.action' >>/etc/privoxy/config
systemctl start privoxy.service
