#!/bin/bash
mkdir /usr/bin/custom_script
cd /usr/bin/custom_script > /usr/bin/custom_script/exec_result.txt 2>&1
wget https://raw.githubusercontent.com/fromhans/script/master/install_kafka_3.1.0.sh 1>>/usr/bin/custom_script/exec_result.txt 2>&1
chmod 755 ./*
/bin/sh ./install_kafka_3.1.0.sh 1>/usr/bin/custom_script/kafka_install_log.txt 2>&1
