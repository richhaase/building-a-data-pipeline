#!/usr/bin/env bash

BIGTOP_REPO=http://www.apache.org/dist/bigtop/bigtop-1.1.0/repos/centos7/bigtop.repo
DEMO_DIR=/home/vagrant/sync
EXT_ZIP=http://archive.cloudera.com/gplextras/misc/ext-2.2.zip

## Allow anyone to read files from the vagrant users home directory
chmod 755 /home/vagrant 

## We don't need no stinking firewall
systemctl disable firewalld
systemctl stop firewalld

## Install utilities
yum install -y wget unzip net-tools vim tree

## Install OpenJDK 7
yum install -y java-1.7.0-openjdk-devel

## Add Bigtop Repo
wget -O /etc/yum.repos.d/bigtop.repo ${BIGTOP_REPO}
yum update -y

## Install Apache Hadoop psuedo cluster config
yum install -y hadoop-conf-pseudo 
yum install -y spark-core
yum install -y pig pig-udf-datafu
yum install -y oozie
yum install -y flume flume-agent

## Install ExtJs 2.2 for Oozie UI
wget -O /tmp/ext-2.2.zip ${EXT_ZIP}
unzip /tmp/ext-2.2.zip -d /var/lib/oozie

## Start sh*t up
sudo -u hdfs hdfs namenode -format

/etc/init.d/hadoop-hdfs-namenode start
/etc/init.d/hadoop-hdfs-datanode start
/etc/init.d/hadoop-yarn-resourcemanager start
/etc/init.d/hadoop-yarn-nodemanager start

## Setup HDFS directories
mkdir /var/spool/flume
chown mapred:mapred /var/spool/flume
sudo -u hdfs hdfs dfs -mkdir -p /user/mapred/in
sudo -u hdfs hdfs dfs -mkdir -p /user/mapred/hdd/cfg
sudo -u hdfs hdfs dfs -chown -R mapred:mapred /user/mapred

## Setup Oozie job
sudo -u hdfs hdfs dfs -mkdir -p /user/oozie/share/lib
sudo -u hdfs hdfs dfs -chown -R oozie:oozie /user/oozie

# for some reason oozie ships with commons-io-2.1, but needs commons-io-2.4 
# in order to run `oozie-setup sharelib create -fs <hdfs-path>`
# See https://mail-archives.apache.org/mod_mbox/oozie-user/201507.mbox/%3CCALBGZ8o4n27S8w6fn3HFxfzJmZbA9Gsz71Ewg+r6XEFCZTFpPQ@mail.gmail.com%3E
cp /usr/lib/hive/lib/commons-io-2.4.jar /usr/lib/oozie/lib/
oozie-setup sharelib create -fs hdfs://localhost:8020/user/oozie/share/lib
sudo -u oozie hdfs dfs -put /usr/lib/pig/lib/piggybank.jar /user/oozie/share/lib/lib_*/pig

## Start Oozie
/etc/init.d/oozie start

## Load Oozie workflow
sudo -u hdfs hdfs dfs -put ${DEMO_DIR}/cfg/example/* /user/mapred/hdd/cfg

# Overwrite default capacity-schedule.xml file
# Our copy contains yarn.scheduler.capacity.maximum-am-resource-percent=0.6
# to allow our multiple application masters to run on our pseudo cluster at once.
cat ${DEMO_DIR}/cfg/capacity-scheduler.xml > /etc/hadoop/conf/capacity-scheduler.xml

## Set Job History HDFS directories
sudo -u hdfs hdfs dfs -mkdir -p /tmp/hadoop-yarn/staging/history
sudo -u hdfs hdfs dfs -chmod -R 0777 /tmp
sudo -u hdfs hdfs dfs -chown -R mapred:mapred /tmp

## Startup Job History server
/etc/init.d/hadoop-mapreduce-historyserver start
