---
share: true
---

# IndySCC Hw.1 - NAMD 与 Slurm 踩坑记

第一次作业是学习 NAMD，与 分子动力学（Molecular Dynamics） 有一些关系

## What is NAMD?

- 一个分子动力学软件包
- 实现在生物分子系统中的大规模分子模拟
- 现在有可能实现对数百亿个原子的模拟（[参考](https://www.ornl.gov/news/breaking-benchmarks-frontier-supercomputer-sets-new-standard-molecular-simulation)）

## 我们的任务

- 用 NAMD 运行 ApoA1 基准测试，并且获取测试结果进行分析与绘图

## Slurm 踩坑经历

新人第一次用 Slurm，还是踩了不少典型坑的

### `sinfo` 与节点异常

```sh
$ sinfo
```

这个命令会输出一个列表，代表了所有节点的状态，很不幸，我们捣鼓了一番后的输出是这样的

```txt
PARTITION AVAIL  TIMELIMIT  NODES  STATE NODELIST
debug        up   infinite      1  drain scc112-login
CPU          up   infinite      4  down* scc112-cpu[0-3]
GPU*         up   infinite      1   idle scc112-gpu0
```

或者使用 `-Nel` 开关

```txt
Mon Sep 23 04:56:36 2024
NODELIST      NODES PARTITION       STATE CPUS    S:C:T MEMORY TMP_DISK WEIGHT AVAIL_FE REASON              
scc112-cpu0       1       CPU       down* 32     32:1:1    122        0      1   (null) Not responding      
scc112-cpu1       1       CPU       down* 32     32:1:1    122        0      1   (null) Not responding      
scc112-cpu2       1       CPU       down* 32     32:1:1    122        0      1   (null) Not responding      
scc112-cpu3       1       CPU        down 32     32:1:1    122        0      1   (null) Node unexpectedly re
scc112-gpu0       1      GPU*        idle 16     16:1:1     58        0      1   (null) none                
scc112-login      1     debug     drained 2       2:1:1      5        0      1   (null) Low socket*core*thre
```

可以看到，在我们的节点中，`cpu` 节点显示已下线，于是使用下面的命令查看详情

```bash
$ scontrol show node scc112-cpu3
```

输出如下

```
NodeName=scc112-cpu3 Arch=x86_64 CoresPerSocket=1 
   CPUAlloc=0 CPUEfctv=32 CPUTot=32 CPULoad=0.01
   AvailableFeatures=(null)
   ActiveFeatures=(null)
   Gres=(null)
   NodeAddr=10.3.59.65 NodeHostName=scc112-cpu3 Version=22.05.9
   OS=Linux 6.1.110-1.el9.elrepo.x86_64 #1 SMP PREEMPT_DYNAMIC Thu Sep 12 14:17:14 EDT 2024 
   RealMemory=122 AllocMem=0 FreeMem=124319 Sockets=32 Boards=1
   State=DOWN ThreadsPerCore=1 TmpDisk=0 Weight=1 Owner=N/A MCS_label=N/A
   Partitions=CPU 
   BootTime=2024-09-23T04:53:51 SlurmdStartTime=2024-09-23T04:54:00
   LastBusyTime=2024-09-23T04:48:52
   CfgTRES=cpu=32,mem=122M,billing=32
   AllocTRES=
   CapWatts=n/a
   CurrentWatts=0 AveWatts=0
   ExtSensorsJoules=n/s ExtSensorsWatts=0 ExtSensorsTemp=n/s
   Reason=Node unexpectedly rebooted [rocky@2024-09-23T04:54:01]
```

可以看到错误消息为 `Node unexpectedly rebooted`，但是 `ssh` 能够正常访问，并不知道是什么原因，所以决定先重启节点上的 slurm 服务，也就是在每个 `down` 的节点服务器上运行

```bash
$ sudo systemctl restart slurmd
```

接下来再看看

```bash
$ sinfo
PARTITION AVAIL  TIMELIMIT  NODES  STATE NODELIST
debug        up   infinite      1  drain scc112-login
CPU          up   infinite      4   idle scc112-cpu[0-3]
GPU*         up   infinite      1   idle scc112-gpu0
```

好了捏！

### 你说的对，我输出呢？

在运行 `NAMD` 多核测试的时候，我们使用 `sbatch` 来提交的任务

不过非常神奇，任务刚进去就结束了，我们在 `squeue` 里面找不到它（

使用下面的命令查看单个任务详情

```bash
$ scontrol show job 34
JobId=34 JobName=submit.sh
   UserId=rocky(1000) GroupId=rocky(1000) MCS_label=N/A
   Priority=4294901731 Nice=0 Account=(null) QOS=(null)
   JobState=FAILED Reason=NonZeroExitCode Dependency=(null)
   Requeue=1 Restarts=0 BatchFlag=1 Reboot=0 ExitCode=127:0
   RunTime=00:00:00 TimeLimit=UNLIMITED TimeMin=N/A
   SubmitTime=2024-09-23T05:16:18 EligibleTime=2024-09-23T05:16:18
   AccrueTime=2024-09-23T05:16:18
   StartTime=2024-09-23T05:16:19 EndTime=2024-09-23T05:16:19 Deadline=N/A
   SuspendTime=None SecsPreSuspend=0 LastSchedEval=2024-09-23T05:16:19 Scheduler=Main
   Partition=GPU AllocNode:Sid=scc112-cpu0:2741
   ReqNodeList=(null) ExcNodeList=(null)
   NodeList=scc112-gpu0
   BatchHost=scc112-gpu0
   NumNodes=1 NumCPUs=4 NumTasks=1 CPUs/Task=4 ReqB:S:C:T=0:0:*:*
   TRES=cpu=4,mem=58M,node=1,billing=4
   Socks/Node=* NtasksPerN:B:S:C=0:0:*:* CoreSpec=*
   MinCPUsNode=4 MinMemoryNode=0 MinTmpDiskNode=0
   Features=(null) DelayBoot=00:00:00
   OverSubscribe=OK Contiguous=0 Licenses=(null) Network=(null)
   Command=/home/rocky/apoa1/submit.sh
   WorkDir=/home/rocky/apoa1
   StdErr=/home/rocky/apoa1/error.txt
   StdIn=/dev/null
   StdOut=/home/rocky/apoa1/submitout.txt
   Power=
```

可以发现，`JobSTATE` 为 `FAILED`，而退出的状态码为 `127`，这通常代表 “找不到命令”，奇怪，我们的文件明明放在根目录了！  
而且，更神奇的是，我们的 `StdErr` 和 `StdOut` 等的重定向文件并没有在 `login` 创建。

因为这是一个关于 CPU 基准的测试，所以直到最后偶然发现……  
在 `gpu0` 节点有之前的所有输出文件

这下明白了，我们忽略了 `sinfo` 里面神奇的 `*`

```
$ sinfo
PARTITION AVAIL  TIMELIMIT  NODES  STATE NODELIST
debug        up   infinite      1  drain scc112-login
CPU          up   infinite      4   idle scc112-cpu[0-3]
GPU*         up   infinite      1   idle scc112-gpu0
```

`GPU*` 代表的是这一个 `scc112-gpu0` 节点是我们的默认节点，当没有指定节点的时候，都将在这个节点上运行。

其他难题也就随之迎刃而解了，我们将在 `login` 节点的文件 `scp` 到 `gpu0` 节点，并且简单配置了一下权限，于是就可以正常跑通了！

![../res/Pasted image 20240923141948.png](../res/Pasted%20image%2020240923141948.png)

## OpemMPI 踩坑经历

### `automake` 版本过低

首先就是安装，在 `make` 的过程中居然提示 `automake` 版本太低

```txt
...
configure.ac:14: error: version mismatch.  This is Automake 1.16.2, 
configure.ac:14: but the definition used by this AM_INIT_AUTOMAKE   
configure.ac:14: comes from Automake 1.16.5.  You should recreate   
configure.ac:14: aclocal.m4 with aclocal and run automake again.    
...
WARNING: 'automake-1.16' is probably too old.
         You should only need it if you modified 'Makefile.am' or
         'configure.ac' or m4 files included by 'configure.ac'.
         The 'automake' program is part of the GNU Automake package:
         <https://www.gnu.org/software/automake>
         It also requires GNU Autoconf, GNU m4 and Perl in order to run:
         <https://www.gnu.org/software/autoconf>
         <https://www.gnu.org/software/m4/>
         <https://www.perl.org/>
make: *** [Makefile:1472: Makefile.in] Error 1
```

于是可以用 `wget` 下载所需要的版本安装，于是安装完成了

### 缺少 `munge`

接下来不报错了，但是遇到了

```
...
/usr/bin/ld: cannot find -lmunge
...
collect2: ld returned 1 exit status
```

得，神秘 `ld` 错误，下载一下 `munge`

下载 `munge` 源码后，为了构建 `configure`，还需要运行 `./bootstrap`

于是报错

```
configure.ac:32: error: possibly undefined macro: AC_PROG_LIBTOOL
```

### `libtool` 在 `munge` 安装的配置

可能是 `libtool` 没有配置好，运行

```bash
$ libtoolize --force
```

可以补充链接库

以及

```bash
$ aclocal
$ autoconf
$ automake --add-missing --copy
```

再次按照安装手册运行 `configure`，没有报错了！

于是 `make; make install`，虽然 `make check` 有 2 个 Fail，但是 `make install` 异常顺利

### 回到 OpenMPI 的安装

好了，回到刚才停下的地方，继续 `make`，过了！

然后 `make install`，虽然一堆红红的闪过去了，但是还是安装完成了！

撒花！

### `-n 300`?

![../res/Pasted image 20240923171719.png](../res/Pasted%20image%2020240923171719.png)