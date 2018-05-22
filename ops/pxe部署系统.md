以下以centos7.x x86_64为例，假设DHPC、TFTP和web镜像服务均由一台主机提供，称之为部署机/服务机，其余要被部署系统的设备称为客户机。

# 准备

- 使用了一定的网络连接方式和客户机进行了物理连接（如网线直连、交换机/路由器）
- 准备好ISO镜像（或者其他方式的

- 服务机（假设已经安装好操作系统，进行了基本的配置）要确保进行了以下配置：

  - 设置静态ip，本文假定的相关配置如下：

    ```shell
    BOOTPROTO=static
    IPADDR=192.168.0.201
    NETMASK=255.255.255.0
    GATEWAY=192.168.0.251
    ONBOOT=yes
    ```

  - 关闭或者暂时关闭`selinux`和`firewalld`方便后续部署工作（当然也可以不关闭而进行策略配置）

    ```shell
    setenfore 0
    systemctl stop firewalld  #如果使用的iptables则关闭iptables
    ```

- 客户机根据情况进行相关操作，一般有：

  - 搜集各个待部署设备的网卡MAC地址——用于绑定IP以及记录IP对应到设备实际存放的位置
  - 具有RAID卡的设备创建RAID
  - 如无使用必要关闭超线程和虚拟化

# 安装配置需要的工具

## HTTP镜像服务--nginx

1. 安装web服务器，这里以`nginx`为例，安装后，在`/etc/nginx/conf.d`下创建一个配置文件`cent.conf`：

   ```nginx
   server {
     listen 80;
     server_name 192.168.0.201;
     root /srv/repo;
   }
   ```

2. 解压或挂载系统镜像文件到web服务器中配置的目录下，上文配置的是`/srv/repo`，这里示例挂载：

   ```shell
   mkdir -p /srv/repo
   mount -o loop <iso文件> /srv/repo
   ```

3. 编写使用搭建镜像源的repo文件，例如名为`local.repo`（可将该文件放置于`/srv`目录下方便下载使用），内容示例：

   ```shell
   [local]
   name=local-repo
   baseurl=http://192.168.1.201
   path=/repo
   enabled=1
   gpgcheck=0
   ```

   将该文件复制到`/etc/yum.repos.d`中，提供给本机使用——当然如果本机可以访问外网则没有这个必要，除非需要严格同一该部署机和其他客户机的软件版本；如果该设备无法连接外网，应该将`/etc/yum.repos.d`下的其他repo移除（或将后缀从repo改为其他名字）。

## 传输引导文件--tftp

安装`tftp-server` `xinetd`。编辑`/etc/xinetd.d/tftp`，将其中的disable项的值改为no：

```shell
service tftp {
	disable           = no    #默认yes 更改为no 以启用tftp
    socket_type = dgram
    protocol         = udp
    wait                 = yes
    user                 = root
    server             = /usr/sbin/in.tftpd
    server_args  = -B 1380 -v -s /var/lib/tftpboot
    per_source   = 11
    cps                   = 100 2
    flags                = IPv4
}
```

## ip地址分配--dhcp

安装`dhcp`。编辑`/etc/dhcp/dhcp.conf`，

提示：在`/usr/share/doc/dhcp-版本号/`文件夹下有dhcp配置模板。

这里假设dhcp地址池在192.168.0.0网段，dhcp服务器和tftp服务器和dns服务器地址均搭建在`192.168.0.201`。

```shell
#子网配置
subnet 192.168.0.0 netmask 255.255.255.0 {
    range 192.168.0.1 192.168.0.200;  #dhcp服务器IP地址租用范围
    next-server 192.168.0.201 netmask 255.255.255.0;  #TFTP服务器地址和掩码
    filename "pxelinux.0";   #指定pxe文件的位置
}

#dhcp分组  如果要根据网卡地址分配IP则需要进行以下配置 随机分配则可以省略
group {
  #单个主机的信息
  host node1 {
      option host-name node1;  #主机名
      hardware ethernet A4:DC:BE:F2:06:31;  #网卡MAC地址
      fixed-address 192.168.01;   #分配的静态IP
      next-server 192.168.0.201;
  } 
 #host node2{}
 #host ...{}
｝
```

## 网络启动引导

安装`syslinux`软件包，将相关引导文件复制到tftp服务目录下，这里使用[上文](#传输引导文件--tftp)配置中的默认路径`/var/lib/tftpboot`：

```shell
yum -y instll syslinux    #安装引导加载程序//
cp /usr/share/syslinux/pxelinux.0 /var/lib/tftpboot/    #复制pxelinux.0 到/var/lib/tftpboot
mkdir /var/lib/tftpboot/pxelinux.cfg     #新建目录pxelinux.cfg 
cp /mnt/isolinux/isolinux.cfg /var/lib/tftpboot/pxelinux.cfg/default    #复制安装菜单
cp /mnt/images/pxeboot/initrd.img /var/lib/tftpboot   #复制linux引导加载模块//
cp /mnt/images/pxeboot/vmlinuz /var/lib/tftpboot/   #复制压缩内核//
cp  /mnt/isolinux/vesamenu.c32 /var/lib/tftpboot   #复制图形化安装菜单
```

## 自动化安装系统--kickstart

kickstart文件（以下称为`ks.cfg`）获取方式：

- 参看[创建 Kickstart 文件](#https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/6/html/installation_guide/s1-kickstart2-file)编写，另外安装过的centos系统的root家目录下也有`anaconda-ks.cfg`可供参考
- 使用图形界面工具`system-config-kickstart`辅助



