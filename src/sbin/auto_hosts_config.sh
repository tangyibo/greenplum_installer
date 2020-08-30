#!/bin/bash
############################################
# Function :  配置服务器hosts
# Author : tang
# Date : 2020-04-21
#
############################################

TMP_ETC_HOSTS_FILE=gpnodes/hosts
TMP_GP_ALL_IPS_FILE=gpnodes/all_ips
TMP_GP_ALL_HOST_FILE=gpnodes/all_hosts
TMP_GP_MASTER_HOST_FILE=gpnodes/master_hosts
TMP_GP_MASTER_IP_FILE=gpnodes/master_ip
TMP_GP_STANDBY_HOST_FILE=gpnodes/standby_hosts
TMP_GP_STANDBY_IP_FILE=gpnodes/standby_ip
TMP_GP_SEGMENT_HOST_FILE=gpnodes/segment_hosts
TMP_GP_SEGMENT_IP_FILE=gpnodes/segment_ip
TMP_GP_GPADMIN_HOST_FILE=gpnodes/gpadmin_hosts

PASSWORD_GPDB_ADMIN=$1

# 读取配置文件
# source ./sbin/config_file_reader.sh $FILENAME

rm -f gpnodes/* >>/dev/null 2>&1
[ -d "./gpnodes" ] || mkdir -p "./gpnodes"

echo "127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4" >$TMP_ETC_HOSTS_FILE
echo "::1         localhost localhost.localdomain localhost6 localhost6.localdomain6" >>$TMP_ETC_HOSTS_FILE

# 根据配置构造/template/hosts文件内容
for ((i = 0; i < ${#HOSTSADDR[@]}; i++)); do
    ip=${HOSTSADDR[$i]}
    user_name=${USERNAMES[$i]}
    pass_word=${PASSWORDS[$i]}
    #echo "IP:$ip    User:$user_name   Password:$pass_word"

    if [ "$i" == "0" ]; then
        echo "$ip" >>$TMP_GP_MASTER_IP_FILE
        echo "$ip mdw #master" >>$TMP_ETC_HOSTS_FILE
        echo "mdw" >>$TMP_GP_ALL_HOST_FILE
        echo "mdw" >>$TMP_GP_MASTER_HOST_FILE
        echo "mdw  gpadmin  $PASSWORD_GPDB_ADMIN" >>$TMP_GP_GPADMIN_HOST_FILE
        echo "$ip hostname=mdw" >>$TMP_GP_ALL_IPS_FILE
    elif [ "$i" == "1" ]; then
        echo "$ip" >>$TMP_GP_STANDBY_IP_FILE
        echo "$ip smdw #standby" >>$TMP_ETC_HOSTS_FILE
        echo "smdw" >>$TMP_GP_ALL_HOST_FILE
        echo "smdw" >>$TMP_GP_STANDBY_HOST_FILE
        echo "smdw  gpadmin  $PASSWORD_GPDB_ADMIN" >>$TMP_GP_GPADMIN_HOST_FILE
        echo "$ip hostname=smdw" >>$TMP_GP_ALL_IPS_FILE
    else
        echo "$ip" >>$TMP_GP_SEGMENT_IP_FILE
        idx=$(expr $i - 1)
        echo "$ip sdw$idx #segment$idx" >>$TMP_ETC_HOSTS_FILE
        echo "sdw$idx" >>$TMP_GP_ALL_HOST_FILE
        echo "sdw$idx" >>$TMP_GP_SEGMENT_HOST_FILE
        echo "sdw$idx  gpadmin  $PASSWORD_GPDB_ADMIN" >>$TMP_GP_GPADMIN_HOST_FILE
        echo "$ip hostname=sdw$idx" >>$TMP_GP_ALL_IPS_FILE
    fi
done

echo "[INFO]: parse and prepare config hosts file success!"
