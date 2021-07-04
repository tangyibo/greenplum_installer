#!/bin/bash
############################################
# Function :  配置文件与检查检查
# Author : tang
# Date : 2020-04-21
#
############################################

# 命令行参数校验
FILENAME=$1
if [ ! -n "$FILENAME" ]; then
    echo "[ERROR]: no host ip address(port) account file supplied!!!"
    echo "Usage : $0 [host_ip_account.txt]"
    exit 1
fi

# 读取配置文件
HOSTSADDR=()
HOSTSPORT=()
USERNAMES=()
PASSWORDS=()

echo "[INFO]: Parse configure file content following:"
while read line; do
    if [ ! -n "$line" ]; then
        break
    fi

    ip_port=$(echo $line | cut -d " " -f1)   # 提取文件中的ip地址和port端口

    if [ ! -n "$ip_port" ]; then
        echo "[ERROR]: File content format error,reason get [ip address and port number] empty"
        exit 1
    fi

    ip_port_str_array=(${ip_port//:/ }) 
    len_ip_port_str_array=${#ip_port_str_array[@]}
    if [ "$len_ip_port_str_array" -eq "1" ]; then     
        ip=${ip_port_str_array[0]}          # 提取文件中的ip地址
        port="22"                           # 提取文件中的port端口(不写默认为22端口)
    elif  [ "$len_ip_port_str_array" -eq "2" ]; then
        ip=${ip_port_str_array[0]}          # 提取文件中的ip地址
        port=${ip_port_str_array[1]}        # 提取文件中的port端口
    else
        echo "[ERROR]: File content format error,reason parse [ip address and port number] invalid"
        exit 1
    fi

    user_name=$(echo $line | cut -d " " -f2) # 提取文件中的用户名
    pass_word=$(echo $line | cut -d " " -f3) # 提取文件中的密码
    echo "IP:$ip  Port:$port   User:$user_name   Password:$pass_word"

    if [ ! -n "$ip" ]; then
        echo "[ERROR]: File content format error,reason get [ip address] empty"
        exit 1
    fi
     if [ ! -n "$port" ]; then
        echo "[ERROR]: File content format error,reason get [port number] empty"
        exit 1
    fi
    if [ ! -n "$user_name" ]; then
        echo "[ERROR]: File content format error,reason get [user name] empty"
        exit 1
    fi
    if [ "$user_name" != "root" ]; then
        echo "[ERROR]: File content format error,reason [user name] not is root"
        exit 1
    fi
    if [ ! -n "$pass_word" ]; then
        echo "[ERROR]: File content format error,reason get [password] empty"
        exit 1
    fi

    if [ "$ip" == "$user_name" ]; then
        echo "[ERROR]: File content format error,reason invalid file format"
        exit 1
    fi

    HOSTSADDR[${#HOSTSADDR[*]}]=$ip
    HOSTSPORT[${#HOSTSPORT[*]}]=$port
    USERNAMES[${#USERNAMES[*]}]=$user_name
    PASSWORDS[${#PASSWORDS[*]}]=$pass_word
done <$FILENAME

hosts_length=${#HOSTSADDR[@]}
ports_length=${#HOSTSPORT[@]}
users_length=${#USERNAMES[@]}
passwd_length=${#PASSWORDS[@]}

if [ "$hosts_length" -lt "4" ] || [ "$ports_length" -lt "4" ] || [ "$users_length" -lt "4" ] || [ "$passwd_length" -lt "4" ]; then
    echo "[ERROR]: host ip count lower than 4, must greater or equal than 4 !"
    exit 1
fi

echo "[INFO]: check config file format success!"
