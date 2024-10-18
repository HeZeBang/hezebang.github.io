---
share: true
---

# IndySCC Hw.2

## NFS 共享文件系统的搭建与挂载

我们使用的脚本虽然能够在单个节点上运行良好，但是在多节点会报错，具体报错和[这个 Issue](https://github.com/open-mpi/ompi/issues/8825) 非常像

```
...
           0  restart procs <           64  <=            0  pref procs <           64  <=            0  radario procs <           64
 mo_model_domimp_patches:import_pre_patches: start to import patches
 mo_model_domimp_patches:read_pre_patch: start to init patch_pre
 Read grid file icon_grid_0005_R02B04_G.nc
[scc112-cpu1.novalocal:03960] [32]mca_sharedfp_lockedfile_file_open: Error during file open
[scc112-cpu1.novalocal:03975] [52]mca_sharedfp_lockedfile_file_open: Error during file open
[scc112-cpu1.novalocal:03989] [57]mca_sharedfp_lockedfile_file_open: Error during file open
```

查看 Issue 下面的回答，获取了一些关键信息：

> [!quote] About the file lock
> 
> ompio is able to operate without shared file pointer support if it doesn't find a component that can be used in the current environment and the application doesn't use shared file pointer operations. In this particular scenario, the lockedfile component however said 'I am good to go', because the file system on your local disk does support file locking. **The component however doesn't realize that its not the same file system on the different nodes (which leads to the failure that you observe).**

因此搭建一个共享文件系统十分必要。

### NFS 服务端的搭建

首先确保 nfs 相关依赖和本体已经安装

```bash
sudo rpm -qa | grep nfs-utils
sudo rpm -qa | grep rpcbind
```

若未安装，使用

```bash
sudo yum -y install nfs-utils
sudo yum -y install rpcbind
```

接下来编辑 `/etc/exports` 文件，记得用 `sudo` 的管理员权限

#### 配置挂载点

```bash
sudo vi /etc/exports 
```

加入例如如下一行

```bash
/home/rocky/ICON *(rw,sync,no_subtree_check)
```

> [!warning] 记得不要在 `*` 和 `(` 之间加空格，不然会识别错误

#### 防火墙

我们的机子没有防火墙，略

#### 启动相关服务

```bash
sudo systemctl start rpcbind nfs-server
sudo systemctl enable rpcbind nfs-server
```

#### 检查挂载情况

查看本地挂载是否已经暴露出

```bash
showmount -e localhost
```

如果没有更改成功，使用

```bash
sudo exportfs -arv
```

至此已经实现服务端的暴露

### NFS 客户端的挂载

#### 创建挂载目录

以本次需要用的 `ICON` 为例，新建一个 `~/ICON`，`cd` 进去，什么都没有，ok

#### 查看挂载情况

先查看挂载情况

```bash
showmount -e 10.3.59.150
```

```txt
Export list for 10.3.59.150:
/home/rocky/ICON *
```

确认已经暴露之后开始挂载

#### 编辑挂载文件

```bash
sudo vim /etc/fstab
```

在最后一行中添加

```txt
[IP]:[Remoote Absolute Path] [Local Absolute Path] nfs rw,defaults 0 0
```

例如：

```txt
10.3.59.150:/home/rocky/ICON /home/rocky/ICON nfs rw,defaults 0 0
```

接下来重新挂载

```bash
sudo systemctl daemon-reload
sudo mount -a
```

接下来 `cd` 到 `ICON` 目录已经有文件了