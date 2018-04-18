固态硬盘优化技巧

[TOC]

# 禁用文件系统日志

一般**不建议**。**明显缺点是非正常卸载分区（即断电后，内核锁定等）会造成数据丢失。**

# 分区对齐

如今各大发行版几乎在分区的时候都用了4k对齐。对齐检查：

```shell
parted /dev/sda
align-check optimal 1 
```
使用图形界面的`gaparted`可以调整对齐。

# TRIM

TRIM支持的文件系统：Ext4、Btrfs、JFS、VFAT，XFS。*VFAT 只有挂载参数为'discard'(而不是fstrim)时才支持 TRIM 。*

TRIM需`utils-linux`包。

检验TRIM支持需要`hdparm`包。

```shell
hdparm -I /dev/sda | grep TRIM
#得到类似信息  *    Data Set Management TRIM supported (limit 1 block)
```

有几种TRIM支持的规格，因此，输出内容取决于驱动器支持什么。

```shell
fstrim -v /home   #对home分区执行trim
fstrim -v /
```

*为了方便可以使用cron进行自动定期TRIM或者写入使用alias将其.bashrc手动TRIM。*

# swapiness

将swapiness的值改低（如1到10）会减少内存的交换，从而提升一些系统上的响应度。

```shell
cat /proc/sys/vm/swappiness    #检查swappiness值
sysctl vm.swappiness=1    #临时设置为1
```
为了长久保存设置可新建一个`/etc/sysctl.d/99-sysctl.conf`文件，修改swappiness为1:

```shell
vm.swappiness=1
vm.vfs_cache_pressure=50
```
# 设置频繁读取的分区

## 频繁读取的分区放置于HDD

如单独设置`/var`分区，挂载于HDD上而不是SSD上。

## tmpfs--挂载到内存

使用tmpfs将频繁读取的文件置于内存。

- 内存没用完，linux不会去用交换区。

- `df -h`可查看使用tmpfs的情况。

- 如今许多发行版默认对一些文件夹（如`/tmp`、`/dev/shm` ）使用tmpfs，**大小为物理内存的一半**。

  如果遇到默认分配的tmpfs空间不够大，可以可在`/etc/fstab`中指定size。

  例如，内存为8g的设备，`/tmp`会分配4g，修改为6g大小，编辑`/etc/fstab`添加（或修改）如下：

  ```shell
  # /tmp tmpfs .default size is half of physical memory size
  tmpfs /tmp      tmpfs nodev,nosuid,size=6G          0 0
  ```

  重启后生效。


##  浏览器cache使用tmpfs

- firefox

  1. 在地址栏中输入 about:config 后回车，进入高级设置页
  2. 点击右键新建一个 String ， name 为 `browser.cache.disk.parent_directory` ， value 为 `/dev/shm/firefox`。

- Chromium（或Chrome）

  找到Chromium程序图标所在位置（一般在`/usr/share/applications/chromium.desktop` ），编辑文件中`Exec`一行为：

  ```shell
  Exec=/usr/bin/chromium --disk-cache-dir="/dev/shm/chromium/"
  ```

  建议复制`/usr/share/applications/chromium.desktop`到`~/.local/share/applications/chromium.desktop`，再对其修改。

  ​

另：有 [anything-sync-daemon](https://aur.archlinux.org/packages/anything-sync-daemon/)允许用户将**任意** 目录使用相同的基本逻辑和安全防护措施同步入内存。