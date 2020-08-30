#!/bin/bash
############################################
# Function :  配置账号免登录
# Author : tang
# Date : 2020-04-21
#
#Usage: sh auto_ssh_login.sh ./account.txt
#
############################################

# 读取配置文件
# source ./sbin/config_file_reader.sh $FILENAME

# 环境检查
# source ./sbin/config_env_tools.sh

# 本地密钥对不存在则创建密钥
[ ! -f ~/.ssh/id_rsa.pub ] && ssh-keygen -t rsa -p '' &>/dev/null

# 首先登陆到各个主机上，使用ssh-keygen工具生成公钥和私钥
echo "[INFO]: call ssh-keygen to generate key..."
for ((i = 0; i < ${#HOSTSADDR[@]}; i++)); do
  ip=${HOSTSADDR[$i]}
  user_name=${USERNAMES[$i]}
  pass_word=${PASSWORDS[$i]}
  #echo "IP:$ip    User:$user_name   Password:$pass_word"

  (
    expect <<EOF
                spawn ssh $user_name@$ip "rm -rf  ~/.ssh; ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa -q"
                expect {
                        "yes/no" { send "yes\n";exp_continue}     
                        "password" { send "$pass_word\n"}
                }
                expect eof 
EOF
  ) >/dev/null 2>&1
done

# 其次，拷贝将每个主机上的id_rsa.pub拷贝到本地，并汇总至authorized_keys
echo "[INFO]: copy remote public key to local..."

TMP_AUTHORIZED_KEYS="./.id_rsa.pub.$ip.tmp"
for ((i = 0; i < ${#HOSTSADDR[@]}; i++)); do
  ip=${HOSTSADDR[$i]}
  user_name=${USERNAMES[$i]}
  pass_word=${PASSWORDS[$i]}
  #echo "IP:$ip    User:$user_name   Password:$pass_word"

  TMP_FILE="./.id_rsa.pub.$ip.tmp"
  (
    expect <<EOF
                spawn scp $user_name@$ip:~/.ssh/id_rsa.pub  $TMP_FILE
                expect {
                        "yes/no" { send "yes\n";exp_continue}     
                        "password" { send "$pass_word\n"}
                }
                expect eof 
EOF
  ) >/dev/null 2>&1

  cat $TMP_FILE >>~/.ssh/authorized_keys
  rm -f $TMP_FILE
done

# 最后，将本地authorized_keys分发到每个主机上
echo "[INFO]: send local key to each host..."
for ((i = 0; i < ${#HOSTSADDR[@]}; i++)); do
  ip=${HOSTSADDR[$i]}
  user_name=${USERNAMES[$i]}
  pass_word=${PASSWORDS[$i]}
  #echo "IP:$ip    User:$user_name   Password:$pass_word"

  CMD="scp /root/.ssh/authorized_keys root@$ip:/root/.ssh/authorized_keys"
  if [ "$user_name" != "root" ]; then
    CMD="scp /home/$user_name/.ssh/authorized_keys $user_name@$ip:/home/$user_name/.ssh/authorized_keys"
  fi

  (
    expect <<EOF
                spawn $CMD  
                expect {
                        "yes/no" { send "yes\n";exp_continue}     
                        "password" { send "$pass_word\n"}
                }
                expect eof 
EOF
  ) >/dev/null 2>&1

done

echo "[INFO]: config auto ssh success!"
