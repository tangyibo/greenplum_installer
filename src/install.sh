#!/bin/bash
######################################################
# Function :  环境依赖命令的检查与Greenplum安装
# Author : tang
# Date : 2020-04-21
#
#Usage: sh install.sh
#
######################################################

# Greenplum的RPM安装包路径
RPM_FILE_NAME=files/greenplum-db-6.6.0-rhel7-x86_64.rpm
# 安装主机节点配置列表
TXT_FILE_NAME=$1
# Greenplum主机管理员账号密码
PASSWORD_GPDB_ADMIN=1qazXSW@

# 屏幕打印
source ./sbin/logo_printer.sh
# 环境检查
source ./sbin/config_env_tools.sh
# 配置解析
source ./sbin/config_file_reader.sh $TXT_FILE_NAME
# 配置准备
source ./sbin/auto_hosts_config.sh $PASSWORD_GPDB_ADMIN
# ROOT免登录设置
source ./sbin/auto_ssh_login.sh
# Geenplum安装
ansible-playbook ./deploy.yml -i $TMP_GP_ALL_IPS_FILE -e greenplum_admin_password=$PASSWORD_GPDB_ADMIN -e package_path=$RPM_FILE_NAME
# Master节点配置
if [ $? -eq 0 ];then
   ansible-playbook ./dbinit.yml -i $TMP_GP_MASTER_IP_FILE
fi
