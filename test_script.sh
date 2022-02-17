yum update -y
yum install java-1.8.0-openjdk -y

mkdir /opt/kafka
cd /opt/kafka
wget https://dlcdn.apache.org/kafka/3.1.0/kafka_2.13-3.1.0.tgz --no-check-certificate
tar -zxvf kafka_2.13-3.1.0.tgz

TARGET_DIRS="/opt/kafka/kafka_2.13-3.1.0"
cd ${TARGET_DIRS}/config

echo -e "nohup ${TARGET_DIRS}/bin/zookeeper-server-start.sh ${TARGET_DIRS}/config/zookeeper.properties 1>>${TARGET_DIRS}/zookeeper_execute_log.txt 2>&1 &"  > ${TARGET_DIRS}/zookeeper_startup.sh
echo -e "nohup ${TARGET_DIRS}/bin/kafka-server-start.sh ${TARGET_DIRS}/config/server.properties 1>>${TARGET_DIRS}/kafka_execute_log.txt 2>&1 &" >> ${TARGET_DIRS}/kafka_startup.sh
chmod 755 ${TARGET_DIRS}/kafka_startup.sh
echo "sh ${TARGET_DIRS}/kafka_startup.sh" >> /etc/rc.d/rc.local

nohup ${TARGET_DIRS}/bin/zookeeper-server-start.sh ${TARGET_DIRS}/config/zookeeper.properties 1>>${TARGET_DIRS}/zookeeper_execute_log.txt 2>&1 &
nohup ${TARGET_DIRS}/bin/kafka-server-start.sh ${TARGET_DIRS}/config/server.properties 1>>${TARGET_DIRS}/kafka_execute_log.txt 2>&1 &

${TARGET_DIRS}/bin/kafka-topics.sh --bootstrap-server localhost:9092 --replication-factor 1 --partitions 1 --topic my_topic --create
