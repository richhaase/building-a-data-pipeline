#!/usr/bin/env bash

chmod 755 /home/vagrant

## We don't need no stinking firewall
systemctl disable firewalld
systemctl stop firewalld

## Install utilities
yum install -y wget unzip net-tools

## Install OpenJDK 7
yum install -y java-1.7.0-openjdk-devel

## Add Bigtop Repo
wget -O /etc/yum.repos.d/bigtop.repo http://www.apache.org/dist/bigtop/bigtop-1.1.0/repos/centos7/bigtop.repo
yum update -y

## Install Apache Hadoop psuedo cluster config
yum install -y hadoop-conf-pseudo 
yum install -y spark-core
yum install -y pig pig-udf-datafu
yum install -y oozie
yum install -y flume flume-agent
yum install -y hive hive-metastore hive-hiveserver2
yum install -y hive-hcatalog hive-hcatalog-server

## Install ExtJs 2.2 for Oozie UI
wget -O /tmp/ext-2.2.zip http://archive.cloudera.com/gplextras/misc/ext-2.2.zip
unzip /tmp/ext-2.2.zip -d /var/lib/oozie

## Start sh*t up
sudo -u hdfs hdfs namenode -format

/etc/init.d/hadoop-hdfs-namenode start
/etc/init.d/hadoop-hdfs-datanode start
/etc/init.d/hadoop-yarn-resourcemanager start
/etc/init.d/hadoop-yarn-nodemanager start
/etc/init.d/oozie start

## Setup Flume
mkdir /var/spool/flume
chown flume:flume /var/spool/flume
sudo -u hdfs hdfs dfs -mkdir -p /user/flume/in
sudo -u hdfs hdfs dfs -mkdir -p /user/flume/capture	
sudo -u hdfs hdfs dfs -chown -R flume:flume /user/flume
