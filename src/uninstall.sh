#!/bin/bash
############################################
# Function :  环境依赖命令的检查与安装
# Author : tang
# Date : 2020-04-21
#
#Usage: sh uninstall.sh
#
############################################

# 安装主机节点配置列表
TXT_FILE_NAME=$1

# 屏幕打印
source ./sbin/logo_printer.sh
# 环境检查
source ./sbin/config_env_tools.sh
# 配置解析
source ./sbin/config_file_reader.sh $TXT_FILE_NAME
# 配置准备
source ./sbin/auto_hosts_config.sh
# ROOT免登录设置
source ./sbin/auto_ssh_login.sh
# Geenplum卸载
ansible-playbook ./remove.yml -i $TMP_GP_ALL_IPS_FILE
