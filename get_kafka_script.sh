#!/bin/bash
#유저데이터에서 밀어넣는부분
mkdir /usr/bin/custom_script
cd /usr/bin/custom_script > /usr/bin/custom_script/exec_result.txt 2>&1
wget https://raw.githubusercontent.com/fromhans/script/master/install_kafka.sh 1>>/usr/bin/custom_script/exec_result.txt 2>&1
chmod 755 ./*
/bin/sh ./install_kafka.sh
