#!/bin/bash
############################################
# Function :  BIN包启动脚本
# Author : tang
# Date : 2020-04-25
#
############################################

# 使用说明
function print_usage(){
    echo ""
    echo -e "Usage : $0 [account] [option]"
    echo -e "\t account \t -- file name for ip-account-password "
    echo -e "\t option \t -- option , available values are : install, uninstall"
}

# 需要至少2个输入参数
if [ "$#" -lt "2" ]; then
    if [ "$#" == "0" ]; then
        echo "[ERROR]: no [account] and [option] parameter supplied!!!"
    else
        echo "[ERROR]: no [option] parameter supplied!!!"
    fi

    print_usage
    exit 1
fi

SELF_SHELL_PATH=$(cd `dirname $0`; pwd)
INSTALL_LOG_FILE=${SELF_SHELL_PATH}/install_gpdb.log

# 转换为文件的绝对路径
FILENAME=`readlink -f $1`

# 解压后执行操作
TMP_FILE_NAME=/tmp/greenplum6-centos7-release.tgz
sed -n -e '1,/^exit 0/!p' $0 > ${TMP_FILE_NAME} 2>/dev/null

mkdir -p /tmp/greenplum
tar zxf ${TMP_FILE_NAME} -C /tmp/greenplum
rm -rf ${TMP_FILE_NAME}
cd /tmp/greenplum/src/

# 判断操作类型：install安装或uninstall卸载
if [ "$2" == "uninstall" ] ; then
    sh ./uninstall.sh $FILENAME | tee -a ${INSTALL_LOG_FILE}
elif [ "$2" == "install" ]; then
    sh ./install.sh $FILENAME | tee -a ${INSTALL_LOG_FILE}
else
    echo "[ERROR]: invalid parameter for [option] supplied, available values are : install, uninstall " 
    print_usage
fi

rm -rf ${TMP_FILE_NAME}
rm -rf /tmp/greenplum

# 结束返回
echo -e "OVER!!!!"  
exit 0
