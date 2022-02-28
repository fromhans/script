yum update -y
yum install java-1.8.0-openjdk -y

mkdir /opt/kafka
cd /opt/kafka
wget https://dlcdn.apache.org/kafka/3.1.0/kafka_2.13-3.1.0.tgz --no-check-certificate
tar -zxvf kafka_2.13-3.1.0.tgz

TARGET_DIRS="/opt/kafka/kafka_2.13-3.1.0"
cd ${TARGET_DIRS}/config

echo -e '#!/bin/bash
exec_process=0
for i in {1..10}
do
	bootstrap_port=`netstat -tunlp | grep "2181"`
	kafka_port=`netstat -tunlp | grep "9092"`

	if [[ ${bootstrap_port} == "" ]] && [[ ${kafka_port} == "" ]] && [[ ${exec_process} == 0 ]]
	then
	echo "bootstrap server starting"
	exec_process=1
	nohup /opt/kafka/kafka_2.13-3.1.0/bin/zookeeper-server-start.sh /opt/kafka/kafka_2.13-3.1.0/config/zookeeper.properties 1>>/opt/kafka/kafka_2.13-3.1.0/zookeeper_execute_log.txt 2>&1 &
	fi

        if [[ ${bootstrap_port} == "" ]] && [[ ${kafka_port} == "" ]] && [[ ${exec_process} == 1 ]]
        then
        echo "wait for bootstrap executing"
	sleep 1
        fi

	if [[ ${bootstrap_port} != "" ]] && [[ ${kafka_port} == "" ]] && [[ ${exec_process} == 1 ]]
	then
	echo "bootstrap server started and kafka starting"
	exec_process=2
	nohup /opt/kafka/kafka_2.13-3.1.0/bin/kafka-server-start.sh /opt/kafka/kafka_2.13-3.1.0/config/server.properties 1>>/opt/kafka/kafka_2.13-3.1.0/kafka_execute_log.txt 2>&1 &
        fi

        if [[ ${bootstrap_port} != "" ]] && [[ ${kafka_port} == "" ]] && [[ ${exec_process} == 2 ]]
        then
        echo "waiting for kafka executing"
	sleep 2
        fi

	if [[ ${bootstrap_port} != "" ]] && [[ ${kafka_port} != "" ]]
	then
	echo "bootstrap and kafka execution completed"
	break
	fi
done' > ${TARGET_DIRS}/kafka_startup.sh
echo "sh ${TARGET_DIRS}/kafka_startup.sh" >> /etc/rc.d/rc.local

nohup ${TARGET_DIRS}/bin/zookeeper-server-start.sh ${TARGET_DIRS}/config/zookeeper.properties 1>>${TARGET_DIRS}/zookeeper_execute_log.txt 2>&1 &
nohup ${TARGET_DIRS}/bin/kafka-server-start.sh ${TARGET_DIRS}/config/server.properties 1>>${TARGET_DIRS}/kafka_execute_log.txt 2>&1 &

${TARGET_DIRS}/bin/kafka-topics.sh --bootstrap-server localhost:9092 --replication-factor 1 --partitions 1 --topic quickstart-events --create
