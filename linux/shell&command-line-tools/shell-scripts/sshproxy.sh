#!/bin/sh
#========远程转发======

#代理服务器登录用户名
remoteUser=
#代理服务器地址 (在该服务器上面的sshd_config中将GatewayPorts 设为yes)
remoteAddr=
#远程转发端口
proxyPort=
#远程登录端口
remotePort=22

#本地用户名
localUser=root
#本地端口
localPort=22
#本地地址
localAddr=localhost
#密钥
key="~/.ssh/id_rsa"
#ping 5 次，如果获取到的信息有中100% lost字样则认为网络不通
networkstate=`ping -c 5 z.cn | grep 100%`
#查找进程中是否已经存在指定进程
tunnelstate=`ps aux | grep ${remotePort} | grep ssh | grep -v grep`

if [[ -z "$networkstate" && -z "$tunnelstate" ]] #网络是通的
then
  ssh -i ${key} -fCNR ${proxyPort}:${localAddr}:${localPort} ${user}@${remoteAddr} -p ${remotePort}
fi
