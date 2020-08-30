#!/bin/bash
############################################
# Function :  环境依赖命令的检查与安装
# Author : tang
# Date : 2020-04-21
#
#Usage: sh config_env_tools.sh
#
############################################

# 利用yum安装依赖包函数
package_install() {
  echo "[INFO]: check command package : [ $1 ]"
  if ! rpm -qa | grep -q "^$1"; then
    yum install -y $1
    package_check_ok
  else
    echo "[INFO]: command [ $1 ] already installed."
  fi
}

# 检查命令是否执行成功
package_check_ok() {
  if [ $? != 0 ]; then
    echo "[ERROR]: Install failed, error code is $?, Check the error log."
    exit 1
  fi
}

# 要求必须以root账号执行
if [ "$(whoami)" != 'root' ]; then
  echo "[ERROR]: You have no permission to run $0 as non-root user."
  exit 1
fi

# CentOS7操作系统检查
v=$(cat /etc/redhat-release | sed -r 's/.* ([0-9]+)\..*/\1/')
if [ $v -ne 7 ]; then
  echo "[ERROR]: This program only can run for system CentOS 7 version."
  exit 1
fi

# x86_64平台检查
platform=`uname -m`
if [ "$platform" != "x86_64" ]; then
  echo "[ERROR]: This program only can run for x86_64 operation system."
  exit 1
fi

# 检查python环境
#while ! [ -x "$(command -v python2.7)" ]; do
#  echo 'python2.7 is not installed. installing now ...' >&2
#  yum install python27 -y
#done

# 判断并利用yum安装依赖
package=(expect python ansible)
for p in ${package[@]}; do
  package_install $p
done
