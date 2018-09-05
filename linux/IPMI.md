> IPMI（智能平台管理接口）是一种开放标准的硬件管理接口规格，定义了**嵌入式管理子系统**进行通信的特定方法。IPMI 信息通过基板管理控制器 (BMC)（位于 IPMI 规格的硬件组件上）进行交流。使用低级硬件智能管理而不使用操作系统进行管理。



# 配置

1. 在BIOS中启用IPMI over LAN功能。

2. 安装`ipmitool`工具。

3. 启用`ipmi`服务

4. 设置impi网络参数

  假如该设备目前IP为192.168.1.10，网关为192.168.1.1，则为其配置一个该网段中未被分配使用的IP，示例：

  ```shell
  ipmitool lan print  #查看配置信息
  ipmitool lan print [数字]  #从0开始一个一个试 找到该设备上默认的ipmi的channel值
  ipmitool lan set 1 ipaddr 192.168.0.100  #IP  #这里假设channel时1 下同
  ipmitool lan set 1 netmask 255.255.255.0  #子网掩码
  ipmitool lan set 1 defgw ipaddr 192.168.0.1  #网关
  ipmitool lan set 1 access on  #启用 （off为关闭）
  ```

更多`ipmi`命令可在输入`ipmitool`回车后查看，在`ipmitool lan`回车后可查看配置LAN控制相关命令。

- 设置管理用户

  ```shell
  ipmitool user list 1  #查看当前用户列表
  ipmitool user set name <user id> <username>   #修改用户名
  ipmitool user set password <user id>  #设置admin密码 执行后输入两次新密码
  ```
  **注意**：密码可能有位数要求(一般最少8位），密码过短会返回错误信息。

  更多命令帮助，在`ipmitool user`回车后可查看。

- 检查

  ```shell
  ping 192.168.0.100
  ipmitool -H 192.168.0.100 -U admin power status  #会返回power is on
  ```

# WEB管理

浏览器开启https://你IPMI的IP地址（例如本文中为https://192.168.1.100），输入用户名和密码（本文示例中用户名和密码均为admin），即可登录web管理界面。

在web管理界面可以对设备进行电源管理、镜像挂载、固件升级、网络配置、设备实时画面查看等等操作，就如同身处该设备旁边一般。

提示：如果要使用远程控制中的重定向控制台（Console Redirection），需要安装Java运行环境（JRE）。在点击启用控制台（launch Console）后会提示下载lunch.jnlp文件，下载该文件并打开，会运行一个Java Viwer独立窗口。