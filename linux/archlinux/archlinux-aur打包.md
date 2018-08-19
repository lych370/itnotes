ArchLinux aur打包简易指南

---

[TOC]

# PKGBUILD文件

首次制作，从`/usr/share/pacman/`下复制一份PKGBUILD样本，更名为PKGBUILD，根据情况编辑PKGBUILD内容。

PKGBUILD参考[archwiki-PKGBUILD](https://wiki.archlinux.org/index.php/PKGBUILD_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))，以及在[aur软件包](https://aur.archlinux.org/packages/)仓库中参照他人的PKGBUILD文件（在软件包详细资料的右侧有查看PKGBUILD的链接）。

# mkepkg配置文件（可选）

`/etc/makepkg.conf` 是 makepkg 的主配置文件。用户的自定义配置位于 `$XDG_CONFIG_HOME/pacman/makepkg.conf` 或 `~/.makepkg.conf`。

- 打包人信息：找到`#PACKAGER="John Doe <john@doe.com>"一行，去掉注释符号#（下同），修改“John Doe <john@doe.com>”为当前打包人信息。
- 包输出：*makepkg* 默认会在工作目录创建软件包，并把源代码下载到 `src/` 目录。可根据需要修改起默认位置，找到一下内容进行相关修改：`#PKGDEST`设置产生的包的路径，`#SRCDEST`设置soure数据路径，`SRCPKGDEST`设置产生的源码包（可用`makdepkg -s`生成）的路径。
- 使用tmpfs：编译过程需要大量的读写操作，要处理很多小文件。将工作目录移动到 [tmpfs](https://wiki.archlinux.org/index.php/Tmpfs) 可以减少编译时间。找到`#BUILDDIR=/tmp/makepkg`去掉#，修改为`BUILDDIR=/tmp/makepkg makepkg`。

其余参考[archwiki-makepkg](https://wiki.archlinux.org/index.php/Makepkg_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)#.E9.85.8D.E7.BD.AE)

# 构建和测试

在PKGBUILD文件目录下执行：

```bash
makepkg    #makepkg -f 可覆盖构建
# 如果需要的依赖不满足，构建失败可执行  makepkg -s 自动安装依赖
# 或者makepkg -S pkgname  手动安装依赖
# makepkg -i 可安装构建的软件包
namcap pkgname  #检测依赖情况 pkgname是软件包的名字
pacman -U pkgname    #安装软件包
```

如有错误信息提示，根据提示修正PKGBUILD文件。

# 提交到aur仓库

- 登记密钥

  [登录aur账号](https://aur.archlinux.org/),在账号设置里添加本机（用以打包aur的设备）的ssh公钥（如~/.ssh/id_rsa.pub），生成ssh密钥的方法：

  ```shell
  ssh-keygen
  ssh-keygen  -t  rsa    #或者-t指定加密类型如rsa、dsa
  ```

- 仓库连接

  进入到打包目录使用`git init`  初始化仓库。

  - 提交新的aur

  ```shell
  #在服务器上建立一个名为name.git的新仓库(name一般是软件包名)
  git clone git+ssh://aur@aur.archlinux.org/name.git
  #初始化仓库
  git init
  #连接远程仓库
  git remote add origin git+ssh://aur@aur.archlinux.org/name.git
  ```

  - 连接已经存在的aur仓库

  ```shell
  #连接仓库(name是该仓库名)
  git remote add origin git+ssh://aur@aur.archlinux.org/name.git
  #从服务器同步内容
  git pull origin master
  ```

  注意：即使 AUR 中的软件包被删除，Git 仓库也不会删除，所以你可能会发现 clone 一个 AUR 中还不存在的软件包时不会看到提示信息。

- 生成信息并上传

  **只提交PKGBUILD文件和.SRCINFO文件，软件包相关资源应在PKGBUILD的source中提供URI，而不是上传到aur的git服务器。**

  ```shell
  updpkgsums     #生成校验码 如果不使用校验，跳过该步骤
  makepkg --printsrcinfo > .SRCINFO     #生成信息文件
  git add PKGBUILD .SRCINFO	# 提交变动到暂存区
  git commit -m 'some description'     #增加快照
  git push    #推送 
  ```

  注意：

  - 每次更新了软件包都需要重新生成校验码(sums)和信息文件（如果希望PKGBUILD文件的md5sum等加密方式的值为**SKIP**，则无需执行 ）。
  - aur的git服务器不允**不允许强制推送**，只能在最新快照上更新推送。
  - **每一次提交中都包含[.SRCINFO](https://wiki.archlinux.org/index.php/.SRCINFO)文件**，如果忘记在提交中包含`.SRCINFO`，即使稍后补上该文件，AUR也会拒绝接收推送请求。 要解决这个问题，可以使用[git rebase](https://git-scm.com/docs/git-rebase) 中的 `--root` 选项或是 [git filter-branch](https://git-scm.com/docs/git-filter-branch) 中的 `--tree-filter` 选项。

