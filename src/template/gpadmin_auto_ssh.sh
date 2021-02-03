#!/bin/bash
############################################
# Function :  配置账号免登录(完整版本)
# Author : tang
# Date : 2020-04-21
#
#Usage: sh gpadmin_auto_ssh.sh ./gpadmin_hosts
#
############################################

FILENAME=$1
if [ ! -n "$FILENAME" ]; then
        echo "[ERROR]: no host ip address account file supplied!!!"
        echo "Usage : $0 [host_ip_account.txt]"
        exit 1
fi

# 读取配置文件
HOSTSADDR=()
USERNAMES=()
PASSWORDS=()
while read line; do
        if [ ! -n "$line" ]; then
                break 1
        fi

        ip=$(echo $line | cut -d " " -f1)        # 提取文件中的ip地址
        user_name=$(echo $line | cut -d " " -f2) # 提取文件中的用户名
        pass_word=$(echo $line | cut -d " " -f3) # 提取文件中的密码
        #echo "IP:$ip    User:$user_name   Password:$pass_word"

        if [ ! -n "$ip" ]; then
                echo "[ERROR]: File content format error,reason get [ip address] empty"
                exit 1
        fi
        if [ ! -n "$user_name" ]; then
                echo "[ERROR]: File content format error,reason get [user name] empty"
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
        USERNAMES[${#USERNAMES[*]}]=$user_name
        PASSWORDS[${#PASSWORDS[*]}]=$pass_word
done <$FILENAME

# 本地密钥对不存在则创建密钥
[ ! -f ~/.ssh/id_rsa.pub ] && ssh-keygen -t rsa -p '' &>/dev/null

# 首先登陆到各个主机上，使用ssh-keygen工具生成公钥和私钥
echo "#### [1] call ssh-keygen to generate key..."
for ((i = 0; i < ${#HOSTSADDR[@]}; i++)); do
        ip=${HOSTSADDR[$i]}
        user_name=${USERNAMES[$i]}
        pass_word=${PASSWORDS[$i]}
        echo "IP:$ip    User:$user_name   Password:$pass_word"

        expect <<EOF
                set timeout 180
                spawn ssh $user_name@$ip "rm -rf  ~/.ssh; ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa -q"
                expect {
                        "yes/no" { send "yes\n";exp_continue}     
                        "password" { send "$pass_word\n"}
                }
                expect eof 
EOF
done

# 其次，拷贝将每个主机上的id_rsa.pub拷贝到本地，并汇总至authorized_keys
echo "#### [2] copy remote public key to local..."

TMP_AUTHORIZED_KEYS="./.id_rsa.pub.$ip.tmp"
for ((i = 0; i < ${#HOSTSADDR[@]}; i++)); do
        ip=${HOSTSADDR[$i]}
        user_name=${USERNAMES[$i]}
        pass_word=${PASSWORDS[$i]}
        echo "IP:$ip    User:$user_name   Password:$pass_word"

        TMP_FILE="./.id_rsa.pub.$ip.tmp"
        expect <<EOF
                set timeout 180
                spawn scp $user_name@$ip:~/.ssh/id_rsa.pub  $TMP_FILE
                expect {
                        "yes/no" { send "yes\n";exp_continue}     
                        "password" { send "$pass_word\n"}
                }
                expect eof 
EOF

        cat $TMP_FILE >>~/.ssh/authorized_keys
        rm -f $TMP_FILE
done

# 最后，将本地authorized_keys分发到每个主机上
echo "#### [3] send local key to each host..."
for ((i = 0; i < ${#HOSTSADDR[@]}; i++)); do
        ip=${HOSTSADDR[$i]}
        user_name=${USERNAMES[$i]}
        pass_word=${PASSWORDS[$i]}
        echo "IP:$ip    User:$user_name   Password:$pass_word"

        CMD="scp /root/.ssh/authorized_keys root@$ip:/root/.ssh/authorized_keys"
        if [ "$user_name" != "root" ]; then
                CMD="scp /home/$user_name/.ssh/authorized_keys $user_name@$ip:/home/$user_name/.ssh/authorized_keys"
        fi

        expect <<EOF
                set timeout 180
                spawn $CMD  
                expect {
                        "yes/no" { send "yes\n";exp_continue}     
                        "password" { send "$pass_word\n"}
                }
                expect eof 
EOF
done

echo "[INFO]: config auto ssh success!"
