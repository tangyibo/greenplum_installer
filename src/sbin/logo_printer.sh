#!/bin/bash
############################################
# Function :  LOGO版权打印
# Author : tang
# Date : 2020-04-23
#
#Usage: sh logo_printer.sh
#
############################################

# 发布时间设置
PUBLISH_DATE=2020-12-02
VERSION_CODE=1.2
AUTHOR_NAME=tang
CONTACT_ADDR=inrgihc@126.com

now_time=$(date +"%Y-%m-%d %H:%M:%S")
shellwidth=$(stty size | awk '{print $2}')

print_line() {
    for ((i = 1; i <= $shellwidth; i++)); do
        echo -n '*'
    done
}

print_line
echo ''
echo '  _________   _____      _____ _____________________________      _____              __________________________ __________ '
echo ' /   _____/  /     \    /  _  \\______   \__    ___/\______ \    /     \            /  _____/\______   \______ \\______   \'
echo ' \_____  \  /  \ /  \  /  /_\  \|       _/ |    |    |    |  \  /  \ /  \   ______ /   \  ___ |     ___/|    |  \|    |  _/'
echo ' /        \/    Y    \/    |    \    |   \ |    |    |    `   \/    Y    \ /_____/ \    \_\  \|    |    |    `   \    |   \'
echo '/_______  /\____|__  /\____|__  /____|_  / |____|   /_______  /\____|__  /          \______  /|____|   /_______  /______  /'
echo '        \/         \/         \/       \/                   \/         \/                  \/                  \/       \/ '
echo ''
echo ' Greenplum Automatic Installer V'$VERSION_CODE' '
echo ' Publish Time  : '$PUBLISH_DATE' '
echo ' Write Author  : '$AUTHOR_NAME'  '
echo ' Contact Email : '$CONTACT_ADDR'  '
echo ' Copyright @ tang reserved!'
echo ''
echo ' Refrence Address: https://gpdb.docs.pivotal.io/6-12/install_guide/prep_os.html'
echo ''
echo ' Install time: '$now_time ' '
echo ''
print_line
