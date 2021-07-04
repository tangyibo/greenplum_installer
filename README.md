# Greenplum6分布式数据库CentOS7系统下一键安装包


## 一、功能简介

**基于ansible自动化运维工具提供Greenplum6数据库多节点在CentOS7系统下的一键安装部署功能。**


**当前提供安装的版本：**

- 6.10.1 请见6.10.1分支

- 6.12.1 请见6.12.1分支

- 6.13.0 请见6.13.0分支

- 6.16.3 请见6.16.3分支

**注：支持多个物理主机或虚拟主机的安装，不支持容器（docker/podman）等环境的安装**

**托管地址：**

- github: https://github.com/tangyibo/greenplum_installer

- gitee: https://gitee.com/inrgihc/greenplum_installer

## 二、安装教程

### 1、制作安装bin包：

```
[root@localhost root]# git clone -b 6.16.3 https://gitee.com/inrgihc/greenplum_installer.git
[root@localhost root]# cd greenplum_installer && make all
[root@localhost root]# tree bin/
.
├── account.txt
└── greenplum6-centos7-release.bin
```

### 2、服务器上安装：

```
[root@localhost root]# tree .
.
├── account.txt
└── greenplum6-centos7-release.bin
[root@localhost root]# cat account.txt 
10.101.1.10 root 123321      //第1个主机的IP:端口,账号,密码
10.101.1.11 root 123321      //第2个主机的IP:端口,账号,密码
10.101.1.12 root 123321      //第3个主机的IP:端口,账号,密码
10.101.1.13 root 123321      //第4个主机的IP:端口,账号,密码 (至少四个主机)
[root@localhost root]# sh greenplum6-centos7-release.bin ./account.txt install
```

注：Greenplum不支持非22端口安装，安装文档:  https://gitee.com/inrgihc/greenplum_installer/wikis/pages

## 三、数据迁移

当安装完Greenplum分布式数据库后，可能会考虑把其他常见关系数据库中的数据迁移到Greenplum中来，以便感受下Greenplum的优越性，那么您可以参考本人的另外一个项目：https://gitee.com/inrgihc/dbswitch

## 四、问题反馈

如果您看到或使用了本工具，或您觉得本工具对您有价值，请为此项目点个赞，多谢！如果您在使用时遇到了bug，欢迎在issue中反馈。也可扫描下方二维码入群讨论：（加好友请注明："程序交流"）

![structure](https://gitee.com/inrgihc/dbswitch/raw/master/images/weixin.PNG)
