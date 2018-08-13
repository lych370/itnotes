[TOC]

- 跨平台压缩推荐使用7z或zip（注意使用UTF-8格式！）
- tar打包压缩推荐配合xz（即最后制成.tar.xz文件），xz压缩率好，大多数linux都带有该工具。

以下示例命令中test指某个文件或者文件夹

# .zip

工具zip和unzip/unzip-iconv（unzip-iconv用法同unzip，只是多了一个-O参数可指定编码格式）

```shell
zip test.zip test  #打包
unzip test.zip  #解包
#指定编码格式(如gbk)避免乱码 需要安装unzip-iconv
unzip -O gbk
```

# .7z

工具p7zip

```shell
7za a  test.7z test  #压缩
7za x test.7z  #解压
```

# .rar

工具rar和unrar

```shell
rar a test.rar test  #压缩
unrar test.rar  #解压
```

# .tar

```shell
tar -cvf test.tar test  #打包
tar -xvf test.tar  #解包
```

- 在上面命令的参数后面加上：
  - `-z`可以在打包/解包时进行压缩/解压.tar.gz
  - `-j`可以在打包/解包时进行压缩/解压.tar.bz2
- .tar.xz需要先使用tar解包在使用xz解压（压缩则反向进行）

# .gz

```shell
gnuzip test.gz  #解压
gnuzip -d test.gz  #解压
gzip test  #压缩
```

# .bz2

```shell
#使用bzip2或bunzip2
bzip2 -z test  #压缩
bzip2 -d test.bz2  #解压
```
# .xz

```shell
xz -z test  #压缩
xz -d test.xz  #解压
```

# .rpm

解包

```shell
rpm2cpio test.rpm | cpio -div 
```

# .deb

解包

```shell
dpkg-deb --fsys-tartest test.deb | tar xvf - ar p 
test.deb data.tar.gz | tar xvzf – 
#或
bsdtar -xJf test.deb
```

# .cpio.gz/.cgz

```shell
gzip -dc test.cgz | cpio -div  
```

# .cpio/cpio

```shell
cpio -div test.cpio 
#或
cpio -divc test.cpio 
```

# .a

```shell
tar xv test.a 
```

# .z

```shell
uncompress test.Z  
```
