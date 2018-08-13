> LSF（Load Sharing Facility）是一款分布式集群管理系统软件，负责计算资源的管理和批处理作业的调度。它给用户提供统一的集群资源访问接口，让用户透明地访问整个集群资源。同时提供了丰富的功能和可定制的策略。



提交任务---->调度系统---->分配节点执行任务

> 普通用户提交可执行程序或脚本给LSF。LSF 将已提交的程序称为作业。作业在LSF 的队列 (Queue) 里排队 (PEND) ，等待调度。 

openlava是LSF的开源实现，具有LSF大部分功能，二者使用类似。

# LSF/openlava管理

部分命令可能需要root（或sudo）用户才能执行。

- 启动/停止程序

  ```shell
  lsf_daemons start  #启动程序
  lsf_daemons stop  #停止程序
  ```

- 资源监控

  - 集群信息

    ```shell
    lsid
    lsf_daemon status  #lsf进程启用状况
    ```

  - 节点信息

    ```shell
    lshosts  #展示各个节点的cpu 内存操作系统信息
    bhosts  #主要展示了节点可用状态
    lsload  #展示节点的负载信息
    ```

- 开关主机

  ```shell
  badmin hopen  <主机名>
  badmin hclose <主机名>
  ```

- 队列管理

  - 队列信息

    ```shell
    bqueues  #查看所有队列
    bqueues <队列名>  #查看某个具体队列的信息
    ```

  - 开启或关闭队列

    ```shell
    badmin qopen <队列名>
    badmin qclose <队列名>
    ```

# 作业管理

## 提交作业bsub

root用户不能提交作业！

```shell
bsub -q normal -n 12 -o output.log -e output.err -J testjob <commond>
```

最后的`<command>`是要提交执行的命令（或脚本文件）

- 常用参数
  - q  提交的队列  默认为openlava设置的队列
  - n  申请的进程数  默认为1
  - o  作业输出文件  默认输出为`%J.log`（`%J`为提交作业后系统分配的作业编号）
  - e  错误输出文件  默认为`J%.err`
  - J  作业名

## 查询作业bjobs/bhist/bpeek

```shell
bjobs  #列出所有作业
bjobs 
bjobs -l 135  #查看135号作业
bjobs -p 135  #查看135号作业处于当前排队状态的原因

bhist　#查看作业历史

bpeek 135  #查看135号作业输出信息
```

- 常用参数

  - l  查看指定编号的作业
  - p  查看指定编号作业排队原因

- 各种作业状态(STAT)说明

  - PEND  作业排队等待中
  - PSUSP  作业在排队中被挂起
  - USUSP  作业在计算中被挂起
  - SSUSP  作业被调度系统挂起

- 常见排队(PEDN)原因说明

  - > User has reached the pre-user job slot limit of the queue

    用户作业达到了排队中作业所在队列的个人作业进程数上限。此队列中用户正在运行的作业有计算结束，才会再分配后续的排队作业。

  - > The slot limit reached; 4hosts

    排队中作业达到了所在队列可使用节点数的上限。此队列中所有用户正在运行的作业有计算结束，才会再分配此队列中排在最前边的作业。

  - > The user has reached his/her job slot limit

    用于已运行的作业数达到了系统规定的限制，需已运行的作业有新的计算结束，排队中的作业才会进入系统调度。

  - > The queue has reached its job slot limit

    队列中已经运行的所有作业的总使用进程数，达到了系统上队列队列总作业进程数的上限。需该队列中已运行的作业有新的计算结束，才会调度该队列中排在第一位的作业。

## 调整未完成作业

### 更改作业提交参数bmod

 只能在作业尚处于排队中时，已经运行的作业无法再更改提交或计算参数。

```shell
bmod -q high 123  #将123号作业编进名为high的队列中
bmod -J new_name 123  #给123号作业重新起名为new_name
```

### 更改作业的前后顺序btop/bbot

只能修改正在排列的作业，对已经开始运行的作业无效。

```shell
btop 123  #将123号作业移动到排队的顶部
bbot 123  #将123号作业移动到排队的底部
```

### 挂起未完成作业bstop

```shell
bstop  <作业编号>
bstop 1234  #删除1234号任务
```

### 恢复挂起的作业bresume

```shell
bresume  <作业编号>
bresume 1234  #删除1234号任务
```

### 删除作业任务bkill

```shell
bkill  <作业编号>
bkill 1234  #删除1234号任务
```

# 增删节点

- 增加节点

  1. 修改`/share/openlava/etc/lsb.hosts`配置文件，将新节点的`hostname`添加新节点到队列数组中

  2. 更新lsf配置

     ```shell
     lsadmin reconfig
     ```

  3. 在新计算节点上启动lsf相关服务

     ```shell
     source  /share/openlava/etc/openlava.sh
     /share/openlava/etc/openlava start
     ```

- 删改节点

参照增加节点的方法，删除和修改`/share/openlava/etc/lsb.hosts`配置，然后更新lsf配置。